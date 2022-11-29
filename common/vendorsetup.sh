#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is executed by build/envsetup.sh, and can use anything
# defined in envsetup.sh.
#
# In particular, you can add lunch options with the add_lunch_combo
# function: add_lunch_combo generic-eng

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib

android_top_path=$(cd $(dirname ${BASH_SOURCE[0]})/../../.. && pwd)

build_system=$(d="lichee"; [ -d $android_top_path/../*/device/config/chips ] && d="longan"; echo $d)

if [ "x$build_system" == "xlichee" ]; then
    lichee_top_path=$(cd $android_top_path/../*/tools/pack/chips/../../.. && pwd)
else
    lichee_top_path=$(cd $android_top_path/../*/device/config/chips/../../.. && pwd)
fi

lichee_build_config=$lichee_top_path/.buildconfig

function get_device_dir()
{
    local target_device=""
    if [ -n "$ANDROID_PRODUCT_OUT" ]; then
        target_device=$(basename $ANDROID_PRODUCT_OUT)
    else
        target_device=$(get_build_var TARGET_DEVICE)
    fi
    echo "${android_top_path}/device/softwinner/$target_device"
}

function cdevice()
{
    local device_dir=$(get_device_dir)
    [ ! -d $device_dir ] && echo "Device path $device_dir not found" && return 1
    cd $device_dir
}

function cout()
{
    cd $OUT
}

function ca()
{
    cd $android_top_path
}

function com()
{
    cd $android_top_path/device/softwinner/common
}

function cl()
{
    cd $lichee_top_path
}

function ck()
{
    if [ ! -f $lichee_build_config ]; then
        echo "Please run ./build.sh config first!"
        return 1
    fi
    local kver=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_KERN_VER="{print $2}' $lichee_build_config)
    [ "x$build_system" == "xlongan" ] && \
    cd $lichee_top_path/kernel/$kver && return 0
    cd $lichee_top_path/$kver
}

function ct()
{
    cd $lichee_top_path/tools
}

function cb()
{
    [ "x$build_system" == "xlongan" ] && \
    cd $lichee_top_path/build && return 0
    cd $lichee_top_path/tools/build
}

function cbr()
{
    [ "x$build_system" != "xlongan" ] && \
    cd $lichee_top_path/brandy && return 0

    local vbr=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_BRANDY_VER="{print $2}' $lichee_build_config) && \
    if [ "x$vbr" == "x1.0" ]; then
        cd $lichee_top_path/brandy/brandy-1.0/brandy
    elif [ "x$vbr" == "x2.0" ]; then
        cd $lichee_top_path/brandy/brandy-2.0/
    fi
}

function cs()
{
    [ "x$build_system" != "xlongan" ] && \
    cd $lichee_top_path/bootloader/uboot_2014_sunxi_spl/sunxi_spl && return 0

    local vbr=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_BRANDY_VER="{print $2}' $lichee_build_config) && \
    if [ "x$vbr" == "x1.0" ]; then
        cd $lichee_top_path/brandy/brandy-1.0/bootloader/uboot_2014_sunxi_spl/sunxi_spl
    elif [ "x$vbr" == "x2.0" ]; then
        cd $lichee_top_path/brandy/brandy-2.0/spl
    fi
}

function cu()
{
    [ "x$build_system" != "xlongan" ] && \
    cd $lichee_top_path/brandy/u-boot-2014.07 && return 0

    local vbr=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_BRANDY_VER="{print $2}' $lichee_build_config) && \
    if [ "x$vbr" == "x1.0" ]; then
        cd $lichee_top_path/brandy/brandy-1.0/brandy/u-boot-2014.07
    elif [ "x$vbr" == "x2.0" ]; then
        cd $lichee_top_path/brandy/brandy-2.0/u-boot-2018
    fi
}

function cbd()
{
    if [ ! -f $lichee_build_config ]; then
        echo "Please run ./build.sh config first!"
        return 1
    fi
    local ic=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_IC="{print $2}' $lichee_build_config)
    local chip=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_CHIP="{print $2}' $lichee_build_config)
    local board=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_BOARD="{print $2}' $lichee_build_config)
    [ "x$build_system" == "xlongan" ] && \
    cd $lichee_top_path/device/config/chips/$ic/configs/$board && return 0
    cd $lichee_top_path/tools/pack/chips/$chip/configs/$board
}

function cbb()
{
    if [ ! -f $lichee_build_config ]; then
        echo "Please run ./build.sh config first!"
        return 1
    fi
    local ic=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_IC="{print $2}' $lichee_build_config)
    local chip=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_CHIP="{print $2}' $lichee_build_config)
    local bussiness=$(awk -F'=' '$0~"^[[:space:]]*export*[[:space:]]+LICHEE_BUSSINESS="{print $2}' $lichee_build_config)
    if [ "$bussiness" == "" ]; then
        [ "x$build_system" == "xlongan" ] && \
        cd $lichee_top_path/device/config/chips/$ic/bin/ && return 0
        cd $lichee_top_path/tools/pack/chips/$chip/bin/
    else
        cd $lichee_top_path/device/config/chips/$ic/$bussiness/bin/ && return 0
    fi
}

function get_lichee_out_dir()
{
    local board=$(get_build_var PRODUCT_BOARD)
    local chip=$(get_build_var TARGET_BOARD_CHIP)
    local ic=$(get_build_var TARGET_BOARD_IC)
    local linuxout_dir=$lichee_top_path/out/$chip/android/common
    [ "x$build_system" == "xlongan" ] && \
    linuxout_dir=$lichee_top_path/out/$ic/$board/android
    echo "$linuxout_dir"
}

function extract-bsp()
{
    local device_dir=$(get_device_dir)
    local linuxout_dir=$(get_lichee_out_dir)
    local linuxout_module_dir=$linuxout_dir/lib/modules/*/*
    [ -f $linuxout_dir/.buildconfig ] && lichee_build_config=$linuxout_dir/.buildconfig

    (
    [ ! -d $device_dir ] && echo "Device path $device_dir not found" && return 1
    cd $device_dir

    #extract kernel
    rm -rf kernel
    cp $linuxout_dir/bImage kernel
    echo "Copy $linuxout_dir/bImage to $device_dir/kernel"

    #extract dtboimg
    if [ -f $linuxout_dir/dtbo.img ]; then
        cp $linuxout_dir/dtbo.img $device_dir/dtbo.img
        echo "Copy $linuxout_dir/dtbo.img to $device_dir/dtbo.img"
    fi

    #extract linux modules
    rm -rf modules
    mkdir -p modules/modules
    cp -rf $linuxout_module_dir modules/modules
    echo "Copy $linuxout_module_dir to $device_dir/modules!"

    #extract dtb
    rm -fr sunxi.dtb
    if [ -f $linuxout_dir/sunxi.dtb ]; then
        cp $linuxout_dir/sunxi.dtb $device_dir/sunxi.dtb
        echo "Copy $linuxout_dir/sunxi.dtb to $device_dir/sunxi.dtb"
    fi
    )
}

function package_usage()
{
    local ic=$(get_build_var TARGET_BOARD_IC)
    local chip=$(get_build_var TARGET_BOARD_CHIP)
    local platform=android
    local board=$(get_build_var PRODUCT_BOARD)

    printf "Usage: pack [-cCHIP] [-pPLATFORM] [-bBOARD] [-d] [-s] [-v] [-h]
    -c CHIP (default: $chip)
    -p PLATFORM (default: $platform)
    -b BOARD (default: $board)
    -d pack firmware with debug info output to card0
    -s pack firmware with signature
    -v pack firmware with secureboot
    -h print this help message"
}

function package()
{
    local ic=$(get_build_var TARGET_BOARD_IC)
    local chip=$(get_build_var TARGET_BOARD_CHIP)
    local platform=android
    local platform_version=$(get_build_var PLATFORM_VERSION)
    local board=$(get_build_var PRODUCT_BOARD)
    local linux_dtbo=$(get_build_var SUNXI_DTBO_FILE)
    local debug=uart0
    local sigmode=none
    local securemode=none
    local packpath=$lichee_top_path/tools/pack

    [ "x$build_system" == "xlongan" ] && \
    packpath=$lichee_top_path/build

    while getopts "i:c:p:b:dsvh" arg
    do
        case $arg in
            i)
                ic=$OPTARG
                ;;
            c)
                chip=$OPTARG
                ;;
            p)
                platform=$OPTARG
                ;;
            b)
                board=$OPTARG
                ;;
            d)
                debug=card0
                ;;
            s)
                sigmode=sig
                ;;
            v)
                securemode=secure
                ;;
            h)
                package_usage
                return 0
                ;;
            ?)
                return 1
                ;;
        esac
    done

    (
    cd $packpath
	LINUX_DTBO_FILE=$linux_dtbo ./pack -i $ic -c $chip -p $platform -b $board -d $debug -s $sigmode -v $securemode --platform_version ${platform_version}
    )

    return $?
}

function cmd_usage()
{
    printf "Usage:
    cdevice : go to android/device/softwinner/{board}/
    cout    : go to android/out/target/product/{board}/
    ca      : go to android top dir
    com     : go to android/device/softwinner/common/
    cl      : go to longan or lichee top dir
    ck      : go to linux kernel dir
    ct      : go to longan/tools or lichee/tools
    cb      : go to longan/build/
    cbr     : go to brandy dir
    cs      : go to bootloader dir
    cu      : go to uboot dir
    cbd     : go to longan/device/config/chips/{board}/configs/{board}/
    cbb     : go to longan/device/config/chips/{board}/bin/
"
}

function cmd()
{
    cmd_usage
}

function pack()
{
    local device_dir=$(get_device_dir)
    export ANDROID_IMAGE_OUT=$OUT

    if [ -f $device_dir/package.sh ]; then
        sh $device_dir/package.sh $*
        [ $? -ne 0 ] && return 1
    else
        #verity_data_init

        OPTIND=1
        package $@
        [ $? -ne 0 ] && return 1
        echo -e "\033[31muse pack4dist for release\033[0m"
    fi
}

function fex_copy()
{
    if [ -e $1 ]; then
        cp -vf $1 $2
    else
        echo $1" not exist"
    fi
}

function update_uboot()
{
    echo "copy fex into $1"
    mkdir ./IMAGES
    local fex_out=$lichee_top_path/tools/pack/out
    [ "x$build_system" == "xlongan" ] && \
    fex_out=$lichee_top_path/out/pack_out

    fex_copy $fex_out/boot-resource.fex ./IMAGES/boot-resource.fex
    fex_copy $fex_out/env.fex ./IMAGES/env.fex
    fex_copy $fex_out/boot0_nand.fex ./IMAGES/boot0_nand.fex
    fex_copy $fex_out/boot0_sdcard.fex ./IMAGES/boot0_sdcard.fex
    fex_copy $fex_out/boot_package.fex ./IMAGES/u-boot.fex
    fex_copy $fex_out/toc1.fex ./IMAGES/toc1.fex
    fex_copy $fex_out/toc0.fex ./IMAGES/toc0.fex
    zip -r -m $1 ./IMAGES
}

function pack4dist()
{
    # Found out the number of cores we can use
    local cpu_cores=`cat /proc/cpuinfo | grep "processor" | wc -l`
    local JOBS=`expr ${cpu_cores} / 2`
    if [ ${cpu_cores} -le 8 ] ; then
        JOBS=${cpu_cores}
    fi

    make -j $JOBS target-files-package
    [ $? -ne 0 ] && return 1

    local keys_dir="./vendor/security"
    local target_product=$(get_build_var TARGET_PRODUCT)
    local target_files=$(ls -t $OUT/obj/PACKAGING/target_files_intermediates/${target_product}-target_files-*.zip | head -n 1)
    local signed_target_files=$OUT/$(basename $target_files | sed "s/-target_files-/-signed_target_files-/g")
    local target_images="$OUT/target_images.zip"
    local old_target_files="./old_target_files.zip"

    local final_target_files="$target_files"
    local k_arg=""
    if [ -d $keys_dir ]; then
        final_target_files=$signed_target_files
        ./build/tools/releasetools/sign_target_files_apks \
        -d $keys_dir -o $target_files $final_target_files
        k_arg="-k $keys_dir/releasekey"
    fi

    [ $? -ne 0 ] && return 1

    local full_ota=$OUT/$(basename $final_target_files | sed "s/-\(signed_\)*target_files-/-full_ota-/g")
    local inc_ota=$OUT/$(basename $final_target_files | sed "s/-\(signed_\)*target_files-/-inc_ota-/g")

    ./build/tools/releasetools/img_from_target_files \
    $final_target_files $target_images && \

    unzip -o $target_images -d $OUT && \

    rm -rf $target_images && \

    pack $@ && \

    update_uboot $final_target_files && \

    ./build/tools/releasetools/ota_from_target_files $k_arg $final_target_files $full_ota
    [ $? -ne 0 ] && return 1

    if [ -f $old_target_files ]; then
        ./build/tools/releasetools/ota_from_target_files $k_arg -i $old_target_files $final_target_files $inc_ota
        [ $? -ne 0 ] && return 1
    fi
    echo -e "target files package: \033[31m$final_target_files\033[0m"
    echo -e "full ota zip: \033[31m$full_ota\033[0m"
    if [ -f $inc_ota ]; then
        echo -e "inc ota zip: \033[31m$inc_ota\033[0m"
    fi
}

function read_var()
{
    read -p "please enter $1($2): " TMP
    eval $1="${TMP:=\"$2\"}"
}

function clone()
{
    if [ $# -ne 0 ]; then
        echo "don't enter any params"
        return
    fi
    local source_device=$(get_build_var TARGET_DEVICE)
    local source_product=$(get_build_var TARGET_PRODUCT)
    local source_path=$(gettop)/device/softwinner/$source_device
    # PRODUCT_DEVICE
    read_var PRODUCT_DEVICE "$source_device"
    if [ $source_device == $PRODUCT_DEVICE ]; then
        echo "don't have the same device name!"
        return
    fi
    TARGET_PATH=$(gettop)/device/softwinner/$PRODUCT_DEVICE
    if [ -e $TARGET_PATH ]; then
        read -p "$PRODUCT_DEVICE is already exists, delete it?(y/n)"
        case $REPLY in
            [Yy])
                echo "delete"
                rm -rf $TARGET_PATH
                ;;
            [Nn])
                echo "do nothing"
                return
                ;;
            *)
                echo "do nothing"
                return
                ;;
        esac
    fi
    # copy device
    cp -r $source_path $TARGET_PATH
    rm -rf $TARGET_PATH/.git*
    sed -i "s/$source_device/$PRODUCT_DEVICE/g" `grep -rl $source_device $TARGET_PATH`
    # PRODUCT_NAME
    read_var PRODUCT_NAME "$source_product"
    if [ $source_product == $PRODUCT_NAME ]; then
        echo "don't have the same product name!"
        return
    fi
    mv $TARGET_PATH/$source_product.mk $TARGET_PATH/$PRODUCT_NAME.mk
    sed -i "s/$source_product/$PRODUCT_NAME/g" `grep -rl $source_product $TARGET_PATH`
    # config
    read_var PRODUCT_BOARD "$(get_build_var PRODUCT_BOARD)"
    sed -i "s/\(PRODUCT_BOARD := \).*/\1$PRODUCT_BOARD/g" $TARGET_PATH/$PRODUCT_NAME.mk
    read_var PRODUCT_MODEL "$(get_build_var PRODUCT_MODEL)"
    sed -i "s/\(PRODUCT_MODEL := \).*/\1$PRODUCT_MODEL/g" $TARGET_PATH/$PRODUCT_NAME.mk
    density=`sed -n 's/.*ro\.sf\.lcd_density=\([0-9]\+\).*/\1/p' $TARGET_PATH/$PRODUCT_NAME.mk`
    read_var DENSITY "$density"
    sed -i "s/\(ro\.sf\.lcd_density=\).*/\1$DENSITY/g" $TARGET_PATH/$PRODUCT_NAME.mk
    # 160(mdpi) 213(tvdpi) 240(hdpi) 320(xhdpi) 400(400dpi) 480(xxhdpi) 560(560dpi) 640(xxxhdpi)
    if [ $DENSITY -lt 186 ]; then
        PRODUCT_AAPT_PREF_CONFIG=mdpi
    elif [ $DENSITY -lt 226 ]; then
        PRODUCT_AAPT_PREF_CONFIG=tvdpi
    elif [ $DENSITY -lt 280 ]; then
        PRODUCT_AAPT_PREF_CONFIG=hdpi
    elif [ $DENSITY -lt 360 ]; then
        PRODUCT_AAPT_PREF_CONFIG=xhdpi
    elif [ $DENSITY -lt 440 ]; then
        PRODUCT_AAPT_PREF_CONFIG=400dpi
    elif [ $DENSITY -lt 520 ]; then
        PRODUCT_AAPT_PREF_CONFIG=xxhdpi
    elif [ $DENSITY -lt 600 ]; then
        PRODUCT_AAPT_PREF_CONFIG=560dpi
    else
        PRODUCT_AAPT_PREF_CONFIG=xxxhdpi
    fi
    sed -i "s/\(PRODUCT_AAPT_PREF_CONFIG := \).*/\1$PRODUCT_AAPT_PREF_CONFIG/g" $TARGET_PATH/$PRODUCT_NAME.mk
}

