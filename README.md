# 🚀 Innovatech Chile | Plataforma DevOps Cloud-Native en AWS

![AWS](https://img.shields.io/badge/AWS-EKS-orange?style=for-the-badge&logo=amazonaws)
![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.35-326CE5?style=for-the-badge&logo=kubernetes)
![Docker](https://img.shields.io/badge/Docker-Contenedores-2496ED?style=for-the-badge&logo=docker)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-Automatizado-2088FF?style=for-the-badge&logo=githubactions)
![Estado](https://img.shields.io/badge/Producción-Ready-success?style=for-the-badge)

---

## 🧭 Descripción general

Innovatech Chile es una plataforma cloud-native basada en microservicios desplegada en AWS, diseñada bajo estándares modernos de ingeniería DevOps.

El sistema simula un entorno productivo real con:
- Arquitectura de microservicios
- Pipeline CI/CD completamente automatizado
- Orquestación con Kubernetes (Amazon EKS)
- Infraestructura segura bajo modelo Zero Trust
- Diseño escalable y observable

---

## 🏗️ Arquitectura del sistema

Desarrollador → GitHub → GitHub Actions (CI/CD) → Docker (multi-stage) → Amazon ECR → Amazon EKS → Microservicios

---

## ☁️ Infraestructura en AWS

- Amazon VPC (10.0.0.0/16)
- Amazon EKS (Kubernetes v1.35)
- Amazon ECR
- Elastic Load Balancer
- AWS CloudWatch
- AWS Systems Manager
- NAT Gateway / Internet Gateway

Arquitectura:
- Multi-AZ
- Subredes públicas y privadas
- Backend aislado en subred privada
- Comunicación interna controlada

---

## 🔐 Seguridad (Zero Trust)

- Sin SSH (puerto 22 cerrado)
- Sin llaves .pem
- Acceso por AWS Systems Manager
- Credenciales temporales (STS)
- ClusterIP para backend interno
- Superficie de ataque reducida

---

## ☸️ Kubernetes (Amazon EKS)

- Cluster: innovatech-eks-cluster
- Versión: v1.35
- Nodos: T3 Large Spot
- Autoescalado habilitado

Servicios:
- Frontend → LoadBalancer (público)
- Backend Ventas → ClusterIP (interno)
- Backend Logística → ClusterIP (interno)

---

## 🐳 Contenedores

- Microservicios dockerizados
- Multi-stage builds
- Imágenes optimizadas
- Publicación en Amazon ECR

Versionado:
eks-${{ github.run_number }}

---

## ⚙️ Pipeline CI/CD (GitHub Actions)

Flujo:
Desarrollador → GitHub → Actions → Docker → ECR → EKS → Deploy

Etapas:
- Checkout del código
- Autenticación AWS (STS)
- Build de imagen Docker
- Push a ECR
- Deploy en EKS
- Rolling update sin downtime

Características:
- Deploy automático en main
- Versionado dinámico
- Entrega inmutable
- Cero downtime

---

## 📈 Escalabilidad y resiliencia

Horizontal Pod Autoscaler (HPA):
- Escalado automático por CPU
- Umbral 50%
- Ajuste dinámico de réplicas
- Optimización con Spot Instances

---

## 📊 Observabilidad

Metrics Server:
kubectl top pods -n tienda

CloudWatch:
- Logs API Server
- Auditoría del clúster
- Eventos de autenticación
- Eventos del sistema

---

## 🧩 Microservicios

| Servicio | Tecnología | Función |
|----------|------------|----------|
| Frontend | JavaScript | Interfaz |
| Ventas | Spring Boot | Gestión de ventas |
| Logística | Spring Boot | Gestión de entregas |

---

## 📂 Estructura del repositorio

.
├── .github/workflows
├── back-Ventas_SpringBoot
├── back-Despachos_SpringBoot
├── front_despacho
└── README.md

---

## 🚀 Validación del sistema

kubectl get pods -n tienda  
kubectl get svc -n tienda  
kubectl get deployments -n tienda  
kubectl top pods -n tienda  

---

## 🎯 Resultados de ingeniería

- Infraestructura en AWS
- Microservicios
- Kubernetes (EKS)
- CI/CD automatizado
- Seguridad Zero Trust
- Escalabilidad horizontal
- Observabilidad

---

## 👥 Equipo

- Benjamin Serrano
- Emilio Araya
- Luis Villalobos

---

## 📄 Licencia

Proyecto académico desarrollado en Duoc UC con fines educativos.
