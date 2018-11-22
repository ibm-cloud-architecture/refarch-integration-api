# Delete deployments - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get deployments -n  $NAMESPACE | awk -F' ' '{print $1 }'  | while read deploymentId
do
    if [ "$deploymentId" != "NAME" ]
    then
        echo "Deleting the Deployment : " $deploymentId
        kubectl delete deployments -n $NAMESPACE $deploymentId --force 
    fi
done