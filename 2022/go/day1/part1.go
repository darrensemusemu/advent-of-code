package day1

import (
	"bufio"
	"io"
	"os"
	"strconv"
	"strings"
)

func CalorieCount(filename string) (int, error) {

	file, err := os.Open(filename)
	if err != nil {
		return 0, nil
	}
	defer file.Close()

	highSum := 0
	currSum := 0

	rd := bufio.NewReader(file)
	for {
		s, err := rd.ReadString('\n')
		if err == io.EOF {
			break
		}
		if err != nil {
			return 0, err
		}

		s = strings.TrimSpace(s)
		if s == "" {
			if currSum > highSum {
				highSum = currSum
			}
			currSum = 0
			continue
		}

		n, err := strconv.Atoi(s)
		if err != nil {
			return 0, err
		}
		currSum += n
	}

	return highSum, nil
}
