# my personal linux setup
i'm a sucker for declarative coding and [aasc](https://github.com/finos/architecture-as-code). so I got sucked into nix and nixOS.  
halfway through I realized that I don't really care for Nix as a language - so there might be some hacks and such things through out.  
but [i wanted to finish through](https://en.wikipedia.org/wiki/Sunk_cost) and here we are.

not much comments or anything, i like keeping my own things concise. makes it easier parsing through for me.

# features (reminder to myself)

- Packaged shell scripts, both wrapped with dependencies and free standing
- Gustom modules, with default presets
- Nextcloud instance
- Wireguard network (NetBird)
- [SOPS](https://getsops.io/)  secret management
- import existing bash scripts and aliases into nixos

# sops

![readme](secrets/readme.md)