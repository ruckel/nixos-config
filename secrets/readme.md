# Encrypted secrets

Files in this folder are encrypted with [sops](https://getsops.io/) using [age](https://github.com/FiloSottile/age) keys.

## Configuration / Quick start
### Get sops and age:
`$ nix-shell -p sops age`

### Sops age key files:
The contents of the key file should be a list of **age X25519 identities, one per line**. 
Lines beginning with `#` are considered comments and ignored. 
Each identity will be tried in sequence until one is able to decrypt the data.

Multiple identities can be set as dependencies per encrypted file.

#### Directories:
Sops looks for `keys.txt` in the following dirs, falling order:
`$XDG_CONFIG_HOME/sops/age/`
`$HOME/.config/sops/age/`

#### Environment variables
Directory lookup can be overridden by environment variables:
```bash
SOPS_AGE_KEY
SOPS_AGE_KEY_FILE
SOPS_AGE_KEY_CMD
```

#### SSH age keys
Encrypting with SSH keys via age is also supported by SOPS.  You can use SSH public keys ("ssh-ed25519 AAAA...", "ssh-rsa AAAA...") as age recipients when encrypting a file. 

Note that only **ssh-rsa** and **ssh-ed25519** are supported.
##### SSH directories
When decrypting a file, SOPS will look for: `~/.ssh/id_ed25519 || ~/.ssh/id_rsa`.
#####  Environment variable
You can specify the location of the private key manually by setting the environment variable 
`SOPS_AGE_SSH_PRIVATE_KEY_FILE`

## Using age-keygen
Generate identity file:
`age-keygen -o dir/age.key.txt`
Get public key (*recipient*) from identity file:
`age-keygen -y dir/age.key.txt`
## Using sops
### .sops.yaml
The repos config file. Name sensitive.
Use this to specify access (*creation*) rules.
Apply updates with `sops updatekeys <files to update>`

#### Syntax example:
```yaml
keys:
  - &admin recipientKey
  - &system recipientKey1
  - &common recipientKey2
creation_rules:

  # json files needs two have "common" AND [ admin || system ]
  - path_regex: .*json$
    key_groups:
      - age: 
        - *common
      - age: 
        - *admin
        - *system
          
  # catch all (no path_regex). needs one of either id:s
  - key_groups:
      - age: 
        - *admin
        - *system
        - *common
```

#### Editing in sops
`sops <file>`
Decrypt to stdout with `-d`.

If using multiple key groups, set how many groups are needed for decryption with  
`sops --shamir-secret-sharing-threshold [min: 2] <file to edit>`
