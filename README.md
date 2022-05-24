### https://2021-03-lke.container.training/#180

### install cert-manager
```shell
kubectl create ns nginx-v2

helm repo add jetstack https://charts.jetstack.io
helm repo add nginx-stable https://helm.nginx.com/stable
helm install nginx-ingress  nginx-stable/nginx-ingress

#helm repo add traefik https://helm.traefik.io/traefik
#kubectl create ns nginx-v2
#Install in the namespace "traefik-v2"
#helm install --namespace=traefik-v2 traefik traefik/traefik

helm repo update

export VERSION=v1.8.0
helm install cert-manager jetstack/cert-manager \
--namespace cert-manager \
--create-namespace \
--version $VERSION \
--set installCRDs=true

# uninstall
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces

kubectl get pods,services,ingresses \
--selector=acme.cert-manager.io/http01-solver=true

kubectl describe ingress \
--selector=acme.cert-manager.io/http01-solver=true

k describe ing cm-acme-http-solver-lcr76
curl http://wordpress.aerogramme.io/.well-known/acme-challenge/jT5uo4g5qJubxNSc9

helm --namespace cert-manager delete cert-manager
kubectl delete namespace cert-manager
```

### Check Cert-manager plugin
```shell
curl -L -o kubectl-cert-manager.tar.gz \
https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin

kubectl cert-manager check api

```
### Create Secret
```shell
# Create keys and cert
openssl req \
-x509 \
-nodes \
-days 365 \
-newkey rsa:2048 \
-keyout tls.key \
-out tls.crt \
-subj "/CN=wordpress.aerogramme.io"

openssl req \
-x509 \
-nodes \
-days 365 \
-newkey rsa:2048 \
-out tls.crt \
-keyout tls.key \
-subj "/CN=wordpress.aerogramme.io/O=wordpress-app-secret"

# CREATE KUBERNETES TLS SECRET USING OPENSSL
kubectl create secret tls wordpress-app-secret \
--namespace wordpress \
--key tls.key \
--cert tls.crt
```
