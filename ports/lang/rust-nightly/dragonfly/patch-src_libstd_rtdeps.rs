--- src/libstd/rtdeps.rs.orig	2016-03-18 13:54:58 UTC
+++ src/libstd/rtdeps.rs
@@ -29,13 +29,13 @@ extern {}
 #[link(name = "log")]
 extern {}
 
-#[cfg(target_os = "freebsd")]
+#[cfg(any(target_os = "freebsd",
+          target_os = "dragonfly"))]
 #[link(name = "execinfo")]
 #[link(name = "pthread")]
 extern {}
 
-#[cfg(any(target_os = "dragonfly",
-          target_os = "bitrig",
+#[cfg(any(target_os = "bitrig",
           target_os = "netbsd",
           target_os = "openbsd"))]
 #[link(name = "pthread")]
