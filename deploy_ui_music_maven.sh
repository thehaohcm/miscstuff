#!/bin/sh

clear

echo '          *****************************************************************'
echo '          * Author:       Hao Nguyen (thehaohcm@yahoo.com.vn)             *'
echo '          * Version:      1.0                                             *'
echo '          * Purpose:      Run script to deploy product MusicMaven Angular *'
echo '          *               and send it to server automatically             *'
echo '          * Date Release: 06-2-2019                                       *'
echo '          *****************************************************************'
echo '          * Note:		Please contact with Server Administrator if     *'
echo '          *               your creditial not working properly             *'				 
echo '          *****************************************************************'

#server=180.16.10.109
#username=root
#file_rsa=id_rsa_mb
#path=\/var\/www\/html\/
server=ec2-52-15-111-218.us-east-2.compute.amazonaws.com
username=centos
file_rsa=musicmaven.pem
path=\/tmp\/
path_html=\/var\/www\/html\/
music_maven=music-maven
if [ -d "music-maven" ]; then
    echo 'exists'
else
    echo 'not exists'
fi

if [ ! -d "music-maven" ]; then
    echo 'cannot found the folder music-maven in this current path'
    echo 'exiting ...'
	exit $?
fi
echo abc
if ! [ -f $file_rsa ]; then
    echo 'cannot found the file id_rsa_mb in this current path'
    echo 'exiting ...'
	exit $?
fi
cd music-maven
if [ -d "dist" ]; then
    echo 'found the dist folder'
    echo 'removing the dist folder ...'
    rm -rf ./dist
    echo 'done'
fi
echo 'building product angular ...'
ng build --prod --base-href /music-maven/
check
echo 'done'
cd ./dist/music-maven
echo 'trying to replace the path of URL ...'
sed -i -e "s/<base href=.*/<base href=\"\.\/music-maven\/\">/g" index.html
check
echo 'done'
cd ..
echo 'trying to send folder to server ...'
scp -i $file_rsa -r ./music-maven $username@$server:$path
check
echo done
echo trying to run script set permission for all of server\'s path \($server\) ...
#ssh -i $file_rsa $username@$server '/opt/musicmayvn/deploy_ui_script.sh'
ssh -i $file_rsa $username@$server << EOF
 sudo su -
 cp $path$music_maven $path_html
 cd $path
 #cd music-maven
 #find -type d -exec chmod 755 {} \;
 #find -type f -exec chmod 644 {} \;
 #cd ..
 #chmod 755 music-maven
 #chown -R nginx:nginx music-maven
EOF
check

function check {
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
        exit $?
    fi;
}

exit 0
