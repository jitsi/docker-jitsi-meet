# Install Guide for Kubernetes using Kustomize

This guide will deploy jitsi on a kubernetes cluster based on [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/). Kubernetes Kustomize allows you to configure your jitsi setup in an easy and transparent way. 


## Kustomize Your Jitsi 

To create a custom deployment based on kustomize, first create an overlay with your custom settings. Create a new folder with the file *kustomization.yaml*:

	namespace: jitsi
	bases:
	- https://github.com/rsoika/docker-jitsi-meet/examples/kubernetes/kustomize
	
	resources:
	- 041-ingress.yaml
	
	patchesStrategicMerge:
	- 010-deployment.yaml



The *kustomization.yaml* file simply points into the base directory hosted on github. It defines the default namespace 'jitsi' where the resource objects will be created. Within this directory you can define new resources like an Ingress configuration and also resources with custom environment variables to be merged into the a existing base resources. 

So your Kubernetes setup directory for jitsi should look like this:

	.
	├── my-jitsi
	│   ├── 010-deployment.yaml
	│   ├── 041-ingress.yaml
	│   └── kustomization.yaml
	
              
## Custom Configuration

With the file *010-deployment.yaml* you can add additional environment variables to configure jitsi. 
The following example shows how to set the environment variable 'PUBLIC_URL' which should point to your public Internet domain configured in your Ingress:


	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  labels:
	    k8s-app: jitsi
	  name: jitsi
	spec:
	  template:
	    metadata:
	      labels:
	        k8s-app: jitsi
	    spec:
	      containers:
	        - name: web
	          env:
	            - name: PUBLIC_URL
	              value: "https://jitsi.foo.com"
	
	        - name: prosody
	          env:
	            - name: PUBLIC_URL
	              value: "https://jitsi.foo.com"


Replace 'jitsi.foo.com' with your internet domain name:
 
**Note:** Setting the PUBLIC_URL it is important that you do not add a tailing / at the end of the URL!

Jitsi provides a lot of additional environment variables to customize your setup. 

## Ingress Example

The following example file 041-ingress.yaml adds a new resource object with a custom ingress configuration applied to your cluster. 

	---
	###################################################
	# Ingress
	###################################################
	kind: Ingress
	apiVersion: networking.k8s.io/v1
	metadata:
	  name: jitsi
	  namespace: jitsi
	  annotations:
	    cert-manager.io/cluster-issuer: "letsencrypt-prod"
	spec:
	  tls:
	  - hosts:
	    - jitsi.foo.com
	    secretName: tls-jitsi
	  rules:
	  - host: jitsi.foo.com
	    http:
	      paths:
	      - path: /
	        pathType: Prefix
	        backend:
	          service:
	            name: web
	            port:
	              number: 80

Replace 'jitsi.foo.com' with your Internet domain name:

**Note:** This Ingress example assumes that you have already a running [Ingress Network](https://kubernetes.io/docs/concepts/services-networking/ingress/)  based on the [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx) in combination with the ACME provider [Let's Encrypt](https://letsencrypt.org/).

## Deploy

Before you deploy the first time, create a namespace to deploy jitsi to:

	kubectl create namespace jitsi

Next create a secret with your secret password (replace `my-password` with some random strings):

	kubectl create secret generic jitsi-config -n jitsi --from-literal=JICOFO_COMPONENT_SECRET=my-password --from-literal=JICOFO_AUTH_PASSWORD=my-password --from-literal=JVB_AUTH_PASSWORD=my-password


Now you can deploy your jitsi with:

	$ kubectl apply -k  ./my-deployment
	

## Undeploy

To undeploy jitsi run

	$ kubectl delete -k  ./my-deployment
	$ kubectl delete namespace jitsi
	



	
	