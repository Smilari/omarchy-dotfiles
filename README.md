# omarchy-dotfiles

Configuración de mi estación de trabajo: **Omarchy** (Arch Linux), Hyprland/Wayland,
Alacritty, fish y Neovim/LazyVim.

El objetivo es simple: si reinstalo el sistema o cambio de máquina, clono este repo,
corro un script y vuelvo a tener todo como lo tenía.

---

## Qué incluye

- **Funciones de fish** — utilidades de terminal y un toolkit para trabajar con
  servidores remotos por SSH.
- **Configuración de aplicaciones** — Alacritty, tmux, Neovim, Hyprland.
- **Lista de paquetes** — todo lo instalado explícitamente con pacman y desde AUR.
- **Unidades de systemd** de usuario.
- **Plantillas de `/etc`** — solo la forma del archivo, nunca los valores.

No hay credenciales, claves privadas ni datos de ningún entorno concreto. Las
plantillas usan `[COMPLETAR]` en lugar de valores reales.

---

## Estructura

```text
omarchy-dotfiles/
├── fish/
│   ├── functions/       funciones de fish
│   ├── completions/
│   └── config.fish
├── config/              alacritty/, hypr/, tmux/, nvim/
├── systemd/             unidades de usuario
├── packages/            pacman-explicit.txt, aur.txt
├── etc/                 plantillas, sin credenciales
├── sync.fish            sistema → repo
├── install.fish         repo → sistema
└── README.md
```

---

## Uso

### Guardar los cambios del sistema

```fish
./sync.fish
git status --short
git add -A; and git commit -m "sync: <qué cambió>"
```

Correrlo cada vez que agregues una función o cambies algo que quieras conservar.
La idea de tener los dos sentidos es que el repo no se quede viejo: mantenerlo es
`./sync.fish` y commitear.

### Restaurar en una máquina nueva

```fish
git clone https://github.com/Smilari/omarchy-dotfiles.git ~/omarchy-dotfiles
cd ~/omarchy-dotfiles
./install.fish
```

Instala los paquetes base, copia las funciones y configuraciones, y al terminar
lista los pasos que quedan a mano (clave SSH, credenciales, variables de entorno).

---

## Funciones incluidas

### Terminal

| Comando | Qué hace |
| --- | --- |
| `cls` | Limpia pantalla y scrollback, también dentro de tmux |
| `<cmd> \| copy` | Manda la salida al portapapeles (Wayland) |

### Acceso a servidores

Trabajan sobre los hosts definidos en `~/.ssh/config`, que cada uno define por
su cuenta. Sin esa configuración no tienen a dónde conectarse.

| Comando | Qué hace |
| --- | --- |
| `vm [-u usuario] [filtro]` | Selector fzf de hosts; graba la sesión en `$VM_LOG_DIR/<host>/` (por defecto `$OPS_BASE/logs/ssh`) |
| `vmlog [host]` | Elige una sesión grabada, la muestra sin códigos de terminal y deja una copia `.txt` al lado |
| `vmrun <host> '<cmd>'` | Ejecuta un comando remoto y trae la salida local |
| `vmrunx [-p] '<cmd>' <host>…` | El mismo comando en varios hosts, con separadores; `-p` los corre en paralelo |
| `vmx <filtro>` | Abre varios hosts en panes de tmux sincronizados |
| `vmfs <host> [ruta]` / `vmfs-u [host]` | Monta y desmonta el filesystem remoto vía sshfs (`vmfs-u` sin host elige de los montados) |
| `gf <host>` | Estado de un servicio GlassFish y sus instancias |
| `myq [-f] "<sql>"\|archivo.sql <host>…` | Ejecuta SQL en uno o varios MySQL por SSH; pide confirmación si detecta escritura sobre producción |
| `vpn-up` / `vpn-down` / `vpn-status` | Levanta una VPN Forti vía systemd y fija los dominios DNS (espera a que la interfaz ppp tenga DNS) |

`myq` no selecciona base: prefijá `USE <base>;` o pasalo en el `.sql`.
Autentica con `sudo` contra `/root/.my.cnf` (o `/etc/mysql/debian.cnf` como
fallback); si esas credenciales rotan, hay que actualizarlas en cada nodo.

### Notas de trabajo

| Comando | Qué hace |
| --- | --- |
| `work [filtro]` | Selector fzf de items con preview; deja la shell parada en la carpeta del item |
| `work new <slug> ["Título"] [-p <padre>]` | Crea un item (`README.md` + `log.md`), opcionalmente hijo de otro. En el selector, `Ctrl-E` abre el README y `Ctrl-L` el log |
| `work close <slug>` | Marca el item como cerrado y lo mueve a `archive/` |
| `work index` | Regenera el índice de items en el `README.md` raíz |
| `graph token` / `estado` / `logout` | Token de Microsoft Graph (el de Graph Explorer, ~24 h) compartido por todas las terminales |
| `planner plans` / `sync` / `apply` | Baja planners de Microsoft como Markdown y muestra qué cambió; `apply` escribe cambios con simulacro y confirmación |
| `mail sync` / `lista` / `leer` / `buscar` / `ticket <ID>` / `tickets` | Correo de trabajo vía Graph (solo lectura): por tipo, historia de tickets NOC/MDA y cruce con la bitácora |
| `vault estado` / `inventario` / `lock` | VaultWarden del equipo vía `bw` (solo lectura por ahora) |
| `snapshot <perfil> <amb> [etiqueta]` / `diff` / `lista` | Fotos de estado de VMs antes y después de una maniobra |
| `teams sync` / `lista` / `dump` / `buscar` / `md` | Chats grupales de Teams y MD elegidos (guardados en OneDrive por Power Automate) a Markdown; `sync` muestra qué llegó |

Estas funciones trabajan sobre el repo que indique `$OPS_BASE` y delegan en
scripts que viven en ese repo, no en este: `tools/work-index.py`, `tools/graph.py`,
`tools/planner.py` (con la lista de planners en `tools/planners.tsv`), `tools/teams.py`, `tools/mail.py`, `tools/vault.py` y `tools/snapshot.py`.
El token de Graph se guarda en `$XDG_RUNTIME_DIR` (en memoria, permisos 600): sobrevive a
cerrar terminales y se borra al cerrar sesión o reiniciar.

---

## Notas

- **Hyprland no se restaura automáticamente.** Omarchy administra esos archivos y
  cambia su formato entre versiones, así que `install.fish` los omite. Quedan
  versionados como referencia para replicar los cambios a mano.
- **`fish_variables` está ignorado**: guarda variables universales con rutas locales.
  Las que importan se setean durante la instalación.
- Antes de restaurar `config/`, conviene mirar qué archivos modificaste realmente
  para no pisar cambios que traiga una versión más nueva de Omarchy.
