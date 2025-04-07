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





