# Delete resources
kubectl delete ClusterRoleBinding apiconnect-user 
kubectl delete secret apiconnect-icp-secret -n apiconnect 

./deleteAllSecrets.sh

kubectl delete namespace apiconnect