{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "terraform-dev-${version}";
  src = ./.;
  version = "0.11.5";

  buildInputs = with pkgs; [
    (terraform.overrideAttrs (old: rec {
      name = "terraform-${version}";
      src = fetchgit {
        url = "https://github.com/hashicorp/terraform.git";
        rev = "v${version}";
        sha256 = "130ibb1pd60r2cycwpzs8qfwrz6knyc1a1849csxpipg5rs5q3jy";
      };
    }))
  ];

  shellHook = ''
    source .env
  '';
}
