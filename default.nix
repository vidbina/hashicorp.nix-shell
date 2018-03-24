{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "terraform-dev-${version}";
  src = ./.;
  version = "0.1.0";

  buildInputs = with pkgs; [
    (terraform.overrideAttrs (old: rec {
      name = "terraform-${version}";
      src = ../terraform;
      version = "0.11.2-dev";
      #sha256 = "testing";
    }))
  ];

  shellHook = ''
    source .env
  '';
}
