#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#
PROJECT_NAME=apic41dev
GATEWAY_ENDPOINT=gateway.DOMAIN_NAME
GATEWAY_DIRECTOR_ENDPOINT=gateway-director.DOMAIN_NAME
CLUSTER_NAME=mycluster.icp
# MODE can be set to standard for HA environment
MODE=dev
# CLUSTER_SIZE can be set to 3 for HA environment
CLUSTER_SIZE=1

cd ./$PROJECT_NAME
 
# Setup gateway subsystem
echo "Set gateway system properties"
echo
apicup subsys create gwy gateway --k8s
apicup subsys set gwy api-gateway $GATEWAY_ENDPOINT 
apicup subsys set gwy apic-gw-service $GATEWAY_DIRECTOR_ENDPOINT
apicup subsys set gwy namespace apiconnect
apicup subsys set gwy registry-secret apiconnect-icp-secret
apicup subsys set gwy image-repository ibmcom/datapower
apicup subsys set gwy image-tag "latest"
apicup subsys set gwy image-pull-policy Always
apicup subsys set gwy replica-count $CLUSTER_SIZE
apicup subsys set gwy max-cpu 4
apicup subsys set gwy max-memory-gb 6
apicup subsys set gwy storage-class rbd-storage-class
apicup subsys set gwy v5-compatibility-mode true 
apicup subsys set gwy enable-tms false
apicup subsys set gwy mode $MODE

#OPTIONAL: Write the configuration to an output file to inspect apicinstall/apiconnect-up.yaml prior to installation
apicup subsys install gwy --out gwy-out  --debug 

#If output file is not used, enter command below to start the installation
apicup subsys install gwy  --debug

cd ..