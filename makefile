
compile:
	@echo CXX Compiling 'nclassic.o' ...
	$(CXX) $(CFLAGS) -c $(SRC) -o $(OBJ)

build:
	@make compile
	@echo CXX Building 'nclassic.so' ...
	$(CXX) $(LIBFLAG) $(LFLAGS) -o $(LIB) $(OBJ)

install: $(LIB) $(OBJ)
	@echo Installing '$(LIB)'
	cp $(LIB) $(INST_LIBDIR)/$(LIB)
	@echo Done! ^,..,^

clean:
	@echo Cleaning up ..
	@rm nclassic.so
	@rm nclassic.o
	@echo Done! ^,..,^

