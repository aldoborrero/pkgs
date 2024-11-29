{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options = {
    sopsSecrets = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable automatic sops secrets loading";
      };
      secretsDir = mkOption {
        type = types.path;
        default = null;
        description = "Directory containing sops-encrypted secret files";
      };
      fileExtensions = let
        fileExtensionEnum = types.enum [
          "yaml"
          "json"
          "env"
          "ini"
        ];
      in
        mkOption {
          type = types.listOf fileExtensionEnum;
          default = ["yaml" "json"];
          example = ["yaml" "json" "env"];
          description = ''
            List of file extensions to consider as valid secret files.
            Supported values: ${lib.concatStringsSep ", " (types.getValues fileExtensionEnum)}
          '';
        };
    };
  };

  config = let
    cfg = config.sopsSecrets;

    hasValidExtension = filename:
      lib.any (ext: lib.hasSuffix ".${ext}" filename) cfg.fileExtensions;

    loadSecrets = dir: let
      # Read all files in the secrets directory
      secretFiles = builtins.readDir dir;
      # Filter for files with valid extensions
      validFiles =
        lib.filterAttrs (
          name: type:
            type == "regular" && hasValidExtension name
        )
        secretFiles;
      # Convert each file into a sops configuration
      secretsConfig =
        lib.mapAttrs' (
          name: _: let
            # Remove all valid extensions to get secret name
            secretName =
              lib.foldl
              (acc: ext: lib.removeSuffix ".${ext}" acc)
              name
              cfg.fileExtensions;
          in
            lib.nameValuePair secretName {
              sopsFile = "${dir}/${name}";
            }
        )
        validFiles;
    in
      secretsConfig;
  in {
    flake = {
      sopsSecrets = lib.mkIf cfg.enable (loadSecrets cfg.secretsDir);

      schemas.sopsSecrets = {
        version = 1;
        doc = ''
          The `sopsSecrets` flake output contains sops-encrypted secret configurations.
          Each secret entry points to a sops-encrypted file that contains sensitive data.
          Supported file extensions: ${lib.concatStringsSep ", " (map (ext: ".${ext}") cfg.fileExtensions)}
        '';
        inventory = output:
          lib.mapAttrs (name: value: {
            what = "sops secret configuration";
            evalChecks = {
              hasSopsFile = value ? sopsFile;
              sopsFileExists = builtins.pathExists value.sopsFile;
              validExtension = hasValidExtension value.sopsFile;
            };
          })
          output;
      };
    };
  };
}
