{ pkgs ? import ./nix/nixpkgs.nix { config = { allowBroken = true; }; } }:
let slides = import ./. { inherit pkgs; };
in slides
