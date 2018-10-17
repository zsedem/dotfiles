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
      (python36.withPackages (ps: with ps; [ pyyaml pyxdg pygobject3 ]))
      expat
      openssh
      git
      glib
      gnome2.gtk
      atk
      pango
      nss
      nspr
      gdk_pixbuf
      cairo
      gnome3.gconf
      gnome3.gtk
      libcap
      libudev
      dbus
      libnotify
      (stdenv.mkDerivation {
         name = "udev0-soft-link";
         buildCommand = ''
           mkdir -p $out/lib
           ln -s ${systemd.lib}/lib/libudev.so.1 $out/lib/libudev.so.0
         '';
      })
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
  runScript = "sudo -u azsigmond bash";
}).env
