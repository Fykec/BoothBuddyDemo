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

CURRENTDIR=`pwd`
ROOTPATH="$CURRENTDIR/iDolphin"

CONFIGURATION="Release"

SDK="iphoneos"

PROFILE_SIGN=""
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
    
    mv ${ROOTPATH}/${TARGET}/build/${CONFIGURATION}-iphoneos/${TARGET}.ipa ${SERVER_BUILDS_PATH}${PACKAGE_PREFIX}${BUILD_NO}.ipa

    echo $BUILD_NO > ${LAST_BUILD_NO_FILE_KEY}
    mv ${LAST_BUILD_NO_FILE_KEY} ${SERVER_BUILDS_PATH}${LAST_BUILD_NO_FILE_KEY}
    rm -f ${LAST_BUILD_NO_FILE_KEY}
    popd
}


pushd ${CURRENTDIR}

rm -rf ${ROOTPATH}

git clone -b ${MASTER_BRANCH} ${GITSERVER} ${ROOTPATH}

checkFailed "Clone ${MASTER_BRANCH} FAILED!"

echo "${MASTER_BRANCH} branch change log:" > ${CURRENTDIR}/changelog.log

pushd ${ROOTPATH}

git log --since="1 days ago" >> ${CURRENTDIR}/changelog.log

#################master iPhone xuanfeng###################

buildAndArchive "DolphiniPhone" "$PROFILE_SIGN" "$IPHONE_CHINESE_XUANFENG_PROFILE_NAME" "DolphinChineseiPhone" "iPhoneChineseLatest"

popd
popd

