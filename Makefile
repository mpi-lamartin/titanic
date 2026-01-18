.PHONY: build run clean

build:
	dune build

run: build
	dune exec src/women_survive.exe

clean:
	dune clean
	rm -f submission.csv
