--- src/ukengine/usrkeymap.cpp.orig	2006-04-09 02:31:40.000000000 +0300
+++ src/ukengine/usrkeymap.cpp
@@ -23,6 +23,8 @@
 
 #include "stdafx.h"
 #include <iostream>
+#include <cstdio>  // for fprintf stderr
+#include <cstring> // for strcmp strlen
 using namespace std;
 
 #include <ctype.h>
@@ -262,4 +263,4 @@ int getLabelIndex(int event)
             return i;
     }
     return -1;
-}
\ No newline at end of file
+}
