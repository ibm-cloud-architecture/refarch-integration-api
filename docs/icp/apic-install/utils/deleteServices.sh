# Delete services - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get services -n  $NAMESPACE | awk -F' ' '{print $1 }'  | while read serviceId
do
    if [ "$serviceId" != "NAME" ]
    then
        echo "Deleting the Service : " $serviceId
        kubectl delete services -n $NAMESPACE $serviceId --force 
    fi
done 