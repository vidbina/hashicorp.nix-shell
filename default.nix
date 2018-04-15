{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "terraform-dev-${version}";
  src = ./.;
  version = "0.11.5";

  buildInputs = with pkgs; [
    go_1_9
    graphviz
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
    exitstatus()
    {
        if [[ $? == 0 ]]; then
            echo -e "\e[92m>\e[39m"
        else
            echo -e "\e[91m>\e[39m"
        fi
    }
    export PS1='$(exitstatus) '
    export PS2="> "
  '';
}
