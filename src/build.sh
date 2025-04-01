#!/usr/bin/env bash

set -eux


version=$1
os_name=$2
os_arch=$3

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="${current_dir}/../target"

export GOPATH=${current_dir}/main/golang

env GOOS=linux GOARCH=amd64 go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@${version}
env GOOS=linux GOARCH=arm64 go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@${version}
env GOOS=darwin GOARCH=amd64 go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@${version}
env GOOS=darwin GOARCH=arm64 go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@${version}

rm -rf "${target_dir:?}/${os_name}/${os_arch}"
mkdir -p "${target_dir}/${os_name}/${os_arch}"

cp -a "${current_dir}/main/golang/bin/protoc-gen-openapiv2" "${target_dir}/${os_name}/${os_arch}"

if [ -f "${current_dir}//main/golang/bin/darwin_amd64/protoc-gen-openapiv2" ]; then
  mkdir -p "${target_dir}/osx/x86_64/"
  cp -a "${current_dir}/main/golang/bin/darwin_amd64/protoc-gen-openapiv2" "${target_dir}/osx/x86_64/protoc-gen-openapiv2"
fi

if [ -f "${current_dir}//main/golang/bin/darwin_arm64/protoc-gen-openapiv2" ]; then
  mkdir -p "${target_dir}/osx/aarch_64/"
  cp -a "${current_dir}/main/golang/bin/darwin_arm64/protoc-gen-openapiv2" "${target_dir}/osx/aarch_64/protoc-gen-openapiv2"
fi

if [ -f "${current_dir}//main/golang/bin/linux_amd64/protoc-gen-openapiv2" ]; then
  mkdir -p "${target_dir}/linux/x86_64/"
  cp -a "${current_dir}/main/golang/bin/linux_amd64/protoc-gen-openapiv2" "${target_dir}/linux/x86_64/protoc-gen-openapiv2"
fi

if [ -f "${current_dir}//main/golang/bin/linux_arm64/protoc-gen-openapiv2" ]; then
  mkdir -p "${target_dir}/linux/aarch_64/"
  cp -a "${current_dir}/main/golang/bin/linux_arm64/protoc-gen-openapiv2" "${target_dir}/linux/aarch_64/protoc-gen-openapiv2"
fi

proto_dir="${current_dir}/main/proto/protoc-gen-openapiv2/options/"

rm -rf "${proto_dir}"
mkdir -p "${proto_dir}"

if [ -d "${current_dir}/main/golang/src/github.com/grpc-ecosystem/grpc-gateway/protoc-gen-openapiv2/options" ]; then
  cp "${current_dir}"/main/golang/src/github.com/grpc-ecosystem/grpc-gateway/protoc-gen-openapiv2/options/*.proto "${proto_dir}"
fi

if [ -d "${current_dir}/main/golang/pkg/mod/github.com/grpc-ecosystem/grpc-gateway/v2@v2.26.0/protoc-gen-openapiv2/options" ]; then
  cp "${current_dir}"/main/golang/pkg/mod/github.com/grpc-ecosystem/grpc-gateway/v2@v2.26.0/protoc-gen-openapiv2/options/*.proto "${proto_dir}"
fi
