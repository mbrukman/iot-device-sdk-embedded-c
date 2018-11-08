# Copyright 2018 Google LLC
#
# This is part of the Google Cloud IoT Edge Embedded C Client,
# it is licensed under the BSD 3-Clause license; you may not use this file
# except in compliance with the License.
#
# You may obtain a copy of the License at:
#  https://opensource.org/licenses/BSD-3-Clause
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CC ?= gcc
AR ?= ar

IOTC_COMPILER_FLAGS += -fPIC
IOTC_LIB_FLAGS += $(IOTC_TLS_LIBFLAGS)

include make/mt-os/mt-os-common.mk

IOTC_FREERTOS_DIR_PATH = $(LIBIOTC)/third_party/FreeRTOSv10.1.1/FreeRTOS
IOTC_INCLUDE_FLAGS += -I$(IOTC_FREERTOS_DIR_PATH)/Source/include
IOTC_INCLUDE_FLAGS += -I$(LIBIOTC)/third_party/freertos-addons/Linux/portable/GCC/Linux

IOTC_ARFLAGS += -rs -c $(XI)

# Temporarily disable these warnings until the code gets changed.
IOTC_COMPILER_FLAGS += -Wno-format

#################################################################
# Download FreeRTOS kernel and FreeRTOS Plus Linux Simulator ####
#################################################################
IOTC_FREERTOS_KERNEL_URL=https://kent.dl.sourceforge.net/project/freertos/FreeRTOS/V10.1.1/FreeRTOSv10.1.1.zip
IOTC_FREERTOS_KERNEL_ZIP_PATH=$(LIBIOTC)/third_party/FreeRTOSv10.1.1.zip
IOTC_FREERTOS_README_PATH=$(basename $(IOTC_FREERTOS_KERNEL_ZIP_PATH))/readme.txt

IOTC_FREERTOS_ADDONS_README_PATH=$(LIBIOTC)/third_party/freertos-addons/README.md

#################################################################
# Download FreeRTOS Plus Linux Simulator ########################
#################################################################
$(IOTC_FREERTOS_ADDONS_README_PATH): $(IOTC_FREERTOS_README_PATH)
	@echo IOTC FreeRTOS Linux build: git cloning freertos-addons repo
	@git clone https://github.com/michaelbecker/freertos-addons.git $(dir $@)
	@cp -r $(dir $@)/* $(IOTC_FREERTOS_DIR_PATH)

#################################################################
# Unzip FreeRTOS kernel #########################################
#################################################################
$(IOTC_FREERTOS_README_PATH): $(IOTC_FREERTOS_KERNEL_ZIP_PATH)
	@echo IOTC FreeRTOS Linux build: unzipping
	@echo	$< to $(basename $<)
	@unzip -q $< -d $(dir $<)
	@touch $@

#################################################################
# Download FreeRTOS kernel ######################################
#################################################################
$(IOTC_FREERTOS_KERNEL_ZIP_PATH):
	@echo "IOTC FreeRTOS Linux build: downloading FreeRTOS Kernel to file $@"
	@-mkdir -p $(dir $@)
	@curl -L -o $@ $(IOTC_FREERTOS_KERNEL_URL)

IOTC_BUILD_PRECONDITIONS := $(IOTC_FREERTOS_ADDONS_README_PATH)
