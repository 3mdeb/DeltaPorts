--- include/common/types.h.orig	2019-07-22 23:21:17 UTC
+++ include/common/types.h
@@ -196,7 +196,7 @@
     #define IF_PLATFORM_LINUX(...)      __VA_ARGS__
 #endif /* __linux__ */
 
-#if defined(__bsd__) || defined(__bsd) || defined(__FreeBSD__) || defined(freebsd) || defined(openbsd) || defined(bsdi) || defined(__darwin__)
+#if defined(__bsd__) || defined(__bsd) || defined(__FreeBSD__) || defined(freebsd) || defined(openbsd) || defined(bsdi) || defined(__darwin__) || defined(__DragonFly__)
     #define PLATFORM_BSD
     #define IF_PLATFORM_BSD(...)        __VA_ARGS__
 #endif /* __bsd__ */
