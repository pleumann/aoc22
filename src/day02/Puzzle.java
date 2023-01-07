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
    int play1(char them, char us) {
        switch (them) {
            case 'A': {                 // Rock
                switch (us) {
                    case 'X': return 4; // Rock,     draw, 1 + 3 = 4 points
                    case 'Y': return 8; // Paper,    win,  2 + 6 = 8 points
                    case 'Z': return 3; // Scissors, lose, 3 + 0 = 3 points
                }
            }
            case 'B': {                 // Paper
                switch (us) {
                    case 'X': return 1; // Rock,     lose, 1 + 0 = 1 points
                    case 'Y': return 5; // Paper,    draw, 2 + 3 = 5 points
                    case 'Z': return 9; // Scissors, win,  3 + 6 = 9 points
                }
            }
            case 'C': {                 // Scissors
                switch (us) {
                    case 'X': return 7; // Rock,     win,  1 + 6 = 7 points
                    case 'Y': return 2; // Paper,    lose, 2 + 0 = 2 points
                    case 'Z': return 6; // Scissors, draw, 3 + 3 = 6 points
                }
            }
        }
        
        throw new RuntimeException("Oops");
    }

    /**
     * Plays a single round according to the rules of part 2, returns our score.
     */
    int play2(char them, char us) {
        switch (them) {
            case 'A': {                 // Rock
                switch (us) {
                    case 'X': return 3; // Scissors, lose, 3 + 0 = 3 points
                    case 'Y': return 4; // Rock,     draw, 1 + 3 = 4 points
                    case 'Z': return 8; // Paper,    win,  2 + 6 = 8 points
                }
            }
            case 'B': {                 // Paper
                switch (us) {
                    case 'X': return 1; // Rock,     lose, 1 + 0 = 1 points
                    case 'Y': return 5; // Paper,    draw, 2 + 3 = 5 points
                    case 'Z': return 9; // Scissors, win,  3 + 6 = 9 points
                }
            }
            case 'C': { // Scissors
                switch (us) {
                    case 'X': return 2; // Paper,    lose, 2 + 0 = 2 points
                    case 'Y': return 6; // Scissors, draw, 3 + 3 = 6 points
                    case 'Z': return 7; // Rock,     win,  1 + 6 = 7 points
                }
            }
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
            char them = s.charAt(0);
            char us = s.charAt(2);
            
            part1 += play1(them, us);
            part2 += play2(them, us);
            
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
