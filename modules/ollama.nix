{ lib, pkgs, config, ... } : with lib; let
  cfg = config.ollama;
in {
  options.ollama = {
    enable = mkEnableOption "";
    webui = mkEnableOption "";
    nvidia = mkEnableOption "";
    amd = mkEnableOption "";
  };

  config = mkIf cfg.enable ( mkMerge [
    ({
      services.ollama = {
        enable = true;
        #acceleration = mkDefault false;
        #loadModels = [ "llama3.2:3b" ];
        environmentVariables = {
          HIP_VISIBLE_DEVICES = "0,1";
          #OLLAMA_LLM_LIBRARY = "cpu";
          OLLAMA_KEEP_ALIVE = "60m";
          OLLAMA_DEBUG = "INFO"; # INFO | ??
          OLLAMA_HOST = "0.0.0.0";
         };
        # listenAddress = "127.0.0.1:11434";
        # home = "/home/foo";
        # models = "/path/to/ollama/models";
        # writablePaths = [ ];
        # sandbox = false;
      };
    })
    ( mkIf cfg.webui {
      services.open-webui = {
        enable = true;
        #stateDir = "/var/lib/open-webui-aux";
        #host = "127.0.0.1";
        port = 1337;
        environment = {
          ANONYMIZED_TELEMETRY = "True";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          # OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          ## Disable authentication
          WEBUI_AUTH = "True";
        };
        openFirewall = true;
      };
    })
    ( mkIf cfg.nvidia {
      /* https://developer.nvidia.com/cuda-gpus */
      /* 1070 not supported */
      nixpkgs.config.allowUnfree = true;
      services.ollama.package = pkgs.ollama-cuda;
      services.ollama.acceleration = "cuda";
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "cuda_cudart"
        "cuda_cccl"
        "cuda_nvcc"
        "libcublas"
      ];
    })
    ( mkIf cfg.amd {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.ollama = {
        package = pkgs.ollama-rocm;
        rocmOverrideGfx = "10.3.0";
      };
      hardware = {
        amdgpu.opencl.enable = true;
        graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
      };
    })
  ]);
}
