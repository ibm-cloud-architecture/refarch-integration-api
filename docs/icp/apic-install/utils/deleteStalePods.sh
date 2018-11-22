# Delete secrets - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get pods -n $NAMESPACE | grep -v Running | awk -F' ' '{print $1 }'  | while read podId
do
    if [ "$podId" != "NAME" ]
    then
        echo "Deleting the pod  : " $podId
        kubectl delete pods $podId  -n $NAMESPACE -- force --grace-period=0
    fi
done 
