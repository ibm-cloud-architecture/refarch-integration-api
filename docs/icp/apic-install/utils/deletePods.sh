# Delete pods - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get pods -n  $NAMESPACE | awk -F' ' '{print $1 }'  | while read podId
do
    if [ "$podId" != "NAME" ]
    then
        echo "Deleting the Job : " $podId
        kubectl delete pods -n $NAMESPACE $podId --grace-period=0 --force 
    fi
done