# Delete Persistent Volume Claim - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get pvc -n $NAMESPACE | awk -F' ' '{print $1 }'  | while read pvcId
do
    if [ "$pvcId" != "NAME" ]
    then
        echo "Deleting the Persistent Volume Claim : " $pvcId
        kubectl delete pvc $pvcId -n $NAMESPACE --force
    fi
done 