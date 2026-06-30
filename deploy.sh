#!/bin/bash

# Evita que continúe si hay algún error
set -e

# Configuración de variables (Ajustables según tu entorno)
REGION="us-east-1"
CLUSTER_NAME="devopseks"

# Obtener automáticamente el ID de Cuenta de AWS de la sesión actual
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URL="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

echo "===================================="
echo "AWS Account ID : ${ACCOUNT_ID}"
echo "EKS Cluster    : ${CLUSTER_NAME}"
echo "AWS Region     : ${REGION}"
echo "ECR URL Base   : ${ECR_URL}"
echo "===================================="

# 1. Actualizar kubeconfig para conectarse al clúster EKS
echo ""
echo "Actualizando kubeconfig para EKS..."
aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

# 2. Autenticar Docker con Amazon ECR
echo ""
echo "Iniciando sesión en Amazon ECR..."
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URL}

# 3. Crear el Namespace 'innovatech' si no existe
echo ""
echo "Creando namespace 'innovatech' si no existe..."
kubectl create namespace innovatech || true

# 4. Construcción y subida de imágenes a ECR
echo ""
echo "Iniciando compilación de imágenes Docker..."

# A. Backend Despachos
echo "----------------------------------------"
echo "Construyendo Backend Despachos..."
docker build -t despachos "./proyecto semestral/back-Despachos_SpringBoot/Springboot-API-REST-DESPACHO"
docker tag despachos:latest ${ECR_URL}/despachos:latest
docker push ${ECR_URL}/despachos:latest

# B. Backend Ventas
echo "----------------------------------------"
echo "Construyendo Backend Ventas..."
docker build -t ventas "./proyecto semestral/back-Ventas_SpringBoot/Springboot-API-REST"
docker tag ventas:latest ${ECR_URL}/ventas:latest
docker push ${ECR_URL}/ventas:latest

# C. Frontend
echo "----------------------------------------"
echo "Construyendo Frontend..."
docker build -t frontend "./proyecto semestral/front_despacho"
docker tag frontend:latest ${ECR_URL}/frontend:latest
docker push ${ECR_URL}/frontend:latest

# 5. Modificar manifiestos con la imagen correcta y desplegar
echo ""
echo "Aplicando manifiestos en Kubernetes..."

# Backend Despachos
echo "Desplegando Backend Despachos..."
sed -i "s|nginx:latest|${ECR_URL}/despachos:latest|g" kubernetes/01-despachos.yaml
kubectl apply -f kubernetes/01-despachos.yaml

# Backend Ventas
echo "Desplegando Backend Ventas..."
sed -i "s|nginx:latest|${ECR_URL}/ventas:latest|g" kubernetes/02-ventas.yaml
kubectl apply -f kubernetes/02-ventas.yaml

# Frontend
echo "Desplegando Frontend..."
sed -i "s|nginx:latest|${ECR_URL}/frontend:latest|g" kubernetes/03-frontend.yaml
kubectl apply -f kubernetes/03-frontend.yaml

# Aplicar políticas de Autoscaling
echo "Aplicando políticas de Autoscaling (HPA)..."
kubectl apply -f kubernetes/04-autoscaling.yaml

# 6. Monitoreo y Verificación
echo ""
echo "Esperando 15 segundos a que inicien los contenedores..."
sleep 15

echo "========================================="
echo "EVIDENCIA: ESTADO DE MÁQUINAS (NODOS)"
echo "========================================="
kubectl get nodes -o wide

echo ""
echo "========================================="
echo "EVIDENCIA: ESTADO DE CONTENEDORES (PODS)"
echo "========================================="
kubectl get pods -n innovatech

echo ""
echo "========================================="
echo "EVIDENCIA: ESTADO DE SERVICIOS (CONEXIONES Y URL)"
echo "========================================="
kubectl get svc -n innovatech
