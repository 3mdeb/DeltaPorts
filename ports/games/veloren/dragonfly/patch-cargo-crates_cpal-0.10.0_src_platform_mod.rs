--- cargo-crates/cpal-0.10.0/src/platform/mod.rs.orig	2019-07-05 18:30:36 UTC
+++ cargo-crates/cpal-0.10.0/src/platform/mod.rs
@@ -456,7 +456,7 @@ macro_rules! impl_platform_host {
 }
 
 // TODO: Add pulseaudio and jack here eventually.
-#[cfg(any(target_os = "linux", target_os = "freebsd"))]
+#[cfg(any(target_os = "linux", target_os = "dragonfly", target_os = "freebsd"))]
 mod platform_impl {
     pub use crate::host::alsa::{
         Device as AlsaDevice,
@@ -559,7 +559,7 @@ mod platform_impl {
     }
 }
 
-#[cfg(not(any(windows, target_os = "linux", target_os = "freebsd", target_os = "macos",
+#[cfg(not(any(windows, target_os = "linux", target_os = "dragonfly", target_os = "freebsd", target_os = "macos",
               target_os = "ios", target_os = "emscripten")))]
 mod platform_impl {
     pub use crate::host::null::{
