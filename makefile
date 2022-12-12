SRC = ./1_2_1/nclassic.cxx
OBJ = nclassic.o 
LIB = nclassic.so
LFLAGS = -llua -o

compile:
	@echo CXX Compiling '$(OBJ)' ...
	$(CXX) $(CFLAGS) -c $(SRC) -o $(OBJ)

build:
	@make compile
	@echo CXX Building 'nclassic.so' ...
	$(CXX) $(LIBFLAG) $(LFLAGS) $(LIB) $(OBJ)

install: $(LIB) $(OBJ)
	@echo Installing '$(LIB)'
	cp $(LIB) $(INST_LIBDIR)/$(LIB)
	@echo Done! ^,..,^

clean:
	@echo Cleaning up ..
	@rm nclassic.so
	@rm nclassic.o
	@echo Done! ^,..,^

