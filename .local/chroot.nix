{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "chroot-env";
  targetPkgs = pkgs: (with pkgs;
    [ udev
      alsaLib
      clib
      zlib
      busybox
      freetype
      fontconfig
      fuse
      xorg.libXi
      xorg.libXdamage
      xorg.libXtst
      xorg.libXext
      xorg.libXfixes
      xorg.libXrender
      xorg.libXcomposite
      expat
      openssh
      git
      glib
      atk
      pango
      nss
      nspr
      gdk_pixbuf
      cairo
      gnome3.gtk
      libcap
      libudev
      dbus
      libnotify
    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
    ]);
  multiPkgs = pkgs: (with pkgs;
    [ udev
      libudev
      alsaLib
    ]);
  runScript = "bash";
}).env
