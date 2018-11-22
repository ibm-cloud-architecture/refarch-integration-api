# Delete images - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl get images -n $NAMESPACE | awk -F' ' '{print $1 }' | while read imageId
do
    if [ "$imageId" != "NAME" ]
    then
        echo "Deleting the image : " $imageId
        kubectl delete image $imageId -n $NAMESPACE --force 
    fi
done

