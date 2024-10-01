{
  user = "korv";
  host = "nixburk";
  keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPC8sV9tofPmdM1VmrsUK1AoymNkobPphDynC6nKd/E korv@nixos-dell"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@debian-homelab"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
    ];
  ports = [ 6842 6843 6844 ];
  stateVersion = "24.05";
}