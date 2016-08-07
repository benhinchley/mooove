package main

import "github.com/benhinchley/files"

func stripRoot(r string, p <-chan string) []string {
	o := make([]string, 0, 20)
	for path := range p {
		o = append(o, files.StripRoot(r, path))
	}
	return o
}
