package day14;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

/**
 * Day 14 "Regolith Reservoir" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Represents a coordinate tuple and helps us somewhat with the parsing.
     */
    record Point(int x, int y) {
        
        static Point parse(String s) {
            String[] a = s.split(",");
            return new Point(Integer.parseInt(a[0]), Integer.parseInt(a[1]));
        }
        
    }
    
    /**
     * Holds the whole map including sand.
     */
    char[][] map = new char[1000][200];

    /**
     * The bottom according to the puzzle text (i.e. 2 below lowest rock).
     */
    int bottom = 0;  

    /**
     * Loads the puzzle input.
     */
    void load(BufferedReader r) throws IOException {
        for (char[] c: map) {
            Arrays.fill(c, ' ');
        }
        
        String s = r.readLine();
        while (s != null) {
            String[] points = s.split(" -> ");
            
            Point p = Point.parse(points[0]);
            bottom = Math.max(bottom, p.y + 2);
            for (int i = 1; i < points.length; i++) {
                Point q = Point.parse(points[i]);
                bottom = Math.max(bottom, q.y + 2);
                                
                if (p.x < q.x) {
                    for (int j = p.x; j <= q.x; j++) {
                        map[j][p.y] = '#';
                    }
                } else if (p.x > q.x) {
                    for (int j = q.x; j <= p.x; j++) {
                        map[j][p.y] = '#';
                    }
                } else if (p.y < q.y) {
                    for (int j = p.y; j <= q.y; j++) {
                        map[p.x][j] = '#';
                    }
                } else if (p.y > q.y) {
                    for (int j = q.y; j <= p.y; j++) {
                        map[p.x][j] = '#';
                    }
                }
                
                p = q;
            }
            
            s = r.readLine();
        }
    }
    
    /**
     * Simulates the sand falling.
     */
    void solve() {
        int count = 0;
        int abyss = 0;
        
        while (true) {
            count++;
            int x = 500;
            int y = 0;
            
            while (y < bottom - 1) {
                if (map[x][y + 1] == ' ') {
                    y++;
                } else if (map[x - 1][y + 1] == ' ') {
                    x--;
                    y++;
                } else if (map[x + 1][y + 1] == ' ') {
                    x++;
                    y++;
                } else {
                    break;
                }
            }
            
            map[x][y] = 'o';
            if (y == 0) {
                break;
            } else if (y == bottom - 1 && abyss == 0) {
                abyss = count - 1;
            }
        }
         
        System.out.println("Part 1: " + abyss);
        System.out.println("Part 2: " + count);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.14 Regolith Reservoir ***");
        System.out.println();
        
        Puzzle p = new Puzzle();
        p.load(new BufferedReader(new FileReader(args[0])));
        p.solve();
        
        System.out.println();
    }
    
}
