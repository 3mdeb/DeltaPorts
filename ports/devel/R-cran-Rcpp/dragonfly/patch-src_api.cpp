--- src/api.cpp.orig	2015-05-01 14:41:53 UTC
+++ src/api.cpp
@@ -34,7 +34,9 @@ using namespace Rcpp;
 #endif
 
 #if defined(__GNUC__)
-    #if defined(WIN32) || defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__CYGWIN__) || defined(__sun) || defined(_AIX)
+    #if defined(WIN32) || defined(__FreeBSD__) || defined(__NetBSD__) \
+     || defined(__OpenBSD__) || defined(__CYGWIN__) || defined(__sun) \
+     || defined(_AIX) || defined(__DragonFly__)
         // do nothing
     #else
         #include <execinfo.h>
@@ -257,7 +259,9 @@ SEXP rcpp_can_use_cxx11() {
 // [[Rcpp::register]]
 SEXP stack_trace(const char* file, int line) {
     #if defined(__GNUC__)
-        #if defined(WIN32) || defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__CYGWIN__) || defined(__sun) || defined(_AIX)
+        #if defined(WIN32) || defined(__FreeBSD__) || defined(__NetBSD__) \
+         || defined(__OpenBSD__) || defined(__CYGWIN__) || defined(__sun) \
+         || defined(_AIX) || defined(__DragonFly__)
             // Simpler version for Windows and *BSD
             List trace = List::create(_["file"] = file,
                                       _[ "line"  ] = line,
