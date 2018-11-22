# Delete StatefulSets - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get StatefulSets -n $NAMESPACE  | awk -F' ' '{print $1 }'  | while read statefulsetId
do
    if [ "$statefulsetId" != "NAME" ]
    then
        echo "Deleting the StatefulSet : " $statefulsetId
        kubectl delete StatefulSet $statefulsetId -n $NAMESPACE --force 
    fi
done 