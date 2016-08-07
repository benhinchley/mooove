package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/benhinchley/files"
	"github.com/robertkrimen/otto"
	"github.com/robertkrimen/otto/parser"
)

var (
	debug  bool
	script string
	input  string
	output string
)

// Errors
var (
	noScript           = fmt.Sprintf("no script given")
	scriptDoesNotExist = fmt.Sprintf("the provided script does not exist. check the provided path: %s", script)
	inputDoesNotExist  = fmt.Sprintf("the provided input directory does not exist. check the provided path: %s", input)
)

func init() {
	flag.BoolVar(&debug, "debug", false, "enable debug mode")
	flag.StringVar(&script, "s", "", "path to mooove script")
	flag.Parse()
}

func main() {
	if script == "" {
		fmt.Println(noScript)
		os.Exit(1)
	}
	if !files.Exists(script) {
		fmt.Println(scriptDoesNotExist)
		os.Exit(1)
	}

	args := os.Args[3:]
	input = args[0]
	if len(args) < 2 {
		output = input
	} else {
		output = args[1]
	}

	if !files.Exists(input) {
		fmt.Println(inputDoesNotExist)
		os.Exit(1)
	}

	if !files.Exists(output) {
		if err := os.MkdirAll(output, 0777); err != nil {
			fmt.Printf("your output directory didn't exist, so I tried to create it, and well now we are here\nerror => %s\n", err)
			os.Exit(1)
		}
	}

	s, err := ioutil.ReadFile(script)
	if err != nil {
		fmt.Printf("ooops looks like we had a bit of an issue reading that script\nerror +> %s\n", err)
		os.Exit(1)
	}

	if !strings.HasSuffix(input, "/") {
		input = input + "/"
	}

	files := stripRoot(input, files.ListPath(input))

	vm := otto.New()
	vm.Set("input", files)
	vm.Set("srcDir", input)
	vm.Set("dstDir", output)

	vm.Set("copy", copy)
	vm.Set("move", move)
	vm.Set("extname", extname)
	vm.Set("basename", basename)
	vm.Set("join", join)

	defer func() { recover() }()

	p, err := parser.ParseFile(nil, "", s, 0)
	if err != nil {
		fmt.Printf("there was an error parsing your script\nerror => %s\n", err)
	}

	if _, err := vm.Run(p); err != nil {
		fmt.Printf("there was an error running your script\nerror => %s", err)
		os.Exit(1)
	}

	os.Exit(0)
}
