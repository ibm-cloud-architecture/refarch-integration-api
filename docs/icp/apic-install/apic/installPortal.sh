#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#
PROJECT_NAME=apic41dev
PORTAL_ADMIN_ENDPOINT=portal-admin.DOMAIN_NAME
PORTAL_ENDPOINT=portal.DOMAIN_NAME
CLUSTER_NAME=mycluster.icp
BACKUP_HOST=XXXXXX
BACKUP_DIR=/home/XXXXX/apicbackup 
FTP_USER=XXXXX
FTP_PASS=XXXXX

cd ./$PROJECT_NAME

# Setup Portal subsystem
echo "Set portal system properties"
echo
apicup subsys create ptl portal --k8s
apicup subsys set ptl portal-admin $PORTAL_ADMIN_ENDPOINT
apicup subsys set ptl portal-www $PORTAL_ENDPOINT
apicup subsys set ptl namespace apiconnect
apicup subsys set ptl registry $CLUSTER_NAME:8500/apiconnect
apicup subsys set ptl registry-secret apiconnect-icp-secret 
apicup subsys set ptl storage-class rbd-storage-class
apicup subsys set ptl www-storage-size-gb 5
apicup subsys set ptl backup-storage-size-gb 5
apicup subsys set ptl db-storage-size-gb 12
apicup subsys set ptl db-logs-storage-size-gb 2
apicup subsys set ptl admin-storage-size-gb 1
apicup subsys set ptl site-backup-host $BACKUP_HOST 
apicup subsys set ptl site-backup-port 22
apicup subsys set ptl site-backup-path $BACKUP_DIR
apicup subsys set ptl site-backup-auth-user $FTP_USER
apicup subsys set ptl site-backup-auth-pass $FTP_PASS
apicup subsys set ptl site-backup-path $BACKUP_DIR
apicup subsys set ptl site-backup-protocol sftp
apicup subsys set ptl site-backup-schedule "0 2 * * *"
apicup subsys set ptl mode dev

# OPTIONAL: Write the configuration to an output file to inspect apicinstall/apiconnect-up.yaml prior to installation
apicup subsys install ptl --out ptl-out  --debug 
#apicup subsys install ptl --plan-dir ptl-out  --debug

# If output file is not used, enter command below to start the installation
apicup subsys install ptl  --debug

cd ..
