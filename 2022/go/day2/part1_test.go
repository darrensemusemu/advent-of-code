package day2

import (
	"testing"
)

func TestStategyGuide(t *testing.T) {

	res, err := StrategyGuide("data/test.txt")
	if err != nil {
		t.Log(err)
	}
	t.Logf("day2 part1: %d\n", res)
	res, err = StrategyGuide("data/data.txt")
	if err != nil {
		t.Log(err)
	}
	t.Logf("day2 part1: %d\n", res)
}
