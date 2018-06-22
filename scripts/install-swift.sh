#!/bin/bash
set -ve
echo "Installing Swift for Linux"
echo "-Ubuntu Trusty 14.04"
echo "      Updating, Fetching & Installing Ubuntu Trusty 14.04 dependencies..."
sudo apt-get -y update
sudo apt-get -y install clang libicu-dev git
sudo apt-get -y install clang-3.6
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
echo "-Installing Swift using SwiftEnv"
echo "      Downloading SwiftEnv"
mkdir .swiftenv
git clone https://github.com/kylef/swiftenv ~/.swiftenv
export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"
if [ -f ".swift-version" ] || [ -n "$SWIFT_VER" ]; then
  swiftenv install -s
else
  swiftenv rehash
fi
echo "Finished installing Swift!"
