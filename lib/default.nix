lib:
let
  deduplicateRepositories =
    repositories:
    let
      filterDuplicate =
        acc: item:
        if acc.seen ? ${item.name} then
          acc
        else
          {
            seen = acc.seen // {
              ${item.name} = true;
            };
            result = acc.result ++ [ item ];
          };

      final = builtins.foldl' filterDuplicate {
        seen = { };
        result = [ ];
      } repositories;
    in
    final.result;

  updateReleasePaths =
    root: releases:
    map (
      r:
      r
      // {
        chart = lib.path.removePrefix root r.chart;
        values = map (v: if builtins.isPath v then lib.path.removePrefix root v else v) r.values;
      }
    ) releases;

  helmfileModule =
    { lib, ... }:
    with lib;
    {
      options.helmfile = {
        repositories = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                name = mkOption { type = types.str; };
                url = mkOption { type = types.str; };
                oci = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
              };
            }
          );
          default = [ ];
        };

        releases = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                name = mkOption { type = types.str; };
                namespace = mkOption { type = types.str; };
                createNamespace = mkOption {
                  type = types.bool;
                  default = true;
                };

                chart = mkOption { type = types.path; };
                version = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };

                needs = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };

                dependencies = mkOption {
                  type = types.listOf (
                    types.submodule {
                      options = {
                        chart = mkOption { type = types.str; };
                        version = mkOption { type = types.str; };
                      };
                    }
                  );
                  default = [ ];
                };

                values = mkOption {
                  type = types.listOf (types.either types.path types.attrs);
                  default = [ ];
                };
              };
            }
          );
          default = [ ];
        };
      };
    };

  filterEmptyRecursive =
    value:
    let
      filterFunc =
        v: (v != null && !(builtins.isAttrs v && v == { }) && !(builtins.isList v && v == [ ]));
    in
    if builtins.isAttrs value then
      lib.filterAttrs (k: filterFunc) (builtins.mapAttrs (k: filterEmptyRecursive) value)
    else if builtins.isList value then
      builtins.filter filterFunc (builtins.map filterEmptyRecursive value)
    else
      value;
in
{
  evalModuleToHelmfile =
    {
      root,
      specialArgs ? { },
      module,
    }:
    let
      helmfile =
        (lib.evalModules {
          inherit specialArgs;
          modules = [
            helmfileModule
            module
          ];
        }).config.helmfile;
    in
    filterEmptyRecursive {
      repositories = deduplicateRepositories helmfile.repositories;
      releases = updateReleasePaths root helmfile.releases;
    };
}
