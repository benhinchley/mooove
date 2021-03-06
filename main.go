package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/benhinchley/files"
	"github.com/robertkrimen/otto"
	"github.com/robertkrimen/otto/parser"
)

var (
	//debug  bool
	script      string
	source      string
	destination string
	v           bool
)

var (
	Version string
	Build   string
)

func init() {
	//flag.BoolVar(&debug, "debug", false, "enable debug mode")
	flag.StringVar(&script, "s", "", "path to script")
	flag.BoolVar(&v, "v", false, "print version info")
	flag.Parse()
}

func main() {
	if v {
		fmt.Printf("mooove - version: %s - build: %s\n", Version, Build)
		os.Exit(0)
	}

	if script == "" {
		fmt.Println("urhm you didn't provide a script")
		os.Exit(1)
	}
	if !files.Exists(script) {
		fmt.Printf("so the script you provided doesn't seem to exist, check the path you provided => %s\n", script)
		os.Exit(1)
	}

	args := os.Args[3:]
	source = args[0]
	if len(args) < 2 {
		destination = source
	} else {
		destination = args[1]
	}

	if !files.Exists(source) {
		fmt.Printf("it doesn't seem like the source path you provided exists, check the path you provided => %s\n", source)
		os.Exit(1)
	}

	if !files.Exists(destination) {
		if err := os.MkdirAll(destination, 0777); err != nil {
			fmt.Printf("your output directory didn't exist, so I tried to create it, and well now we are here\nerror => %s\n", err)
			os.Exit(1)
		}
	}

	s, err := ioutil.ReadFile(script)
	if err != nil {
		fmt.Printf("ooops looks like we had a bit of an issue reading that script\nerror +> %s\n", err)
		os.Exit(1)
	}

	vm := otto.New()

	// set variables
	vm.Set("input", stripRoot(source, files.ListPath(source)))
	vm.Set("srcDir", source)
	vm.Set("dstDir", destination)

	// set helper functions
	vm.Set("copy", copy)
	vm.Set("move", move)
	vm.Set("symlink", symlink)
	vm.Set("extname", extname)
	vm.Set("basename", basename)
	vm.Set("join", join)
	vm.Set("directory", directory)

	// parse script
	defer func() { recover() }()
	p, err := parser.ParseFile(nil, "", s, 0)
	if err != nil {
		fmt.Printf("there was an error parsing your script\nerror => %s\n", err)
	}

	// run script
	if _, err := vm.Run(p); err != nil {
		fmt.Printf("there was an error running your script\nerror => %s", err)
		os.Exit(1)
	}

	os.Exit(0)
}
