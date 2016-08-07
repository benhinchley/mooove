package main

import (
	"path"
	"path/filepath"

	"github.com/benhinchley/files"
	"github.com/robertkrimen/otto"
)

func copy(call otto.FunctionCall) otto.Value {
	src, _ := call.Argument(0).ToString()
	dst, _ := call.Argument(1).ToString()
	res := true

	if err := files.Copy(path.Join(input, src), path.Join(output, dst)); err != nil {
		res = false
	}

	r, _ := otto.ToValue(res)
	return r
}

func move(call otto.FunctionCall) otto.Value {
	src, _ := call.Argument(0).ToString()
	dst, _ := call.Argument(1).ToString()
	res := true

	if err := files.Move(path.Join(input, src), path.Join(output, dst)); err != nil {
		res = false
	}
	r, _ := otto.ToValue(res)
	return r
}

func basename(call otto.FunctionCall) otto.Value {
	p, _ := call.Argument(0).ToString()
	res := filepath.Base(p)
	r, _ := otto.ToValue(res)
	return r
}

func extname(call otto.FunctionCall) otto.Value {
	p, _ := call.Argument(0).ToString()
	res := filepath.Ext(p)
	r, _ := otto.ToValue(res)
	return r
}

func join(call otto.FunctionCall) otto.Value {
	j := make([]string, 0, 8)
	for _, arg := range call.ArgumentList {
		p, _ := arg.ToString()
		j = append(j, p)
	}
	res := path.Join(j...)
	r, _ := otto.ToValue(res)
	return r
}
