#!/bin/bash
set -e

if [[ $TRAVIS_OS_NAME == 'linux' ]]; then
    echo "Installing Swift for Linux"
    echo "...removing dependencie locks"
    sudo rm /var/lib/apt/lists/lock
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock
    echo "...intalling dependencies"
    sudo apt-get install clang libicu-dev git
    if [[ $OS_VER == '14.04' ]]; then
        echo ">Ubuntu Trusty 14.04"
        echo "-Fetching & Installing Ubuntu Trusty 14.04 dependencies..."
        sudo apt-get install clang-3.6 -qq
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
    else
        echo ">Ubuntu Xenial 16.04"
    fi
    echo "-Installing Swift through #SwiftEnv#"
    mkdir .swiftenv
    git clone https://github.com/kylef/swiftenv ~/.swiftenv
    echo 'eval "$(swiftenv init -)"' >> ~/.bashrc
    echo '>>>>"$(swiftenv init -)"'
    sudo swiftenv install $SWIFT_VER
    swiftenv version
    swiftenv global $SWIFT_VER
    swiftenv version
    swiftenv which swift
    source ~/.bashrc
    echo "Finished installing Swift!"
fi