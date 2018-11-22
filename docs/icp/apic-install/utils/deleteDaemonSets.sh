# Delete daemon sets - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get DaemonSets -n $NAMESPACE  | awk -F' ' '{print $1 }'  | while read daemonsetId
do
    if [ "$daemonsetId" != "NAME" ]
    then
        echo "Deleting the StatefulSet : " $daemonsetId
        kubectl delete DaemonSet $daemonsetId -n $NAMESPACE --force
    fi
done