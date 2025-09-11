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

# Kernel type selection
choose_kernel_type() {
  ui_print " "
  ui_print "Kernel Type:"
  ui_print "  Volume + : GKI"
  ui_print "  Volume - : CLO"
  ui_print " "
  
  while true; do
    input=$(getevent -qlc 1 2>/dev/null | grep -E "KEY_VOLUME(UP|DOWN)")
    case "$input" in
      *KEY_VOLUMEUP*) return 1 ;;
      *KEY_VOLUMEDOWN*) return 2 ;;
    esac
    sleep 0.1
  done
}

# KSU selection
choose_ksu() {
  ui_print " "
  ui_print "KernelSU Support:"
  ui_print "  Volume + : With KSU"
  ui_print "  Volume - : Without KSU"
  ui_print " "
  
  while true; do
    input=$(getevent -qlc 1 2>/dev/null | grep -E "KEY_VOLUME(UP|DOWN)")
    case "$input" in
      *KEY_VOLUMEUP*) return 1 ;;
      *KEY_VOLUMEDOWN*) return 2 ;;
    esac
    sleep 0.1
  done
}

# Handle selection
choose_kernel_type
if [ $? -eq 1 ]; then
  kernel_type="gki"
  ui_print "Selected: GKI"
else
  kernel_type="clo"
  ui_print "Selected: CLO"
fi

choose_ksu
if [ $? -eq 1 ]; then
  ksu_type="ksu"
  ui_print "Selected: With KSU"
else
  ksu_type="noksu"
  ui_print "Selected: Without KSU"
fi

# Move selected kernel
selected_kernel="Image.${kernel_type}.${ksu_type}"
if [ -f "$AKHOME/$selected_kernel" ]; then
  ui_print "Flashing: $selected_kernel"
  mv "$AKHOME/$selected_kernel" "$AKHOME/Image"
else
  abort "Kernel file not found: $selected_kernel"
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
