#!/bin/bash
# create namespace
kubectl create ns nginx-v2
# add repo
helm repo add jetstack https://charts.jetstack.io
helm repo add nginx-stable https://helm.nginx.com/stable
# install nginx-ingress-controller
helm install nginx-ingress  nginx-stable/nginx-ingress
# update repo
helm repo update
# cert-manager-version
export VERSION=v1.8.0
# install cert-manager
helm install cert-manager jetstack/cert-manager \
--namespace cert-manager \
--create-namespace \
--version $VERSION \
--set installCRDs=true

sleep 5
# switch context
kubectl config set-context --current --namespace nginx-v2

#kubectl apply -f basic-auth.yaml
#kubectl apply -f issuer-stage.yaml
#kubectl apply -f issuer-prod.yaml
#kubectl apply -f cm-certificate.yaml
#kubectl apply -f deployment.yaml