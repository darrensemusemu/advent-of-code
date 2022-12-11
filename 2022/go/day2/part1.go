package day2

import (
	"bufio"
	"os"
	"strings"
)

var (
	rock        = "X"
	rock_op     = "A"
	paper       = "Y"
	paper_op    = "B"
	scissors    = "Z"
	scissors_op = "C"
)

var matchDraw = map[string]string{
	rock_op:     rock,
	paper_op:    paper,
	scissors_op: scissors,
}

var matchWin = map[string]string{
	rock_op:     paper,
	paper_op:    scissors,
	scissors_op: rock,
}

var points = map[string]int{
	rock:     1,
	paper:    2,
	scissors: 3,
}

func StrategyGuide(filename string) (int, error) {
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

		points := points[round[1]]
		if matchWin[round[0]] == round[1] { // win
			points += 6
		} else if matchDraw[round[0]] == round[1] { // draw
			points += 3
		}
		pointsTotal += points
	}

	return pointsTotal, nil
}
