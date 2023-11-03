{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "chroot-env";
  targetPkgs = pkgs: (with pkgs;
    [ udev
      alsaLib
      clib
      zlib
      busybox
      fish
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
      openjdk
      sbt
      cairo
      libcap
      dbus
      libnotify
      vim
    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
    ]);
  multiPkgs = pkgs: (with pkgs;
    [ udev
      alsaLib
    ]);
  runScript = "fish";
}).env
