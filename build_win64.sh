#!env bash
set -eu

PROJECT_ROOT_DIR=${PWD}

mkdir -p build
cd build

: ${configs:=Debug Release}

cmake .. -G "Visual Studio 14 2015 Win64"
for config in ${configs}; do
	cmake --build . --config $config
done
cd -
