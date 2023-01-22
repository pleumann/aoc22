package day09;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;

/**
 * Day 9 "Rope Bridge" part 2.
 */
public class Puzzle {

    /**
     * Holds then umber of knots our bridge has.
     */
    int knots;
    
    /**
     * Hold the x and y values of the bridge, head first.
     */
    int[] x, y;

    /**
     * Hold the maximum range visited so far.
     */
    int xMin, xMax, yMin, yMax;
    
    /**
     * Creates a puzzle instance for the given number of knots.
     */
    public Puzzle(int knots) {
        this.knots = knots;
        this.x = new int[knots];
        this.y = new int[knots];
    }
    
    /**
     * Returns the sign of an integer, i.e. -1, 0, or 1.
     */
    int sign(int x) {
        return x > 0 ? 1 : x < 0 ? -1 : 0;    
    }
    
    /**
     * Moves the head of the bridge into the given direction, adjusts the tail.
     */
    void move(char dir) {
        switch (dir) {
           case 'R' -> x[0] += 1;
           case 'L' -> x[0] -= 1;
           case 'U' -> y[0] += 1;
           case 'D' -> y[0] -= 1;
        }
        
        xMin = Math.min(xMin, x[0]);
        xMax = Math.max(xMax, x[0]);
        yMin = Math.min(yMin, y[0]);
        yMax = Math.max(yMax, y[0]);
        
        for (int i = 1; i < knots; i++) {
            int dx = x[i - 1] - x[i];
            int dy = y[i - 1] - y[i];
            
            if (Math.abs(dx) > 1 || Math.abs(dy) > 1) {
                x[i] += sign(dx);
                y[i] += sign(dy);
            }
        }
    }
    
    /**
     * Processes the whole input.
     */
    int process(BufferedReader r) throws IOException {
        HashSet<String> seen = new HashSet();

        String s = r.readLine();
        while (s != null) {
            char dir = s.charAt(0);
            int steps = Integer.parseInt(s.substring(2));
            
            for (int i = 0; i < steps; i++) {
                move(dir);
                seen.add("" + x[knots - 1] + "/" + y[knots - 1]);
            }
            
            s = r.readLine();
        }
        
        return seen.size();
    }    
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.09 Rope Bridge ***");
        System.out.println();

        System.out.printf("Part 1: %4d visited positions\n", 
            new Puzzle(2).process(new BufferedReader(new FileReader(args[0]))));

        System.out.printf("Part 2: %4d visited positions\n", 
            new Puzzle(10).process(new BufferedReader(new FileReader(args[0]))));

        System.out.println();
    }
    
}
