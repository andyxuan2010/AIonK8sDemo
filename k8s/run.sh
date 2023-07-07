#!/bin/bash
#Build the Docker image:
docker build -t dolly-api:v1.0 .
docker images

#tag docker image before push
docker tag dolly-api:v1.1 andyxuan2010/dolly-api:v1.1

#docker login --username=andyxuan2010

#Push the Docker image to a container registry (e.g., Docker Hub, Google Container Registry, etc.):
docker push andyxuan2010/dolly-api:v1.1


#Apply the Kubernetes deployment, service, and ingress:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
