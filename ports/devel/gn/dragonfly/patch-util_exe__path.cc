--- util/exe_path.cc.orig	2019-06-18 13:09:10 UTC
+++ util/exe_path.cc
@@ -13,7 +13,7 @@
 #include <mach-o/dyld.h>
 #elif defined(OS_WIN)
 #include <windows.h>
-#elif defined(OS_FREEBSD)
+#elif defined(OS_FREEBSD) ||  defined(OS_DRAGONFLY)
 #include <limits.h>
 #include <sys/sysctl.h>
 #include <sys/types.h>
@@ -50,7 +50,7 @@ base::FilePath GetExePath() {
   return base::FilePath(system_buffer);
 }
 
-#elif defined(OS_FREEBSD)
+#elif defined(OS_FREEBSD) || defined(OS_DRAGONFLY)
 
 base::FilePath GetExePath() {
   int mib[] = { CTL_KERN, KERN_PROC, KERN_PROC_PATHNAME, -1 };
