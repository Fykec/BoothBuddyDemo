#!/bin/sh
#Author Yinjiaji
#Email yinjiaji110@gmail.com

PROFILE_SIGN="iPhone Distribution: DAN ZHOU(6RH4H94576)"
PROFILE_PATH="AllPartner_Adhoc.mobileprovision"

checkFailed()
{
    INFO="$1"
    EXITVALUE=$?
    if [ $EXITVALUE != 0 ]; then
    echo "$INFO"
    exit 1
    fi;
}

CURRENTDIR=`pwd`
ROOTPATH="$CURRENTDIR/BoothBuddyDemo"

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
    PACKAGE_PREFIX="$4"
    LAST_BUILD_NO_FILE_KEY="$5"

    pushd ${ROOTPATH}/${TARGET}

    # agvtool bump -all
    xcodebuild GCC_PREPROCESSOR_DEFINITIONS=${PREPROCESSOR_MACROS} -configuration $CONFIGURATION -arch "armv7" -target ${TARGET} -sdk $SDK CODE_SIGN_IDENTITY="$CODE_SIGN"
    checkFailed "\n\nBUILD FAILED! Compilation/${TARGET} target failed."

    # NB! xcrun NEEDS absolute paths to -o and --embed params !
    /usr/bin/xcrun -sdk $SDK PackageApplication -v build/${CONFIGURATION}-iphoneos/${TARGET}.app -o "${ROOTPATH}/${TARGET}/build/${CONFIGURATION}-iphoneos/${TARGET}.ipa" --sign "$CODE_SIGN" --embed "${CURRENTDIR}/${PROFILE_NAME}"
    checkFailed "\n\nBUILD FAILED! IPA target failed."
    
    mv ${ROOTPATH}/${TARGET}/build/${CONFIGURATION}-iphoneos/${TARGET}.ipa ${ROOTPATH}/${PACKAGE_PREFIX}BoothBuddyDemo.ipa

    popd
}


buildAndArchive "BoothBuddyDemo" "${PROFILE_SIGN}" "${PROFILE_PATH}"

popd
popd

