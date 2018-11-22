# Delete secrets - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get secret -n $NAMESPACE | awk -F' ' '{print $1 }'  | while read secretId
do
    if [ "$secretId" != "NAME" ]
    then
        echo "Deleting the Secret  : " $secretId
        kubectl delete secret $secretId  -n $NAMESPACE
    fi
done