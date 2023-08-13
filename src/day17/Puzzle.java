package day17;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

/**
 * Day 17 "Pyroclastic Flow" part 1.
 */
public class Puzzle {

    /**
     * The pieces as bitmaps.
     */
    static final int[][] PIECES = {
        {
            0b000111100,
            0b000000000,
            0b000000000,   
            0b000000000   
        },{
            0b000010000,
            0b000111000,
            0b000010000,
            0b000000000
        },{
            0b000111000,
            0b000001000,
            0b000001000,
            0b000000000,
        },{
            0b000100000,
            0b000100000,
            0b000100000,
            0b000100000
        },{
            0b000110000, 
            0b000110000,
            0b000000000,
            0b000000000   
        }
    };
    
    /**
     * The height of each piece.
     */
    static final int[] HEIGHTS = {1, 3, 3, 4, 2};
    
    /**
     * The size of our map.
     */
    static final int SIZE = 8192;
    
    /**
     * The actual map.
     */
    int[] map = new int[SIZE];
        
    /**
     * The complete jet we need to process.
     */
    char[] jet;

    /**
     * A count/height record needed for our cache mechanism in part 2.
     */
    record Info(int count, int height) {

    };
    
    /**
     * Loads the jet from the file.
     */
    void load(BufferedReader r) throws IOException {
        jet = r.readLine().toCharArray();
    }
    
    /**
     * Processes the first part.
     */
    void solve1() throws IOException {
        for (int i = 1; i < SIZE; i++) {
            map[i] = 0b100000001;
        }
        map[0] = 0b111111111;
        
        int nextJet = 0;
        int nextPiece = 0;
        int count = 1;
        
        int height = 0;
        
        while (true) {
            int[] piece = PIECES[nextPiece].clone();
            int position = height + 4;
            
            System.out.println("Piece " + count + " is type " + nextPiece + " and starts at position " + position);

            while (true) {
                int[] backup = piece.clone();
                
                if (jet[nextJet] == '<') {
                    System.out.print('<');
                    for (int i = 0; i < 4; i++) {
                        piece[i] = piece[i] << 1;
                    }
                } else {
                    System.out.print('>');
                    for (int i = 0; i < 4; i++) {
                        piece[i] = piece[i] >> 1;
                    }
                }

                nextJet = (nextJet + 1) % jet.length;

                for (int i = 0; i < 4; i++) {
                    if ((map[position + i] & (piece[i])) != 0) {
                        piece = backup;
                        System.out.print('X');
                        break;
                    }
                }

                int i = 0;
                while (i < 4 && (map[position + i - 1] & (piece[i])) == 0) {
                    i++;
                }

                if (i == 4) {
                    position--;
                } else {
                    System.out.println();
                    for (int j = 0; j < 4; j++) {
                        map[position + j] = map[position + j] | piece[j];
                    }
                    System.out.println("Piece " + count + " stops at position " + position);
                    
                    int min = Math.max(position - 5, 0);
                    
                    for (int j = 9; j >= 0; j--) {
                        for (int k = 8; k >= 0; k--) {
                            if ((map[min + j] & (1 << k)) != 0) {
                                System.out.print('#');
                            } else {
                                System.out.print('.');
                            }
                        }
                        System.out.println();
                    }
                    
                    height = Math.max(height, position + HEIGHTS[nextPiece] - 1);
                    nextPiece = (nextPiece + 1) % PIECES.length;
                    System.out.println("New height is " + height);
                    System.out.println();

                    if (count == 2022) {
                        System.out.println("Part 1: " + height);
                        System.out.println();
                        
                        return;
                    }

                    count++;
                    break;
                }
            }
        }
    }

    /**
     * Processes the second part.
     */
    void solve2() throws IOException {
        HashMap<Long, Info> seen = new HashMap();

        int cycle;
        long factor = -1;
        long target = 1000000000000l;
        int delta = -1;

        for (int i = 1; i < SIZE; i++) {
            map[i] = 0b100000001;
        }
        map[0] = 0b111111111;
        
        int nextJet = 0;
        int nextPiece = 0;
        int count = 1;
        
        int height = 0;
        
        while (true) {
            int[] piece = PIECES[nextPiece].clone();
            int position = height + 4;
            
            while (true) {
                int[] backup = piece.clone();
                
                if (jet[nextJet] == '<') {
                    for (int i = 0; i < 4; i++) {
                        piece[i] = piece[i] << 1;
                    }
                } else {
                    for (int i = 0; i < 4; i++) {
                        piece[i] = piece[i] >> 1;
                    }
                }

                nextJet = (nextJet + 1) % jet.length;

                for (int i = 0; i < 4; i++) {
                    if ((map[position + i] & (piece[i])) != 0) {
                        piece = backup;
                        break;
                    }
                }

                int i = 0;
                while (i < 4 && (map[position + i - 1] & (piece[i])) == 0) {
                    i++;
                }

                if (i == 4) {
                    position--;
                } else {
                    for (int j = 0; j < 4; j++) {
                        map[position + j] = map[position + j] | piece[j];
                    }
                    
                    height = Math.max(height, position + HEIGHTS[nextPiece] - 1);
                    nextPiece = (nextPiece + 1) % PIECES.length;

                    if (seen != null) {
                        if (height >= 8) {
                            long fingerprint = 0;
                            for (int j = 0; j < 6; j++) {
                                fingerprint = fingerprint << 9 | map[height - j];
                            }

                            fingerprint = fingerprint << 9 | nextJet;
                            Info info = seen.get(fingerprint);
                            if (info != null) {
                                boolean ok = true;
                                for (int l = 0; l < 100; l++) {
                                    if (map[info.height - l] != map[height - l]) {
                                        ok = false;
                                        break;
                                    }
                                }
                                
                                if (ok) {
                                    cycle = count - info.count;
                                    factor = (target - count) / cycle;
                                    delta = height - info.height;
                                    target = count + (target - count) % cycle;
                                    
                                    System.out.println("Cycle of length " + cycle + " from " + info.count +  " to " + count + " detected");
                                    System.out.println("Height delta per cycle is " + delta);
                                    System.out.println("Factor is " + factor);
                                    System.out.println("Reduced target is " + target);

                                    seen = null;
                                } else {
                                    seen.put(fingerprint, new Info(count, height));
                                    
                                }
                                
                            } else {
                                seen.put(fingerprint, new Info(count, height));
                            }
                        }
                    }
                    
                    if (count == target) {
                        System.out.println();
                        System.out.println("Part 2: " + (factor * delta + height));
                        
                        return;
                    }

                    count++;
                    break;
                }
            }
        }
    }

    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.17 Pyroclastic Flow ***");
        System.out.println();
        
        Puzzle p = new Puzzle();
        p.load(new BufferedReader(new FileReader(args[0])));
        p.solve1();
        p.solve2();
        
        System.out.println();
    }
    
}
