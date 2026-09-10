-- Configuración de monitores para Samsung Odyssey G40B (240 Hz)
local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "desc:Samsung Electric Company Odyssey G40B H9VXB20701", mode = "1920x1080@239.76", position = "0x0", scale = omarchy_monitor_scale })
