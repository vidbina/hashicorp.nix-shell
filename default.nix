{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "hashicorp-env-${version}";
  src = ./.;
  version = "0.1.0";

  packer_version = "1.2.2";
  terraform_version = "0.11.5";

  buildInputs = with pkgs; [
    go_1_9
    graphviz
    jq
    (packer.overrideAttrs (old: rec {
      name = "packer-${packer_version}";
      src = fetchgit {
        url = "https://github.com/hashicorp/packer.git";
        rev = "v${packer_version}";
        sha256 = "05k3hzp0456f7ygz0k0f2sz6xv32rdb9bg5fkr5s69af84p53d91";
      };
    }))
    openssh
    (terraform.overrideAttrs (old: rec {
      name = "terraform-${terraform_version}";
      src = fetchgit {
        url = "https://github.com/hashicorp/terraform.git";
        rev = "v${terraform_version}";
        sha256 = "130ibb1pd60r2cycwpzs8qfwrz6knyc1a1849csxpipg5rs5q3jy";
      };
    }))
    rsync
    which
  ];

  shellHook = ''
    # https://github.com/NixOS/nix/issues/1056
    export TERMINFO=/run/current-system/sw/share/terminfo
    real_TERM=$TERM; TERM=xterm; TERM=$real_TERM; unset real_TERM

    export GOPATH=`realpath GOPATH`
    export PATH=$PATH:$GOPATH/bin
    source project.env

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
