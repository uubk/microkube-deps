#!/bin/bash

set -e

mkdir artifacts
mkdir artifacts/linux
mkdir artifacts/windows

echo "Building microkube dependencies"
echo "###############################"
echo "########## CNI Plugins ########"
echo "###############################"
cd cni-plugins
./build.sh
cp bin/* ../artifacts/linux
# At the moment, no CNI on Windows
# rm bin/*
# GOOS=windows GOARCH=amd64 ./build.sh
# cp bin/* ../artifacts/windows
cd ..
echo "###############################"
echo "############# ETCD ############"
echo "###############################"
cd etcd
git checkout build
./build
cp bin/* ../artifacts/linux
rm bin/*
GOOS=windows GOARCH=amd64 ./build
cp bin/* ../artifacts/windows
cd ..
echo "###############################"
echo "########## Kubernetes #########"
echo "###############################"
cd kubernetes
make
cp _output/local/bin/linux/amd64/hyperkube ../artifacts/linux/
KUBE_BUILD_PLATFORMS=windows/amd64 make
cp _output/local/bin/windows/amd64/hyperkube.exe ../artifacts/windows/

cd ../artifacts
cd linux
strip *
cd ../windows
strip *
