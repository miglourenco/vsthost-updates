# wineusb for Wine 10.0 with URB_FUNCTION_VENDOR_ENDPOINT

Wine (https://www.winehq.org) is free software under the GNU LGPL 2.1 or later. The VSTHost unit updates ship
wineusb.sys / wineusb.so built from the upstream Wine 10.0 source with `wine10-wineusb-vendor-endpoint.patch`
applied (a backport of the vendor-endpoint request from Wine 11). `build_wine10_wineusb.sh` is the build used.
