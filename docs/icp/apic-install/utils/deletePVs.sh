# Delete Persistent Volume - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get pv | grep $NAMESPACE | awk -F' ' '{print $1 }'  | while read pvId
do
    if [ "$pvId" != "NAME" ]
    then
        echo "Deleting the Persistent Volume : " $pvId
        kubectl delete pv $pvId --force
    fi
done 