LOCAL_PATH:= $(call my-dir)

common_src_files := \
	VolumeManager.cpp \
	CommandListener.cpp \
	VoldCommand.cpp \
	NetlinkManager.cpp \
	NetlinkHandler.cpp \
	Volume.cpp \
	DirectVolume.cpp \
	Process.cpp \
	Ext4.cpp \
	Fat.cpp \
	Loop.cpp \
	Devmapper.cpp \
	ResponseCode.cpp \
	Xwarp.cpp \
	fstrim.c \
	cryptfs.c

common_c_includes := \
	$(KERNEL_HEADERS) \
	system/extras/ext4_utils \
	external/openssl/include

common_shared_libraries := \
	libsysutils \
	libcutils \
	liblog \
	libdiskconfig \
	libhardware_legacy \
	liblogwrap \
	libcrypto

include $(CLEAR_VARS)

LOCAL_MODULE := libvold

LOCAL_SRC_FILES := $(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := libfs_mgr

LOCAL_MODULE_TAGS := eng tests

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE:= vold

LOCAL_SRC_FILES := \
	main.cpp \
	$(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_CFLAGS := -Werror=format

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := libfs_mgr

ifeq ($(BOARD_USES_HDMI),true)
LOCAL_CFLAGS += -DBOARD_USES_HDMI
LOCAL_SHARED_LIBRARIES += libhdmiclient
LOCAL_C_INCLUDES += \
	device/samsung/$(TARGET_BOARD_PLATFORM)/libhdmi/libhdmiservice

ifeq ($(TARGET_SOC),exynos4x12)
	LOCAL_CFLAGS += -DSAMSUNG_EXYNOS4x12
endif

ifeq ($(TARGET_SOC),exynos5250)
	LOCAL_CFLAGS += -DSAMSUNG_EXYNOS5250
endif

ifeq ($(BOARD_USE_V4L2_ION),true)
	LOCAL_CFLAGS += -DBOARD_USE_V4L2_ION
endif

ifeq ($(BOARD_USE_V4L2),true)
	LOCAL_CFLAGS += -DBOARD_USE_V4L2
endif
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= vdc.c

LOCAL_MODULE:= vdc

LOCAL_C_INCLUDES := $(KERNEL_HEADERS)

LOCAL_CFLAGS := 

LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_EXECUTABLE)
