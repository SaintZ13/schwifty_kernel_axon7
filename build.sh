export KBUILD_BUILD_USER=SaintZ93
export KBUILD_BUILD_HOST=hidden
export ARCH=arm64
export CROSS_COMPILE=$HOME/aarch64-elf-gcc/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=$HOME/arm-eabi-gcc/bin/arm-eabi-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/out"
#NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" lineageos_axon7_defconfig

echo "building kernel..."
make O="$BUILD" -j8

echo "building modules..."
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.gz-dtb" "$OUT/Image.gz-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"

echo "Image.gz-dtb & modules can be found in $BUILD"

