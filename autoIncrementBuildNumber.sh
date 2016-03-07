#!/bin/sh

#  autoIncrementBuildNumber.sh
#  Gourmand
#
#  Created by alireza ghias on 3/7/16.
#  Copyright © 2016 MacMini. All rights reserved.
conf=${CONFIGURATION}
arch=${ARCHS:0:4}
# Only increase the build number on Device and AdHoc/AppStore build

buildPlist=${INFOPLIST_FILE}
buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBuildVersion" $buildPlist)
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBuildNumber" $buildPlist)
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBuildNumber $buildNumber" $buildPlist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildVersion.$buildNumber" $buildPlist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $buildVersion.$buildNumber" $buildPlist
