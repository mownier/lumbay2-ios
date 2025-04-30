# Lumbay Lumbay Game iOS App

## How to generate proto files

```
brew install protobuf

protoc --swift_out=. ./Libs/Lumbay2cl/Sources/Lumbay2cl/lumbay2.proto

protoc --swift_out=. --swift_opt=Visibility=Public ./Libs/Lumbay2cl/Sources/Lumbay2cl/lumbay2.proto

protoc --grpc-swift_out=. ./Libs/Lumbay2cl/Sources/Lumbay2cl/lumbay2.proto
```
