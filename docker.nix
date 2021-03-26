{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; } }:
let
  fima = import ./release.nix;
in
pkgs.dockerTools.buildImage {
  name = "fima";
  tag = "latest";

  contents = [
    fima
  ];

  config = {
    Cmd = [ "fima" ];
  };
}
