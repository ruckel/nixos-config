{ pkgs, config, lib, ... } : with lib; let cfg = config.ollama;
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
        acceleration = mkDefault false;
        loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
        #/* environmentVariables = {
        #     HIP_VISIBLE_DEVICES = "0,1";
        #     OLLAMA_LLM_LIBRARY = "cpu";
        #   } */
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
        #   stateDir = "/var/lib/open-webui";
        #   host = "127.0.0.1";
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
      services.ollama.acceleration = "cuda";
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
        "cuda_cudart"
        "cuda_cccl"
        "cuda_nvcc"
        "libcublas"
      ];
    })
    ( mkIf cfg.amd {
      boot.initrd.kernelModules = [ "amdgpu" ];
      hardware = {
        services.ollama.acceleration = "rocm";
        amdgpu.opencl.enable = true;
        opengl.extraPackages = [ rocmPackages.clr.icd ];
      };
    })
  ]);
}
