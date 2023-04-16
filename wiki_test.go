package main

import "testing"

func TestDummy(t *testing.T) {
	name := "Peter"
	want := "Peter"
	if want != name {
		t.Fatalf(`%q is not equal to %q`, name, want)
	}
}
