.PHONY: build run clean

# Build the women_survive executable without Dune
build:
	cd src &&\
	ocamlfind ocamlopt -package str -linkpkg csv_loader.ml women_survive.ml -o ../women_survive.exe

# Run the executable
run: build
	./women_survive.exe

# Clean build artifacts and generated files
clean:
	rm -f women_survive.exe *.cm[iox] *.o src/*.cm[iox] src/*.o
	rm -rf _build
	rm -f submission.csv
