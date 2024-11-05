FROM nimlang/nim:2.0.8-regular AS builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc mingw-w64 xz-utils git

COPY . /Nimcrypt2

RUN nimble --accept install winim nimcrypto docopt ptr_math && \
    cd /Nimcrypt2/nim-strenc && nimble install && \
    cd /Nimcrypt2 && \
    nim c -d=release --cc:gcc --embedsrc=on --hints=on --app=console --cpu=amd64 --out=nimcrypt nimcrypt.nim && \
    cp /Nimcrypt2/nimcrypt /nimcrypt && \
    cp /Nimcrypt2/syscalls.nim /syscalls.nim && \
    cp /Nimcrypt2/GetSyscallStub.nim /GetSyscallStub.nim

ENTRYPOINT ["/nimcrypt"]
