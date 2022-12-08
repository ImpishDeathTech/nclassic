SRC        = 1_2_1/*.cxx
CXX        = g++
STD        = -std=c++20
MAN_LIBDIR = /usr/lib/lua/5.4/ 


all: 
	make build

nclassic.so:
	$(CXX) $(LIBFLAG) -o $@ -L$(LUA_LIBDIR) $<

nclassic.o:
	$(CXX) $(STD) $(CFLAGS) -I$(LUA_INCDIR) $< -o $@

install:
	cp nclassic.so $(INST_LIBDIR)

compile:
	@echo CXX Compiling 'nclassic.o' ...
	$(CXX) $(STD) -fpic -c $(SRC)

build:
	@make compile
	@echo CXX Building 'nclassic.so' ...
	@c++ -std=c++20 -shared -o nclassic.so nclassic.o -llua

manual-install:
	@echo Installing 'nclassic-1.2.1' ...
	@sudo cp nclassic.so $(MAN_LIBDIR)/nclassic.so
	@echo Done! ^,..,^

remove:
	@echo Uninstalling 'nclassic-1.2.1' ...
	@sudo rm $(MAN_LIBDIR)/nclassic.so
	@echo Done! ^,..,^

clean:
	@echo Cleaning up ..
	@rm nclassic.so
	@rm nclassic.o
	@echo Done! ^,..,^

