#!/bin/sh

set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

function change_ads_version
{
	# SDK 版本号，直接从shared.config获取
	SF_ADSDK_VERSION=""
	SF_ADSDK_VERSION_MAIN=""


	local verson=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
	echo "verson=${verson}"
	SF_ADSDK_VERSION_MAIN="$(pwd)/${verson}"

	date=$(date '+%y%m%d%H%M')
	echo "date=${date}"

	SF_ADSDK_VERSION="$date"
	echo "buildNumber=${SF_ADSDK_VERSION}"

	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $SF_ADSDK_VERSION" "$INFOPLIST_FILE"
}


function build_ads_framework
{
	PROJECT_PATH="$(dirname $0)/../GPSequence.xcworkspace"
	SCHEME="GrapeSequence"
	CONFIGURATION="Release"
	XCCONFIG=" "
	CONFIG_FILE="$(dirname $0)/buildIgnoreWarning.xcconfig"

	CONFIGURATION_BUILD_DIR_SIM_BIN="$(pwd)/build/iphonesimulator/${SCHEME}.framework/${SCHEME}"
	CONFIGURATION_BUILD_DIR_OS="$(pwd)/build/iphoneos/${SCHEME}.framework/${SCHEME}"

	echo  "CONFIGURATION_BUILD_DIR_SIM_BIN=${CONFIGURATION_BUILD_DIR_SIM_BIN}"
	echo  "CONFIGURATION_BUILD_DIR_OS=${CONFIGURATION_BUILD_DIR_OS}"

	args="-workspace"

	# build
	xcodebuild $args "$PROJECT_PATH" -configuration $CONFIGURATION -hideShellScriptEnvironment 	\
	ARCHS="i386 x86_64" CONFIGURATION_BUILD_DIR="$(pwd)/build/iphonesimulator" 					\
	-xcconfig "$CONFIG_FILE" $XCCONFIG -scheme "$SCHEME" -sdk iphonesimulator build 

	if [ "$?" != "0" ]; then
		echo "iphonesimulator ERROR"

	    exit 1
	fi

	# archive
	xcodebuild $args "$PROJECT_PATH" -configuration $CONFIGURATION -hideShellScriptEnvironment \
	ARCHS="armv7 armv7s arm64" STRIP_INSTALLED_PRODUCT=NO SKIP_INSTALL=NO DSTROOT= INSTALL_PATH="$(pwd)/build/iphoneos" \
	-xcconfig "$CONFIG_FILE" $XCCONFIG DWARF_DSYM_FOLDER_PATH="$(pwd)/build/iphoneos" -scheme "$SCHEME" -sdk iphoneos archive 

	if [ "$?" != "0" ]; then
	    exit 1
	fi

	lipo -create ${CONFIGURATION_BUILD_DIR_SIM_BIN} ${CONFIGURATION_BUILD_DIR_OS} -output ${CONFIGURATION_BUILD_DIR_OS}
}

function copy_foleder
{
    src=$1
    des=$2
    
    echo "src=${src}"
    echo "des=${des}"
    
    if [ ! -d "$des" ]; then
    mkdir ${des}
    fi
    
    rm -rf ${des}
    cp -a ${src} ${des}
}


if [ "${CONFIGURATION}" == "Release" ]; then
	
	# 修改版本号
	change_ads_version

	# 打包framework
	build_ads_framework
	
fi
