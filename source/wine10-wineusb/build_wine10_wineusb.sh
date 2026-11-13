#!/bin/sh
# build_wine10_wineusb.sh - in WSL Debian 13 (as root): wineusb.sys + wineusb.so of Wine 10.0 with the vendor-endpoint
# backport (wine10-wineusb-vendor-endpoint.patch), for the units' stock Debian Wine (10.0~repack-6; the engine runs
# /usr/bin/wine). Built from the upstream 10.0 tarball: Debian's repack drops generated files (configure,
# server_protocol.h, vulkan.h, ...) and has the same wineusb sources (checked below against the Debian source when
# /root/wsrc/wine10/src exists: apt-get source wine=10.0~repack-6).
#   tarball: https://dl.winehq.org/wine/source/10.0/wine-10.0.tar.xz -> /root/wsrc/wine10/
#   output:  /root/wsrc/wine10/out/{wineusb.sys,wineusb.so}
set -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
P=/mnt/c/www/myfoh/sg-spike/linux/wine10-wineusb-vendor-endpoint.patch
W=/root/wsrc/wine10
cd $W
[ -f wine-10.0.tar.xz ] || { echo "put wine-10.0.tar.xz in $W first"; exit 1; }
if [ ! -d up ]; then mkdir up && tar xf wine-10.0.tar.xz -C up --strip-components=1; fi
if [ -d src ]; then
    for f in wineusb.c unixlib.c unixlib.h Makefile.in; do
        if grep -q VENDOR_ENDPOINT src/dlls/wineusb.sys/$f 2>/dev/null; then continue; fi   # (src may carry the patch)
        cmp -s up/dlls/wineusb.sys/$f src/dlls/wineusb.sys/$f && echo "same as Debian: $f" || echo "DIFFERS from Debian: $f"
    done
fi
cd up
if ! grep -q "URB_FUNCTION_VENDOR_ENDPOINT" dlls/wineusb.sys/wineusb.c; then
    sed 's/\r$//' "$P" > /tmp/wineusb-ve.patch      # (no patch(1) in this WSL; git apply works outside a repo)
    git apply -p1 /tmp/wineusb-ve.patch
fi
echo "patched: $(grep -c VENDOR_ENDPOINT dlls/wineusb.sys/wineusb.c) + $(grep -c VENDOR_ENDPOINT dlls/wineusb.sys/unixlib.c) lines"
mkdir -p ../build-up && cd ../build-up
if [ ! -f Makefile ]; then
    ../up/configure --enable-win64 --disable-tests --with-usb --with-mingw \
        --without-x --without-freetype --without-gstreamer --without-cups --without-sane --without-krb5 \
        --without-netapi --without-opencl --without-pcap --without-pcsclite --without-v4l2 --without-wayland \
        --without-vulkan --without-sdl --without-capi --without-gphoto --without-gssapi --without-ffmpeg \
        > ../configure-up.log 2>&1 || { tail -20 ../configure-up.log; exit 1; }
fi
grep -i "usb" ../configure-up.log | grep -i -E "warning|libusb" || true
make -j"$(nproc)" dlls/wineusb.sys/all > ../make-up.log 2>&1 || { tail -30 ../make-up.log; exit 1; }
mkdir -p ../out
cp -f dlls/wineusb.sys/x86_64-windows/wineusb.sys dlls/wineusb.sys/wineusb.so ../out/
ls -la ../out
md5sum ../out/*
