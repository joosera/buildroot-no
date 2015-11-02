################################################################################
#
# WPE
#
################################################################################

WPE_VERSION = f9741a5172810b9bbd8e1bfbd1135cad4f45a0f9
ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
WPE_VERSION = 8875dcec4e6b432577ffe862e267f099a586c467
endif
WPE_SITE = $(call github,Metrological,WebKitForWayland,$(WPE_VERSION))

WPE_INSTALL_STAGING = YES
WPE_DEPENDENCIES = host-flex host-bison host-gperf host-ruby host-ninja \
	host-pkgconf zlib pcre libgles libegl cairo freetype fontconfig \
	harfbuzz icu libxml2 libxslt sqlite libinput libsoup jpeg webp \
	libxkbcommon xkeyboard-config

WPE_FLAGS = \
	-DENABLE_ACCELERATED_2D_CANVAS=ON \
	-DENABLE_BATTERY_STATUS=OFF \
	-DENABLE_CANVAS_PATH=ON \
	-DENABLE_CANVAS_PROXY=OFF \
	-DENABLE_CHANNEL_MESSAGING=ON \
	-DENABLE_CSP_NEXT=OFF \
	-DENABLE_CSS3_TEXT=OFF \
	-DENABLE_CSS3_TEXT_LINE_BREAK=OFF \
	-DENABLE_CSS_BOX_DECORATION_BREAK=ON \
	-DENABLE_CSS_COMPOSITING=OFF \
	-DENABLE_CSS_DEVICE_ADAPTATION=OFF \
	-DENABLE_CSS_GRID_LAYOUT=ON \
	-DENABLE_CSS_IMAGE_ORIENTATION=OFF \
	-DENABLE_CSS_IMAGE_RESOLUTION=OFF \
	-DENABLE_CSS_IMAGE_SET=ON \
	-DENABLE_CSS_REGIONS=ON \
	-DENABLE_CSS_SHAPES=ON \
	-DENABLE_CUSTOM_SCHEME_HANDLER=OFF \
	-DENABLE_DATALIST_ELEMENT=OFF \
	-DENABLE_DATA_TRANSFER_ITEMS=OFF \
	-DENABLE_DETAILS_ELEMENT=ON \
	-DENABLE_DEVICE_ORIENTATION=OFF \
	-DENABLE_DOM4_EVENTS_CONSTRUCTOR=OFF \
	-DENABLE_DOWNLOAD_ATTRIBUTE=OFF \
	-DENABLE_ES6_CLASS_SYNTAX=OFF \
	-DENABLE_FONT_LOAD_EVENTS=OFF \
	-DENABLE_FTL_JIT=OFF \
	-DENABLE_FTPDIR=OFF \
	-DENABLE_FULLSCREEN_API=OFF \
	-DENABLE_GAMEPAD=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_ICONDATABASE=ON \
	-DENABLE_INDEXED_DATABASE=OFF \
	-DENABLE_INPUT_TYPE_COLOR=OFF \
	-DENABLE_INPUT_TYPE_DATE=OFF \
	-DENABLE_INPUT_TYPE_DATETIMELOCAL=OFF \
	-DENABLE_INPUT_TYPE_DATETIME_INCOMPLETE=OFF \
	-DENABLE_INPUT_TYPE_MONTH=OFF \
	-DENABLE_INPUT_TYPE_TIME=OFF \
	-DENABLE_INPUT_TYPE_WEEK=OFF \
	-DENABLE_LEGACY_NOTIFICATIONS=OFF \
	-DENABLE_LEGACY_VENDOR_PREFIXES=ON \
	-DENABLE_LINK_PREFETCH=OFF \
	-DENABLE_MATHML=OFF \
	-DENABLE_MEDIA_CAPTURE=OFF \
	-DENABLE_MEDIA_STATISTICS=OFF \
	-DENABLE_METER_ELEMENT=ON \
	-DENABLE_MHTML=OFF \
	-DENABLE_MOUSE_CURSOR_SCALE=OFF \
	-DENABLE_NAVIGATOR_CONTENT_UTILS=ON \
	-DENABLE_NAVIGATOR_HWCONCURRENCY=ON \
	-DENABLE_NETSCAPE_PLUGIN_API=OFF \
	-DENABLE_NOSNIFF=OFF \
	-DENABLE_NOTIFICATIONS=OFF \
	-DENABLE_ORIENTATION_EVENTS=OFF \
	-DENABLE_PERFORMANCE_TIMELINE=ON \
	-DENABLE_PROXIMITY_EVENTS=OFF \
	-DENABLE_QUOTA=OFF \
	-DENABLE_REQUEST_ANIMATION_FRAME=ON \
	-DENABLE_RESOLUTION_MEDIA_QUERY=OFF \
	-DENABLE_RESOURCE_TIMING=ON \
	-DENABLE_SECCOMP_FILTERS=OFF \
	-DENABLE_STREAMS_API=ON \
	-DENABLE_SUBTLE_CRYPTO=ON \
	-DENABLE_SVG_FONTS=ON \
	-DENABLE_TEMPLATE_ELEMENT=ON \
	-DENABLE_TEXT_AUTOSIZING=OFF \
	-DENABLE_TOUCH_EVENTS=ON \
	-DENABLE_TOUCH_ICON_LOADING=OFF \
	-DENABLE_TOUCH_SLIDER=OFF \
	-DENABLE_USER_TIMING=ON \
	-DENABLE_VIBRATION=OFF \
	-DENABLE_WEBGL=ON \
	-DENABLE_WEB_REPLAY=OFF \
	-DENABLE_WEB_SOCKETS=ON \
	-DENABLE_WEB_TIMING=ON \
	-DENABLE_XSLT=ON \
	-DUSE_SYSTEM_MALLOC=OFF \
	-DENABLE_THREADED_COMPOSITOR=ON

WPE_EXTRA_CFLAGS=

ifeq ($(BR2_mipsel),y)
WPE_FLAGS += \
	-DENABLE_JIT=OFF
endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
WPE_EXTRA_CFLAGS += \
	-D__UCLIBC__
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
WPE_DEPENDENCIES += wayland
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WPE_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
WPE_DEPENDENCIES += bcm-refsw
WPE_FLAGS += \
	-DUSE_LD_GOLD=OFF
endif

ifeq ($(BR2_PACKAGE_WPE_USE_GSTREAMER),y)
WPE_DEPENDENCIES += \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
WPE_FLAGS += \
	-DENABLE_VIDEO=ON -DENABLE_VIDEO_TRACK=ON -DENABLE_WEB_AUDIO=ON
else
WPE_FLAGS += \
	-DENABLE_VIDEO=OFF -DENABLE_VIDEO_TRACK=OFF -DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE = Debug
WPE_FLAGS += \
	-DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align $(WPE_EXTRA_CFLAGS)" \
	-DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align $(WPE_EXTRA_CFLAGS)"
ifeq ($(BR2_BINUTILS_VERSION_2_25),y)
WPE_FLAGS += \
	-DDEBUG_FISSION=TRUE
endif
else
BUILDTYPE = Release
WPE_FLAGS += \
	-DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align $(WPE_EXTRA_CFLAGS)" \
	-DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align $(WPE_EXTRA_CFLAGS)"
endif

ifeq ($(BR2_PACKAGE_WPE_USE_GSTREAMER_GL),y)
WPE_FLAGS += -DUSE_GSTREAMER_GL=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_ENCRYPTED_MEDIA),y)
WPE_DEPENDENCIES += openssl
WPE_FLAGS += -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_ENCRYPTED_MEDIA_V2),y)
WPE_FLAGS += -DENABLE_ENCRYPTED_MEDIA_V2=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_DXDRM_EME),y)
WPE_DEPENDENCIES += dxdrm
WPE_FLAGS += -DENABLE_DXDRM=ON
ifeq ($(BR2_PACKAGE_DXDRM_EXTERNAL),y)
WPE_FLAGS += -DENABLE_PROVISIONING=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPE_USE_MEDIA_SOURCE),y)
WPE_FLAGS += -DENABLE_MEDIA_SOURCE=ON
endif

ifeq ($(BR2_PACKAGE_WPE_ENABLE_JS_MEMORY_TRACKING),y)
WPE_FLAGS += -DENABLE_JS_MEMORY_TRACKING=ON
endif

ifeq ($(BR2_PACKAGE_WPE_GENERATE_ECLIPSE_PROJECT),y)
WPE_NINJA_GENERATOR = 'Eclipse CDT4 - Ninja'
else
WPE_NINJA_GENERATOR = Ninja
endif

ifeq ($(BR2_PACKAGE_WPE_USE_HOLE_PUNCH_GSTREAMER),y)
WPE_FLAGS += -DUSE_HOLE_PUNCH_GSTREAMER=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_HOLE_PUNCH_EXTERNAL),y)
WPE_FLAGS += -DUSE_HOLE_PUNCH_EXTERNAL=ON
endif

WPE_BUILDDIR = $(@D)/build-$(BUILDTYPE)

WPE_CONF_OPT = -DPORT=WPE -G $(WPE_NINJA_GENERATOR) \
	-DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
	$(WPE_FLAGS)

WPE_NINJA_EXTRA_OPTIONS=
ifeq ($(VERBOSE),1)
	WPE_NINJA_EXTRA_OPTIONS += -v
endif

define WPE_BUILD_CMDS
	$(WPE_MAKE_ENV) $(HOST_DIR)/usr/bin/ninja -C $(WPE_BUILDDIR) $(WPE_NINJA_EXTRA_OPTIONS) libWPEWebKit.so libWPEWebInspectorResources.so WPE{Web,Network}Process
endef

define WPE_INSTALL_STAGING_CMDS
	(cd $(WPE_BUILDDIR) && \
	cp bin/WPE{Network,Web}Process $(STAGING_DIR)/usr/bin/ && \
	cp -d lib/libWPE* $(STAGING_DIR)/usr/lib/ )
	DESTDIR=$(STAGING_DIR) $(HOST_DIR)/usr/bin/cmake -DCOMPONENT=Development -P $(WPE_BUILDDIR)/Source/WebKit2/cmake_install.cmake
endef

define WPE_INSTALL_TARGET_CMDS
	(pushd $(WPE_BUILDDIR) > /dev/null && \
	cp bin/WPE{Network,Web}Process $(TARGET_DIR)/usr/bin/ && \
	cp -d lib/libWPE* $(TARGET_DIR)/usr/lib/ && \
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/libWPEWebKit.so.0.0.1 && \
	popd > /dev/null)
endef

RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests --exclude WebKitBuild

$(eval $(cmake-package))
