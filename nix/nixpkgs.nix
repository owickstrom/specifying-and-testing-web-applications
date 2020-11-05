let
  baseUrl = "https://github.com/nixos/nixpkgs-channels";
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
  rev = "84d74ae9c9cbed73274b8e4e00be14688ffc93fe";
in

import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2020-08-10";
  url = "${baseUrl}/archive/${rev}.tar.gz";
  sha256 = "0ww70kl08rpcsxb9xdx8m48vz41dpss4hh3vvsmswll35l158x0v";
})
