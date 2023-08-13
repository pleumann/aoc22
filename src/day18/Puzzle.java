package day18;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 18 "Boiling Boulders" parts 1 and 2.
 */
public class Puzzle {
    
    static final int AIR   = 0;
    
    static final int STONE = 1;
    
    static final int WATER = 2;

    /**
     * Our 3D map.
     */
    int[][][] map = new int[20][20][20];

    /**
     * Determines the total number of visible cube sides. A cube side is visible
     * if it is on the outer edge of the map or its immediate neighbour is AIR.
     */
    int visible() {
        int count = 0;
        
        for (int i = 0; i < 20; i++) {
            for (int j = 0; j < 20; j++) {
                for (int k = 0; k < 20; k++) {
                    if (map[i][j][k] == STONE) {
                        if (i ==  0 || map[i - 1][j][k] == AIR) {
                            count++;
                        }
                        if (i == 19 || map[i + 1][j][k] == AIR) {
                            count++;
                        }
                        if (j ==  0 || map[i][j - 1][k] == AIR) {
                            count++;
                        }
                        if (j == 19 || map[i][j + 1][k] == AIR) {
                            count++;
                        }
                        if (k ==  0 || map[i][j][k - 1] == AIR) {
                            count++;
                        }
                        if (k == 19 || map[i][j][k + 1] == AIR) {
                            count++;
                        }
                    }
                }
            }
        }
        
        return count;
    }
    
    /**
     * Recursively flood-fills the AIR in the map with WATER.
     */
    void flood(int x, int y, int z) {
        if (map[x][y][z] == AIR) {
            map[x][y][z] = WATER;
            
            if (x >  0) flood(x - 1, y, z);
            if (x < 19) flood(x + 1, y, z);
            if (y >  0) flood(x, y - 1, z);
            if (y < 19) flood(x, y + 1, z);
            if (z >  0) flood(x, y, z - 1);
            if (z < 19) flood(x, y, z + 1);
        }
    }
    
    /**
     * Inverts the map. STONE becomes AIR and vice versa. WATER stays as-is.
     */
    void invert() {
        for (int i = 0; i < 20; i++) {
            for (int j = 0; j < 20; j++) {
                for (int k = 0; k < 20; k++) {
                    if (map[i][j][k] == AIR) {
                        map[i][j][k] = STONE;
                    } else if (map[i][j][k] == STONE) {
                        map[i][j][k] = AIR;
                    }
                }
            }
        }
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        while (s != null) {
            String[] a = s.split(",");
            int x = Integer.parseInt(a[0]);
            int y = Integer.parseInt(a[1]);
            int z = Integer.parseInt(a[2]);
            
            map[x][y][z] = 1;
            
            s = r.readLine();
        }

        int v1 = visible();

        System.out.println("Overall surface : " + v1);

        flood(0, 0, 0);
        invert();

        int v2 = visible();

        System.out.println("Internal surface: " + v2);
        System.out.println("External surface: " + (v1 - v2));
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.18 Boiling Boulders ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
