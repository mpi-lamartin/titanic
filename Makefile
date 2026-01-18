.PHONY: build run clean id3

build:
	dune build

run: build
	dune exec src/women_survive.exe

id3: build
	dune exec src/id3.exe

clean:
	dune clean
	rm -f submission.csv
