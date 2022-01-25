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
```
az storage blob upload-batch \
  --destination specifications \
  --pattern "*.md" \
  --source ~/sample \
  --account-name $HOT_STORAGE_NAME \
  --account-key $HOT_KEY
```


# X. Go to Azure Portal
https://portal.azure.com/#home

