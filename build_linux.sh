#!/bin/sh
set -eu

PROJECT_ROOT_DIR=${PWD}

mkdir -p build
cd build

: ${configs:=Debug Release}

for config in ${configs}; do
	cmake -H../ -DCMAKE_MODULE_PATH="${PROJECT_ROOT_DIR}/cmake_modules" -DCMAKE_BUILD_TYPE=$config -B./$config
	cmake --build $config --target clean
	cmake --build $config --target all
done
cd -
