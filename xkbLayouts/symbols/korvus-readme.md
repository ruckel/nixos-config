Checkout original layout with:
```sh
less $(echo "$(nix-build --no-out-link '<nixpkgs>' -A xorg.xkeyboardconfig)/etc/X11/xkb/")symbols/se 00-keyboard.conf
```

## §-key
*over TAB*
[ ` /, \, ', ' ` ]
key <TLDE> {[ slash, backslash, apostrophe, apostrophe ]};
org: `key <TLDE> {[section, onehalf, paragraph, threequarters]}`


## `-Key
*left of backspace*
[ ``` `, ~, ±, ¬ ``` ]
key <AE12> {[ grave, asciitilde, plusminus, notsign ]};
org: `key <AE12> {[dead_acute, dead_grave, plusminus, notsign]}`


## ^-Key
*upper left of return (¨^~)*
[ ` ~, ^, ¨, ^ ` ]
key <AD12> {[ asciitilde, dead_circumflex, dead_diaeresis, asciicircum ]};
org: `key <AD12> {[dead_diaeresis, dead_circumflex, dead_tilde, asciicircum]}`


## apostrophe-key
*lower left of return*
[ ` *, {, }, } ` ]
key <BKSL> {[ apostrophe, asterisk, braceleft, braceright ]};
org: `key <BKSL> {[apostrophe, asterisk, acute, multiply]}`


## Spacebar
[ ` [space], [space], [invisible char],‌ [invisible char 2] ` ]
key <SPCE> {[ space, space, U200B, U200C ]};
org: `key <SPCE> {[space, space, space, nobreakspace]}`