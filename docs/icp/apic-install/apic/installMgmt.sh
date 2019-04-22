#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#
PROJECT_NAME=apic41dev
APIC_MGMT_ENDPOINT=management.DOMAIN_NAME
CLUSTER_NAME=mycluster.icp
BACKUP_HOST=XXXXX
BACKUP_DIR=/home/XXXX/apicbackup 
FTP_USER=XXXX
FTP_PASS=XXXX
# MODE can be set to standard for HA environment
MODE=dev
# CLUSTER_SIZE can be set to 3 for HA environment
CLUSTER_SIZE=1

cd ./$PROJECT_NAME

# Setup management subsystem
echo "Set management system properties"
echo 
apicup subsys create mgmt management --k8s
apicup subsys set mgmt create-crd true
apicup subsys set mgmt platform-api   $APIC_MGMT_ENDPOINT
apicup subsys set mgmt api-manager-ui $APIC_MGMT_ENDPOINT
apicup subsys set mgmt cloud-admin-ui $APIC_MGMT_ENDPOINT
apicup subsys set mgmt consumer-api   $APIC_MGMT_ENDPOINT
apicup subsys set mgmt namespace apiconnect
apicup subsys set mgmt registry $CLUSTER_NAME:8500/apiconnect/
apicup subsys set mgmt registry-secret apiconnect-icp-secret
apicup subsys set mgmt cassandra-max-memory-gb 16
apicup subsys set mgmt cassandra-cluster-size 1
apicup subsys set mgmt cassandra-volume-size-gb 16
apicup subsys set mgmt cassandra-backup-host $BACKUP_HOST 
apicup subsys set mgmt cassandra-backup-protocol sftp
apicup subsys set mgmt cassandra-backup-port 22
apicup subsys set mgmt cassandra-backup-path $BACKUP_DIR/cassandra
apicup subsys set mgmt cassandra-backup-auth-user  $FTP_USER
apicup subsys set mgmt cassandra-backup-auth-pass  $FTP_PASS
apicup subsys set mgmt cassandra-backup-schedule "0 0 * * *"
apicup subsys set mgmt storage-class rbd-storage-class
apicup subsys set mgmt mode dev

# OPTIONAL: Write the configuration to an output file to inspect apicinstall/apiconnect-up.yaml prior to installation
apicup subsys install mgmt --out mgmt-out --debug

# If output file is not used, enter command below to start the installation
apicup subsys install mgmt --debug

cd ..