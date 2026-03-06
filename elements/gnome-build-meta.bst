kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: master
  ref: 49-branchpoint-511-g47b88824582f66ad40233d7dc27022f1d52547a9

config:
  overrides:
    # This along with the patches is required and has to match what gnome-build-meta is using
    freedesktop-sdk.bst: freedesktop-sdk.bst

    # fuck you gnomeos, i want nmtui!!!!!!
    core-deps/NetworkManager.bst: freedesktop-sdk.bst:components/networkmanager.bst

    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
