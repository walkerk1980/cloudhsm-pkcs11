FROM walkerk1980/cloudhsm-base
WORKDIR /root/
RUN /usr/bin/wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Xenial/cloudhsm-client-pkcs11_latest_amd64.deb \
  && /usr/bin/dpkg -i cloudhsm-client-pkcs11_latest_amd64.deb \
  && /bin/rm cloudhsm-client-pkcs11_latest_amd64.deb
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --assume-yes -y --yes -f install -y \ 
  opensc opensc-pkcs11 \
  && /opt/cloudhsm/bin/setup_redis \
  && /bin/rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/lib/
# pkcs11-logger Not enabled by default - https://github.com/Pkcs11Interop/pkcs11-logger
RUN /usr/bin/wget https://github.com/Pkcs11Interop/pkcs11-logger/releases/download/v2.2.0/pkcs11-logger-x64.so
ENV PKCS11_LOGGER_LIBRARY_PATH='/opt/cloudhsm/lib/libcloudhsm_pkcs11.so'
ENV PKCS11_LOGGER_LOG_FILE_PATH='/tmp/pkcs11.log'
ENV PKCS11_LOGGER_FLAGS='0'
ENV CAKEYPASS=Password1
ENV CASUBJECT=example.com
ENV REGION=us-west-2
