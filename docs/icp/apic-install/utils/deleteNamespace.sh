# Delete namespace - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

kubectl delete namespace $NAMESPACE 
