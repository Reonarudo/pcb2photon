#!/bin/bash
set -ev
platform='unknown'
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
else
    platform='macos'
fi

if [[ $platform == 'linux' ]]; then
    sudo apt-get install git -qq
    sudo apt-get update
    sudo apt-get install clang libicu-dev libpython2.7
    wget -q -O - https://swift.org/keys/all-keys.asc | sudo gpg --import -
    wget https://swift.org/builds/swift-4.0.3-release/ubuntu1604/swift-4.0.3-RELEASE/swift-4.0.3-RELEASE-ubuntu16.04.tar.gz
    gpg --verify swift-4.0.3-RELEASE-ubuntu16.04.tar.gz.sig
    tar xzf swift-4.0-RELEASE-ubuntu16.04.tar.gz
    mv swift-4.0.3-RELEASE-ubuntu16.04 /usr/share/swift
    echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
    source  ~/.bashrc
fi