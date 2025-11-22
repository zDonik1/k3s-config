{ pkgs, config, ... }:

{
  env = config.secretspec.secrets;

  packages = with pkgs; [
    pgcli
    postgresql
    secretspec
  ];

  scripts = {
    apply.exec = "helmfile apply $@";
  };
}
