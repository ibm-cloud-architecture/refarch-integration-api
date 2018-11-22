# Delete services - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

helm ls --tls --namespace  $NAMESPACE | awk -F' ' '{print $1 }'  | while read helmReleaseId
do
    if [ "$helmReleaseId" != "NAME" ]
    then
        echo "Deleting the helm release : " $helmReleaseId
        helm delete $helmReleaseId --purge --tls
    fi
done