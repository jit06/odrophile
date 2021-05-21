
![Odrophile logo](https://raw.githubusercontent.com/jit06/odrophile/main/gfx/logo.png)

# Odrophile
Odroid based neo-retro audiophile tablet with leds vu-meter for Odroid C1+/C0 with Hifi Shield and HDMI touch screen (840x480).
It provides an embeded chromium with GLES acceleration for a smooth browsing experience on volumio UI.
2 volumio plugins that I wrote are included and setup : gpiorandom and commandOnEvent. Plugins sources can be found on volumio github : https://github.com/volumio/volumio-plugins 

If you want to another resolution, it can be changed if needed (boot.ini and chromium window's size in /opt/volumiokiosk.sh). However, the boot splash will not be displayed correctly unless you provide another one (/etc/logo.lzo).

3D print case available here : https://www.thingiverse.com/thing:4641846

How to build on an odroid C1+/C0 :
- get my custom volumio image on https://github.com/jit06/Build
- clone this repo
- as root, run build.sh

Hardware build details (with the first software version) can be found here : https://www.bluemind.org/odrophile-odroid-c0-based-audiophile-tablet/
