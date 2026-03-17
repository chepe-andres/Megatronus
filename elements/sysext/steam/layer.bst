kind: manual

build-depends:
  - freedesktop-sdk.bst:components/fakecap.bst
  - freedesktop-sdk.bst:components/squashfs-tools.bst
  - freedesktop-sdk.bst:components/python3.bst
  - freedesktop-sdk.bst:components/erofs-utils.bst
  - freedesktop-sdk.bst:vm/prepare-image.bst
  - oci/zirconium/init-scripts.bst
  - sysext/steam/init-scripts.bst
  - filename: oci/zirconium/filesystem.bst
    config:
      location: /sysroot
  - filename: sysext/steam/filesystem.bst
    config:
      location: /sysroot-steam

sources:
- kind: local
  path: files/sysext/make-layer.py
# We'll add these when we do signing for the sysext
# - kind: local
#   path: files/boot-keys/SYSEXT.key
# - kind: local
#   path: files/boot-keys/SYSEXT.crt

variables:
  sysroot-seed: df2427db-01ec-4c99-96b1-be3edb3cd9f6
  repart-seed: 53752261-a988-42fb-a585-b35ae0ab2af4
  strip-binaries: ''

environment:
  EROFS_OPTIONS: -z zstd --all-time -T %{filesystem-time} -E fragments,fragdedupe=inode
  EROFS_WORKERS: --workers=%{max-jobs}
  LD_PRELOAD: /usr/libexec/fakecap/fakecap.so
  FAKECAP_DB: '%{build-root}/fakecap'

environment-nocache:
- EROFS_WORKERS

config:
  build-commands:
    - mkdir fakecap
    - cp -a /sysroot sysroot
    - cp -a /sysroot-steam sysroot-steam
    - |
      prepare-image.sh \
        --sysroot sysroot \
        --initscripts /initial_scripts \
        --seed "%{sysroot-seed}" \
        --noroot --noboot --nodepmod >/dev/null
    - |
      prepare-image.sh \
        --sysroot sysroot-steam \
        --initscripts /initial_scripts-steam \
        --seed "%{sysroot-seed}" \
        --noroot --noboot --nodepmod >/dev/null

    - |
      mkdir -p sysroot-steam/usr/lib/extension-release.d

      cat <<EOF >sysroot-steam/usr/lib/extension-release.d/extension-release.steam
      ID="zirconium-hawaii"
      VERSION_ID="%{freedesktop-sdk-flatpak-branch}"
      EOF

    - |
      mkdir -p output
      python ./make-layer.py sysroot/usr sysroot-steam/usr output/usr

    - |
      mkdir -p tmp

    - |
      TMPDIR='%{build-root}/tmp' \
      mkfs.erofs ${EROFS_OPTIONS} ${EROFS_WORKERS} steam-%{systemd-arch}.raw output

  install-commands:
    - |
      mv steam-%{systemd-arch}.raw %{install-root}
