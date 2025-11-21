# Kubernetes Manifests (Optional)

This directory contains Kubernetes manifests for deploying the Task Management application to Azure Kubernetes Service (AKS) or other Kubernetes clusters.

## 📁 Structure

```
kubernetes/
├── base/                   # Base configurations
│   ├── namespace.yaml
│   ├── configmap.yaml
│   └── secrets.yaml
├── backend/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── hpa.yaml           # Horizontal Pod Autoscaler
├── frontend/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── database/
│   ├── statefulset.yaml
│   ├── service.yaml
│   └── pvc.yaml           # Persistent Volume Claim
└── kustomization.yaml     # Kustomize overlay
```

## 🚀 Quick Start

### Prerequisites
- AKS cluster provisioned via Terraform
- kubectl configured to connect to cluster
- ACR integrated with AKS

### Deploy All Services
```bash
kubectl apply -k .
```

### Deploy Individual Services
```bash
kubectl apply -f base/namespace.yaml
kubectl apply -f database/
kubectl apply -f backend/
kubectl apply -f frontend/
```

## 📊 Monitoring

### Check Deployment Status
```bash
kubectl get pods -n taskmanager
kubectl get services -n taskmanager
kubectl get ingress -n taskmanager
```

### View Logs
```bash
kubectl logs -f deployment/backend -n taskmanager
kubectl logs -f deployment/frontend -n taskmanager
```

### Scale Deployments
```bash
kubectl scale deployment backend --replicas=3 -n taskmanager
```

## 🔐 Secrets Management

### Create Secrets from Environment Variables
```bash
kubectl create secret generic app-secrets \
  --from-literal=DATABASE_URL=postgresql://... \
  --from-literal=JWT_SECRET=... \
  -n taskmanager
```

### Or use Azure Key Vault (recommended)
Install Secrets Store CSI Driver:
```bash
helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure
```

## 🌐 Ingress Configuration

The frontend ingress is configured to use Azure Application Gateway or NGINX Ingress Controller.

### Get Ingress IP
```bash
kubectl get ingress -n taskmanager
```

### Configure DNS
Point your domain to the ingress IP address.

## 📈 Autoscaling

Horizontal Pod Autoscaler (HPA) is configured to scale based on CPU/memory:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## 🔄 CI/CD Integration

GitHub Actions can deploy to Kubernetes automatically:

```yaml
- name: Deploy to AKS
  uses: azure/k8s-deploy@v1
  with:
    manifests: |
      infra/kubernetes/backend/deployment.yaml
      infra/kubernetes/backend/service.yaml
    images: |
      ${{ secrets.ACR_LOGIN_SERVER }}/tm-backend:${{ github.sha }}
    namespace: taskmanager
```

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| ImagePullBackOff | Verify ACR credentials: `kubectl create secret docker-registry acr-secret` |
| CrashLoopBackOff | Check logs: `kubectl logs <pod-name>` and events: `kubectl describe pod <pod-name>` |
| Service not accessible | Verify service and ingress configuration |
| Database connection failed | Check secret and configmap values |

## 📖 Best Practices

1. **Use Namespaces**: Isolate environments (dev, staging, prod)
2. **Resource Limits**: Set CPU/memory limits for all containers
3. **Health Checks**: Configure liveness and readiness probes
4. **ConfigMaps**: Externalize configuration
5. **Secrets**: Never commit secrets to Git
6. **Monitoring**: Use Azure Monitor or Prometheus

## 🎯 Next Steps

- Set up Prometheus & Grafana for monitoring
- Configure Azure Monitor integration
- Implement GitOps with Flux or ArgoCD
- Add network policies for security
- Configure pod security policies
