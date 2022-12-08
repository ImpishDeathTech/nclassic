SRC = 1_2_1/*.cxx

*.o: $(SRC)
	@make build 

$(SRC):
	@make compile

compile:
	@echo CXX Compiling 'nclassic.o' ...
	@c++ -std=c++20 -fpic -c ./1_2_1/nclassic.cxx

build:
	@make compile
	@echo CXX Building 'nclassic.so' ...
	@c++ -std=c++20 -shared -o nclassic.so nclassic.o -llua

install:
	@echo Installing 'nclassic-1.2.1' ...
	@sudo cp nclassic.so /usr/lib/lua/5.4/nclassic.so
	@echo Done! ^,..,^

remove:
	@echo Uninstalling 'nclassic-1.2.1' ...
	@sudo rm /usr/lib/lua/5.4/nclassic.so
	@echo Done! ^,..,^

clean:
	@echo Cleaning up ..
	@rm nclassic.so
	@rm nclassic.o
	@echo Done! ^,..,^

