
let
  pkgs = import <nixpkgs> {};
in {
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    jre = pkgs.oraclejdk8;
    jdk = pkgs.oraclejdk8;
  };
}
