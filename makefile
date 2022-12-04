
build:
  c++ -std=c++20 -fpic -c ./5-2/nclassic.cxx
	c++ -std=c++20 -shared -o nclassic.so nclassic.o -llua
 
install:
  sudo cp nclassic.so /usr/lib/lua/5.4/nclassic.so
 
remove:
  sudo rm /usr/lib/lua/5.4/nclassic.so

clean:
  rm nclassic.so
  rm nclassic.o
