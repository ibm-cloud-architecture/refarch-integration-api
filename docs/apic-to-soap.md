# API Connect to SOAP service
One possible configuration is to do not use IBM Integration Bus and do the interface mapping in API Connect assembly. The architecture will look like the diagram below:

![](cp-phy-view.png)

## How the SOAP interface was mapped to RESTful API
In order to map the SOAP service to a REST api, we followed the following steps:  
1) Using the API Manager, create a REST API (see tutorial here: https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.apionprem.doc/tutorial_apionprem_expose_SOAP.html)
 a- Add a new product
2) Import the WSDL for the SOAP service in the "Services" component. This is basically an import from either a file or an url. We used the url option by pointing to on-premise WebSphere Liberty server URL: http://172.16.254.44:9080/inventory/ws?WSDL.
3) Create an assembly for each of the supported REST operations:

```
          title: operation-switch
          case:
            - operations:
                - verb: get
                  path: /items
            - operations:
                - verb: get
                  path: '/item/{itemId}'
            - operations:
                - verb: post
                  path: /items
            - operations:
                - verb: put
                  path: '/item/{itemId}'
            - operations:
                - verb: delete
                  path: '/item/{itemId}'
```


 For each of these operations, there is a generated map and a `invoke` created by the import of the WSDL. You need to find the operation map that corresponds to the REST operation you are implementing and drop it on the canvas.

 But first you must define the "url-path" that corresponds to the SOAP operation.  
 For example, to implement GET /items REST API, you would need to define a "Path" for "/items" first. Go over to the "assembly" tab, you'll see a default invoke policy has been defined for you for the GET /items path - delete it by hovering over the policy until a few icons appear on top of the policy. Click on the trash icon to delete. In the assembly tab of the API Manager UI, you'll see a whole bunch of operations at the left hand bottom portion of the screen. Select "items" and drag it to the canvas. It should now look like this:
map(items:input)->invoke(items:invoke)->map(items:output)

For a get item by id the pattern is the same as illustrated in the image below:
 ![](assemble-get-item.png)
 The invoke is a SOAP request (a HTTP POST)
Using the REST input parameter, itemId, we need to use it for the SOAP request itemById.id element.:
![](inputtosoap.png)

The following diagram illustrates a mapping from the SOAP response of the itemById to the JSON document of the /item/{itemId} which is part of the new exposed API.

![itemById](rest2soap-mapping.png)


See the completed yaml here: https://github.com/ibm-cloud-architecture/refarch-integration-api/blob/master/apiconnect/sample-inventory-api_1.0.0.yaml
