package day23;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Day 23 "Unstable Diffusion" parts 1 and 2.
 */
public class Puzzle {

    /**
     * An enum for the directions with a function for getting the next direction
     * including wrap-around.
     */
    enum Dir {
        NORTH, SOUTH, EAST, WEST;
        
        Dir next() {
            return switch(this) {
                case NORTH -> SOUTH;
                case SOUTH -> WEST;
                case WEST  -> EAST;
                case EAST  -> NORTH;
            };
        }
    }
    
    /**
     * Represents an Elf including its current and desired position.
     */
    class Elf {
        
        int x, y;
        
        int targetX, targetY;
        
        Elf(int i, int j) {
            x = i;
            y = j;
        }

        boolean alone() {
            return consider(Dir.NORTH) && consider(Dir.SOUTH) && consider(Dir.EAST) && consider(Dir.WEST);
        }
        
        boolean consider(Dir dir) {
            switch (dir) {
                case NORTH -> {
                    for (int i = y - 1; i < y + 2; i++) {
                        if (map.containsKey("" + (x - 1) + "/" + i)) {
                            return false;
                        }
                    }
                    return true;
                }
                
                case SOUTH -> {
                    for (int i = y - 1; i < y + 2; i++) {
                        if (map.containsKey("" + (x + 1) + "/" + i)) {
                            return false;
                        }
                    }
                    return true;
                }
                
                case WEST -> {
                    for (int i = x - 1; i < x + 2; i++) {
                        if (map.containsKey("" + i + "/" + (y - 1))) {
                            return false;
                        }
                    }
                    return true;
                }

                case EAST -> {
                    for (int i = x - 1; i < x + 2; i++) {
                        if (map.containsKey("" + i + "/" + (y + 1))) {
                            return false;
                        }
                    }
                    return true;
                }

                
            }

            throw new RuntimeException("Oops!");
        }
        
        @Override
        public String toString() {
            return "" + x + "/" + y;
        }
        
    }
    
    /**
     * Holds all the elves.
     */
    ArrayList<Elf> elves = new ArrayList();
    
    /**
     * The (hash) map, so we have O(1) when investigating fields.
     */
    HashMap<String, Integer> map = new HashMap();

    /**
     * The preferred direction 
     */
    Dir dir = Dir.NORTH;
    
    /**
     * The part 1 result.
     */
    int part1;
    
    /**
     * The part 2 result (aka the number of rounds).
     */
    int part2;
    
    /**
     * Prints the map and status.
     */
    void dump() {
        System.out.println("\033[2;0H");
        System.out.printf("Part 1: %4d    Part 2: %4d\n", part1, part2);
        System.out.println();
        
        for (int i = 15; i < 46; i++) {
            for (int j = 0; j < 80; j++) {
                if (map.getOrDefault("" + i + "/" + j, 0) == 1) {
                    System.out.print("#");
                } else {
                    System.out.print(".");
                }
            }
            System.out.println();
        }
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        int ii = 0;
        
        String s = r.readLine();
        while (s != null) {
            for (int j = 0; j < s.length(); j++) {
                if (s.charAt(j) == '#') {
                    Elf e = new Elf(ii ,j);
                    elves.add(e);
                    map.put(e.toString(), 1);
                }
            }
            ii++;
            s = r.readLine();
        }
    
        for (part2 = 1; part2 < 10000; part2++) {
            dump();
            
            HashMap<String, Integer> newMap = new HashMap();
    
            int ok = 0;
            
            for (Elf e: elves) {
                e.targetX = e.x;
                e.targetY = e.y;
                
                if (!e.alone()) {
                    Dir d = dir;
                    
                    for (int j = 0; j < 4; j++) {
                        if (e.consider(d)) {
                            switch (d) {
                                case NORTH ->  {
                                    e.targetX--;
                                }
                                case SOUTH ->  {
                                    e.targetX++;
                                }
                                case WEST ->  {
                                    e.targetY--;
                                }
                                case EAST ->  {
                                    e.targetY++;
                                }
                            }
                            
                            break;
                        }
                        
                        d = d.next();
                    }
                } else {
                    ok++;
                }
                
                String k = "" + e.targetX + "/" + e.targetY;
                newMap.put(k, newMap.getOrDefault(k, 0) + 1);
                
                if (part2 == 11) {
                    int minX = Integer.MAX_VALUE;
                    int minY = Integer.MAX_VALUE;
                    int maxX = Integer.MIN_VALUE;
                    int maxY = Integer.MIN_VALUE;

                    for (Elf f: elves) {
                        minX = Math.min(f.x, minX);
                        minY = Math.min(f.y, minY);
                        maxX = Math.max(f.x, maxX);
                        maxY = Math.max(f.y, maxY);
                    }
                    
                    part1 = (maxX - minX + 1) * (maxY - minY + 1) - elves.size();
                }
            }
            
            if (ok == elves.size()) {
                return;
            }

            map.clear();

            for (Elf e: elves) {
                
                if (newMap.get(e.targetX + "/" + e.targetY) == 1) {
                    e.x = e.targetX;
                    e.y = e.targetY;
                }
                
                map.put("" + e.x + "/" + e.y, 1);
            }
            
            dir = dir.next();
        }
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.print("\033[2J\033[H");
        System.out.println("*** AoC 2022.23 Unstable Diffusion ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
