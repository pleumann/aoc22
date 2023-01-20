package day08;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 8 "Treetop Tree House" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Size of our map (in both dimensions).
     */
    int size;
    
    /**
     * The actual map containing the tree heights.
     */
    char[][] map;

    /**
     * The number of visible trees.
     */
    int totalVisible;

    /**
     * Best scenic score so far.
     */
    int highScore;

    /**
     * Calculates the scenic score for the given location.
     */
    void checkTree(int row, int column) {
        
        int height = map[row][column];
        int visible = 4;
        
        int left = column;
        while (left > 0) {
            left--;
            if (map[row][left] >= height) {
                visible--;
                break;
            }
        }

        int right = column;
        while(right < size - 1) {
            right++;
            if (map[row][right] >= height) {
                visible--;
                break;
            }
        }

        int up = row;
        while (up > 0) {
            up--;
            if (map[up][column] >= height) {
                visible--;
                break;
            }
        }

        int down = row;
        while (down < size - 1) {
            down++;
            if (map[down][column] >= height) {
                visible--;
                break;
            }
        }

        if (visible > 0) {
            totalVisible++;
        }
        
        int score = (column - left) * (right - column) * (row - up) * (down - row);
        if (score > highScore) {
            highScore = score;
        }
    }
        
    /**
     * Processes the whole input.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        
        size = s.length();
        
        map = new char[size][];
        
        for (int i = 0; i < size; i++) {
            map[i] = s.toCharArray();

            s = r.readLine();
        }
    
        for (int i = 0; i < size; i++) {
            for (int j = 0 ; j < size; j++) {
                checkTree(i, j);
            }
        }
        
        System.out.println("Part 1: " + totalVisible + " trees are visible.");
        System.out.println("Part 2: Scenic score is " + highScore + ".");
    }    
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.08 Treetop Tree House ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
