#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#

# Define cluster information
CLUSTER_NAME=mycluster.icp
CLUSTER_ADMIN=admin
CLUSTER_PWD=XXXX
CLUSTER_EMAIL=admin@DOMAIN_NAME

# Create namespace
kubectl create namespace apiconnect
kubectl apply -f apiconnect-user.yaml -n apiconnect 

# Create secrets
kubectl create secret docker-registry apiconnect-icp-secret --docker-server=$CLUSTER_NAME:8500 --docker-username=$CLUSTER_ADMIN --docker-password=$CLUSTER_PWD --docker-email=$CLUSTER_EMAIL --namespace apiconnect