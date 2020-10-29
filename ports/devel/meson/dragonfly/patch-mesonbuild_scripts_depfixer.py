--- mesonbuild/scripts/depfixer.py.orig	2020-09-10 16:39:24 UTC
+++ mesonbuild/scripts/depfixer.py
@@ -15,6 +15,8 @@
 
 import sys, struct
 import shutil, subprocess
+import platform
+
 
 from ..mesonlib import OrderedSet
 
@@ -296,6 +298,32 @@ class Elf(DataSizes):
         self.fix_rpathtype_entry(rpath_dirs_to_remove, new_rpath, DT_RPATH)
         self.fix_rpathtype_entry(rpath_dirs_to_remove, new_rpath, DT_RUNPATH)
 
+    def adjust_new_rpath(self, old, new):
+        if platform.system().lower() == 'dragonfly':
+            # Compiler implictly might set rpaths like:
+            # /lib/priv/
+            # /usr/lib/priv/
+            # /usr/lib/gcc80/
+            # /usr/local/foo/bar/
+            baseprefix = ["/lib", "/usr/lib", "/usr/local"]
+            if not isinstance(old, str):
+                old = old.decode()
+            oldlist = old.split(":")
+            base = []
+            for path in oldlist:
+                if path.startswith(tuple(baseprefix)):
+                    base.append(path)
+            # Prepend base paths from old_rpath first.
+            if base:
+                if new:
+                    if not isinstance(new, str):
+                        new = new.decode()
+                    return ":".join(base) + ":" + new
+                else:
+                    return ":".join(base)
+        # No adjustments.
+        return new;
+
     def fix_rpathtype_entry(self, rpath_dirs_to_remove, new_rpath, entrynum):
         if isinstance(new_rpath, str):
             new_rpath = new_rpath.encode('utf8')
@@ -325,6 +353,12 @@ class Elf(DataSizes):
         # Prepend user-specified new entries while preserving the ones that came from pkgconfig etc.
         new_rpath = b':'.join(new_rpaths)
 
+        # Try to adjust new_rpath, if there was previous rpath.
+        if old_rpath:
+            new_rpath = self.adjust_new_rpath(old_rpath, new_rpath)
+            if isinstance(new_rpath, str):
+                new_rpath = new_rpath.encode('utf8')
+
         if len(old_rpath) < len(new_rpath):
             msg = "New rpath must not be longer than the old one.\n Old: {}\n New: {}".format(old_rpath, new_rpath)
             sys.exit(msg)
