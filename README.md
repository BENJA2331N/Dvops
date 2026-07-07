# 🚀 Innovatech Chile | Plataforma Cloud-Native en AWS (DevOps Enterprise)

---

## 🧭 Resumen Ejecutivo

Innovatech Chile es una plataforma cloud-native basada en microservicios, desplegada sobre AWS y diseñada bajo prácticas modernas de DevOps, automatización CI/CD y arquitectura distribuida.

El sistema simula un entorno productivo real con enfoque en:
- Alta disponibilidad (Multi-AZ)
- Escalabilidad horizontal
- Seguridad bajo modelo Zero Trust
- Automatización completa del ciclo de vida del software
- Observabilidad centralizada

---

## 🏗️ Arquitectura General

Flujo de despliegue end-to-end:

GitHub → GitHub Actions → Docker (multi-stage build) → Amazon ECR → Amazon EKS → Microservicios

---

## ☁️ Infraestructura en AWS

### Componentes principales

- Amazon VPC (10.0.0.0/16)
- Amazon EKS (Kubernetes v1.35)
- Amazon ECR (registro de contenedores)
- Elastic Load Balancer (exposición pública)
- AWS CloudWatch (logs y monitoreo)
- AWS Systems Manager (acceso seguro sin SSH)
- NAT Gateway / Internet Gateway

### Diseño de red

- Arquitectura Multi-AZ
- Subredes públicas y privadas
- Backend aislado en subred privada
- Exposición controlada mediante Load Balancer
- Comunicación interna restringida dentro del clúster

---

## 🔐 Seguridad (Zero Trust)

El sistema implementa un enfoque Zero Trust:

- Eliminación de acceso SSH (puerto 22 cerrado)
- Sin uso de llaves .pem
- Acceso administrativo mediante AWS Systems Manager Session Manager
- Autenticación con credenciales temporales (STS)
- Servicios internos expuestos únicamente vía ClusterIP
- Reducción de superficie de ataque

---

## ☸️ Kubernetes (Amazon EKS)

- Cluster: innovatech-eks-cluster
- Versión: Kubernetes v1.35
- Tipo de nodos: T3 Large (Spot Instances)
- Autoescalado habilitado

### Exposición de servicios

| Servicio         | Tipo          | Exposición |
|----------------|--------------|------------|
| Frontend        | LoadBalancer | Público    |
| Backend Ventas  | ClusterIP    | Interno    |
| Backend Logística | ClusterIP  | Interno    |

---

## 🐳 Estrategia de Contenedores

- Microservicios dockerizados
- Uso de multi-stage builds para optimización
- Imágenes livianas y seguras
- Publicación en Amazon ECR

Versionado de imágenes:
eks-${{ github.run_number }}

---

## ⚙️ CI/CD (GitHub Actions)

### Flujo de despliegue

GitHub → Actions → Docker → ECR → EKS → Deploy

### Etapas del pipeline

- Checkout del código fuente
- Autenticación con AWS (STS)
- Build de imagen Docker
- Push a Amazon ECR
- Deploy en Amazon EKS
- Rolling update sin downtime

### Características

- Despliegue automático en cada push a main
- Versionado dinámico de imágenes
- Entrega inmutable
- Cero downtime en producción

---

## 📈 Escalabilidad y Resiliencia

- Horizontal Pod Autoscaler (HPA)
- Escalado automático basado en CPU
- Umbral de uso: 50%
- Optimización de costos con instancias Spot

---

## 📊 Observabilidad

### Metrics Server
- kubectl top pods -n tienda

### CloudWatch
- Logs del API Server
- Auditoría del clúster
- Eventos del sistema
- Eventos de autenticación

---

## 🧩 Microservicios

| Servicio   | Tecnología   | Función |
|------------|-------------|--------|
| Frontend   | JavaScript  | Interfaz de usuario |
| Ventas     | Spring Boot | Gestión de ventas |
| Logística  | Spring Boot | Gestión de entregas |

---

## 📂 Estructura del repositorio

.
├── .github/workflows
├── back-Ventas_SpringBoot
├── back-Despachos_SpringBoot
├── front_despacho
└── README.md

---

## 🚀 Validación del Sistema

kubectl get pods -n tienda
kubectl get svc -n tienda
kubectl get deployments -n tienda
kubectl top pods -n tienda

---

## 🎯 Resultados de Ingeniería

- Infraestructura cloud en AWS operativa
- Arquitectura de microservicios distribuida
- Orquestación con Kubernetes (EKS)
- CI/CD completamente automatizado
- Seguridad bajo modelo Zero Trust
- Escalabilidad horizontal automática
- Observabilidad centralizada

---

## 👥 Equipo

- Benjamin Nuñez 
- Luis Ugalde
- Constanza Ulloa

---

## 📄 Licencia

Proyecto académico desarrollado en Duoc UC con fines educativos.
