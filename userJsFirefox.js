/*** GRAPHICS & PERFORMANCE ***/
// WebRender is enabled by default. Do not force experimental compositors.
// Keep Skia font cache increase
user_pref("gfx.content.skia-font-cache-size", 32);

// Accelerated Canvas2D
user_pref("gfx.canvas.accelerated", true);
user_pref("gfx.canvas.accelerated.cache-items", 16384);
user_pref("gfx.canvas.accelerated.cache-size", 4096);

// WebGL: 4096 is the safest realistic limit for 8GB Unified Memory.
// 8192 often leads to crashes on integrated memory systems.
user_pref("webgl.max-size", 4096);

// VAAPI Video Decoding (Crucial for M1 Battery Life)
user_pref("media.ffmpeg.vaapi.enabled", true);
// Enforce video decoding isolation for security/stability
user_pref("media.rdd-ffmpeg.enabled", true);

// Cache GPU shaders on disk to reduce CPU load and startup stutters
user_pref("gfx.webrender.program-binary.disk", true);

/*** MEDIA CACHE (Tuned for 8GB RAM + Fanless) ***/
user_pref("media.memory_cache_max_size", 65536);              // 64 MB
user_pref("media.memory_caches_combined_limit_kb", 262144);  // 256 MB

// CRITICAL FIX: Lowered from 300. 
// 300s buffers can consume >1.5GB RAM per video tab on high bitrate streams.
// 60s is the sweet spot for 8GB RAM to prevent swapping.
user_pref("media.cache_readahead_limit", 60);
user_pref("media.cache_resume_threshold", 60);

/*** BROWSER CACHE ***/
// Disk cache is VITAL on Apple NVMe to offload RAM
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.smart_size.enabled", true);

// RAM Cache: 64MB is safe for 8GB RAM.
user_pref("browser.cache.memory.capacity", 65536);
user_pref("browser.cache.memory.max_entry_size", 10240); // 10 MB

// Image Cache: INCREASED from your original. 
// 7MB causes CPU-heavy re-decoding. 50MB is a better balance for battery vs RAM.
user_pref("image.cache.size", 52428800); // 50 MB
user_pref("image.mem.decode_bytes_at_a_time", 32768);
// Enable shared surfaces to save RAM when the same image is used multiple times
user_pref("image.mem.shared", true);

/*** SESSION & TABS ***/
// Drastically limit history in RAM to save space
user_pref("browser.sessionhistory.max_total_viewers", 4);
user_pref("browser.sessionstore.max_tabs_undo", 10);

// Aggressive tab unloading (Essential for 8GB)
user_pref("browser.tabs.unloadOnLowMemory", true);
// Lowered from 15% to 5%. On 8GB, this triggers unloading sooner (~400MB free), preventing swap.
user_pref("browser.low_commit_space_threshold_percent", 5);

// Prevent tabs from loading until selected (Faster startup)
user_pref("browser.sessionstore.restore_on_demand", true);

/*** NETWORK ***/
user_pref("network.http.max-connections", 900);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.dnsCacheEntries", 5000);
user_pref("network.dnsCacheExpiration", 1800); // 30 min
user_pref("network.ssl_tokens_cache_capacity", 4096);

// Disable Speculative Loading (Privacy + Bandwidth + Battery)
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", false);

/*** MACOS FEEL & SCROLLING (Wayland/Niri) ***/
// Smooth scrolling physics
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", 2.0);
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);

// ADJUSTED: 120 allows for fast scrolling without losing precision control.
// The physics settings above provide the "inertia," so a raw multiplier of 300 is overkill.
user_pref("mousewheel.default.delta_multiplier_y", 120);

// Touchpad gestures and overscroll
user_pref("apz.overscroll.enabled", true);
user_pref("widget.wayland.overscroll.enabled", true);

/*** WAYLAND & ASAHILINUX INTEGRATION ***/
// Force use of XDG Desktop Portal (Vital for Niri/Wayland: 
// ensures file pickers, color schemes, and screen sharing work correctly)
user_pref("widget.use-xdg-desktop-portal", true);

// DMABUF support for video decoding (Reduces RAM copying on Wayland)
user_pref("media.ffmpeg.vaapi-drm-display.enabled", true);

// Picture-in-Picture support
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", true);

// UI Scaling: If Firefox looks blurry or wrong size on Niri, uncomment and adjust:
// user_pref("layout.css.devPixelsPerPx", "2.0"); // 2.0 = 200% scaling (Retina)

/*** PRIVACY & CLEANUP ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);

/*** ASAHI & 8GB OPTIMIZATIONS ***/
// Limit content processes to 4 to reduce RAM overhead (Crucial for 8GB)
user_pref("dom.ipc.processCount", 4);

// Disable Accessibility Service (Saves significant performance if not needed)
user_pref("accessibility.force_disabled", 1);

// Wayland: Better Gesture Support (Pinch to zoom)
user_pref("apz.allow_zooming", true);
user_pref("dom.w3c_touch_events.enabled", 1);

// Wayland: Try to unblock VA-API (Video Accel) specifically for Wayland
user_pref("widget.wayland-dmabuf-vaapi.enabled", true);

// Disable Pocket (Unnecessary bloat)
user_pref("extensions.pocket.enabled", false);

// Disable Firefox View (Saves a tiny bit of RAM/CPU on startup)
user_pref("browser.tabs.firefox-view", false);

// OPTIONAL: Disable WebGL2 if you do NOT play web games.
// This saves VRAM and improves stability on 8GB systems.
// Uncomment the line below to enable:
// user_pref("webgl.disable-webgl2", true);
