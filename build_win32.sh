#!env bash
set -eu

mkdir build
cd build

: ${configs:=Debug Release}

cmake .. -G "Visual Studio 14 2015 Win64"
for config in ${configs}; do
	cmake --build . --config $config
done
cd -
