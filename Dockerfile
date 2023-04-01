FROM alpine:3.17.3 as base
WORKDIR /app
EXPOSE 80

# Use multi-stage build, do not serve production image with compilation dependencies
FROM base as build
WORKDIR /src
RUN apk update && apk add git cmake make gcc g++ pkgconfig eudev-dev libusb-dev linux-headers

# We can't install hidapi-dev from apk because it is too old there
# We need to build it from source
#RUN mkdir -p ~/.ssh/ && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone https://github.com/libusb/hidapi.git && \
    cd hidapi && \
    git checkout bd6be4d83b36d0dcd5401fb335384586b066a2eb &&\
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/dependencies/hidapi && \
    cmake --build . && \
    cmake --build . --target install

COPY . .
RUN mkdir build && cd build && cmake .. && make

FROM base as final
WORKDIR /app
RUN apk update && apk add libusb-dev
COPY --from=build /src/build/co2mond .
COPY --from=build /dependencies/hidapi /dependencies/hidapi
ENTRYPOINT ["./co2mond", "-P", "0.0.0.0:80"]
