package day2

import (
	"testing"
)

func TestStategyGuide2(t *testing.T) {
	res, err := StrategyGuide2("data/test.txt")
	if err != nil {
		t.Log(err)
	}
	t.Logf("day2 part2: %d\n", res)
	res, err = StrategyGuide2("data/data.txt")
	if err != nil {
		t.Log(err)
	}
	t.Logf("day2 part2: %d\n", res)
}
