-- Keep only your personal keybinding overrides and additions here.

-- Web app bindings (desvinculando primero los defaults de Omarchy)
hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Gemini", { webapp = "https://gemini.google.com/gem/22aa404c6138" })

hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + SHIFT + N", "Netflix", { webapp = "https://www.netflix.com/browse" })

hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Cashew", { webapp = "https://budget-track.web.app/" })

hl.unbind("SUPER + SHIFT + Y")
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })

hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Google Maps", { webapp = "https://maps.google.com/", focus = true })

hl.unbind("SUPER + SHIFT + B")
o.bind("SUPER + SHIFT + B", "Bitwarden", { launch = "bitwarden-desktop" })

-- Control de Brillo (Samsung Odyssey G40B)
hl.unbind("SUPER + F1")
o.bind("SUPER + F1", "Bajar Brillo", { launch = "sh ~/.local/bin/monitor-ctrl.sh 10 - 10" })
hl.unbind("SUPER + F2")
o.bind("SUPER + F2", "Subir Brillo", { launch = "sh ~/.local/bin/monitor-ctrl.sh 10 + 10" })

-- Control de Contraste (Samsung Odyssey G40B)
hl.unbind("SUPER + F3")
o.bind("SUPER + F3", "Bajar Contraste", { launch = "sh ~/.local/bin/monitor-ctrl.sh 12 - 10" })
hl.unbind("SUPER + F4")
o.bind("SUPER + F4", "Subir Contraste", { launch = "sh ~/.local/bin/monitor-ctrl.sh 12 + 10" })

-- Navegación de workspace
o.bind("SUPER + CTRL + LEFT", "Workspace anterior", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + CTRL + RIGHT", "Siguiente workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + CTRL + ALT + LEFT", "Mover app al workspace anterior", hl.dsp.window.move({ workspace = "e-1" }))
o.bind("SUPER + CTRL + ALT + RIGHT", "Mover app al siguiente workspace", hl.dsp.window.move({ workspace = "e+1" }))
