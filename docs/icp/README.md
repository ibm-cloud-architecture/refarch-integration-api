# Install IBM API Connect 2018.1 on ICP 2.1.0.2

## Download the tar files from Passport Advantage / Fix Central

I got most of my files from Fix Central, with the exception of gateway-images-icp.tgz which is in XL.

## Install apicup

```bash
chmod 755 apicup-linux
alias apicup=~/apicup-linux
chmod 755 apic-linux
alias apic=~/apic-linux
```

## Prepare terminal for IBM Cloud Private

```console
bx pr login --skip-ssl-validation -a https://mycluster.icp:8443 -u admin -p admin -c id-mycluster-account
bx pr cluster-config mycluster
docker login mycluster.icp:8500 -u admin -p admin
```

## Create namespace in IBM Cloud Private

```bash
kubectl create namespace apiconnect
#privileged is required for portal. Best practice might require create a new role and be more selective with permissions.
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: apiconnect-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: privileged
subjects:
- kind: ServiceAccount
  name: default
  namespace: apiconnect
EOF
```

### Create via ICP Console

- [Creating a namespace](https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/user_management/create_project.html)

## Create registry secret

```bash
kubectl create secret docker-registry apiconnect-icp-secret --docker-server=mycluster.icp:8500 --docker-username=admin --docker-password=admin --docker-email=admin@admin.com --namespace apiconnect
```

## Setup helm

```bash
wget https://mycluster.icp:8443/helm-api/cli/linux-amd64/helm --no-check-certificate
chmod 755 helm
#Initialize your Helm CLI.
./helm init --client-only --skip-refresh
echo $PATH
mkdir -p /root/bin
mv helm /root/bin/helm
#Workaround for ICP 2.1.02
mv /root/bin/helm /root/bin/helm-icp
wget https://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9b.tgz
tar xvfz shc-3.8.9b.tgz
cd shc-3.8.9b
make
echo -e '#!/bin/bash\n /root/bin/helm-icp "$@" --tls\n' | cat > helm.sh
./shc -f helm.sh
mv helm.sh.x /root/bin/helm
#Verify that the Helm CLI is initialized
helm version
helm list
```

## Upload the tar files to the image registry

```bash
apicup registry-upload management management-images.tgz mycluster.icp:8500 --accept-license --debug
apicup registry-upload portal portal-images.tgz mycluster.icp:8500 --accept-license --debug
apicup registry-upload analytics analytics-images.tgz mycluster.icp:8500 --accept-license --debug
#workaround
bx pr load-ppa-archive --archive gateway-images-icp.tgz -namespace apiconnect
apicup registry-upload gateway gateway-images-icp.tgz mycluster.icp:8500 --accept-license --debug
```

## Verify images are loaded correctly

```bash
kubectl get images -n apiconnect
```

## First add a management service

```bash
###############################
### TODO Consider DEMO mode ###
###############################
mkdir ./myProject
cd ./myProject
apicup init
apicup subsys create mgmt management --k8s
apicup endpoints set mgmt platform-api apicplatform.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set mgmt api-manager-ui apicmanager.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set mgmt cloud-admin-ui apiccloud.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set mgmt consumer-api apicconsumer.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup subsys set mgmt registry mycluster.icp:8500
apicup subsys set mgmt namespace apiconnect
apicup subsys set mgmt registry-secret apiconnect-icp-secret
apicup subsys set mgmt cassandra-max-memory-gb 16
apicup subsys set mgmt cassandra-cluster-size 1
apicup subsys set mgmt cassandra-volume-size-gb 10
apicup subsys set mgmt search-max-memory-gb 2
apicup subsys set mgmt search-volume-size-gb 10
apicup subsys set mgmt storage-class $(kubectl get storageclass -o yaml | grep name: | awk '{ print $2}')
apicup subsys set mgmt portal-base-uri http://apicportal.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup subsys set mgmt mode demo

apicup subsys install mgmt --debug --no-wait
```

## Configure a Gateway Service Endpoint and API Endpoint in DataPower

```bash
apicup subsys create gw1 gateway --k8s
apicup endpoints set gw1 gateway apicapi-gateway.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set gw1 gateway-director apicapic-gateway-director.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup subsys set gw1 namespace apiconnect
apicup subsys set gw1 registry mycluster.icp:8500
apicup subsys set gw1 registry-secret apiconnect-icp-secret
apicup subsys set gw1 mode demo
apicup subsys set gw1 max-cpu 2
apicup subsys set gw1 max-memory-gb 5
apicup subsys set gw1 replica-count 1

apicup subsys install gw1 --debug --no-wait
```

## Add an analytics service

```bash
apicup subsys create analytics analytics --k8s
apicup endpoints set analytics analytics-ingestion apicai.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set analytics analytics-client apicac.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup subsys set analytics registry mycluster.icp:8500
apicup subsys set analytics namespace apiconnect
apicup subsys set analytics registry-secret apiconnect-icp-secret
apicup subsys set analytics coordinating-max-memory-gb 6
apicup subsys set analytics data-max-memory-gb 8
apicup subsys set analytics data-storage-size-gb 50
apicup subsys set analytics master-max-memory-gb 8
apicup subsys set analytics master-storage-size-gb 1
apicup subsys set analytics storage-class $(kubectl get storageclass -o yaml | grep name: | awk '{ print $2}')
apicup subsys set analytics mode demo


// OPTIONAL: Write the configuration to an output file to inspect myProject/apiconnect-up.yaml prior to installation
apicup subsys install analytics --out analytics-out
apicup subsys install analytics --plan-dir ./myProject/analytics-out

//If output file is not used, enter command below to start the installation
apicup subsys install analytics --debug --no-wait
```

## Add a portal service

```bash
apicup subsys create ptl portal --k8s
apicup endpoints set ptl portal-admin apicpadmin.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup endpoints set ptl portal-www apicportal.$(kubectl cluster-info | grep "Kubernetes master" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/").nip.io
apicup subsys set ptl registry mycluster.icp:8500
apicup subsys set ptl namespace apiconnect
apicup subsys set ptl registry-secret apiconnect-icp-secret
apicup subsys set ptl www-storage-size-gb     5
apicup subsys set ptl backup-storage-size-gb  5
apicup subsys set ptl db-storage-size-gb      12
apicup subsys set ptl db-logs-storage-size-gb 2
apicup subsys set ptl mode demo

// OPTIONAL: Write the configuration to an output file to inspect myProject/apiconnect-up.yaml prior to installation
apicup subsys install ptl --out portal-out
apicup subsys install ptl --plan-dir ./myProject/portal-out

//If output file is not used, enter command below to start the installation
apicup subsys install ptl --debug --no-wait
```

## Login to API Cloud

```bash
#API Cloud login url
helm status $(helm list | grep apiconnect-2 | awk '{print $1}') | grep apiconnect-cm-ui | awk '{print "http://"$2}'
######################################################################################
## Create a gateway service. Navigate to `Topology -> Register Service -> Gateway`.
##
## For SNI, select the default TLS profile
## SNI host = *
## SNI TLS server profile = default
######################################################################################
#API Endpoint Base
kubectl get ingress -n apiconnect | grep dynamic-gateway-service-gw | awk '{print "https://"$2}'
#Endpoint
kubectl get svc -n apiconnect | grep dynamic-gateway-service-ingress | awk '{print "https://"$1".apiconnect:3000"}'
######################################################################################
## Create a analytics service. Navigate to `Topology -> Register Service -> analytics`.
######################################################################################
#Endpoint
kubectl get svc -n apiconnect | grep analytics-client | awk '{print "https://"$1".apiconnect:"$5}'
######################################################################################
## Create a portal service. Navigate to `Topology -> Register Service -> portal`.
######################################################################################
#Director Endpoint
kubectl get svc -n apiconnect | grep apic-portal-director | awk '{print "https://"$1".apiconnect:"$5}'
#Web Endpoint
kubectl get ingress -n apiconnect | grep apic-portal-web | awk '{print "https://"$2}'
helm status $(helm list | grep apic-portal) | grep apic-portal-web | awk '{print "http://"$2}'
```

You can login with default user name `admin` and password `7iron-hide`
