--- fpmake.pp.orig	2017-09-02 16:48:24 UTC
+++ fpmake.pp
@@ -22,7 +22,7 @@ begin
     P.Options.Add('-S2h');
     D:=P.Dependencies.Add('fcl-base');
       D.Version:='3.0.4';
-    D:=P.Dependencies.Add('iconvenc',[linux,darwin,iphonesim,freebsd,haiku,beos,aix]);
+    D:=P.Dependencies.Add('iconvenc',[linux,darwin,iphonesim,dragonfly,freebsd,haiku,beos,aix]);
 
     P.Author := 'Sebastian Guenther, Sergei Gorelkin and FPC development team';
     P.License := 'LGPL with modification, ';
@@ -151,7 +151,7 @@ begin
           AddUnit('dom');
           AddUnit('htmldefs');
         end;
-    T:=P.Targets.AddUnit('xmliconv.pas',[linux,freebsd,darwin,iphonesim,haiku,beos,aix]);
+    T:=P.Targets.AddUnit('xmliconv.pas',[linux,dragonfly,freebsd,darwin,iphonesim,haiku,beos,aix]);
       with T.Dependencies do
         begin
           AddUnit('xmlread');
