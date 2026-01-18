.PHONY: build run clean

# Build the women_survive executable without Dune
build:
	# Compile the library module first (outputs to src/)
	ocamlopt -c src/csv_loader.ml
	# Compile and link the executable using the compiled module
	ocamlopt -I src -o women_survive.exe src/csv_loader.cmx src/women_survive.ml

# Run the executable
run: build
	./women_survive.exe

# Clean build artifacts and generated files
clean:
	rm -f women_survive.exe *.cm[iox] *.o src/*.cm[iox] src/*.o
	rm -rf _build
	rm -f submission.csv
