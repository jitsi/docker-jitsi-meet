# Install guide for kubernetes

This guide will deploy jitsi on a kubernetes cluster in the most simple way based on.
The setup is based on [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) providing a declarative object management.


## Kustomize your Jitsi 

To create a custom deployment create an overlay with your custom settings. First create a new folder with the file *kustomization.yaml*:

	namespace: jitsi
	bases:
	- https://github.com/rsoika/docker-jitsi-meet/examples/kubernetes/
	
	resources:
	- 041-ingress.yaml
	
	patchesStrategicMerge:
	- 010-deployment.yaml



The *kustomization.yaml* file simply points into the base directory hosted on github. It defines the default namespace 'jitsi' where the resource objects will be created. Within this directory you can define new resources or resources to be merged in a existing resource. 

So will have the following directory structure:

	.
	├── my-jitsi
	│   ├── 010-deployment.yaml
	│   ├── 041-ingress.yaml
	│   └── kustomization.yaml
	


             
              
## Custom Configuration

With the file *010-deployment.yaml* you can add additional environment variable to configure jitsi. 
The following example shows how to set DOCKER_HOST_ADDRESS which should point to your cluster node


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
	        - name: jvb
	          env:
	            - name: DOCKER_HOST_ADDRESS
	              value: <Set the address for any node in the cluster here>
	        - name: web
	          env:
	            - name: ENABLE_XMPP_WEBSOCKET
	              value: "0"





## Ingress Example

The file 041-ingress.yaml contains the custom ingress configuration applied to your cluster. See the following example. Replace 'jitsi.foo.com' with your internet domain name:

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
              
 

## Deploy

Before you deploy first create a namespace to deploy jitsi to:

	kubectl create namespace jitsi

Add the secret with secret values (replace `...` with some random strings):

	kubectl create secret generic jitsi-config -n jitsi --from-literal=JICOFO_COMPONENT_SECRET=... --from-literal=JICOFO_AUTH_PASSWORD=... --from-literal=JVB_AUTH_PASSWORD=... 


You can now deploy your jitsi  with:

	$ kubectl apply -k  ./my-deployment
	

## Undeploy

To undeploy jitsi run

	$ kubectl delete -k  ./my-deployment
	$ kubectl delete namespace jitsi
	



	
	