kind delete clusters app-clusters
kind create cluster --config=kind-deploy.yaml
cd ./postgres
kubectl apply -f .
cd ../pgpool
kubectl apply -f .
cd ../crossbar-deploy
kubectl apply -f .
cd ../app
kubectl apply -f .
cd ../redis
kubectl apply -f .
cd ../celery
kubectl apply -f .
cd ../pgadmin
# kubectl wait --namespace ingress-nginx \
#   --for=condition=ready pod \
#   --selector=app.kubernetes.io/component=controller 
  
# run after ingress is up and running
kubectl apply -f .

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml




