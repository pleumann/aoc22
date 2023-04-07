package day12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Day 12 "Hill Climbing Algorithm" parts 1 and 2.
 */
public class Puzzle {

    /**
     * The height map.
     */
    char[][] map;

    /**
     * The cost for a trail that starts here and leads to the target.
     */
    int[][] cost;

    /**
     * The width and height of the map.
     */
    int width, height;
    
    /**
     * The origin of the trail for part 1.
     */
    int originX, originY;
    
    void load(BufferedReader r) throws IOException {
        ArrayList<String> l = new ArrayList();
        
        String s = r.readLine();
        while (s != null) {
            l.add(s);            
            s = r.readLine();
        }
        
        width = l.get(0).length();
        height = l.size();
        
        map = new char[height][];
        cost = new int[height][];
        
        for (int i = 0; i < height; i++) {
            map[i] = l.get(i).toCharArray();
            cost[i] = new int[width];
            Arrays.fill(cost[i], 9999);

            int p = l.get(i).indexOf('S');
            if (p != -1) {
                System.out.printf("Origin is at %d,%d.\n", i, p);
                map[i][p] = 'a';
                originX = i;
                originY = p;
            }
            
            p = l.get(i).indexOf('E');
            if (p != -1) {
                System.out.printf("Target is at %d,%d.\n", i, p);
                map[i][p] = 'z';
                cost[i][p] = 0;
            }
        }
        
        System.out.println();
    }    
    
    /**
     * Tries to update the cost for field x,y by considering to move to a
     * neighbour that has height h and cost c. Returns true if an update was
     * made, i.e. a better way was found.
     */
    boolean update(int x, int y, char h, int c) {
        if (h <= map[x][y] + 1 && c + 1 < cost[x][y]) {
            cost[x][y] = c + 1;
            return true;
        }
        
        return false;
    }
    
    /**
     * Performs a single iteration, trying to find better cost values for all
     * fields by considering to come there from any of the four neighbours.
     * Returns true to indicate a change was made (and we need another round).
     */
    boolean think() {
        boolean again = false;
        
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                char h = map[i][j];
                int c = cost[i][j];

                if (i > 0 && update(i - 1, j, h, c)) {
                    again = true;
                }

                if (i < height - 1 && update(i + 1, j, h, c)) {
                    again = true;
                }

                if (j > 0 && update(i, j - 1, h, c)) {
                    again = true;
                }
                
                if (j < width - 1 && update(i, j + 1, h, c)) {
                    again = true;
                }
            }
        }
        
        return again;
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        load(r);

        while (think()) {
            System.out.print('.');
        }
        
        int best = Integer.MAX_VALUE;
              
        System.out.println();
        System.out.println();
        System.out.printf("Part 1: Trail starting at %2d,%2d has cost %d.\n", originX, originY, cost[originX][originY]);
        
        int bestX = -1;
        int bestY = -1;
        
        for (int i = 0; i < height; i++) {
           for (int j = 0; j < width; j++) {
               if (map[i][j] == 'a' && cost[i][j] < best) {
                   best = cost[i][j];
                   bestX = i;
                   bestY = j;
               }
           }
        }

        System.out.printf("Part 2: Trail starting at %2d,%2d has cost %d.\n", bestX, bestY, best);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.12 Hill Climbing Algorithm ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
