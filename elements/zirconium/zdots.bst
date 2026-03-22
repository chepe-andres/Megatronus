kind: manual

sources:
- kind: git_repo
  url: github:zirconium-dev/zdots.git
  track: main
  ref: c45711810b18a8bc5e8d3bd684a79470809dd45f

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- cli/chezmoi.bst

variables:
  strip-binaries: ""

config:
  install-commands:
  - |
    install -dm0755 "%{install-root}%{prefix}/share/zirconium"
    cp -r $(pwd) "%{install-root}%{prefix}/share/zirconium/zdots"
  - |
    %{install-extra}

