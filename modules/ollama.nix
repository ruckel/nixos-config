{ pkgs, config, lib, ... } :
with lib;
let cfg = config.ollama;
in
{
options.ollama.enable = mkEnableOption "";
options.ollama.enableWebui = mkEnableOption "";

config = lib.mkIf cfg.enable {
  networking.firewall = {
    allowedTCPPorts = [ 1337 ]; #TODO ports
    allowedUDPPorts = [ 1337 ];
  };
hardware.amdgpu.opencl.enable = true;
 #hardware.opengl.extraPackages = [ rocmPackages.clr.icd ];
  services.ollama = {
    enable = true;
    acceleration = false;
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
  services.open-webui = {
    enable = true;
#   stateDir = "/var/lib/open-webui";
#   host = "127.0.0.1";
    port = 1337;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      # OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      ## Disable authentication
      WEBUI_AUTH = "True";
    };
   openFirewall = true;
  };
};
}
