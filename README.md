# Xcode iPhone PNG Optimizer Enhancement

This project is an enhacement for Xcodes [`Compress PNG Files`][COMPRESS_PNG_FILES] Build Setting and includes Scribd's fork of the [AdvanceCOMP utilities][Scribd-AdvanceCOMP] as a submodule.

**Important:** This project directly modifies configuration files that are private to Xcode!  Although considerable effort was made to find a way to implement the functionality provided by this project using a different means (i.e., a `.xcplugin` in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/`), no other viable way of providing this functionality was found.

## Overview

This project modifies the files in `/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin` to change the Xcode [`Compress PNG Files`][COMPRESS_PNG_FILES] setting from a `Boolean` `YES` / `NO` option to a Build Setting with the following options:

  Setting  | Description
:----------|:-----------
 `None`    | Identical to the unmodified `COMPRESS_PNG_FILES` `NO` setting.
 `Low`     | Identical to the unmodified `COMPRESS_PNG_FILES` `YES` setting.  This uses the Apple proprietery version of `pngcrush` to optimize PNG files for the iPhone.
 `Medium`  | The compressed PNG files from the `Low` setting are further optimized by the `advpngidat` command.
 `Medium`  | The same as `Low`, except the `advpngidat` command is run on the PNG files compressed by the `Low` setting.
 `High`    | The same as `Medium`, except a handful of carefully chosen `-m` compression methods that work much better in practice are used instead of the default heuristic used by `pngcrush`.
 `Extreme` | The same as `Medium`, except `pngcrush` is passed the `-brute` option which tries all of the compression method permutations.<br />**Warning:** This can take a ***very*** long time!

### Xcode versions supported

The Xcode iPhone PNG Optimizer Enhancement has been tested with the following versions of Xcode:

Major   | Version
--------|:-------
Xcode 3 | 3.2.6
Xcode 4 | 4.0

## Installing

To install, run the included `install.sh` script:

<pre>
shell% <b>./install.sh &crarr;</b>
Warning: In general, this script must be executed as the super user in order to modify the Xcode Plug-In files.
Warning: Consider running this script as 'sudo "./install.sh"' instead.

Installing in to the Xcode Developer Tools at '/Developer', which was determined automatically by the command 'xcode-select'.

Note: You can override this location by setting the environment variable DEVTOOLS_PATH if you have multiple versions of the Xcode Developer Tools installed.

Do you want to install in to this directory? (y/n)? <b>y &crarr;</b>

A backup of     '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin'
was created at: '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS_xcplugin_backup_20110621184402_40989.tar.gz'
./install.sh:90: error: Unable to copy '/Users/you/gitRepos/Xcode-OptimizePNG/plugin-src/copypng' to '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin/Contents/Resources/copypng'.  Aborting.
shell% &#9612;
</pre>

This installation failed because the `install.sh` script requires super-user privliges in order to update certain Xcode files.  When re-run using `sudo`:

**Important:** `sudo` will execute the `install.sh` script with super-user (i.e., `root`) privileges.

<pre>
shell% <b>sudo "./install.sh" &crarr;</b>
Password: &nbsp;<i><b>Enter your password, it will not be displayed.</b></i>
Installing in to the Xcode Developer Tools at '/Developer', which was determined automatically by the command 'xcode-select'.

Note: You can override this location by setting the environment variable DEVTOOLS_PATH if you have multiple versions of the Xcode Developer Tools installed.

Do you want to install in to this directory? (y/n)? <b>y &crarr;</b>

A backup of     '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin'
was created at: '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS_xcplugin_backup_20110621185206_41066.tar.gz'

Installation was successful!

Warning: You must exit and restart Xcode before the new 'Compress PNG Files' Build Setting options are available.
shell% &#9612; <i>The warning above will only be displayed if Xcode.app is currently running.</i>
</pre>

If `Xcode.app` is not running at the time that `install.sh` is executed, the last warning in the previous example will not be displayed.

### Installing in a different version of the Xcode Development Tools 

If you have multiple versions of the Xcode Development Tools installed on your system, you can install the Xcode iPhone PNG Optimizer Enhacement in the different Xcode versions using the environment variable `DEVTOOLS_PATH`.

**Important:** When you set the `DEVTOOLS_PATH` environment variable, the `install.sh` script will not ask if the directory that `DEVTOOLS_PATH` is set to is really the directory you want to install in to.

<pre>
shell% <b>setenv DEVTOOLS_PATH "/Developer4" &crarr;</b>
shell% <b>./install.sh &crarr;</b>
Warning: In general, this script must be executed as the super user in order to modify the Xcode Plug-In files.
Warning: Consider running this script as 'sudo DEVTOOLS_PATH="$DEVTOOLS_PATH" "./install.sh"' instead.

Installing in to the Xcode Developer Tools at '/Developer4', which was determined by the environment variable DEVTOOLS_PATH.

A backup of     '/Developer4/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin'
was created at: '/Developer4/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS_xcplugin_backup_20110621193634_41339.tar.gz'
./install.sh:90: error: Unable to copy '/Users/johne/projects/scribd/xcode/Xcode-OptimizePNG/plugin-src/copypng' to '/Developer4/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin/Contents/Resources/copypng'.  Aborting.
shell% &#9612;
</pre>

Like the example without `DEVTOOLS_PATH`, this installation failed because the `install.sh` script requires super-user privliges in order to update certain Xcode files.  When re-run using `sudo DEVTOOLS_PATH="$DEVTOOLS_PATH"`:

**Important:** `sudo` will execute the `install.sh` script with super-user (i.e., `root`) privileges.

<pre>
shell% <b>setenv DEVTOOLS_PATH "/Developer4" &crarr;</b>
shell% <b>sudo DEVTOOLS_PATH="$DEVTOOLS_PATH" "./install.sh" &crarr;</b>
Password: &nbsp;<i><b>Enter your password, it will not be displayed.</b></i>
Installing in to the Xcode Developer Tools at '/Developer4', which was determined by the environment variable DEVTOOLS_PATH.

A backup of     '/Developer4/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin'
was created at: '/Developer4/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS_xcplugin_backup_20110621193734_41355.tar.gz'

Installation was successful!

Warning: You must exit and restart Xcode before the new 'Compress PNG Files' Build Setting options are available.
shell% &#9612; <i>The warning above will only be displayed if Xcode.app is currently running.</i>
</pre>

### Trying to install when already installed

The `install.sh` checks to see if the `iPhoneOS Build System Support.xcplugin` files it is about to update are identical to the ones in the `plugin-src` directory.  If they are, the install script displays the following:

<pre>
shell% ./install.sh
The enhanced 'Compress PNG Files' Xcode iPhoneOS Build System Support Plug-In in '/Developer' is up to date.
</pre>

**Note:** Super-user privileges are not required if the Xcode iPhone PNG Optimizer Enhancement is already installed.

### Errors and Other Problems

The `install.sh` script does its best to make sure that everything is in order before it begins its work, which includes checking if all the required files and directories exist.  Before any changes are made, a backup of the current `iPhoneOS Build System Support.xcplugin` directory is made using `tar`, and the name of the `.tar` backup includes the date and time when the backup was made.

### `advpngidat` not installed

By default, the Xcode iPhone PNG Optimizer Enhancement looks in the projects root directory for `bin/advpngidat`, and if it can't find the `advpngidat` command there, it looks for the command in `$PATH`.  If it was unable to find the command in any of these locations, and [`Compress PNG Files`][COMPRESS_PNG_FILES] is &ge; `Medium`, then you will see a warning when you build your project that the `advpngidat` command was not found.

To fix this, you will need to build the Scribd fork of the [AdvanceCOMP utilities][Scribd-AdvanceCOMP], and then install the compiled `advpngidat` command in either the `bin/` directory relative to the root of your projects directory, or in a directory that is included in the `$PATH` environment variable.

## Uninstalling

The `install.sh` script makes a back up of the `iPhoneOS Build System Support.xcplugin` directory using `tar` and stores it in <code><i>DEVTOOLS_PATH</i>/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/</code>.

The name of the `.tar` backup is <code>iPhoneOS\_xcplugin\_backup\_<i>YearMonthDayHourMinuteSecond</i>\_<i>Random</i>.tar.gz</code>.

The `install.sh` script makes a back up of the `iPhoneOS Build System Support.xcplugin` directory as follows:

 What                            | Directory or File
---------------------------------|------------
Directory containing `.tar` file | <code><i>DEVTOOLS_PATH</i>/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/</code>
`.tar` file naming scheme        | <code>iPhoneOS\_xcplugin\_backup\_<i>YearMonthDayHourMinuteSecond</i>\_<i>Random</i>.tar.gz</code>

The `install.sh` script also prints this information:

<pre>
A backup of     '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin'
was created at: '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS_xcplugin_backup_20110621185206_41066.tar.gz'
</pre>

To uninstall the Xcode iPhone PNG Optimizer Enhancement, you can use `tar` to restore the original files:

<pre>
shell% <b>cd /Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/ &crarr;</b>
shell% <b>sudo tar czf iPhoneOS_xcplugin_backup_20110621185206_41066.tar.gz &crarr;</b>
Password: &nbsp;<i><b>Enter your password, it will not be displayed.</b></i>
shell% &#9612;
</pre>

As before, if `Xcode.app` is running when you make the changes above, you will need to exit and restart Xcode in order for them to take effect.

## Usage

To use the Xcode iPhone PNG Optimizer Enhancement, simply open your the Build Settings for your iPhone project, find the [`Compress PNG Files`][COMPRESS_PNG_FILES] Build Setting under Packaging&hellip;, and select one of the available options.

<!--
* Changing the Xcode build setting for Compress PNG Files.
* Important note blurb about the need for `advpngidat`.
* Important note blurb about sharing a Xcode `project.pbxproj` that has been modified to use the enhanced [`Compress PNG Files`][COMPRESS_PNG_FILES] functionality with uses that do not have it installed.
-->

## Results

The following results are taken from a real-world iPhone application.  The amount of additional optimization that is possible will vary for each project based on a number of difficult to quantify factors.  The results for each project may differ, sometimes dramatically, from the results below.  You are strongly encouraged to verify whether or not a setting &ge; `Medium` provides any worthwhile benefit for your project.

|  Setting  | Size<sup>&dagger;</sup> | &Delta; `Low` | &Delta; `High` | Time<sup>&Dagger;</sup> | &Delta; `Low` | &Delta; `High` 
|:----------|------------------------:|---------- ---:|---------------:|------------------------:|--------------:|---------------:
| `Low`     |                 9740448 |        100.0% |         125.6% |                      46 |        100.0% |          35.9%
| `Medium`  |                 8969108 |         92.1% |         115.6% |                     101 |        219.6% |          78.9%
| `High`    |                 7756942 |         79.6% |         100.0% |                     128 |        260.9% |         100.0%
| `Extreme` |                 7418479 |         76.2% |          95.6% |                     751 |       1632.6% |         586.7%
 
&nbsp;&nbsp;&nbsp;<sup>&dagger;</sup> bytes.<br />
&nbsp;&nbsp;&nbsp;<sup>&Dagger;</sup> seconds.  Timing done on a MacBook Pro with a 2.66GHz Intel Core 2 Dual CPU.


[Scribd-AdvanceCOMP]: https://github.com/scribd/advancecomp
[RFC 1950]: http://www.ietf.org/rfc/rfc1950.txt
[PNG]: http://www.w3.org/TR/PNG/
[COMPRESS_PNG_FILES]: http://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html#//apple_ref/doc/uid/TP40003931-CH3-SW6
