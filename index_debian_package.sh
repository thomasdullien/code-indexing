#!/bin/bash

# Assumes you have build-ear (https://github.com/rizsotto/Bear) and woboq
# installed.

# Define the variables we need. Mostly paths.
#woboq_root_path=/usr/local/google/home/thomasdullien/Desktop/sources/woboq/woboq_codebrowser
#codebrowser_generator_path=$woboq_root_path/generator/codebrowser_generator
#index_generator_path=$woboq_root_path/indexgenerator/codebrowser_indexgenerator
output_directory=/home/thomas_dullien/indexed_sources
woboq_root_path=/home/thomas_dullien/woboq_codebrowser
codebrowser_generator_path=$(which codebrowser_generator)
index_generator_path=$(which codebrowser_indexgenerator)

set -e

for packagename in "$@"
do
  if [ -d "temp" ]; then
    sudo rm -rf ./temp
  fi
  mkdir temp
  cd temp

  echo "Installing build dependencies for $packagename"
  sudo apt-get build-dep $packagename

  echo "Downloading source for $packagename"
  apt-get source $packagename
  directory=$(ls -d */)
  version=$(cat *.dsc | grep Version\: | grep -v Standards | grep -v GnuPG | rev | cut -d":" -f1 | cut -d" " -f1 | rev | tr -d [:blank:])

  echo "Version string is $version"
  if [ ${#version} -lt 3 ]; then
    echo "Version strnig $version seems fishy, exiting.";
    exit 1;
  fi

  cd $directory
  full_directory=$output_directory/$packagename-$version

  echo "Full output directory is $full_directory"
  mkdir -p $full_directory

  echo "Launching debuild."
  sudo /usr/local/bin/bear debuild -b -uc -us || true

  echo "Launching codebrowser_generator."
  echo $codebrowser_generator_path -a -b=$(pwd)/compile_commands.json -p=$packagename-$version:$(pwd):$version -o=$full_directory
  $codebrowser_generator_path -a -b=$(pwd)/compile_commands.json -p=$packagename-$version:$(pwd):$version -o=$full_directory

  echo "Launching codebrowser_indexgenerator."
  echo $index_generator_path $full_directory -p -p=$packagename:/$(pwd):$version
  $index_generator_path $full_directory -p -p=$packagename:/$(pwd):$version

  echo "Dealing with the data directories."
  mkdir -p $output_directory/data
  mkdir -p $full_directory/data
  cp -R $woboq_root_path/data/* $output_directory/data
  cp -R $woboq_root_path/data/* $full_directory/data

  echo "Inserting the hypothes.is javascript into the relevant html files"
  for html in $(find $full_directory -iname \*.html); do
    #sed -i -e 's/title="KDevelop"\/>/title="KDevelop"\/><script src="https:\/\/hypothes.is\/embed.js" async><\/script>/g' $html;
    sed -i -e 's/title="KDevelop"\/>/title="KDevelop"\/><script type="application\/json" class="js-hypothesis-config">{ "services" : [ { "apiUrl" : "http:\/\/35.196.26.228:5000\/api\/" } ] }<\/script><script src="http:\/\/35.196.26.228:5000\/embed.js" async><\/script>/g' $html;
  done;

  cd ..
done

