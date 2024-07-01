# A small shell script to build & install woboq code browser, linked against
# clang-5.0

# One-by-one installation - it seems not all packages exist on all rodete and
# debian installs, so rather be safe than miss a package.
sudo apt-get install clang-5.0 clang-5.0-dev
sudo apt-get install llvm-5.0 llvm-5.0-dev
sudo apt-get install g++ 
sudo apt-get install clang-format-5.0
sudo apt-get install clang-tools-5.0 
sudo apt-get install clang-tidy-5.0
git clone https://github.com/woboq/woboq_codebrowser.git

# Clang + cmake packaging is in an almost-permanently broken state under debian,
# see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=862328 for clang 4.0 and
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900440 for clang 6.0.
#
# This script applies the same steps that fix clang 6.0 (even though we are
# dealing with the clang 5.0 packages).

sudo cp /usr/share/llvm-5.0/cmake/. /usr/lib/llvm-5.0/lib/cmake/clang -r
sudo ln -s /usr/lib/llvm-5.0/bin/clang /usr/lib/llvm-5.0/bin/clang-5.0

mkdir woboq_codebrowser.build
cd woboq_codebrowser.build
cmake ../woboq_codebrowser
make -j
sudo make install

