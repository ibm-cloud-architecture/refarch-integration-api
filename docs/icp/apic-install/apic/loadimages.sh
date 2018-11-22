#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#

# Define cluster name 
CLUSTER_NAME=mycluster.icp
# Define the location of images 
IMAGE_DIR=/DIRECTORY_HAVING_IMAGES

# Load PPA Archives
cd $IMAGE_DIR
cloudctl catalog load-ppa-archive --archive $IMAGE_DIR/analytics-images-icp.tgz --registry $CLUSTER_NAME:8500
cloudctl catalog load-ppa-archive --archive $IMAGE_DIR/gateway-images-icp.tgz --registry $CLUSTER_NAME:8500
cloudctl catalog load-ppa-archive --archive $IMAGE_DIR/management-images-icp.tgz --registry $CLUSTER_NAME:8500
cloudctl catalog load-ppa-archive --archive $IMAGE_DIR/portal-images-icp.tgz --registry $CLUSTER_NAME:8500