kind: filter

build-depends:
- sysext/steam/lib32.bst

config:
  include:
    - arch
  include-orphans: False
  exclude:
    - debug
