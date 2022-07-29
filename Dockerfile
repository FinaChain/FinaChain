FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS build

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BUILDPLATFORM

RUN git clone https://github.com/NethermindEth/nethermind --branch 1.13.4 --recursive

WORKDIR /nethermind

COPY specs/*.json src/Nethermind/Chains
COPY specs/configs/*.cfg src/Nethermind/Nethermind.Runner/configs

RUN if [ "$TARGETARCH" = "amd64" ] ; \
    then git submodule update --init src/Dirichlet src/int256 src/rocksdb-sharp src/Math.Gmp.Native && \
    dotnet publish src/Nethermind/Nethermind.Runner -r $TARGETOS-x64 -c release -o out ; \
    else git submodule update --init src/Dirichlet src/int256 src/rocksdb-sharp src/Math.Gmp.Native && \
    dotnet publish src/Nethermind/Nethermind.Runner -r $TARGETOS-$TARGETARCH -c release -o out ; \
    fi

FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/aspnet:6.0-jammy

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BUILDPLATFORM

RUN apt-get update && apt-get -y install libsnappy-dev libc6-dev libc6

# Fix rocksdb issue in ubuntu 22.04
RUN if [ "$TARGETARCH" = "amd64" ] ; \
    then ln -s /usr/lib/x86_64-linux-gnu/libdl.so.2 /usr/lib/x86_64-linux-gnu/libdl.so > /dev/null 2>&1 ; \
    else ln -s /usr/lib/aarch64-linux-gnu/libdl.so.2 /usr/lib/aarch64-linux-gnu/libdl.so > /dev/null 2>&1  && apt-get -y install libgflags-dev > /dev/null 2>&1 ; \
    fi

WORKDIR /nethermind

COPY --from=build /nethermind/out .

EXPOSE 8545
EXPOSE 40101

VOLUME /nethermind/nethermind_db
VOLUME /nethermind/logs
VOLUME /nethermind/keystore

ENTRYPOINT ["./Nethermind.Runner"]