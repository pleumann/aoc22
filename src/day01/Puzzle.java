package day01;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

/**
 * Day 01 "Calorie Counting" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Maximum number of calorie sections (or sums) we can handle.
     */
    static int SIZE = 1000;

    /**
     * Solves the puzzle for the input coming from the given reader.
     */    
    void solve(BufferedReader r) throws IOException {
        int[] calories = new int[SIZE];
    
        int i = 0;
        
        String s = r.readLine();
        while (s != null) {            
            if ("".equals(s)) {
                i++;
            } else {
                calories[i] += Integer.parseInt(s);
            }
            
            s = r.readLine();
        }

        Arrays.sort(calories); // Bah! int[] can't be custom-sorted in Java. :(

        int part1 = calories[SIZE - 1];
        int part2 = calories[SIZE - 1] + calories[SIZE - 2] + calories[SIZE - 3];
        
        System.out.printf("Part 1: %6d calories\n", part1);
        System.out.printf("Part 2: %6d calories\n", part2);
    }
    
    /**
     * Provides the canonical entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.01 Calorie Counting ***");
        System.out.println();
        
        new Puzzle().solve(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
