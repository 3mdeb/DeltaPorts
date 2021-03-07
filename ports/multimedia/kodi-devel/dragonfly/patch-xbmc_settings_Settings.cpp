--- xbmc/settings/Settings.cpp.orig	2020-10-05 13:49:34 UTC
+++ xbmc/settings/Settings.cpp
@@ -642,6 +642,9 @@ bool CSettings::InitializeDefinitions()
 #elif defined(TARGET_ANDROID)
   if (CFile::Exists(SETTINGS_XML_FOLDER "android.xml") && !Initialize(SETTINGS_XML_FOLDER "android.xml"))
     CLog::Log(LOGFATAL, "Unable to load android-specific settings definitions");
+#elif defined(TARGET_DRAGONFLY)
+  if (CFile::Exists(SETTINGS_XML_FOLDER "dragonfly.xml") && !Initialize(SETTINGS_XML_FOLDER "dragonfly.xml"))
+    CLog::Log(LOGFATAL, "Unable to load dragonfly-specific settings definitions");
 #elif defined(TARGET_FREEBSD)
   if (CFile::Exists(SETTINGS_XML_FOLDER "freebsd.xml") && !Initialize(SETTINGS_XML_FOLDER "freebsd.xml"))
     CLog::Log(LOGFATAL, "Unable to load freebsd-specific settings definitions");
