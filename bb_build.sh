#!/bin/sh
#Author Yinjiaji
#Email yinjiaji110@gmail.com


checkFailed()
{
    INFO="$1"
    EXITVALUE=$?
    if [ $EXITVALUE != 0 ]; then
    echo "$INFO"
    exit 1
    fi;
}

$ENV{CODESIGN_ALLOCATE} = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate'

CURRENTDIR=`pwd`
ROOTPATH="$CURRENTDIR/BoothBuddyDemo"
WORKSPACE_NAME="BoothBuddyDemo.xcworkspace"
SCHEME_NAME="BoothBuddyDemo"
PROFILE_SIGN=""
PROFILE_PATH=""


CONFIGURATION="Release"

SDK="iphoneos"


MASTER_BRANCH="master"
GITSERVER=""
PREPROCESSOR_MACROS='$(value)'"$(printf 'BUILD_NUMBER=%q ' "${BUILD_NO}")"

buildAndArchive()
{
    TARGET="$1" #folder and target
    CODE_SIGN="$2"
    PROFILE_NAME="$3"

    # agvtool bump -all
    xcodebuild -workspace ${WORKSPACE_NAME} -scheme ${SCHEME_NAME} GCC_PREPROCESSOR_DEFINITIONS=${PREPROCESSOR_MACROS} -configuration $CONFIGURATION -arch "armv7"  -sdk $SDK CODE_SIGN_IDENTITY="$CODE_SIGN" build
    checkFailed "\n\nBUILD FAILED! Compilation/${TARGET} target failed."

    # NB! xcrun NEEDS absolute paths to -o and --embed params !
    /usr/bin/xcrun -sdk $SDK PackageApplication -v build/${CONFIGURATION}-iphoneos/${TARGET}.app -o "${ROOTPATH}/${TARGET}/build/${CONFIGURATION}-iphoneos/${TARGET}.ipa" --sign "$CODE_SIGN" --embed "${CURRENTDIR}/${PROFILE_NAME}"
    
    mv ${ROOTPATH}/${TARGET}/build/${CONFIGURATION}-iphoneos/${TARGET}.ipa ${ROOTPATH}/${PACKAGE_PREFIX}BoothBuddyDemo.ipa
}

buildAndArchive "BoothBuddyDemo" "${PROFILE_SIGN}" "${PROFILE_PATH}"

