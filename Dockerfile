FROM ubuntu
WORKDIR /home/app
COPY key.asc ./

RUN apt-get update -y \
  && apt-get install -y wget curl gnupg \
  && curl -O https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc \
  && curl -O https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz \
  && gpg --import /home/app/key.asc \
  && gpg --verify /home/app/litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc /home/app/litecoin-0.18.1-x86_64-linux-gnu.tar.gz

RUN useradd -r litecoin \
  && apt-get -y install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
  && tar --strip=2 -xzf /home/app/litecoin-0.18.1-x86_64-linux-gnu.tar.gz -C /usr/local/bin \
  && rm /home/app/litecoin-0.18.1-x86_64-linux-gnu.tar.gz

VOLUME ["/home/litecoin/.litecoin"]

EXPOSE 9332 9333 19332 19333

CMD ["/usr/local/bin/litecoind"]