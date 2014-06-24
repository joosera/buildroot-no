################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = 4b81937fae07da1d04c5792ff3a3874ec49a7b08
WEBKITGTK_SITE = $(call github,Metrological,webkitgtk,$(WEBKITGTK_VERSION))
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	host-pkgconf zlib pcre libgles libegl \
	icu libxml2 libxslt libgtk3 sqlite enchant libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

WEBKITGTK_AUTORECONF = YES

WEBKITGTK_DEPENDENCIES += $(if $(BR2_PACKAGE_OPENSSL),ca-certificates)

WEBKITGTK_EGL_CFLAGS = \
	$(shell PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig $(HOST_DIR)/usr/bin/pkg-config --define-variable=prefix=$(STAGING_DIR)/usr --cflags egl)

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WEBKITGTK_EGL_CFLAGS += \
	-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux
endif

# Give explicit path to icu-config.
WEBKITGTK_CONF_ENV = \
	ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	AR_FLAGS="cru" \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS) -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"

WEBKITGTK_CONF_OPT = \
	--disable-webkit1 \
	--disable-credential-storage \
	--disable-geolocation \
	--disable-web-audio

ifeq ($(BR2_PACKAGE_XORG7),y)
	WEBKITGTK_CONF_OPT += --enable-x11-target
	WEBKITGTK_DEPENDENCIES += xlib_libXt
endif
ifeq ($(BR2_PACKAGE_WAYLAND),y)
	WEBKITGTK_CONF_OPT += --enable-wayland-target
	WEBKITGTK_DEPENDENCIES += wayland
endif

$(eval $(autotools-package))
