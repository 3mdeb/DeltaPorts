--- src/dinterpreter.hpp.bak	2015-12-14 11:29:30.000000000 +0200
+++ src/dinterpreter.hpp
@@ -56,7 +56,7 @@ extern int __cdecl __MINGW_NOTHROW fetes
 #  endif
 #  include <fenv.h>
 #endif
-#  if defined(__FreeBSD__)
+#  if defined(__FreeBSD__) || defined(__DragonFly__)
 #    pragma STDC FENV_ACCESS ON
 #  endif
 }
