#!/bin/sh

echo '********************************************************************'
echo '* Author:       Hao Nguyen                                         *'
echo '* Version:      1.0                                                *'
echo '* Purpose:      Run script to deploy product MusicMaven Angular and*'
echo '*               send it to server automatically                    *'
echo '* Date Release: 06-24-2019                                         *'
echo '********************************************************************'

server=180.16.10.109
username=root
password=Aa123456@
file_rsa=id_rsa_mb

path=\/var\/www\/html\/
if ! [ -d "music-maven"]; then
    echo 'cannot found the folder \'music-maven\' in this current path'
    echo 'exiting ...'
	exit $?;
fi;
if ! [ -f "id_rsa_mb"]; then
    echo 'cannot found the file \'id_rsa_mb\' in this current path'
    echo 'exiting ...'
	exit $?;
fi;
cd music-maven
if [ -d "dist"]; then
    echo 'found the \'dist\' folder'
    echo 'removing the dist folder ...'
    rm -rf ./dist
    echo 'done'
fi;
echo 'building product angular ...'
ng build --prod --base-href /music-maven/
check
echo 'done'
cd ./dist/music-maven
echo 'trying to replace the path of URL ...'
sed 's/.../\./music-maven//' index.html
check
echo 'done'
cd ..
echo 'trying to send folder to server ...'
scp -i $file_rsa -r ./music-maven $username@$server:$path
check
echo done
echo trying to run script set permission for all of server\'s path \($server\) ...
ssh -i $file_rsa $username@$server '/opt/musicmayvn/deploy_ui_script.sh'
check

function check {
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
        exit $?;
    fi;
}