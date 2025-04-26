# Lumbay Lumbay Game iOS App

## How to generate proto files

```
brew install protobuf

git clone https://github.com/apple/swift-protobuf.git
cd swift-protobuf.git

swift build -c release

sudo cp ./build/release/protoc-gen-swift /usr/local/bin

protoc --swift_out=. ./Lumbay2/gRPC/lumbay2.proto
```