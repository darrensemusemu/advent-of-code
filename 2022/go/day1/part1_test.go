package day1

import "testing"

func TestCalorieCount(t *testing.T) {
	output, err := CalorieCount("test.txt")
	if err != nil {
		t.Fatalf("Failed calories count: %s\n", err)
	}
	t.Logf("Highest calorie: %d\n", output)

	output, err = CalorieCount("data.txt")
	if err != nil {
		t.Fatalf("Failed calories count: %s\n", err)
	}
	t.Logf("Highest calorie: %d\n", output)
}
