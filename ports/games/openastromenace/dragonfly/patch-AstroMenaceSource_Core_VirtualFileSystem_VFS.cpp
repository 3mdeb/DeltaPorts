--- AstroMenaceSource/Core/VirtualFileSystem/VFS.cpp.orig	2013-05-16 11:04:45.000000000 +0300
+++ AstroMenaceSource/Core/VirtualFileSystem/VFS.cpp
@@ -1436,6 +1436,7 @@ long eFILE::ftell()
 //------------------------------------------------------------------------------------
 // узнаем, достигли конца файла или нет
 //------------------------------------------------------------------------------------
+#undef feof
 int eFILE::feof()
 {
 	// если указатель больше или равен длине файла - значит он уже за массивом данных файла
