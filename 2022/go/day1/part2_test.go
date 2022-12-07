package day1

import "testing"

func TestCalorieSum(t *testing.T) {
	res, err := CalorieCountSum("test.txt")
	if err != nil {
		t.Fatalf("TestCalorieSum failed: %s\n", err)
	}
	t.Logf("TestCalorieSum data set result: %d\n", res)

	res, err = CalorieCountSum("data.txt")
	if err != nil {
		t.Fatalf("TestCalorieSum failed: %s\n", err)
	}
	t.Logf("TestCalorieSum data set result: %d\n", res)
}
