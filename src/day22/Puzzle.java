package day22;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 22 "Monkey Map" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.22 Monkey Map ***");
        System.out.println();
        
        int part1 = new Puzzle1().process(new BufferedReader(new FileReader(args[0])));
        int part2 = new Puzzle2().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
        System.out.println("Part 1: " + part1);
        System.out.println("Part 2: " + part2);
        System.out.println();
    }
    
}
