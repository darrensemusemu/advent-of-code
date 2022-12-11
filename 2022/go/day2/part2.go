package day2

import (
	"bufio"
	"os"
	"strings"
)

var matchLose = map[string]string{
	rock_op:     scissors,
	paper_op:    rock,
	scissors_op: paper,
}

func StrategyGuide2(filename string) (int, error) {
	f, err := os.Open(filename)
	if err != nil {
		return 0, err
	}
	defer f.Close()

	pointsTotal := 0
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		v := strings.TrimSpace(scanner.Text())
		round := strings.Split(v, " ")
		sum := 0
		sel := ""
		if round[1] == "Z" { // win
			sel = matchWin[round[0]]
			sum += 6
		} else if round[1] == "Y" { // draw
			sel = matchDraw[round[0]]
			sum += 3
		} else { // lose
			sel = matchLose[round[0]]
		}
		pointsTotal += points[sel] + sum
	}

	return pointsTotal, nil
}
