# Minicube is a beast an recuires 8gb of memory, set this up in youur docker settings
minikube start --cpus 4 --memory 7964MB  --kubernetes-version  1.19.0 --driver=hyperkit

#enable ingress
minikube addons enable ingress

# Add the helm char for Rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

#Create the namespace for rancher
kubectl create namespace cattle-system

#Install Cert Manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.4

# Wait for cert-manager to power up
kubectl -n cert-manager rollout status deploy/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager-cainjector
kubectl -n cert-manager rollout status deploy/cert-manager-webhook

#Install rancher
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.ualberta.ca

kubectl -n cattle-system rollout status deploy/rancher

kubectl get ingress -n cattle-system
