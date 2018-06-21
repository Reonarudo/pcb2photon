#!/bin/bash
set -e
cat ~/.bashrc
cat ~/.bash_profile
if [[ $TRAVIS_OS_NAME == 'linux' ]]; then
    echo "Installing Swift for Linux"
    if [[ $OS_VER == '14.04' ]]; then
        echo ">Ubuntu Trusty 14.04"
        echo "-Fetching & Installing Ubuntu Trusty 14.04 dependencies..."
        sudo apt-get install clang-3.6
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
    else
        echo ">Ubuntu Xenial 16.04"
    fi
    source ~/.bashrc
    echo "-Installing Swift through #SwiftEnv#"
    mkdir .swiftenv
    git clone https://github.com/kylef/swiftenv ~/.swiftenv
    echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bash_profile
    echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(swiftenv init -)"' >> ~/.bash_profile
    echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bashrc
    echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(swiftenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    source ~/.bash_profile
    swiftenv install $SWIFT_VER
    swiftenv which swift
    cat ~/.bashrc
    cat ~/.bash_profile
    source ~/.bashrc
    source ~/.bash_profile
    echo "Finished installing Swift!"
fi