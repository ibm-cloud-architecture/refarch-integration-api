# Delete jobs - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get jobs -n  $NAMESPACE | awk -F' ' '{print $1 }'  | while read jobId
do
    if [ "$jobId" != "NAME" ]
    then
        echo "Deleting the Job : " $jobId
        kubectl delete jobs -n $NAMESPACE $jobId --force 
    fi
done