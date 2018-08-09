#!/bin/bash

set -e

echo "Building microkube dependencies"
echo "###############################"
echo "############# ETCD ############"
echo "###############################"
cd etcd
git checkout build
./build
cd ..
echo "###############################"
echo "########## Kubernetes #########"
echo "###############################"
cd kubernetes
make
cd ..

mkdir artifacts
cp etcd/bin/* artifacts/
cp kubernetes/_output/local/bin/linux/amd64/kube* artifacts/
cd artifacts
strip *
