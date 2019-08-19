FROM walkerk1980/cloudhsm-base
WORKDIR /root/
RUN /usr/bin/wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Xenial/cloudhsm-client-pkcs11_latest_amd64.deb \
  && /usr/bin/dpkg -i cloudhsm-client-pkcs11_latest_amd64.deb \
  && rm cloudhsm-client-pkcs11_latest_amd64.deb
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --assume-yes -y --yes -f install -y \ 
  opensc opensc-pkcs11 \
  && /opt/cloudhsm/bin/setup_redis \
  && rm -rf /var/lib/apt/lists/*
ENV CAKEYPASS=Password1
ENV CASUBJECT=example.com
ENV REGION=us-west-2
