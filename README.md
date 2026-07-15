# 🚀 Proyecto DevOps | Plataforma Cloud-Native en AWS

---

## 🧭 Resumen Ejecutivo

Este repositorio contiene la infraestructura y el código fuente de una plataforma cloud-native basada en arquitectura de microservicios, desplegada íntegramente sobre **Amazon Web Services (AWS)**. El proyecto ha sido diseñado aplicando las mejores prácticas de **DevOps, automatización CI/CD, Infraestructura Inmutable y Orquestación de Contenedores**.

El ecosistema garantiza alta disponibilidad, despliegues sin interrupciones y una gestión centralizada de recursos mediante Kubernetes.

---

## 🏗️ Arquitectura General

El flujo de despliegue automatizado (*end-to-end*) sigue este ciclo autónomo:

`GitHub Push` → `GitHub Actions` → `Docker (Multi-stage build)` → `Amazon ECR (Auto-creación y Push)` → `Inyección Dinámica de Secretos (DB IP)` → `Amazon EKS` → `Pods`

---

## ☁️ Infraestructura en AWS

El proyecto se despliega sobre una infraestructura robusta en la nube de AWS que incluye:

- **Amazon EKS (Elastic Kubernetes Service)**: Clúster principal `eks-semestral` responsable de orquestar todos los contenedores y asegurar escalabilidad.
- **Amazon ECR (Elastic Container Registry)**: Creación automatizada desde el pipeline y almacenamiento de imágenes Docker privadas.
- **Amazon EC2**: Alojamiento de la base de datos relacional (MySQL).
- **Elastic Load Balancer (ELB)**: Punto de entrada público (balanceador de carga) asignado de forma dinámica por Kubernetes para exponer el frontend.
- **AWS CLI en CI/CD**: Para orquestación de red y extracción dinámica de la dirección IP interna en tiempo de despliegue.

---

## ☸️ Orquestación con Kubernetes (Amazon EKS)

Toda la orquestación de los servicios está definida mediante manifiestos declarativos ubicados en la carpeta `k8s/`. 

- **Namespace Aislado**: Todos los recursos operan dentro del namespace `innovatech` para organizar y prevenir conflictos.
- **Inyección de Configuración Dinámica**: Uso de un `ConfigMap` que recibe de forma dinámica (inyectada por el Pipeline) la dirección IP privada de la base de datos de EC2, evitando exponer credenciales en código duro.
- **Microservicios Backend (Ventas y Despachos)**: Desplegados mediante manifiestos `Deployment` con múltiples réplicas (Alta Disponibilidad). Se comunican internamente a través de un servicio `ClusterIP`, asegurando que no queden expuestos directamente a Internet por seguridad.
- **Frontend**: Expuesto de manera pública y tolerante a fallos utilizando un servicio de tipo `LoadBalancer`.

---

## 🐳 Estrategia de Contenedores (Docker)

Cada microservicio cuenta con un `Dockerfile` optimizado con enfoque en rendimiento y ciberseguridad:

- **Multi-stage Builds**: Separación estricta de las etapas de construcción (builder con Maven/Node) y la etapa de ejecución, resultando en imágenes finales ultra ligeras (basadas en Alpine Linux).
- **Seguridad (Non-root Users)**: Los contenedores en producción ejecutan sus procesos bajo usuarios sin privilegios del sistema operativo (ej. `spring:spring` o `appuser`), reduciendo drásticamente la superficie de ataque.
- **Nginx Proxy**: El frontend utiliza una plantilla `nginx.conf.template` que, mediante sustitución nativa de variables de entorno, enruta las peticiones de la API directamente al servicio DNS interno de Kubernetes (`backend-despachos`).

---

## ⚙️ Automatización CI/CD (GitHub Actions)

El archivo central de automatización `.github/workflows/workflow.yml` gestiona todo el ciclo de vida del software:

1. **Checkout & Auth**: Descarga del código y autenticación segura con AWS mediante Secretos de repositorio.
2. **Aprovisionamiento ECR (Auto-Healing)**: Antes de construir, el pipeline verifica si los repositorios ECR existen mediante AWS CLI. Si no existen, **los aprovisiona automáticamente**, garantizando autonomía total del flujo sin requerir a un operador manual.
3. **Build & Push**: Construcción paralela de las 3 imágenes (Ventas, Despachos, Frontend) asignándoles tags inmutables basados en el commit de GitHub (`github.sha`).
4. **Descubrimiento de Red (Network Discovery)**: El pipeline se conecta a EC2, busca la instancia de Base de Datos y obtiene su IP privada para reemplazar los marcadores (`REPLACE_DB_ENDPOINT`) en los manifiestos de Kubernetes on-the-fly usando `sed`.
5. **Continuous Deployment (CD)**: Ejecuta `kubectl apply` para desplegar la nueva versión en Amazon EKS utilizando el patrón Rolling Update (cero tiempo de inactividad).

---

## 🧩 Ecosistema de Microservicios

El proyecto modular se divide en tres componentes:

| Componente | Tecnología | Puerto (K8s) | Rol |
|------------|------------|--------------|-----|
| **Frontend** | React / Vite / Nginx | 8080 | UI de usuario conectada al ELB (Pública) |
| **Backend Ventas** | Spring Boot / Java 17 | 8080 | Lógica de ventas (Red Privada) |
| **Backend Despachos**| Spring Boot / Java 17 | 8081 | Lógica logística (Red Privada) |

---

## 📂 Estructura Principal del Repositorio

```text
.
├── .github/workflows/
│   └── workflow.yml               # Pipeline CI/CD Central
├── back-Despachos_SpringBoot/     # Microservicio de Despachos
│   └── Dockerfile                 # Contenedor Multi-stage Java
├── back-Ventas_SpringBoot/        # Microservicio de Ventas
│   └── Dockerfile                 # Contenedor Multi-stage Java
├── front_despacho/                # Aplicación Web (React/Vite)
│   ├── nginx.conf.template        # Proxy Inverso Interno
│   └── Dockerfile                 # Contenedor Node+Nginx
├── k8s/                           # Cluster Manifests (IaC)
│   ├── 00-namespace-config.yaml   # Configuración de Entorno e IP de BD
│   ├── 01-backend-despachos.yaml  # Configuración Backend 1
│   ├── 02-backend-ventas.yaml     # Configuración Backend 2
│   └── 03-frontend.yaml           # Configuración UI & LoadBalancer
└── docker-compose.yml             # Orquestación de entorno de pruebas local
```

---

## 🚀 Entorno de Desarrollo Local

Para iniciar el entorno localmente (sin conexión a AWS EKS), ejecuta desde la raíz:

```bash
docker-compose build
docker-compose up -d
```
Esto levantará de forma autónoma una base de datos MySQL local interconectada a las réplicas de desarrollo de tus aplicaciones backend y frontend.

---

## 🎯 Resumen de Entregables e Hitos Alcanzados

- [x] Pipeline de Integración y Entrega Continua (CI/CD) completamente automatizado en un solo flujo.
- [x] Creación condicional y autónoma de repositorios Elastic Container Registry (ECR).
- [x] Inyección dinámica de IP de Base de Datos y control de versiones inmutable en tiempo de despliegue.
- [x] Arquitectura implementada en Kubernetes (Amazon EKS) aplicando Rolling Updates.
- [x] Seguridad mejorada con arquitecturas Alpine, Non-root containers y componentes de backend en capa 100% privada (Zero Trust / ClusterIP).
