# Kubernetes Cluster on AWS with Terraform and Kubeadm

This project sets up a basic Kubernetes cluster on AWS using:
- Terraform for provisioning EC2 instances and networking
- Bash script to install containerd, kubeadm, and Kubernetes components


## Structure

- `terraform/` – AWS infrastructure setup (VPC, subnet, EC2s)
- `scripts/k8s-install.sh` – Node preparation and Kubernetes installation script


### Provision AWS Resources


cd terraform
terraform init
terraform apply

Now check all the resources and try to ping with each others. If everything goes well, perform next action on each nodes.


### Install Kubernetes on EC2 nodes

Login to each nodes using ssh or directly from aws console and copy the script K8s-cluster.sh  to install kubernetes on each workers node and maste node...........

make it executable
#chmod +X K8s-cluster.sh
#./K8s-cluster.sh

If everything goes well, you will see the message for init kubeadm or join worker nodes to the master node


# Initialize Kubernetes Master Node: Initialize the Kubernetes cluster using kubeadm

only on master node runs this command 


#sudo kubeadm init

# Deploy a Pod Network: Install a pod network so that your nodes can communicate with each other

 kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Joining Worker nodes to master node 
 # You will get a command to join the Worker Nodes after running kubeadm init on master node 

 Now login to the workers node and run the command that you get from master node
 
 for example: 
 
 kubeadm join 10.0.1.201:6443 --token hqsq0f.8vjj4rpzrz1bfkzh \
        --discovery-token-ca-cert-hash sha256:449b526a1345371f4dacc8c8212405c28335c7f59d3b87accb7ef983287df573 

Finally check the nodes joined or not:

Run the following command on master nodes and check the output:

kubectl get nodes 

output will be like this :

ubuntu@ip-10-0-1-201:~$ kubectl get nodes

NAME            STATUS   ROLES           AGE     VERSION
ip-10-0-1-109   Ready    <none>          8m50s   v1.29.15
ip-10-0-1-201   Ready    control-plane   17m     v1.29.15
ip-10-0-1-61    Ready    <none>          5m15s   v1.29.15


#### Deploy simple Python App to Kubernetes cluster ###

my-python-app/
├── app.py
├── requirements.txt
└── Dockerfile

########################
Create app.py
### Paste this code to app.py####

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Kubernetes!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

    #########

  #####  create requirements.txt file and paste #####
    flask


###Create Docker File ####
Dockerfile

#################

FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]

################



###Build & Push Docker Image###

docker build -t dockerhub-username/python-web-app .
docker push dockerhub-username/python-web-app

###Create Kubernetes Deployment YAML####

For simplicity I use master node to create Kubernetes Deployment YAML
#############################
Make a folder on your master node
mkdir k8-kubernetes
cd k8-kubernetes
nano deployment.yml
############################

apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: python-web
  template:
    metadata:
      labels:
        app: python-web
    spec:
      containers:
      - name: python-web
        image: your-dockerhub-username/python-web-app
        ports:
        - containerPort: 5000

        ###############


        service.yml

        

        #########################

        apiVersion: v1
kind: Service
metadata:
  name: python-web-service
spec:
  selector:
    app: python-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
      nodePort:30080
  type: Nodeport


  ##################


 #######Deploy to Kubernetes############
 Run the following command on master node to deploy the application

 kubectl apply -f deployment.yaml
 kubectl apply -f service.yaml

 ####Access your applicatio####

 kubectl get svc

and then try from your broser using public ip and port
http://52.58.126....:30080/

#####  Scale the Deployment Manually#####
kubectl scale deployment python-web-app --replicas=4


#### Then verify ####

kubectl get pods -o wide


##### Check Which Node Each Pod Runs On ####
kubectl get pods -o=custom-columns=NAME:.metadata.name,NODE:.spec.nodeName

#### Check pod log ####

kubectl logs pod-name











