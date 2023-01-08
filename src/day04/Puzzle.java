package day04;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 4 "Camp Cleanup" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Solves the puzzle for the input coming from the given reader.
     */    
    void solve(BufferedReader r) throws IOException {
        int part1 = 0;
        int part2 = 0;
        
        String s = r.readLine();
        while (s != null) {
            String[] values = s.split("\\,|\\-");
            int a = Integer.parseInt(values[0]);
            int b = Integer.parseInt(values[1]);
            int c = Integer.parseInt(values[2]);
            int d = Integer.parseInt(values[3]);
            
            if (a >= c && b <= d || c >= a && d <= b) {         // contained
                part1++;
                part2++;
            } else if (a >= c && a <= d || b >= c && b <= d) {  // overlapping
                part2++;
            }
            
            s = r.readLine();
        }
        
        System.out.printf("Part 1: %3d ranges contained\n", part1);
        System.out.printf("Part 2: %3d ranges overlapping\n", part2);
    }
    
    /**
     * Provides the canonical entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.04 Camp Cleanup ***");
        System.out.println();
        
        new Puzzle().solve(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
