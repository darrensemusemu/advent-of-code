package day1

import (
	"bufio"
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

func CalorieCountSum(filename string) (int, error) {

	file, err := os.Open(filename)
	if err != nil {
		return 0, nil
	}
	defer file.Close()

	sums := make([]int, 0)
	currSum := 0

	rd := bufio.NewReader(file)
	for {
		s, err := rd.ReadString('\n')
		if err == io.EOF {
			if currSum > 0 {
				sums = append(sums, currSum)
			}
			break
		}
		if err != nil {
			return 0, err
		}

		s = strings.TrimSpace(s)
		if s == "" {
			sums = append(sums, currSum)
			currSum = 0
			continue
		}

		n, err := strconv.Atoi(s)
		if err != nil {
			return 0, err
		}
		currSum += n
	}

	sort.Slice(sums, func(i, j int) bool { return sums[i] > sums[j] })
	return sums[0] + sums[1] + sums[2], nil
}
