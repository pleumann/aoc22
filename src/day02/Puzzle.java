package day02;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 02 "Rock Paper Scissors" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Plays a single round according to the rules of part 1, returns our score.
     */
    int play1(String hands) {
        switch (hands) {
            case "A X": return 4; // Rock-rock,         draw, 1 + 3 = 4 points
            case "A Y": return 8; // Rock-paper,        win,  2 + 6 = 8 points
            case "A Z": return 3; // Rock-scissors,     lose, 3 + 0 = 3 points
            case "B X": return 1; // Paper-rock,        lose, 1 + 0 = 1 points
            case "B Y": return 5; // Paper-paper,       draw, 2 + 3 = 5 points
            case "B Z": return 9; // Paper-scissors,    win,  3 + 6 = 9 points
            case "C X": return 7; // Scissors-rock,     win,  1 + 6 = 7 points
            case "C Y": return 2; // Scissors-paper,    lose, 2 + 0 = 2 points
            case "C Z": return 6; // Scissors-scissors, draw, 3 + 3 = 6 points
        }
        
        throw new RuntimeException("Oops");
    }

    /**
     * Plays a single round according to the rules of part 2, returns our score.
     */
    int play2(String hands) {
        switch (hands) {
            case "A X": return 3; // Rock-scissors,     lose, 3 + 0 = 3 points
            case "A Y": return 4; // Rock-rock,         draw, 1 + 3 = 4 points
            case "A Z": return 8; // Rock-paper,        win,  2 + 6 = 8 points
            case "B X": return 1; // Paper-rock,        lose, 1 + 0 = 1 points
            case "B Y": return 5; // Paper-paper,       draw, 2 + 3 = 5 points
            case "B Z": return 9; // Paper-scissors,    win,  3 + 6 = 9 points
            case "C X": return 2; // Scissors-paper,    lose, 2 + 0 = 2 points
            case "C Y": return 6; // Scissors-scissors, draw, 3 + 3 = 6 points
            case "C Z": return 7; // Scissors-rock,     win,  1 + 6 = 7 points
        }
        
        throw new RuntimeException("Oops");
    }
    
    /**
     * Solves the puzzle for the input coming from the given reader.
     */    
    void solve(BufferedReader r) throws IOException {
        int part1 = 0;
        int part2 = 0;
        
        String s = r.readLine();
        while (s != null) {            
            part1 += play1(s);
            part2 += play2(s);
            
            s = r.readLine();
        }
        
        System.out.printf("Part 1: %5d points\n", part1);
        System.out.printf("Part 2: %5d points\n", part2);
    }
    
    /**
     * Provides the canonical entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.02 Rock Paper Scissors ***");
        System.out.println();
        
        new Puzzle().solve(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
