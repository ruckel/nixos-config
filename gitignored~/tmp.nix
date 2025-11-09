  {
  options.sops = {
    secrets = lib.mkOption {
      type = lib.types.attrsOf secretType;
      default = { };
      description = ''
        Path where the latest secrets are mounted to.
      '';
    };

    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Default sops file used for all secrets.
      '';
    };

    defaultSopsFormat = lib.mkOption {
      type = lib.types.str;
      default = "yaml";
      description = ''
        Default sops format used for all secrets.
      '';
    };

    defaultSopsKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Default key used to lookup in all secrets.
        This option is ignored if format is binary.
        "" means whole file.
      '';
    };

    validateSopsFiles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Check all sops files at evaluation time.
        This requires sops files to be added to the nix store.
      '';
    };

    keepGenerations = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1;
      description = ''
        Number of secrets generations to keep. Setting this to 0 disables pruning.
      '';
    };

    log = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "keyImport"
          "secretChanges"
        ]
      );
      default = [
        "keyImport"
        "secretChanges"
      ];
      description = "What to log";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.str lib.types.path);
      default = { };
      description = ''
        Environment variables to set before calling sops-install-secrets.

        The values are placed in single quotes and not escaped any further to
        allow usage of command substitutions for more flexibility. To properly quote
        strings with quotes use lib.escapeShellArg.

        This will be evaluated twice when using secrets that use neededForUsers but
        in a subshell each time so the environment variables don't collide.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = (pkgs.callPackage ../.. { }).sops-install-secrets;
      defaultText = lib.literalExpression "(pkgs.callPackage ../.. {}).sops-install-secrets";
      description = ''
        sops-install-secrets package to use.
      '';
    };

    validationPackage = lib.mkOption {
      type = lib.types.package;
      default =
        if pkgs.stdenv.buildPlatform == pkgs.stdenv.hostPlatform then
          sops-install-secrets
        else
          (pkgs.pkgsBuildHost.callPackage ../.. { }).sops-install-secrets;
      defaultText = lib.literalExpression "config.sops.package";

      description = ''
        sops-install-secrets package to use when validating configuration.

        Defaults to sops.package if building natively, and a native version of sops-install-secrets if cross compiling.
      '';
    };

    useTmpfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use tmpfs in place of ramfs for secrets storage.

        *WARNING*
        Enabling this option has the potential to write secrets to disk unencrypted if the tmpfs volume is written to swap. Do not use unless absolutely necessary.

        When using a swap file or device, consider enabling swap encryption by setting the `randomEncryption.enable` option

        ```
        swapDevices = [{
          device = "/dev/sdXY";
          randomEncryption.enable = true;
        }];
        ```
      '';
    };

    age = {
      keyFile = lib.mkOption {
        type = lib.types.nullOr pathNotInStore;
        default = null;
        example = "/var/lib/sops-nix/key.txt";
        description = ''
          Path to age key file used for sops decryption.
        '';
      };

      generateKey = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether or not to generate the age key. If this
          option is set to false, the key must already be
          present at the specified location.
        '';
      };

      sshKeyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = defaultImportKeys "ed25519";
        defaultText = lib.literalMD "The ed25519 keys from {option}`config.services.openssh.hostKeys`";
        description = ''
          Paths to ssh keys added as age keys during sops description.
        '';
      };
    };

    gnupg = {
      home = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/root/.gnupg";
        description = ''
          Path to gnupg database directory containing the key for decrypting the sops file.
        '';
      };

      sshKeyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = defaultImportKeys "rsa";
        defaultText = lib.literalMD "The rsa keys from {option}`config.services.openssh.hostKeys`";
        description = ''
          Path to ssh keys added as GPG keys during sops description.
          This option must be explicitly unset if <literal>config.sops.gnupg.home</literal> is set.
        '';
      };
    };
  };
}
