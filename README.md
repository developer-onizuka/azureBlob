# azureBlob

# 1. Create Container including Azure CLI, azCopy and dotnet SDK
```
$ git clone https://github.com/developer-onizuka/azureBlob
$ cd azureBlob
$ sudo docker build -t azureblob .
```

# 2. Run the container and login to your account. You access to the URL and enter the code for autenticaion.
```
$ sudo docker run -it --rm --name azureblob azureblob:latest
bash-5.1# 
bash-5.1# az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code XxXxXxXxX to authenticate.
```

The followings could be done in the container you invoked in previous command.
---

# 3. Create Storage Account
```
HOT_STORAGE_NAME=hotstorage$RANDOM
LOCATION=japaneast
RESOURCE_GROUP=xxxx-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```
```
az storage account create \
  --location $LOCATION \
  --name $HOT_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_RAGRS \
  --kind BlobStorage \
  --access-tier Hot
```

# 4. Obtain the keys for the Storage Account
```
az storage account keys list \
  --account-name $HOT_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```
```
HOT_KEY=<Use the first key retrieved by the previous command>
```

# 5. Create a container named "myfirstblob"
```
az storage container create \
  --name myfirstblob \
  --account-name $HOT_STORAGE_NAME \
  --account-key $HOT_KEY
```

# 6. Download test file to upload and upload it to the blob
```
cd $HOME
git clone https://github.com/developer-onizuka/azureBlob sample
```

Azure Storage provides extensions for Azure CLI that enable you to specify how you want to authorize operations on blob data. You can authorize data operations in the following ways:

- With the account access key or a shared access signature (SAS) token.
- With an Azure Active Directory (Azure AD) security principal. Microsoft recommends using Azure AD credentials for superior security and ease of use.

# 6-1. Using Access Key
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --account-key $HOT_KEY
```

# 6-2. Using SAS token instead of Account Key
A shared access signature (SAS) is a URI that grants restricted access to an Azure Storage container. Use it when you want to grant access to storage account resources for a specific time range without sharing your storage account key. Let's create like below:

![azureBlob1](https://github.com/developer-onizuka/azureBlob/blob/master/azureBlob1.png)

```
SAS_TOKEN=<Use the key created in azure portal>
```
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --sas-token $SAS_TOKEN
```

# 6-3. Using RBAC instead of Account Key and SAS token
With an Azure Active Directory (Azure AD) security principal.

- Set the --auth-mode parameter to login to sign in using an Azure AD security principal (recommended). You could not find any Access Keys in the az command below:
- You need authorization if your login account is assigned required RBAC roles such as "Storage Blob Data Contributor" or "Storage Queue Data Contributor".
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --auth-mode login
```

- Set the --auth-mode parameter to the legacy key value to attempt to retrieve the account access key to use for authorization. If you omit the --auth-mode parameter, then the Azure CLI also attempts to retrieve the access key.
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --auth-mode key
```

# X. Go to Azure Portal
https://portal.azure.com/#home

