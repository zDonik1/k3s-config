{
  pkgs,
  config,
  helmfile-nix,
  ...
}:

{
  env = config.secretspec.secrets;

  packages = with pkgs; [
    pgcli
    postgresql
    secretspec
    helmfile-nix.packages.${system}.default
  ];

  scripts = {
    apply.exec = "helmfile apply $@";
  };
}
