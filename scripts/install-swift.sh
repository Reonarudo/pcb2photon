#!/bin/bash
set -e
swift_v='4.0.3'

if [[ $TRAVIS_OS_NAME == 'linux' ]]; then
    echo "Installing Swift"
    echo "-Installing dependencies..."
    sudo apt-get install git -qq
    sudo apt-get update
    sudo apt-get install clang libicu-dev libpython2.7
    echo "-Fetching Packages dependencies..."
    wget -q -O - https://swift.org/keys/all-keys.asc | sudo gpg --import -
    wget https://swift.org/builds/swift-$swift_v-release/ubuntu1604/swift-$swift_v-RELEASE/swift-$swift_v-RELEASE-ubuntu16.04.tar.gz
    wget https://swift.org/builds/swift-$swift_v-release/ubuntu1604/swift-$swift_v-RELEASE/swift-$swift_v-RELEASE-ubuntu16.04.tar.gz.sig
    echo "-Verifying packages..."
    gpg --verify swift-$swift_v-RELEASE-ubuntu16.04.tar.gz.sig
    echo "-Extracting packages"
    tar xzf swift-$swift_v-RELEASE-ubuntu16.04.tar.gz
    echo "-Configureing paths..."
    mv swift-$swift_v-RELEASE-ubuntu16.04 /usr/share/swift
    echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
    source  ~/.bashrc
    echo "Finished installing Swift!"
fi