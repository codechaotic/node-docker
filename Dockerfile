FROM alpine:3.1

ENV NODE_VERSION 0.12.2
ENV NPM_VERSION 2.7.3

RUN apk --update add c-ares libgcc libstdc++ libuv gnupg python make g++ \
 && gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D \
 && wget "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" \
 && wget "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
 && gpg --verify SHASUMS256.txt.asc \
 && grep " node-v$NODE_VERSION.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
 && tar -xzf "node-v$NODE_VERSION.tar.gz" \
 && rm "node-v$NODE_VERSION.tar.gz" SHASUMS256.txt.asc \
 && cd node-v$NODE_VERSION \
 && ./configure && make V= && make install \
 && cd .. \
 && apk del gnupg python make g++ \
 && rm -Rf node-v$NODE_VERSION \
 && npm install -g npm@"$NPM_VERSION" \
 && npm cache clear

ENV PATH $PATH:/usr/local/bin/

EXPOSE 8080
CMD ["npm","start"]
