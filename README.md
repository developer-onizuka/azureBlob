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

# 5-1. Create a container named "myfirstblob" instead of using account Access key
You can use --auto-mode instead of --account-key.
```
az storage container create \
  --name myfirstblob \
  --account-name $HOT_STORAGE_NAME \
  --auth-mode login
```

# 6. Download test file to upload and upload it to the blob
```
cd $HOME
git clone https://github.com/developer-onizuka/azureBlob sample
```

Azure Storage provides extensions for Azure CLI that enable you to specify how you want to authorize operations on blob data. You can authorize data operations in the following ways:

- With the account access key or a shared access signature (SAS) token.
- With an Azure Active Directory (Azure AD) security principal. Microsoft recommends using Azure AD credentials for superior security and ease of use.

|  | Possibility of leaking | Impact |
| :--- | :--- | :--- |
| Storage acount Access key<br>(--account-key) | Hard coded usernames, passwords, tokens and other secrets in the source code. | If leaked, it can be used by anyone who obtains it, which can potentially compromise your storage account. But even anyone who obtains Access key can not create Virtual Machines. Because it is only availble for Storage Account. |
| Shared access signature token<br>(--sas-token) | Hard coded usernames, passwords, tokens and other secrets in the source code. | If leaked, it can be used by anyone who obtains it, which can potentially compromise your storage account. But it is safer than Access key because it is a connection string for accessing the storage account with constraints such as expiration date and accessible IP address. |
| Azure AD<br>(--auth-mode) | No | - |

# 6-1. Using account access-key
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --account-key $HOT_KEY
```

# 6-2. Using SAS token instead of account Access key
A shared access signature (SAS) is a URI that grants restricted access to an Azure Storage container. Use it when you want to grant access to storage account resources for a specific time range without sharing your storage account key. Let's create like below:

![azureBlob3](https://github.com/developer-onizuka/azureBlob/blob/master/azureBlob3.png)

```
HOT_SAS_TOKEN=<Use the key created in azure portal>
```
```
az storage blob upload-batch \
  --destination myfirstblob \
  --pattern "test*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --sas-token $HOT_SAS_TOKEN
```

# 6-3. Using Azure AD's RBAC instead of account Access key and SAS token
With an Azure Active Directory (Azure AD) security principal.

- Set the --auth-mode parameter to login to sign in using an Azure AD security principal (recommended). 

"login" mode will directly use your login credentials for the authentication. It means you need authorization if your login account is assigned required RBAC roles such as "Storage Blob Data Contributor".
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

# 7. Create destination for AzCopy
```
COOL_STORAGE_NAME=coolstorage$RANDOM
```
```
az storage account create \
  --location $LOCATION \
  --name $COOL_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_RAGRS \
  --kind BlobStorage \
  --access-tier Cool
```
```
COOL_SAS_TOKEN=<Use the key created in azure portal, See also #6-2>
```

# 8. Create the blob named azcopy-archive thru AzCopy command
```
azcopy make https://$COOL_STORAGE_NAME.blob.core.windows.net/azcopy-archive$COOL_SAS_TOKEN
```

# 9. AzCopy from myfirstblob to azcopy-archive using sas-token
```
azcopy copy https://$HOT_STORAGE_NAME.blob.core.windows.net/myfirstblob/test1.md$HOT_SAS_TOKEN https://$COOL_STORAGE_NAME.blob.core.windows.net/azcopy-archive$COOL_SAS_TOKEN
```


# 10. Delete Blob data
```
az storage blob delete-batch \
   --source myfirstblob \
   --pattern "test*.md" \
   --account-name $HOT_STORAGE_NAME \
   --auth-mode key
```

# X. Go to Azure Portal
https://portal.azure.com/#home

