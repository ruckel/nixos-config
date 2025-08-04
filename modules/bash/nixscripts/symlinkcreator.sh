#!/bin/sh

directoryToLinkTo=$1
linkToCreate=$2

if [[ $linkToCreate == '' ]];then failedInput=true && err=0;fi
if [[ $directoryToLinkTo == '' ]];then failedInput=true && err=2;fi
if [[ ! -d $directoryToLinkTo ]];then failedInput=true && err=3;fi

failed="symlinkCreator <existingDirPath> <linkPath>"

if [[ $failedInput == 'true' ]];
  then echo "$failed ($err)";
  else 
      ln -rs $directoryToLinkTo $linkToCreate
      ls -l $(dirname "$linkToCreate") | grep $linkToCreate
fi

