package day24;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;

/**
 * Day 24 "Blizzard Basin" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Map size.
     */
    int width, height;
    
    /**
     * Represents a single blizzard.
     */
    class Blizzard {
        /**
         * Starting coordinates and delta.
         */
        int sx, sy, dx, dy;

        /**
         * Creates a blizzard from the given values.
         */
        Blizzard(int x, int y, char c) {
            sx = x;
            sy = y;
            
            switch (c) {
                case '<' -> dx = -1;
                case '>' -> dx = +1;
                case '^' -> dy = -1;
                case 'v' -> dy = +1;
            }
        }
        
        /**
         * Checks if this blizzard hits the given position at the given minute.
         */
        boolean isAt(int x, int y, int minute) {
            return (width * width * width + sx + (minute * dx)) % width == x && (height * height * height + sy + (minute * dy)) % height == y;
        }
    }

    /**
     * Represents a single cell on the map. Each cell knows the blizzards it is
     * potentially affected by.
     */
    class Cell {
        /**
         * The blizzards that can affect this cell.
         */
        ArrayList<Blizzard> blizzards = new ArrayList();
        
        /**
         * The cell coorsinates.
         */
        int x, y;
        
        /**
         * Creates a new cell.
         */
        Cell(int x, int y) {
            this.x = x;
            this.y = y;
        }

        /**
         * Returns the number of blizzards hitting this cell at the given minute.
         */
        int getNumBlizzards(int minute) {
            int result = 0;
            for (Blizzard b: blizzards) {
                if (b.isAt(x, y, minute)) {
                    result++;
                }
            }
            
            return result;
        }
        
    }
    
    /**
     * The whole map.
     */
    Cell[][] map;

    /**
     * The set of cells that can currently be occupied by an Elf.
     */
    HashSet<Cell> states = new HashSet();
    
    /**
     * Prints the map at the given point of time.
     */
    void dump(int minute) {
        System.out.println("Map at minute " + minute);
        for (int j = 0; j < height; j++) {
            for (int i = 0; i < width; i++) {
                if (map[i][j].getNumBlizzards(minute) > 0) {
                    System.out.print('B');
                } else {
                    System.out.print('.');
                }
            }
            System.out.println();
        }
        System.out.println();
    }

    /**
     * Simulates the elf taking the trip from the given origin (at the given
     * time) to the given target. Returns the minute when the target has been
     * reached.
     */
    int simulate(int minute, Cell start, Cell goal) {
        states.clear();
        states.add(start);
       
        while (!states.contains(goal)) {
            HashSet<Cell> newStates = new HashSet();

            for (Cell c: states) {
                if (c.y != -1 && c.y != height) {
                    if (c.x > 0) {
                        Cell d = map[c.x - 1][c.y];
                        if (d.getNumBlizzards(minute) == 0) {
                            newStates.add(d);
                        }
                    }

                    if (c.x + 1 < width) {
                        Cell d = map[c.x + 1][c.y];
                        if (d.getNumBlizzards(minute) == 0) {
                            newStates.add(d);
                        }
                    }
                }

                if (c.y > 0) {
                    Cell d = map[c.x][c.y - 1];
                    if (d.getNumBlizzards(minute) == 0) {
                        newStates.add(d);
                    }
                }

                if (c.y + 1 < height) {
                    Cell d = map[c.x][c.y + 1];
                    if (d.getNumBlizzards(minute) == 0) {
                        newStates.add(d);
                    }
                }

                if (c.getNumBlizzards(minute) == 0) {
                    newStates.add(c);
                }
            }

            System.out.println("New states at minute " + minute + ": " + newStates.size());
            states = newStates;
            minute++;            
        }
        
        System.out.println("Goal reached at " + minute + "!");

        return minute;
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        ArrayList<String> lines = new ArrayList();
        
        String s = r.readLine();
        while (s != null) {
            lines.add(s);
            s = r.readLine();
        }

        width = lines.get(0).length() - 2;
        height = lines.size() - 2;
        
        System.out.println("Map is " + width + " x " + height);
        
        map = new Cell[width][height];
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                map[i][j] = new Cell(i, j);
            }
        }

        for (int j = 0; j < height; j++) {
            s = lines.get(1 + j);
            for (int i = 0; i < width; i++) {
                char c = s.charAt(1 + i);
                if (c != '.') {
                    Blizzard b = new Blizzard(i, j, c);
                    
                    for (int k = 0; k < width; k++) {
                        map[k][j].blizzards.add(b);
                    }

                    for (int k = 0; k < height; k++) {
                        map[i][k].blizzards.add(b);
                    }
                }
            }
        }

        Cell start = new Cell(0, -1);
        Cell target = new Cell(width - 1, height);
        
        int minute = simulate(1, start, map[width - 1][height - 1]);
        dump(minute);
        
        int minute2 = simulate(minute + 1, target, map[0][0]);
        dump(minute2);

        int minute3 = simulate(minute2 + 1, start, map[width - 1][height - 1]);
        dump(minute3);
        
        System.out.println();
        System.out.println("Part 1: " + minute);
        System.out.println("Part 2: " + minute3);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.24 Blizzard Basin ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));        
    }
    
}
