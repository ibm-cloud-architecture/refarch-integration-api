#
# UPDATE VARIABLES TO MATCH THE ENVIRONMENT
#
PROJECT_NAME=apic41dev

cd ./$PROJECT_NAME

apicup subsys get mgmt
apicup subsys get gwy
apicup subsys get analyt
apicup subsys get ptl

cd ..