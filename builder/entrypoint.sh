#!/bin/bash
echo "MODULE_SOURCE_PATH=$MODULE_SOURCE_PATH"
echo "MODULE_OUTPUT_PATH=$MODULE_OUTPUT_PATH"
echo "MP_TAG=$MP_TAG"

pushd /tmp

# Clone the latest microptyhon version
git clone https://github.com/micropython/micropython && \
    pushd micropython && \
    git checkout tags/$MP_TAG && \
    popd

# Load the IDF builder
. /opt/esp-idf/export.sh

# Clean the build directory
rm -R $MODULE_OUTPUT_PATH/*

# Build the ESP32_GENERIC port
# Copy the submodules before building
cp -r $MODULE_SOURCE_PATH/*.py /tmp/micropython/ports/esp32/modules

pushd /tmp/micropython/ports/esp32
make submodules

make BOARD=ESP32_GENERIC
cp -r build-ESP32_GENERIC $MODULE_OUTPUT_PATH

make BOARD=ESP32_GENERIC_S2
cp -r build-ESP32_GENERIC_S2 $MODULE_OUTPUT_PATH

make BOARD=ESP32_GENERIC_C3
cp -r build-ESP32_GENERIC_C3 $MODULE_OUTPUT_PATH
popd

# Build the ESP8266 port
cp -r $MODULE_SOURCE_PATH/*.py /tmp/micropython/ports/esp8266/modules
make submodules

make BOARD=ESP8266_GENERIC
cp -r build-ESP8266_GENERIC $MODULE_OUTPUT_PATH
popd
