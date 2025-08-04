#!/bin/sh

drivedir=/run/media/korv/aludrive 

run() {
  checkhostname $@
}

checkhostname() {
#echo hostname:$HOSTNAME
  if [[ $HOSTNAME != "nixos" ]];then
      echo unknown hostname, exiting
  else
      mountOrUnmount $@
  fi
}

mountOrUnmount() {
 if [[ $1 == "--mount" || $1 == '-m'  || $1 == 'm' ]];then
    echo mounting
    nixosmount
 fi

 if [[ $1 == "--unmount" || $1 == '-u'  || $1 == 'u' ]];then
    nixosunmount
 fi

}

nixosmount() {
# if [ ! -d /dev/mapper/luks-4d6464a2-7bce-40df-bb20-b3b1208d6def ];then
#    echo luks not mounted
#    return 1
# fi


 if [ ! -d $drivedir ];then 
    sudo mkdir -p $drivedir
 fi

 sudo mount /dev/mapper/luks-4d6464a2-7bce-40df-bb20-b3b1208d6def $drivedir
 echo aludrive mounted
}

nixosunmount() {
 sudo umount $drivedir
 echo aludrive unmounted
 #sudo rm -r $drivedir
}
sudo printf  ''
run $@
