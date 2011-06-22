#!/bin/sh

SCRIPT_COMMAND=$(/usr/bin/perl -e 'use Cwd qw(abs_path); my $p = abs_path($ARGV[0]); print "$p\n";' "$0")
SCRIPT_PATH=$(/usr/bin/dirname "${SCRIPT_COMMAND}")

XCODE_SELECT=${XCODE_SELECT:-"xcode-select"}
XCODE_SELECT_COMMAND=$(/usr/bin/which ${XCODE_SELECT})

if [ ! -x "${XCODE_SELECT_COMMAND}" ]; then echo "$0:$LINENO: error: The XCODE_SELECT command, '${XCODE_SELECT}', does not exist.  Aborting."; exit 1; fi;

DEVELOPER_DIR_SET=${DEVELOPER_DIR:+"Yes"}
if [ "${DEVELOPER_DIR_SET}" == "Yes" ]; then DEVELOPER_DIR_SET_BY="determined by the environment variable DEVELOPER_DIR"; else DEVELOPER_DIR_SET_BY="determined automatically by the command '${XCODE_SELECT}'"; fi;
DEVELOPER_DIR=$(/usr/bin/perl -e 'use Cwd qw(abs_path); my $p = abs_path($ARGV[0]); print "$p\n";' "${DEVELOPER_DIR:-`${XCODE_SELECT_COMMAND} -print-path`}")

IPHONEOS_BUILD_PLUGIN="iPhoneOS Build System Support.xcplugin"
XCODE3_PLUGIN_PATH="${DEVELOPER_DIR}/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins"
XCODE4_PLUGIN_PATH="${DEVELOPER_DIR}/Platforms/iPhoneOS.platform/Developer/Library/Xcode/PrivatePlugIns"
if [ -d "${XCODE4_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN}" ]; then XCODE_VERSION="4"; XCODE_PLUGIN_PATH=${XCODE4_PLUGIN_PATH}; else XCODE_VERSION="3"; XCODE_PLUGIN_PATH=${XCODE3_PLUGIN_PATH}; fi;

IPHONEOS_BUILD_PLUGIN_PATH="${XCODE_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN}"

PLUGIN_SOURCE_PATH="${SCRIPT_PATH}/plugin-src"

if [ ! -d "${PLUGIN_SOURCE_PATH}" ]; then echo "$0:$LINENO: error: The projects plugin-src directory, '${PLUGIN_SOURCE_PATH}', does not exist.  Aborting."; exit 1; fi;

PLUGIN_COPYPNG="copypng"
PLUGIN_COPYPNGFILE_XCSPEC="CopyPNGFile.xcspec"
PLUGIN_NATIVE_BUILD_SYSTEM_XCSPEC="Native Build System.xcspec"
PLUGIN_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS="English.lproj/Native Build System.strings"
PLUGIN_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_XCODE4_STRINGS="English.lproj/Native Build System_Xcode4.strings"

PLUGIN_SOURCE_COPYPNG="${PLUGIN_SOURCE_PATH}/${PLUGIN_COPYPNG}"
PLUGIN_SOURCE_COPYPNGFILE_XCSPEC="${PLUGIN_SOURCE_PATH}/${PLUGIN_COPYPNGFILE_XCSPEC}"
PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC="${PLUGIN_SOURCE_PATH}/${PLUGIN_NATIVE_BUILD_SYSTEM_XCSPEC}"
if [ "${XCODE_VERSION}" == "3" ]; then PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS="${PLUGIN_SOURCE_PATH}/${PLUGIN_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}"; else PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS="${PLUGIN_SOURCE_PATH}/${PLUGIN_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_XCODE4_STRINGS}"; fi;

if [ ! -r "${PLUGIN_SOURCE_COPYPNG}" ];                                   then echo "$0:$LINENO: error: The plugin-src file, '${PLUGIN_SOURCE_COPYPNG}', does not exist.  Aborting.";                                   exit 1; fi;
if [ ! -r "${PLUGIN_SOURCE_COPYPNGFILE_XCSPEC}" ];                        then echo "$0:$LINENO: error: The plugin-src file, '${PLUGIN_SOURCE_COPYPNGFILE_XCSPEC}', does not exist.  Aborting.";                        exit 1; fi;
if [ ! -r "${PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC}" ];                then echo "$0:$LINENO: error: The plugin-src file, '${PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC}', does not exist.  Aborting.";                exit 1; fi;
if [ ! -r "${PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" ]; then echo "$0:$LINENO: error: The plugin-src file, '${PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}', does not exist.  Aborting."; exit 1; fi;

IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH="${XCODE_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN}/Contents/Resources"

PLUGIN_XCODE_COPYPNG="${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}/${PLUGIN_COPYPNG}"
PLUGIN_XCODE_COPYPNGFILE_XCSPEC="${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}/${PLUGIN_COPYPNGFILE_XCSPEC}"
PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC="${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}/${PLUGIN_NATIVE_BUILD_SYSTEM_XCSPEC}"
PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS="${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}/${PLUGIN_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}"

/usr/bin/diff -q "${PLUGIN_SOURCE_COPYPNG}"                                   "${PLUGIN_XCODE_COPYPNG}"                                   >/dev/null 2>&1; DIFF_COPYPNG=$?;
/usr/bin/diff -q "${PLUGIN_SOURCE_COPYPNGFILE_XCSPEC}"                        "${PLUGIN_XCODE_COPYPNGFILE_XCSPEC}"                        >/dev/null 2>&1; DIFF_COPYPNGFILE_XCSPEC=$?;
/usr/bin/diff -q "${PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC}"                "${PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC}"                >/dev/null 2>&1; DIFF_NATIVE_BUILD_SYSTEM_XCSPEC=$?;
/usr/bin/diff -q "${PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" "${PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" >/dev/null 2>&1; DIFF_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS=$?;

if [ ${DIFF_COPYPNG} == 0 ] && [ ${DIFF_COPYPNGFILE_XCSPEC} == 0 ] && [ ${DIFF_NATIVE_BUILD_SYSTEM_XCSPEC} == 0 ] && [ ${DIFF_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS} == 0 ]; then echo "The enhanced 'Compress PNG Files' Xcode iPhoneOS Build System Support Plug-In in '${DEVELOPER_DIR}' is up to date."; exit 0; fi;

if [ "$1" == "-check" ]; then echo "The enhanced 'Compress PNG Files' Xcode iPhoneOS Build System Support Plug-In in '${DEVELOPER_DIR}' requires updating."; exit 1; fi;

if [ "${UID}" != 0 ]; then
  if [ "${DEVELOPER_DIR_SET}" == "Yes" ]; then SUDO_DEVTOOLS="DEVELOPER_DIR=\"\$DEVELOPER_DIR\" "; else SUDO_DEVTOOLS=""; fi;
  echo "Warning: In general, this script must be executed as the super user in order to modify the Xcode Plug-In files.\nWarning: Consider running this script as 'sudo ${SUDO_DEVTOOLS}\"$0\"' instead.\n";
fi;

echo "Note: Installing in to the Xcode Developer Tools at '${DEVELOPER_DIR}', which was ${DEVELOPER_DIR_SET_BY}.\n"
if [ "${DEVELOPER_DIR_SET}" != "Yes" ]; then
  echo "Note: You can override this location by setting the environment variable DEVELOPER_DIR if you have multiple versions of the Xcode Developer Tools installed.\n";
  read -p "Do you want to install in to this directory? (y/n)? "
  if [ $REPLY != "y" ] && [ $REPLY != "Y" ] && [ $REPLY != "yes" ] && [ $REPLY != "YES" ]; then echo "Install canceled."; exit 1; fi;
  echo
fi;

if [ ! -d "${DEVELOPER_DIR}" ];              then echo "$0:$LINENO: error: The DEVELOPER_DIR directory, '${DEVELOPER_DIR}', does not exist.  Aborting.";                                      exit 1; fi;
if [ ! -d "${XCODE_PLUGIN_PATH}" ];          then echo "$0:$LINENO: error: The Xcode Plug-In directory, '${XCODE_PLUGIN_PATH}', does not exist.  Aborting.";                                  exit 1; fi;
if [ ! -d "${IPHONEOS_BUILD_PLUGIN_PATH}" ]; then echo "$0:$LINENO: error: The iPhoneOS Build System Support Plug-In directory, '${IPHONEOS_BUILD_PLUGIN_PATH}', does not exist.  Aborting."; exit 1; fi;

IPHONEOS_BUILD_PLUGIN_TAR_BACKUP="iPhoneOS_xcplugin_backup_$(/bin/date "+%Y%m%d%H%M%S")_$$.tar.gz"

if [ -f "${XCODE_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN_TAR_BACKUP}" ]; then echo "$0:$LINENO: error: The file '${XCODE_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN_TAR_BACKUP}' already exists, unable to create a back-up of '${IPHONEOS_BUILD_PLUGIN}'.  Aborting."; exit 1; fi;

cd "${XCODE_PLUGIN_PATH}"
/usr/bin/tar -czf "${IPHONEOS_BUILD_PLUGIN_TAR_BACKUP}" "${IPHONEOS_BUILD_PLUGIN}"
if [ $? != 0 ]; then echo "$0:$LINENO: error: Unable create a backup of '${IPHONEOS_BUILD_PLUGIN_PATH}'.  Aborting."; exit 1; fi;

echo "Note: A backup of     '${IPHONEOS_BUILD_PLUGIN_PATH}'"
echo "Note: was created at: '${XCODE_PLUGIN_PATH}/${IPHONEOS_BUILD_PLUGIN_TAR_BACKUP}'"


if [ ! -d "${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}" ];             then echo "$0:$LINENO: error: The Xcode iPhoneOS Build System Support Plug-In Resources directory, '${IPHONEOS_BUILD_PLUGIN_RESOURCES_PATH}', does not exist.  Aborting.";                   exit 1; fi;


if [ ! -r "${PLUGIN_XCODE_COPYPNG}" ];                                   then echo "$0:$LINENO: error: The Xcode iPhoneOS Build System Support Plug-In file, '${PLUGIN_XCODE_COPYPNG}', does not exist.  Aborting.";                                   exit 1; fi;
if [ ! -r "${PLUGIN_XCODE_COPYPNGFILE_XCSPEC}" ];                        then echo "$0:$LINENO: error: The Xcode iPhoneOS Build System Support Plug-In file, '${PLUGIN_XCODE_COPYPNGFILE_XCSPEC}', does not exist.  Aborting.";                        exit 1; fi;
if [ ! -r "${PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC}" ];                then echo "$0:$LINENO: error: The Xcode iPhoneOS Build System Support Plug-In file, '${PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC}', does not exist.  Aborting.";                exit 1; fi;
if [ ! -r "${PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" ]; then echo "$0:$LINENO: error: The Xcode iPhoneOS Build System Support Plug-In file, '${PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}', does not exist.  Aborting."; exit 1; fi;

cp -p "${PLUGIN_SOURCE_COPYPNG}"                                   "${PLUGIN_XCODE_COPYPNG}"                                   >/dev/null 2>&1
if [ $? != 0 ]; then echo "$0:$LINENO: error: Unable to copy '${PLUGIN_SOURCE_COPYPNG}' to '${PLUGIN_XCODE_COPYPNG}'.  Aborting.";                                                                    exit 1; fi;
cp -p "${PLUGIN_SOURCE_COPYPNGFILE_XCSPEC}"                        "${PLUGIN_XCODE_COPYPNGFILE_XCSPEC}"                        >/dev/null 2>&1
if [ $? != 0 ]; then echo "$0:$LINENO: error: Unable to copy '${PLUGIN_SOURCE_COPYPNGFILE_XCSPEC}' to '${PLUGIN_XCODE_COPYPNGFILE_XCSPEC}'.  Aborting.";                                              exit 1; fi;
cp -p "${PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC}"                "${PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC}"                >/dev/null 2>&1
if [ $? != 0 ]; then echo "$0:$LINENO: error: Unable to copy '${PLUGIN_SOURCE_NATIVE_BUILD_SYSTEM_XCSPEC}' to '${PLUGIN_XCODE_NATIVE_BUILD_SYSTEM_XCSPEC}'.  Aborting.";                              exit 1; fi;
cp -p "${PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" "${PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}" >/dev/null 2>&1
if [ $? != 0 ]; then echo "$0:$LINENO: error: Unable to copy '${PLUGIN_SOURCE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}' to '${PLUGIN_XCODE_ENGLISH_LPROJ_NATIVE_BUILD_SYSTEM_STRINGS}'.  Aborting"; exit 1; fi;

echo "\nNote: Installation was successful!"

XCODE_RUNNING=$(/usr/bin/osascript -e 'if application "Xcode" is running then return "Yes"')
if [ "${XCODE_RUNNING}" == "Yes" ]; then echo "\nWarning: You must exit and restart Xcode before the new 'Compress PNG Files' Build Setting options are available."; fi;
