# ----------------- BEGIN MIX-IN DEFINITIONS -----------------
# Mix-In definitions are auto-generated by mixin-update
##############################################################
# Source: device/intel/mixins/groups/dynamic-partitions/true/AndroidBoard.mk
##############################################################
INSTALLED_SUPER_EMPTY_IMAGE_TARGET := $(PRODUCT_OUT)/super_empty.img

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_SUPER_EMPTY_IMAGE_TARGET)
FIRST_STAGE_RAMDISK_DIR := $(PRODUCT_OUT)/recovery/root/first_stage_ramdisk

$(FIRST_STAGE_RAMDISK_DIR):
	@mkdir -p $(PRODUCT_OUT)/recovery/root/first_stage_ramdisk

$(PRODUCT_OUT)/ramdisk-recovery.img: $(FIRST_STAGE_RAMDISK_DIR)
##############################################################
# Source: device/intel/mixins/groups/slot-ab/true/AndroidBoard.mk
##############################################################
RAMDISK_METADATA_DIR:= $(PRODUCT_OUT)/root/metadata

$(RAMDISK_METADATA_DIR):
	@mkdir -p $(PRODUCT_OUT)/root/metadata

$(PRODUCT_OUT)/ramdisk.img: $(RAMDISK_METADATA_DIR)

##############################################################
# Source: device/intel/mixins/groups/variants/default/AndroidBoard.mk
##############################################################
# flashfile_add_blob <blob_name> <path> <mandatory> <var_name>
# - Delete ::variant:: from <path>
# - If the result does not exists and <mandatory> is set, error
# - If <var_name> is set, put the result in <var_name>
# - Add the pair <result>:<blob_name> in BOARD_FLASHFILES_FIRMWARE
define flashfile_add_blob
$(eval blob := $(subst ::variant::,,$(2))) \
$(if $(wildcard $(blob)), \
    $(if $(4), $(eval $(4) := $(blob))) \
    $(eval BOARD_FLASHFILES_FIRMWARE += $(blob):$(1)) \
    , \
    $(if $(3), $(error $(blob) does not exist)))
endef

##############################################################
# Source: device/intel/mixins/groups/boot-arch/project-celadon/AndroidBoard.mk.1
##############################################################
GPT_INI2BIN := ./$(INTEL_PATH_COMMON)/gpt_bin/gpt_ini2bin.py

$(BOARD_GPT_BIN): $(BOARD_GPT_INI)
	$(hide) $(GPT_INI2BIN) $< > $@
	$(hide) echo GEN $(notdir $@)

$(PRODUCT_OUT)/efi/startup.nsh: $(TARGET_DEVICE_DIR)/extra_files/boot-arch/$(@F)
	$(ACP) $(TARGET_DEVICE_DIR)/extra_files/boot-arch/$(@F) $@
	sed -i '/#/d' $@
##############################################################
# Source: device/intel/mixins/groups/boot-arch/project-celadon/AndroidBoard.mk
##############################################################
# Rules to create bootloader zip file, a precursor to the bootloader
# image that is stored in the target-files-package. There's also
# metadata file which indicates how large to make the VFAT filesystem
# image

ifeq ($(TARGET_UEFI_ARCH),i386)
efi_default_name := bootia32.efi
LOADER_TYPE := linux-x86
else
efi_default_name := bootx64.efi
LOADER_TYPE := linux-x86_64
endif

# (pulled from build/core/Makefile as this gets defined much later)
# Pick a reasonable string to use to identify files.
# BUILD_NUMBER has a timestamp in it, which means that
# it will change every time.  Pick a stable value.

KF4UEFI := $(PRODUCT_OUT)/efi/kernelflinger.efi
BOARD_FIRST_STAGE_LOADER := $(KF4UEFI)
BOARD_EXTRA_EFI_MODULES :=

#$(call flashfile_add_blob,capsule.fv,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/capsule.fv,,BOARD_SFU_UPDATE)
#$(call flashfile_add_blob,ifwi.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/ifwi.bin,,EFI_IFWI_BIN)
#$(call flashfile_add_blob,ifwi_dnx.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/ifwi_dnx.bin,,EFI_IFWI_DNX_BIN)
#$(call flashfile_add_blob,firmware.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/emmc.bin,,EFI_EMMC_BIN)
#$(call flashfile_add_blob,afu.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/afu.bin,,EFI_AFU_BIN)
#$(call flashfile_add_blob,dnxp_0x1.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/dnxp_0x1.bin,,DNXP_BIN)
#$(call flashfile_add_blob,cfgpart.xml,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/cfgpart.xml,,CFGPART_XML)
#$(call flashfile_add_blob,cse_spi.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/celadon_ivi/::variant::/$(BIOS_VARIANT)/cse_spi.bin,,CSE_SPI_BIN)


ifneq ($(EFI_IFWI_BIN),)
$(call dist-for-goals,droidcore,$(EFI_IFWI_BIN):$(TARGET_PRODUCT)-ifwi-$(FILE_NAME_TAG).bin)
endif

ifneq ($(EFI_IFWI_DNX_BIN),)
$(call dist-for-goals,droidcore,$(EFI_IFWI_DNX_BIN):$(TARGET_PRODUCT)-ifwi_dnx-$(FILE_NAME_TAG).bin)
endif

ifneq ($(EFI_AFU_BIN),)
$(call dist-for-goals,droidcore,$(EFI_AFU_BIN):$(TARGET_PRODUCT)-afu-$(FILE_NAME_TAG).bin)
endif

ifneq ($(BOARD_SFU_UPDATE),)
$(call dist-for-goals,droidcore,$(BOARD_SFU_UPDATE):$(TARGET_PRODUCT)-sfu-$(FILE_NAME_TAG).fv)
endif

ifneq ($(CALLED_FROM_SETUP),true)
ifeq ($(wildcard $(BOARD_SFU_UPDATE)),)
$(warning BOARD_SFU_UPDATE not found, OTA updates will not provide a firmware capsule)
endif
ifeq ($(wildcard $(EFI_EMMC_BIN)),)
$(warning EFI_EMMC_BIN not found, flashfiles will not include 2nd stage EMMC firmware)
endif
ifeq ($(wildcard $(EFI_IFWI_BIN)),)
$(warning EFI_IFWI_BIN not found, IFWI binary will not be provided in out/dist/)
endif
ifeq ($(wildcard $(EFI_AFU_BIN)),)
$(warning EFI_AFU_BIN not found, AFU IFWI binary will not be provided in out/dist/)
endif
endif

ifeq ($(BOARD_HAS_USB_DISK),true)
ifeq ($(FLASHFILE_VARIANTS),)
BOARD_USB_DISK_IMAGES = $(PRODUCT_OUT)/install-usb.img
else
BOARD_USB_DISK_IMAGE_PFX = $(PRODUCT_OUT)/install-usb
$(foreach var,$(FLASHFILE_VARIANTS), \
	$(eval BOARD_USB_DISK_IMAGES += $(BOARD_USB_DISK_IMAGE_PFX)-$(var).img))
endif
endif

# We stash a copy of BIOSUPDATE.fv so the FW sees it, applies the
# update, and deletes the file. Follows Google's desire to update all
# bootloader pieces with a single "fastboot flash bootloader" command.
# Since it gets deleted we can't do incremental updates of it, we keep
# a copy as capsules/current.fv for this purpose.
intermediates := $(call intermediates-dir-for,PACKAGING,bootloader_zip)
bootloader_zip := $(intermediates)/bootloader.zip
$(bootloader_zip): intermediates := $(intermediates)
$(bootloader_zip): efi_root := $(intermediates)/root
$(bootloader_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(BOARD_FIRST_STAGE_LOADER) \
		$(BOARD_EXTRA_EFI_MODULES) \
		$(BOARD_SFU_UPDATE) \
		| $(ACP) \

	$(hide) rm -rf $(efi_root)
	$(hide) rm -f $@
ifneq ($(BOOTLOADER_SLOT), true)
	$(hide) mkdir -p $(efi_root)/capsules
	$(hide) mkdir -p $(efi_root)/EFI/BOOT
	$(foreach EXTRA,$(BOARD_EXTRA_EFI_MODULES), \
		$(hide) $(ACP) $(EXTRA) $(efi_root)/)
ifneq ($(BOARD_SFU_UPDATE),)
	$(hide) $(ACP) $(BOARD_SFU_UPDATE) $(efi_root)/BIOSUPDATE.fv
	$(hide) $(ACP) $(BOARD_SFU_UPDATE) $(efi_root)/capsules/current.fv
endif
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/loader.efi
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/EFI/BOOT/$(efi_default_name)
	$(hide) echo "Android-IA=\\EFI\\BOOT\\$(efi_default_name)" > $(efi_root)/manifest.txt
else # BOOTLOADER_SLOT == false
	$(hide) mkdir -p $(efi_root)/EFI/INTEL/
	$(hide) $(ACP) $(KF4UEFI) $(efi_root)/EFI/INTEL/KF4UEFI.EFI
endif # BOOTLOADER_SLOT
	$(hide) (cd $(efi_root) && zip -qry ../$(notdir $@) .)

bootloader_info := $(intermediates)/bootloader_image_info.txt
$(bootloader_info):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo "size=$(BOARD_BOOTLOADER_PARTITION_SIZE)" > $@
	$(hide) echo "block_size=$(BOARD_BOOTLOADER_BLOCK_SIZE)" >> $@


# Rule to create $(OUT)/bootloader image, binaries within are signed with
# testing keys

bootloader_bin := $(PRODUCT_OUT)/bootloader.img
ifeq ($(INTEL_PREBUILT),true)
$(bootloader_bin):
	$(hide) $(ACP) $(INTEL_PATH_PREBUILTS)/bootloader.img $@
	@echo "Using prebuilt bootloader image from $(INTEL_PATH_PREBUILTS)"
else # INTEL_PREBUILT
$(bootloader_bin): \
		$(bootloader_zip) \
		$(IMG2SIMG) \
		$(BOOTLOADER_ADDITIONAL_DEPS) \
		$(INTEL_PATH_BUILD)/bootloader_from_zip \

	$(hide) $(INTEL_PATH_BUILD)/bootloader_from_zip \
		--size $(BOARD_BOOTLOADER_PARTITION_SIZE) \
		--block-size $(BOARD_BOOTLOADER_BLOCK_SIZE) \
		$(BOOTLOADER_ADDITIONAL_ARGS) \
		--zipfile $(bootloader_zip) \
		$@
ifneq ($(INTEL_PATH_PREBUILTS_OUT),)
	$(hide) mkdir -p $(INTEL_PATH_PREBUILTS_OUT)
	$(hide) $(ACP) $@ $(INTEL_PATH_PREBUILTS_OUT)
endif # INTEL_PATH_PREBUILTS_OUT
endif # INTEL_PREBUILT

INSTALLED_RADIOIMAGE_TARGET += $(bootloader_zip) $(bootloader_bin) $(bootloader_info)

droidcore: $(bootloader_bin)

.PHONY: bootloader
bootloader: $(bootloader_bin)
$(call dist-for-goals,droidcore,$(bootloader_bin):$(TARGET_PRODUCT)-bootloader-$(FILE_NAME_TAG))

$(call dist-for-goals,droidcore,$(INTEL_PATH_BUILD)/testkeys/testkeys_lockdown.txt:test-keys_efi_lockdown.txt)
$(call dist-for-goals,droidcore,$(INTEL_PATH_BUILD)/testkeys/unlock.txt:efi_unlock.txt)


# Used for efi update
$(PRODUCT_OUT)/vendor.img: $(PRODUCT_OUT)/vendor/firmware/kernelflinger.efi
$(PRODUCT_OUT)/vendor/firmware/kernelflinger.efi: $(PRODUCT_OUT)/efi/kernelflinger.efi
	$(ACP) $(PRODUCT_OUT)/efi/kernelflinger.efi $@

make_bootloader_dir:
	@mkdir -p $(PRODUCT_OUT)/root/bootloader

$(PRODUCT_OUT)/ramdisk.img: make_bootloader_dir

##############################################################
# Source: device/intel/mixins/groups/kernel/gmin64/AndroidBoard.mk.1
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/kernel/load_kernel_modules.in
##############################################################
# Source: device/intel/mixins/groups/kernel/gmin64/AndroidBoard.mk
##############################################################
ifneq ($(wildcard $(INTEL_PATH_PREKERNEL)/$(TARGET_KERNEL_ARCH)/kernel), )
TARGET_PREBUILT_KERNEL := $(INTEL_PATH_PREKERNEL)/$(TARGET_KERNEL_ARCH)/kernel
endif

ifneq ($(TARGET_PREBUILT_KERNEL), )

TARGET_PREBUILT_KERNEL_MODULE := $(INTEL_PATH_PREKERNEL)/modules
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)

$(PRODUCT_OUT)/kernel: $(LOCAL_KERNEL) $(wildcard $(TARGET_PREBUILT_KERNEL_MODULE)/*)
	  $(hide) echo "Copy prebuilt kernel from $(LOCAL_KERNEL) into $@"
	  $(hide) cp $(LOCAL_KERNEL) $@
	  $(hide) echo "Copy modules from $(TARGET_PREBUILT_KERNEL_MODULE) into $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)"
	  $(hide) mkdir -p $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	  $(hide) cp -r $(TARGET_PREBUILT_KERNEL_MODULE)/* $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/

# kernel modules must be copied before ramdisk is generated
$(PRODUCT_OUT)/ramdisk.img: $(PRODUCT_OUT)/kernel

.PHONY: kernel
kernel: $(PRODUCT_OUT)/kernel

else

TARGET_KERNEL_CLANG_VERSION := r416183b1
CLANG_PREBUILTS_PATH := $(abspath $(INTEL_PATH_DEVICE)/../../../prebuilts/clang)

ifneq ($(TARGET_KERNEL_CLANG_VERSION),)
    # Find the clang-* directory containing the specified version
    KERNEL_CLANG_VERSION := $(shell find $(CLANG_PREBUILTS_PATH)/host/$(HOST_OS)-x86/ -name AndroidVersion.txt -exec grep -l $(TARGET_KERNEL_CLANG_VERSION) "{}" \; | sed -e 's|/AndroidVersion.txt$$||g;s|^.*/||g')
else
    # Only set the latest version of clang if TARGET_KERNEL_CLANG_VERSION hasn't been set by the device con    fig
    KERNEL_CLANG_VERSION := $(shell ls -d $(CLANG_PREBUILTS_PATH)/host/$(HOST_OS)-x86/clang-* | xargs -n 1     basename | tail -1)
endif
TARGET_KERNEL_CLANG_PATH ?= $(CLANG_PREBUILTS_PATH)/host/$(HOST_OS)-x86/$(KERNEL_CLANG_VERSION)/bin
KERNEL_CLANG_TRIPLE ?= CLANG_TRIPLE=x86_64-linux-gnu-
KERNEL_CC ?= CC="$(ccache) $(TARGET_KERNEL_CLANG_PATH)/clang"

LOCAL_KERNEL_PATH := $(PRODUCT_OUT)/obj/kernel
KERNEL_INSTALL_MOD_PATH := .
LOCAL_KERNEL := $(LOCAL_KERNEL_PATH)/arch/x86/boot/bzImage
LOCAL_KERNEL_MODULE_TREE_PATH := $(LOCAL_KERNEL_PATH)/lib/modules
KERNELRELEASE := $(shell cat $(LOCAL_KERNEL_PATH)/include/config/kernel.release)

KERNEL_CCACHE := $(realpath $(CC_WRAPPER))

#remove time_macros from ccache options, it breaks signing process
KERNEL_CCSLOP := $(filter-out time_macros,$(subst $(comma), ,$(CCACHE_SLOPPINESS)))
KERNEL_CCSLOP := $(subst $(space),$(comma),$(KERNEL_CCSLOP))


ifeq ($(BASE_CHROMIUM_KERNEL), true)
  LOCAL_KERNEL_SRC := 
  KERNEL_CONFIG_PATH := $(TARGET_DEVICE_DIR)/
else ifeq ($(BASE_LTS2020_YOCTO_KERNEL), true)
  LOCAL_KERNEL_SRC := 
  KERNEL_CONFIG_PATH := $(TARGET_DEVICE_DIR)/
else ifeq ($(BASE_LTS2020_CHROMIUM_KERNEL), true)
  LOCAL_KERNEL_SRC := 
  KERNEL_CONFIG_PATH := $(TARGET_DEVICE_DIR)/
else
  LOCAL_KERNEL_SRC := kernel/lts2018
  EXT_MODULES := 
  DEBUG_MODULES := 
  KERNEL_CONFIG_PATH := $(TARGET_DEVICE_DIR)/config-lts/lts2018/bxt/android/non-embargoed
endif

EXTMOD_SRC := ../modules
EXTERNAL_MODULES := $(EXT_MODULES)

KERNEL_DEFCONFIG := $(KERNEL_CONFIG_PATH)/$(TARGET_KERNEL_ARCH)_defconfig
ifneq ($(TARGET_BUILD_VARIANT), user)
  KERNEL_DEBUG_DIFFCONFIG += $(wildcard $(KERNEL_CONFIG_PATH)/debug_diffconfig)
  ifneq ($(KERNEL_DEBUG_DIFFCONFIG),)
    KERNEL_DIFFCONFIG += $(KERNEL_DEBUG_DIFFCONFIG)
  else
    KERNEL_DEFCONFIG := $(LOCAL_KERNEL_SRC)/arch/x86/configs/$(TARGET_KERNEL_ARCH)_debug_defconfig
  endif
  EXTERNAL_MODULES := $(EXT_MODULES) $(DEBUG_MODULES)
endif # variant not eq user

KERNEL_CONFIG := $(LOCAL_KERNEL_PATH)/.config

ifeq ($(TARGET_BUILD_VARIANT), eng)
  KERNEL_ENG_DIFFCONFIG := $(wildcard $(KERNEL_CONFIG_PATH)/eng_diffconfig)
  ifneq ($(KERNEL_ENG_DIFFCONFIG),)
    KERNEL_DIFFCONFIG += $(KERNEL_ENG_DIFFCONFIG)
  endif
endif

KERNEL_MAKE_OPTIONS = \
    SHELL=/bin/bash \
    -C $(LOCAL_KERNEL_SRC) \
    O=$(abspath $(LOCAL_KERNEL_PATH)) \
    ARCH=$(TARGET_KERNEL_ARCH) \
    INSTALL_MOD_PATH=$(KERNEL_INSTALL_MOD_PATH) \
    CROSS_COMPILE="x86_64-linux-androidkernel-" \
    CCACHE_SLOPPINESS=$(KERNEL_CCSLOP) \
    $(KERNEL_CLANG_TRIPLE) \
    $(KERNEL_CC)

KERNEL_MAKE_OPTIONS += \
    EXTRA_FW="$(_EXTRA_FW_)" \
    EXTRA_FW_DIR="$(abspath $(PRODUCT_OUT)/vendor/firmware)"

KERNEL_MAKE_OPTIONS += \
    LLVM=1 \
    HOSTLDFLAGS=-fuse-ld=lld \


KERNEL_CONFIG_DEPS = $(strip $(KERNEL_DEFCONFIG) $(KERNEL_DIFFCONFIG))

CHECK_CONFIG_SCRIPT := $(LOCAL_KERNEL_SRC)/scripts/diffconfig
CHECK_CONFIG_LOG :=  $(LOCAL_KERNEL_PATH)/.config.check

KERNEL_DEPS := $(shell find $(LOCAL_KERNEL_SRC) \( -name *.git -prune \) -o -print )

KERNEL_MAKE_CMD:= \
      PATH="$(PWD)/prebuilts/build-tools/linux-x86/bin:$(TARGET_KERNEL_CLANG_PATH):$(PWD)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/x86_64-linux/bin:$$PATH" \
      make -j24

# Before building final defconfig with debug diffconfigs
# Check that base defconfig is correct. Check is performed
# by comparing generated .config with .config.old if it exists.
# On incremental build, remove the old .config.old before checking.
# If differences are observed, display a help message
# and stop kernel build.
# If a .config is already present, save it before processing
# the check and restore it at the end
$(CHECK_CONFIG_LOG): $(KERNEL_DEFCONFIG) $(KERNEL_DEPS)
	$(hide) mkdir -p $(@D)
	-$(hide) [[ -e $(KERNEL_CONFIG) ]] && mv -f $(KERNEL_CONFIG) $(KERNEL_CONFIG).save
	$(hide) rm -f $(KERNEL_CONFIG).old
	$(hide) cat $< > $(KERNEL_CONFIG)
	$(hide) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS) olddefconfig
	$(hide) if [[ -e  $(KERNEL_CONFIG).old ]] ; then \
	  $(CHECK_CONFIG_SCRIPT) $(KERNEL_CONFIG).old $(KERNEL_CONFIG) > $@ ;  fi;
	-$(hide) [[ -e $(KERNEL_CONFIG).save ]] && mv -f $(KERNEL_CONFIG).save $(KERNEL_CONFIG)
	$(hide) if [[ -s $@ ]] ; then \
	  echo "CHECK KERNEL DEFCONFIG FATAL ERROR :" ; \
	  echo "Kernel config copied from $(KERNEL_DEFCONFIG) has some config issue." ; \
	  echo "Final '.config' and '.config.old' differ. This should never happen." ; \
	  echo "Observed diffs are :" ; \
	  cat $@ ; \
	  echo "Root cause is probably that a dependancy declared in Kconfig is not respected" ; \
	  echo "or config was added in Kconfig but value not explicitly added to defconfig." ; \
	  echo "Recommanded method to generate defconfig is menuconfig tool instead of manual edit." ; \
	  exit 1;  fi;

.PHONY: menuconfig xconfig gconfig

menuconfig xconfig gconfig: $(CHECK_CONFIG_LOG)
	$(hide) xterm -e $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS) $@
	$(hide) cp -f $(KERNEL_CONFIG) $(KERNEL_DEFCONFIG)
	@echo ===========
	@echo $(KERNEL_DEFCONFIG) has been modified !
	@echo ===========

$(KERNEL_CONFIG): $(KERNEL_CONFIG_DEPS) | $(CHECK_CONFIG_LOG)
	$(hide) cat $(KERNEL_CONFIG_DEPS) > $@
	@echo "Generating Kernel configuration, using $(KERNEL_CONFIG_DEPS)"
	$(hide) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS) olddefconfig </dev/null

# BOARD_KERNEL_CONFIG_FILE and BOARD_KERNEL_VERSION can be used to override the values extracted
# from INSTALLED_KERNEL_TARGET.
BOARD_KERNEL_CONFIG_FILE = $(KERNEL_CONFIG)
BOARD_KERNEL_VERSION = $(shell cat $(KERNEL_DEFCONFIG) | sed -nr 's|.*([0-9]+[.][0-9]+[.][0-9]+)(-rc[1-9])? Kernel Configuration.*|\1|p')

$(PRODUCT_OUT)/kernel: $(LOCAL_KERNEL) $(LOCAL_KERNEL_PATH)/copy_modules
	$(hide) cp $(LOCAL_KERNEL) $@

# kernel modules must be copied before vendorimage is generated
$(PRODUCT_OUT)/vendor.img: $(LOCAL_KERNEL_PATH)/copy_modules

# Copy modules in directory pointed by $(KERNEL_MODULES_ROOT)
# First copy modules keeping directory hierarchy lib/modules/`uname-r`for libkmod
# Second, create flat hierarchy for insmod linking to previous hierarchy
$(LOCAL_KERNEL_PATH)/copy_modules: $(LOCAL_KERNEL)
	@echo Copy modules from $(LOCAL_KERNEL_PATH)/lib/modules/$(KERNELRELEASE) into $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) rm -rf $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) rm -rf $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) mkdir -p $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) cd $(LOCAL_KERNEL_PATH)/lib/modules/$(KERNELRELEASE) && for f in `find . -name '*.ko' -or -name 'modules.*'`; do \
		cp $$f $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$$(basename $$f) || exit 1; \
		mkdir -p $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$(KERNELRELEASE)/$$(dirname $$f) ; \
		ln -s /$(KERNEL_MODULES_ROOT_PATH)/$$(basename $$f) $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$(KERNELRELEASE)/$$f || exit 1; \
		done
	$(hide) touch $@
#usb-init for recovery
	$(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) for f in dwc3.ko dwc3-pci.ko xhci-hcd.ko xhci-pci.ko; do \
		find $(LOCAL_KERNEL_PATH)/lib/modules/ -name $$f -exec cp {} $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)/ \; ;\
		done
#mei for recovery
	$(hide) for f in mei.ko mei-me.ko; do \
		find $(LOCAL_KERNEL_PATH)/lib/modules/ -name $$f -exec cp {} $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)/ \; ;\
		done

ifeq ($(PRODUCT_SUPPORTS_VERITY), true)
DM_VERITY_CERT := $(LOCAL_KERNEL_PATH)/verity.x509
$(DM_VERITY_CERT): $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VERITY_SIGNING_KEY).x509.pem $(OPENSSL)
	$(transform-pem-cert-to-der-cert)
$(LOCAL_KERNEL): $(DM_VERITY_CERT)
endif

$(LOCAL_KERNEL): $(MINIGZIP) $(KERNEL_CONFIG) $(BOARD_DTB) $(KERNEL_DEPS)
	$(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS)
	$(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS) modules
	$(KERNEL_MAKE_CMD) $(KERNEL_MAKE_OPTIONS) INSTALL_MOD_STRIP=1 modules_install


# disable the modules built in parallel due to some modules symbols has dependency,
# and module install depmod need they be installed one at a time.

PREVIOUS_KERNEL_MODULE := $(LOCAL_KERNEL)

define bld_external_module

$(eval MODULE_DEPS_$(2) := $(shell find kernel/modules/$(1) \( -name *.git -prune \) -o -print ))

$(LOCAL_KERNEL_PATH)/build_$(2): $(LOCAL_KERNEL) $(MODULE_DEPS_$(2)) $(PREVIOUS_KERNEL_MODULE)
	@echo BUILDING $(1)
	@mkdir -p $(LOCAL_KERNEL_PATH)/../modules/$(1)
	$(hide) $(KERNEL_MAKE_CMD) $$(KERNEL_MAKE_OPTIONS) M=$(EXTMOD_SRC)/$(1) V=1 $(ADDITIONAL_ARGS_$(subst /,_,$(1))) modules
	@touch $$(@)

$(LOCAL_KERNEL_PATH)/install_$(2): $(LOCAL_KERNEL_PATH)/build_$(2) $(PREVIOUS_KERNEL_MODULE)
	@echo INSTALLING $(1)
	$(hide) $(KERNEL_MAKE_CMD) $$(KERNEL_MAKE_OPTIONS) M=$(EXTMOD_SRC)/$(1) INSTALL_MOD_STRIP=1 modules_install
	@touch $$(@)

$(LOCAL_KERNEL_PATH)/copy_modules: $(LOCAL_KERNEL_PATH)/install_$(2)

$(eval PREVIOUS_KERNEL_MODULE := $(LOCAL_KERNEL_PATH)/install_$(2))
endef


# Check external module path
$(foreach m,$(EXTERNAL_MODULES),$(if $(findstring .., $(m)), $(error $(m): All external kernel modules should be put under kernel/modules folder)))

$(foreach m,$(EXTERNAL_MODULES),$(eval $(call bld_external_module,$(m),$(subst /,_,$(m)))))



# Add a kernel target, so "make kernel" will build the kernel
.PHONY: kernel
kernel: $(LOCAL_KERNEL_PATH)/copy_modules $(PRODUCT_OUT)/kernel

endif

##############################################################
# Source: device/intel/mixins/groups/sepolicy/enforcing/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := sepolicy-areq-checker
LOCAL_REQUIRED_MODULES := sepolicy

#
# On user builds, enforce that open tickets are considered violations.
#
ifeq ($(TARGET_BUILD_VARIANT),user)
LOCAL_USER_OPTIONS := -i
endif

LOCAL_POST_INSTALL_CMD := $(INTEL_PATH_SEPOLICY)/tools/capchecker $(LOCAL_USER_OPTIONS) -p $(INTEL_PATH_SEPOLICY)/tools/caps.conf $(TARGET_ROOT_OUT)/sepolicy

include $(BUILD_PHONY_PACKAGE)
##############################################################
# Source: device/intel/mixins/groups/audio/project-celadon/AndroidBoard.mk
##############################################################
pfw_rebuild_settings := true
# Target specific audio configuration files
include $(TARGET_DEVICE_DIR)/audio/AndroidBoard.mk
AUTO_IN += $(TARGET_DEVICE_DIR)/extra_files/audio/auto_hal.in
##############################################################
# Source: device/intel/mixins/groups/device-type/car/AndroidBoard.mk
##############################################################
# Car device required kernel diff config
KERNEL_CAR_DIFFCONFIG = $(wildcard $(KERNEL_CONFIG_PATH)/car_diffconfig)
KERNEL_DIFFCONFIG += $(KERNEL_CAR_DIFFCONFIG)
##############################################################
# Source: device/intel/mixins/groups/device-specific/celadon_ivi/AndroidBoard.mk
##############################################################
KERNEL_APL_DIFFCONFIG = $(wildcard $(KERNEL_CONFIG_PATH)/apl_nuc_diffconfig)
KERNEL_DIFFCONFIG += $(KERNEL_APL_DIFFCONFIG)

# Specify /dev/mmcblk0 size here
BOARD_MMC_SIZE = 15335424K
##############################################################
# Source: device/intel/mixins/groups/trusty/true/AndroidBoard.mk
##############################################################
.PHONY: tosimage multiboot

EVMM_PKG := $(TOP)/$(PRODUCT_OUT)/obj/trusty/evmm_pkg.bin
EVMM_LK_PKG := $(TOP)/$(PRODUCT_OUT)/obj/trusty/evmm_lk_pkg.bin

LOCAL_CLANG_PATH = $(CLANG_PREBUILTS_PATH)/host/$(HOST_OS)-x86/$(KERNEL_CLANG_VERSION)/bin

LOCAL_MAKE := \
        PATH="$(LOCAL_CLANG_PATH):$(PWD)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/x86_64-linux/bin:$$PATH" \
        $(PWD)/prebuilts/build-tools/linux-x86/bin/make
$(EVMM_PKG):
	@echo "making evmm.."
	$(hide) (cd $(TOPDIR)$(INTEL_PATH_VENDOR)/fw/evmm && $(TRUSTY_ENV_VAR) $(LOCAL_MAKE))

$(EVMM_LK_PKG):
	@echo "making evmm(packing with lk.bin).."
	$(hide) (cd $(TOPDIR)$(INTEL_PATH_VENDOR)/fw/evmm && $(TRUSTY_ENV_VAR) $(LOCAL_MAKE))

# include sub-makefile according to boot_arch
include $(TARGET_DEVICE_DIR)/extra_files/trusty/trusty_project-celadon.mk

LOAD_MODULES_H_IN += $(TARGET_DEVICE_DIR)/extra_files/trusty/load_trusty_modules.in
##############################################################
# Source: device/intel/mixins/groups/firststage-mount/true/AndroidBoard.mk
##############################################################
FIRST_STAGE_MOUNT_CFG_FILE := $(TARGET_DEVICE_DIR)/extra_files/firststage-mount/config.asl

$(FIRSTSTAGE_MOUNT_SSDT): $(FIRST_STAGE_MOUNT_CFG_FILE) $(IASL)
	$(hide) $(IASL) -p $(@:.aml=) $(FIRST_STAGE_MOUNT_CFG_FILE);
##############################################################
# Source: device/intel/mixins/groups/vendor-partition/true/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := vendor-partition
LOCAL_REQUIRED_MODULES := toybox_static
include $(BUILD_PHONY_PACKAGE)

RECOVERY_VENDOR_LINK_PAIRS := \
	$(PRODUCT_OUT)/recovery/root/vendor/bin/getprop:toolbox_static \

RECOVERY_VENDOR_LINKS := \
	$(foreach item, $(RECOVERY_VENDOR_LINK_PAIRS), $(call word-colon, 1, $(item)))

$(RECOVERY_VENDOR_LINKS):
	$(hide) echo "Creating symbolic link on $(notdir $@)"
	$(eval PRV_TARGET := $(call word-colon, 2, $(filter $@:%, $(RECOVERY_VENDOR_LINK_PAIRS))))
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(dir $@)$(PRV_TARGET))
	$(hide) touch $(dir $@)$(PRV_TARGET)
	$(hide) ln -sf $(PRV_TARGET) $@

RECOVERY_VENDOR_BINARIES := $(PRODUCT_OUT)/recovery/root/vendor/bin/sh

$(RECOVERY_VENDOR_BINARIES):  $(RECOVERY_VENDOR_LINKS)
	$(hide) if [[ -e $(PRODUCT_OUT)/recovery/root/vendor/bin/toolbox_static ]] ; then \
			rm $(PRODUCT_OUT)/recovery/root/vendor/bin/toolbox_static ; \
		fi ;
	$(hide) cp $(INTEL_PATH_TARGET_DEVICE)/${TARGET_PRODUCT}/extra_files/vendor-partition/sh_recovery $(PRODUCT_OUT)/recovery/root/vendor/bin/sh
	$(hide) cp $(INTEL_PATH_TARGET_DEVICE)/${TARGET_PRODUCT}/extra_files/vendor-partition/toolbox_recovery $(PRODUCT_OUT)/recovery/root/vendor/bin/toolbox_static

ALL_DEFAULT_INSTALLED_MODULES += \
       $(RECOVERY_VENDOR_BINARIES)
##############################################################
# Source: device/intel/mixins/groups/acpio-partition/true/AndroidBoard.mk
##############################################################
ACPIO_OUT := $(PRODUCT_OUT)/acpio
ACPIO_BIN := $(PRODUCT_OUT)/acpio.bin
INSTALLED_ACPIOIMAGE_TARGET := $(PRODUCT_OUT)/acpio.img

MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg

DUMMY_SSDT = $(PRODUCT_OUT)/dummy-ssdt.aml

ifeq ($(INTEL_PREBUILT),true)
ACPIO_SRC := $(wildcard $(INTEL_PATH_PREBUILTS)/acpio/*.aml)
else
ACPIO_SRC := $(DUMMY_SSDT)
endif

DUMMY_SSDT_FILE := $(TARGET_DEVICE_DIR)/extra_files/acpio-partition/dummy-ssdt.asl
$(DUMMY_SSDT): $(DUMMY_SSDT_FILE) $(IASL)
	$(hide) $(IASL) -p $(@:.aml=) $(DUMMY_SSDT_FILE);

$(ACPIO_BIN): $(ACPIO_SRC) $(MKDTIMG)
	$(hide) rm -rf $(ACPIO_OUT) && mkdir -p $(ACPIO_OUT)
	$(hide) if [ -n "$(ACPIO_SRC)" ]; then \
		$(ACP) $(ACPIO_SRC) $(ACPIO_OUT); \
		$(MKDTIMG) create $@ --dt_type=acpi --page_size=2048 $(ACPIO_OUT)/*; \
	else \
		$(MKDTIMG) create $@ --dt_type=acpi --page_size=2048; \
	fi
ifneq ($(INTEL_PREBUILT),true)
ifneq ($(INTEL_PATH_PREBUILTS_OUT),)
	$(hide) mkdir -p $(INTEL_PATH_PREBUILTS_OUT)/acpio
	@echo "Copy acpio binaries to $(INTEL_PATH_PREBUILTS_OUT)/acpio"
	$(hide) if [ -n "$(ACPIO_SRC)" ]; then \
		$(ACP) $(ACPIO_SRC) $(INTEL_PATH_PREBUILTS_OUT)/acpio; \
	fi
endif # INTEL_PATH_PREBUILTS_OUT
endif # INTEL_PREBUILT

ifeq (true,$(BOARD_AVB_ENABLE)) # BOARD_AVB_ENABLE == true
$(INSTALLED_ACPIOIMAGE_TARGET): $(ACPIO_BIN) $(AVBTOOL)
	$(hide) $(ACP) $< $@
	@echo "$(AVBTOOL): add hashfooter to acpio image: $@"
	$(hide) $(AVBTOOL) add_hash_footer \
		--image $@ \
		--partition_size $(BOARD_ACPIOIMAGE_PARTITION_SIZE) \
		--partition_name acpio
INSTALLED_VBMETAIMAGE_TARGET ?= $(PRODUCT_OUT)/vbmeta.img
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --include_descriptors_from_image $(INSTALLED_ACPIOIMAGE_TARGET)
$(INSTALLED_VBMETAIMAGE_TARGET): $(INSTALLED_ACPIOIMAGE_TARGET)
else
$(INSTALLED_ACPIOIMAGE_TARGET): $(ACPIO_BIN)
	$(hide) $(ACP) $< $@
endif # BOARD_AVB_ENABLE == true

.PHONY: acpioimage
acpioimage: $(INSTALLED_ACPIOIMAGE_TARGET)

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_ACPIOIMAGE_TARGET)

##############################################################
# Source: device/intel/mixins/groups/config-partition/true/AndroidBoard.mk
##############################################################
INSTALLED_CONFIGIMAGE_TARGET := $(PRODUCT_OUT)/config.img

selinux_fc := $(TARGET_ROOT_OUT)/file_contexts.bin

OEM_CONFIG_DIR := $(TARGET_ROOT_OUT)/mnt/vendor/oem_config
RECOVERY_OEM_CONFIG_DIR := $(TARGET_RECOVERY_ROOT_OUT)/mnt/vendor/oem_config

$(OEM_CONFIG_DIR):
	@mkdir -p $(PRODUCT_OUT)/root/mnt/vendor
	@mkdir -p $(PRODUCT_OUT)/root/mnt/vendor/oem_config
$(RECOVERY_OEM_CONFIG_DIR):
	@mkdir -p $(PRODUCT_OUT)/recovery/root/mnt/vendor
	@mkdir -p $(PRODUCT_OUT)/recovery/root/mnt/vendor/oem_config

$(PRODUCT_OUT)/ramdisk.img: $(OEM_CONFIG_DIR) $(RECOVERY_OEM_CONFIG_DIR)

$(INSTALLED_CONFIGIMAGE_TARGET) : PRIVATE_SELINUX_FC := $(selinux_fc)
$(INSTALLED_CONFIGIMAGE_TARGET) : $(MKEXTUSERIMG) $(MAKE_EXT4FS) $(E2FSCK) $(selinux_fc) $(INSTALLED_BOOTIMAGE_TARGET) $(OEM_CONFIG_DIR) $(RECOVERY_OEM_CONFIG_DIR)
	$(call pretty,"Target config fs image: $(INSTALLED_CONFIGIMAGE_TARGET)")
	@mkdir -p $(PRODUCT_OUT)/config
	$(hide)	PATH=$(HOST_OUT_EXECUTABLES):$$PATH \
		$(MKEXTUSERIMG) -s \
		$(PRODUCT_OUT)/config \
		$(PRODUCT_OUT)/config.img \
		ext4 \
		oem_config \
		$(BOARD_CONFIGIMAGE_PARTITION_SIZE) \
		$(PRIVATE_SELINUX_FC)

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_CONFIGIMAGE_TARGET)

selinux_fc :=
##############################################################
# Source: device/intel/mixins/groups/graphics/mesa/AndroidBoard.mk
##############################################################

I915_FW_PATH := vendor/linux/firmware/i915

#list of i915/huc_xxx.bin i915/dmc_xxx.bin i915/guc_xxx.bin
$(foreach t, $(patsubst $(I915_FW_PATH)/%,%,$(wildcard $(I915_FW_PATH)/*)) ,$(eval I915_FW += i915/$(t)) $(eval $(LOCAL_KERNEL) : $(PRODUCT_OUT)/vendor/firmware/i915/$(t)))

_EXTRA_FW_ += $(I915_FW)


##############################################################
# Source: device/intel/mixins/groups/ethernet/dhcp/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/ethernet/load_eth_modules.in
##############################################################
# Source: device/intel/mixins/groups/codecs/configurable/AndroidBoard.mk
##############################################################
AUTO_IN += $(TARGET_DEVICE_DIR)/extra_files/codecs/auto_hal.in
##############################################################
# Source: device/intel/mixins/groups/thermal/thermal-daemon/AndroidBoard.mk
##############################################################
AUTO_IN += $(TARGET_DEVICE_DIR)/extra_files/thermal/auto_hal.in
##############################################################
# Source: device/intel/mixins/groups/flashfiles/ini/AndroidBoard.mk
##############################################################
ff_intermediates := $(call intermediates-dir-for,PACKAGING,flashfiles)

# We need a copy of the flashfiles configuration ini in the
# TFP RADIO/ directory
ff_config := $(ff_intermediates)/flashfiles.ini
$(ff_config): $(FLASHFILES_CONFIG) | $(ACP)
	$(copy-file-to-target)

$(call add_variant_flashfiles,$(ff_intermediates))

INSTALLED_RADIOIMAGE_TARGET += $(ff_config)


$(call flashfile_add_blob,extra_script.edify,$(TARGET_DEVICE_DIR)/flashfiles/::variant::/extra_script.edify)

# We take any required images that can't be derived elsewhere in
# the TFP and put them in RADIO/provdata.zip.
ff_intermediates := $(call intermediates-dir-for,PACKAGING,flashfiles)
provdata_zip := $(ff_intermediates)/provdata.zip
provdata_zip_deps := $(foreach pair,$(BOARD_FLASHFILES),$(call word-colon,1,$(pair)))
ff_root := $(ff_intermediates)/root

define copy-flashfile
$(hide) $(ACP) -fp $(1) $(2)

endef

define deploy_provdata
$(eval ff_var := $(subst provdata,,$(basename $(notdir $(1)))))
$(hide) rm -f $(1)
$(hide) rm -rf $(ff_intermediates)/root$(ff_var)
$(hide) mkdir -p $(ff_intermediates)/root$(ff_var)
$(foreach pair,$(BOARD_FLASHFILES$(ff_var)), \
	$(call copy-flashfile,$(call word-colon,1,$(pair)),$(ff_intermediates)/root$(ff_var)/$(call word-colon,2,$(pair))))
$(hide) zip -qj $(1) $(ff_intermediates)/root$(ff_var)/*
endef

ifneq ($(FLASHFILE_VARIANTS),)
provdata_zip :=
$(foreach var,$(FLASHFILE_VARIANTS), \
	$(eval provdata_zip += $(ff_intermediates)/provdata_$(var).zip) \
	$(eval BOARD_FLASHFILES_$(var) := $(BOARD_FLASHFILES)) \
	$(eval BOARD_FLASHFILES_$(var) += $(BOARD_FLASHFILES_FIRMWARE_$(var))) \
	$(eval provdata_zip_deps += $(foreach pair,$(BOARD_FLASHFILES_FIRMWARE_$(var)),$(call word-colon,1,$(pair)))))
else
$(eval BOARD_FLASHFILES += $(BOARD_FLASHFILES_FIRMWARE))
$(eval provdata_zip_deps += $(foreach pair,$(BOARD_FLASHFILES_FIRMWARE),$(call word-colon,1,$(pair))))
endif

$(provdata_zip): $(provdata_zip_deps) | $(ACP)
	$(call deploy_provdata,$@)


INSTALLED_RADIOIMAGE_TARGET += $(provdata_zip)

##############################################################
# Source: device/intel/mixins/groups/power/true/AndroidBoard.mk
##############################################################
AUTO_IN += $(TARGET_DEVICE_DIR)/extra_files/power/auto_hal.in
##############################################################
# Source: device/intel/mixins/groups/usb-init/true/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/usb-init/load_usb_modules.in
##############################################################
# Source: device/intel/mixins/groups/usb-audio-init/true/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/usb-audio-init/load_usbaudio_modules.in
##############################################################
# Source: device/intel/mixins/groups/load_modules/true/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := load_modules.sh
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC := $(LOAD_MODULES_H_IN) $(LOAD_MODULES_IN)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): $(LOCAL_SRC)
	$(hide) mkdir -p "$(dir $@)"
	echo "#!/vendor/bin/sh" > $@
	echo "modules=\`getprop ro.vendor.boot.moduleslocation\`" >> $@
	cat $(LOAD_MODULES_H_IN) >> $@
	echo wait >> $@
	cat $(LOAD_MODULES_IN) >> $@
##############################################################
# Source: device/intel/mixins/groups/gptbuild/true/AndroidBoard.mk
##############################################################
gptimage_size ?= 16G

raw_config := none
raw_factory := none
tos_bin := none
multiboot_bin := none
raw_product := none
raw_odm := none
raw_acpi := none
raw_acpio := none

.PHONY: none
none: ;

.PHONY: $(INSTALLED_CONFIGIMAGE_TARGET).raw
$(INSTALLED_CONFIGIMAGE_TARGET).raw: $(INSTALLED_CONFIGIMAGE_TARGET) $(SIMG2IMG)
	$(SIMG2IMG) $< $@

.PHONY: $(INSTALLED_FACTORYIMAGE_TARGET).raw
$(INSTALLED_FACTORYIMAGE_TARGET).raw: $(INSTALLED_FACTORYIMAGE_TARGET) $(SIMG2IMG)
	$(SIMG2IMG) $< $@

ifdef INSTALLED_CONFIGIMAGE_TARGET
raw_config := $(INSTALLED_CONFIGIMAGE_TARGET).raw
endif

ifdef INSTALLED_FACTORYIMAGE_TARGET
raw_factory := $(INSTALLED_FACTORYIMAGE_TARGET).raw
endif

ifdef INSTALLED_PRODUCTIMAGE_TARGET
raw_product := $(INSTALLED_PRODUCTIMAGE_TARGET).raw
endif

.PHONY: $(GPTIMAGE_BIN)
ifeq ($(strip $(TARGET_USE_TRUSTY)),true)
ifeq ($(strip $(TARGET_USE_MULTIBOOT)),true)
$(GPTIMAGE_BIN): tosimage multiboot
multiboot_bin = $(INSTALLED_MULTIBOOT_IMAGE_TARGET)
else
$(GPTIMAGE_BIN): tosimage
endif
tos_bin = $(INSTALLED_TOS_IMAGE_TARGET)
endif



ifdef INSTALLED_ACPIOIMAGE_TARGET
raw_acpio := $(INSTALLED_ACPIOIMAGE_TARGET)
$(ACRN_GPTIMAGE_BIN): acpioimage
endif

$(GPTIMAGE_BIN): \
	bootloader \
	bootimage \
	vbmetaimage \
	superimage \
	$(SIMG2IMG) \
	$(raw_config) \
	$(raw_factory)

	$(hide) rm -f $(INSTALLED_SYSTEMIMAGE).raw
	$(hide) rm -f $(INSTALLED_USERDATAIMAGE_TARGET).raw

	$(SIMG2IMG) $(INSTALLED_SUPERIMAGE_TARGET) $(INSTALLED_SUPERIMAGE_TARGET).raw

	$(INTEL_PATH_BUILD)/create_gpt_image.py \
		--create $@ \
		--block $(BOARD_FLASH_BLOCK_SIZE) \
		--table $(BOARD_GPT_INI) \
		--size $(gptimage_size) \
		--bootloader $(bootloader_bin) \
		--tos $(tos_bin) \
		--multiboot $(multiboot_bin) \
		--boot $(INSTALLED_BOOTIMAGE_TARGET) \
		--vbmeta $(INSTALLED_VBMETAIMAGE_TARGET) \
		--super $(INSTALLED_SUPERIMAGE_TARGET).raw \
		--acpio $(raw_acpio) \
		--config $(raw_config) \
		--factory $(raw_factory)

.PHONY: gptimage
gptimage: $(GPTIMAGE_BIN)
# ------------------ END MIX-IN DEFINITIONS ------------------
