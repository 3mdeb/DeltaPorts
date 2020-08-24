--- xbmc/utils/test/TestSystemInfo.cpp.orig	2020-05-31 13:31:35 UTC
+++ xbmc/utils/test/TestSystemInfo.cpp
@@ -61,6 +61,9 @@ TEST_F(TestSystemInfo, GetKernelName)
 #elif defined(TARGET_FREEBSD)
   EXPECT_STREQ("FreeBSD", g_sysinfo.GetKernelName(true).c_str()) << "'GetKernelName(true)' must return 'FreeBSD'";
   EXPECT_STREQ("FreeBSD", g_sysinfo.GetKernelName(false).c_str()) << "'GetKernelName(false)' must return 'FreeBSD'";
+#elif defined(TARGET_DRAGONFLY)
+  EXPECT_STREQ("DragonFly", g_sysinfo.GetKernelName(true).c_str()) << "'GetKernelName(true)' must return 'DragonFly'";
+  EXPECT_STREQ("DragonFly", g_sysinfo.GetKernelName(false).c_str()) << "'GetKernelName(false)' must return 'DragonFly'";
 #elif defined(TARGET_DARWIN)
   EXPECT_STREQ("Darwin", g_sysinfo.GetKernelName(true).c_str()) << "'GetKernelName(true)' must return 'Darwin'";
   EXPECT_STREQ("Darwin", g_sysinfo.GetKernelName(false).c_str()) << "'GetKernelName(false)' must return 'Darwin'";
@@ -99,6 +102,9 @@ TEST_F(TestSystemInfo, GetOsName)
 #elif defined(TARGET_FREEBSD)
   EXPECT_STREQ("FreeBSD", g_sysinfo.GetOsName(true).c_str()) << "'GetOsName(true)' must return 'FreeBSD'";
   EXPECT_STREQ("FreeBSD", g_sysinfo.GetOsName(false).c_str()) << "'GetOsName(false)' must return 'FreeBSD'";
+#elif defined(TARGET_DRAGONFLY)
+  EXPECT_STREQ("DragonFly", g_sysinfo.GetOsName(true).c_str()) << "'GetOsName(true)' must return 'DragonFly'";
+  EXPECT_STREQ("DragonFly", g_sysinfo.GetOsName(false).c_str()) << "'GetOsName(false)' must return 'DragonFly'";
 #elif defined(TARGET_DARWIN_IOS)
   EXPECT_STREQ("iOS", g_sysinfo.GetOsName(true).c_str()) << "'GetOsName(true)' must return 'iOS'";
   EXPECT_STREQ("iOS", g_sysinfo.GetOsName(false).c_str()) << "'GetOsName(false)' must return 'iOS'";
@@ -225,6 +231,8 @@ TEST_F(TestSystemInfo, GetUserAgent)
   EXPECT_EQ(g_sysinfo.GetUserAgent().find('('), g_sysinfo.GetUserAgent().find("(X11; ")) << "Second parameter in 'GetUserAgent()' string must start from 'X11; '";
 #if defined(TARGET_FREEBSD)
   EXPECT_EQ(g_sysinfo.GetUserAgent().find('('), g_sysinfo.GetUserAgent().find("(X11; FreeBSD ")) << "Second parameter in 'GetUserAgent()' string must start from 'X11; FreeBSD '";
+#if defined(TARGET_DRAGONFLY)
+  EXPECT_EQ(g_sysinfo.GetUserAgent().find('('), g_sysinfo.GetUserAgent().find("(X11; DragonFly ")) << "Second parameter in 'GetUserAgent()' string must start from 'X11; DragonFly '";
 #elif defined(TARGET_LINUX)
   EXPECT_EQ(g_sysinfo.GetUserAgent().find('('), g_sysinfo.GetUserAgent().find("(X11; Linux ")) << "Second parameter in 'GetUserAgent()' string must start from 'X11; Linux '";
 #endif // defined(TARGET_LINUX)
