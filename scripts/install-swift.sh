#!/bin/bash
set -ve
cat ~/.bashrc
echo "Installing Swift for Linux"
echo "-Ubuntu Trusty 14.04"
echo "      Updating, Fetching & Installing Ubuntu Trusty 14.04 dependencies..."
sudo apt-get -y update
sudo apt-get -y install clang libicu-dev git
sudo apt-get -y install clang-3.6
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
source ~/.bashrc
echo "-Installing Swift using SwiftEnv"
echo "      Downloading SwiftEnv"
mkdir .swiftenv
git clone https://github.com/kylef/swiftenv ~/.swiftenv
echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bashrc
echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(swiftenv init -)"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get -y install curl
swiftenv install $SWIFT_VER
swiftenv which swift

source ~/.bashrc
echo "Finished installing Swift!"
