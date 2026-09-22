-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Personal macOS-style app switcher (separate Quickshell instance).
o.exec_on_start("quickshell -c mac-switcher --no-duplicate --daemonize")
