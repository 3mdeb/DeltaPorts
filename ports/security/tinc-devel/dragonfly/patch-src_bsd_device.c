--- src/bsd/device.c.orig	2020-04-04 11:51:12 UTC
+++ src/bsd/device.c
@@ -40,8 +40,13 @@
 #include <net/if_utun.h>
 #endif
 
+#if defined(HAVE_FREEBSD) || defined(HAVE_DRAGONFLY)
+#define DEFAULT_TUN_DEVICE "/dev/tun"  // Use the auto-clone device
+#define DEFAULT_TAP_DEVICE "/dev/tap"
+#else
 #define DEFAULT_TUN_DEVICE "/dev/tun0"
 #define DEFAULT_TAP_DEVICE "/dev/tap0"
+#endif
 
 typedef enum device_type {
 	DEVICE_TYPE_TUN,
