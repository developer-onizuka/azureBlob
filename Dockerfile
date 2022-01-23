FROM mcr.microsoft.com/azure-cli:latest
RUN apk add bash icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib; \
    apk add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/
RUN cd $HOME; \
    wget https://dot.net/v1/dotnet-install.sh; \
    bash dotnet-install.sh -i /usr/local/bin
RUN cd $HOME; \
    wget https://aka.ms/downloadazcopy-v10-linux -O - |tar xvfz -; \
    chmod 775 azcopy_linux_amd64_10.13.0/azcopy; \
    cp -p azcopy_linux_amd64_10.13.0/azcopy /usr/local/bin
