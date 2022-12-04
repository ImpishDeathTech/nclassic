
build:
  c++ -std=c++20 -fpic -c ./5-2/nclassic.cxx
  c++ -std=c++20 -shared -o nclassic.so nclassic.o -llua

install-1.0:
  git clone https://github.com/rxi/classic.git
  cd classic
  sudo cp classic.lua /usr/lib/lua/5.4/classic.lua
  cd ..
  sudo rm -r classic
  
install-1.1:
  sudo cp 1-1/core.lua /usr/lib/lua/5.4/nclassic.lua

install-1.2:
  sudo cp nclassic.so /usr/lib/lua/5.4/nclassic.so
 
install:
  make install-1.0
  make install-1.2

remove-1.0:
  sudo rm /usr/lib/lua/5.4/classic.lua

remove-1.1:
  sudo rm /usr/lib/lua/5.4/nclassic.lua

remove-1.2:
  sudo rm /usr/lib/lua/5.4/nclassic.so

remove:
  make remove-1.0
  make remove-1.2

clean:
  rm nclassic.so
  rm nclassic.o
