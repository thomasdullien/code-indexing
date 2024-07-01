# A small shell script to build & install "build ear", a tool to convert build
# processes to a compile_commands.json.

sudo apt-get install cmake git
git clone https://github.com/rizsotto/Bear.git
mkdir Bear.Build
cd Bear.Build
cmake ../Bear
make -j
sudo make install
