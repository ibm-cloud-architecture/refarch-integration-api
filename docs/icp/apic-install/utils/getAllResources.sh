# Get all resources - accepts namespace as an argument
if [ "$1" != "" ]
then
    export NAMESPACE=$1
else
    export NAMESPACE=apiconnect
fi

echo "Getting pods:"
kubectl get pods -n $NAMESPACE

echo ""

echo "Getting deployments:"
kubectl get deployment -n $NAMESPACE

echo ""

echo "Getting service:"
kubectl get service -n $NAMESPACE

echo ""

echo "Getting StatefulSet:"
kubectl get StatefulSet -n $NAMESPACE

echo ""

echo "Getting DaemonSet:"
kubectl get DaemonSet -n $NAMESPACE

echo ""

echo "Getting Storage Class:"
kubectl get sc -n $NAMESPACE

echo ""

echo "Getting Persistent Volume:"
kubectl get pv -n $NAMESPACE

echo ""

echo "Getting Persistent Volume Chain:"
kubectl get pvc -n $NAMESPACE

echo ""

echo "Getting job:"
kubectl get job  -n $NAMESPACE

echo ""

echo "Getting secret:"
kubectl get secret  -n $NAMESPACE

echo ""

echo "Getting Cluster Role:"
kubectl get ClusterRole -n $NAMESPACE

echo ""

echo "Getting Cluster Role Binding:"
kubectl get ClusterRoleBinding -n $NAMESPACE

echo ""

echo "Getting images:"
kubectl get images -n $NAMESPACE