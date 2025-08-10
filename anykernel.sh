### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=by belowzeroiq @ github
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=topaz
device.name2=tapas
device.name3=sapphiren
device.name4=sapphire
device.name5=xun
supported.versions=13-16
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# import functions/variables and setup patching
. tools/ak3-core.sh

# Kernel selection function
choose_kernel() {
  ui_print " "
  ui_print "Kernel Version Selection:"
  ui_print " "
  ui_print "  -EN"
  ui_print "  Volume Up: YASK-GKI"
  ui_print "  Volume Down: YASK-CLO"
  ui_print " "
  ui_print "  -ID"
  ui_print "  Volume Atas: YASK-GKI"
  ui_print "  Volume Bawah: YASK-CLO"
  ui_print " "
  ui_print "Input: "
  ui_print " "

  while true; do
    input=$(getevent -qlc 1 2>/dev/null | grep -E "KEY_VOLUME(UP|DOWN)")
    case "$input" in
      *KEY_VOLUMEUP*)
        return 1
        ;;
      *KEY_VOLUMEDOWN*)
        return 2
        ;;
    esac
    sleep 0.1
  done
}

# Handle kernel selection
if [ -f "$AKHOME/Image.gki" ] && [ -f "$AKHOME/Image.clo" ]; then
  choose_kernel
  case $? in
    1)
      ui_print " "
      ui_print "Selected: YASK-GKI"
      mv -f "$AKHOME/Image.gki" "$AKHOME/Image"
      ;;
    2)
      ui_print " "
      ui_print "Selected: YASK-CLO"
      mv -f "$AKHOME/Image.clo" "$AKHOME/Image"
      ;;
  esac
elif [ -f "$AKHOME/Image.gki" ]; then
  ui_print " "
  ui_print "Only YASK-GKI found, flashing it"
  mv -f "$AKHOME/Image.gki" "$AKHOME/Image"
elif [ -f "$AKHOME/Image.clo" ]; then
  ui_print " "
  ui_print "Only YASK-CLO found, flashing it"
  mv -f "$AKHOME/Image.clo" "$AKHOME/Image"
elif [ -f "$AKHOME/Image" ]; then
  ui_print " "
  ui_print "Single generic Image found, flashing it"
fi

# boot install
if [ -L "/dev/block/bootdevice/by-name/init_boot_a" -o -L "/dev/block/by-name/init_boot_a" ]; then
    split_boot
    flash_boot
else
    dump_boot
    write_boot
fi
## end boot install
