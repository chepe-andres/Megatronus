kind: manual

sources:
- kind: local
  path: files/polkit-configs

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - install -Dm644 -t "%{install-root}%{prefix}/share/polkit-1/rules.d" org.freedesktop.NetworkManager.rules
  - "%{install-extra}"
