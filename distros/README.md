
## Desktop

**Alpine319**

```bash
# alpine
/home/headless # apk add gnome-desktop
(1/55) Installing bubblewrap (0.8.0-r1)
/home/headless # apk add mate-desktop
(1/10) Installing mate-common (1.26.0-r1)
/home/headless # apk add plasma-desktop
(1/234) Purging icu-data-en (74.1-r0)
```

**Debian12**

```bash
# root@x11-debian:/home/headless# apt install --no-install-recommends mate-desktop
0 upgraded, 96 newly installed, 0 to remove and 0 not upgraded.
Need to get 46.7 MB of archives.


# root@x11-debian:/home/headless# apt install --no-install-recommends gnome-session
0 upgraded, 368 newly installed, 1 to remove and 0 not upgraded.
Need to get 225 MB of archives.


# root@x11-debian:/home/headless# apt install --no-install-recommends plasma-desktop 2>&1 |grep session
0 upgraded, 633 newly installed, 0 to remove and 0 not upgraded.
Need to get 409 MB of archives.
After this operation, 1377 MB of additional disk space will be used.
Do you want to continue? [Y/n] ^C
root@x11-debian:/home/headless# apt install --no-install-recommends plasma-desktop 2>&1 |grep plasma
  libkf5peoplebackend5 libkf5peoplewidgets5 libkf5plasma5 libkf5plasmaquick5
  libplacebo208 libplasma-geolocation-interface5 libplist3 libpolkit-agent-1-0
  plasma-desktop-data plasma-framework plasma-integration plasma-workspace
  plasma-workspace-data polkit-kde-agent-1 polkitd python3 python3-minimal
  plasma-browser-integration plasma-discover plasma-disks plasma-firewall
  plasma-nm plasma-pa plasma-systemmonitor plasma-thunderbolt plasma-vault
  plasma-welcome plasma-workspace-wayland powerdevil xdg-desktop-portal-gtk
  libkf5peoplebackend5 libkf5peoplewidgets5 libkf5plasma5 libkf5plasmaquick5
  libplacebo208 libplasma-geolocation-interface5 libplist3 libpolkit-agent-1-0
  plasma-desktop plasma-desktop-data plasma-framework plasma-integration
  plasma-workspace plasma-workspace-data polkit-kde-agent-1 polkitd python3
^C
root@x11-debian:/home/headless# apt install --no-install-recommends plasma-desktop 2>&1 |grep session
  dbus-session-bus-common dbus-system-bus-common dbus-user-session
  dbus-session-bus-common dbus-system-bus-common dbus-user-session
^C

```

**openSUSE15.5**

```bash
x11-opensuse:/home/headless # zypper install mate-desktop
The following 6 NEW packages are going to be installed:
  adwaita-icon-theme libmate-desktop-2-17 mate-desktop mate-desktop-gschemas mate-desktop-gschemas-branding-openSUSE xdg-user-dirs
6 new packages to install.
Package download size:    11.4 MiB

x11-opensuse:/home/headless # zypper install gnome-session
214 new packages to install.
Package download size:    81.2 MiB

x11-opensuse:/home/headless # zypper install plasma5-session
236 new packages to install.
Package download size:   141.2 MiB

```

