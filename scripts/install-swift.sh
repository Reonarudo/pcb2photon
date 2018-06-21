#!/bin/bash
set -ev
swift_v='4.0.3'
platform='unknown'
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
else
    platform='macos'
fi

if [[ $platform == 'linux' ]]; then
    echo "Installing Swift"
    sudo apt-get install git -qq
    sudo apt-get update
    sudo apt-get install clang libicu-dev libpython2.7
    wget -q -O - https://swift.org/keys/all-keys.asc | sudo gpg --import -
    wget https://swift.org/builds/swift-$swift_v-release/ubuntu1604/swift-$swift_v-RELEASE/swift-$swift_v-RELEASE-ubuntu16.04.tar.gz
    gpg --verify swift-4.0.3-RELEASE-ubuntu16.04.tar.gz.sig
    tar xzf swift-$swift_v-RELEASE-ubuntu16.04.tar.gz
    mv swift-$swift_v-RELEASE-ubuntu16.04 /usr/share/swift
    echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
    source  ~/.bashrc
    echo "Finished installing Swift"
fi