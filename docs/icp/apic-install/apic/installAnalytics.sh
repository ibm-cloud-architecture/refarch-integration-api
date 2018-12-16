#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#
PROJECT_NAME=apic41dev
ANALYTICS_INGESTION_ENDPOINT=analytics-ingestion.DOMAIN_NAME
ANALYTICS_CLIENT_ENDPOINT=analytics-client.DOMAIN_NAME
CLUSTER_NAME=mycluster.icp
# MODE can be set to standard for HA environment
MODE=dev

cd ./$PROJECT_NAME

# Seup analytics subsystem
echo "Set analytics system properties"
echo
apicup subsys create analyt analytics --k8s
apicup subsys set analyt analytics-ingestion $ANALYTICS_INGESTION_ENDPOINT
apicup subsys set analyt analytics-client    $ANALYTICS_CLIENT_ENDPOINT
apicup subsys set analyt namespace apiconnect
apicup subsys set analyt registry $CLUSTER_NAME:8500/apiconnect
apicup subsys set analyt registry-secret apiconnect-icp-secret
apicup subsys set analyt coordinating-max-memory-gb 6
apicup subsys set analyt data-max-memory-gb 6
apicup subsys set analyt data-storage-size-gb 200
apicup subsys set analyt master-max-memory-gb 8
apicup subsys set analyt master-storage-size-gb 5
apicup subsys set analyt storage-class rbd-storage-class
apicup subsys set analyt mode $MODE

# OPTIONAL: Write the configuration to an output file to inspect apicinstall/apiconnect-up.yaml prior to installation
apicup subsys install analyt --out analyt-out  --debug 

# If output file is not used, enter command below to start the installation
apicup subsys install analyt  --debug

cd ..