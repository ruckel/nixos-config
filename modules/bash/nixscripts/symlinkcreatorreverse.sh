#!/bin/sh

directoryToLinkTo=$2
linkToCreate=$1

if [[ $linkToCreate == '' ]];then failedInput=true;fi
if [[ $directoryToLinkTo == '' ]];then failedInput=true;fi
if [[ ! -d $directoryToLinkTo ]];then failedInput=true;fi

failed="symlinkCreatorReverse <linkPath> <existingDirPath>"

if [[ $failedInput == 'true' ]];
  then echo $failed;
  else 
      ln -rs $directoryToLinkTo $linkToCreate
      ls -l $(dirname "$linkToCreate") | grep $linkToCreate
fi

