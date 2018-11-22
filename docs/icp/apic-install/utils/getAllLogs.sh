# Get log for all pods - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

export logFileSuffix=.log
kubectl get pods -n  $NAMESPACE | awk -F' ' '{print $1 }'  | while read podId
do
    if [ "$podId" != "NAME" ]
    then
        echo "Getting log for the pod: " $podId
        kubectl logs -n $NAMESPACE $podId > $podId$logFileSuffix
    fi
done
