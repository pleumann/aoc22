package day06;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;

/**
 * Day 6 "Tuning Trouble" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Finds, within the given string, a marker of the given length.
     */
    int findMarker(String s, int count) {
        for (int i = count; i < s.length(); i++) {
            HashSet<Character> c = new HashSet();
            for (int j = i - count; j < i; j++) {
                c.add(s.charAt(j));
            }
            if (c.size() == count) {
                return i;
            }
        }
        
        return -1;
    }

    /**
     * Finds, within the given string, a marker of the given length. Uses a
     * sliding window that keeps track of occurence counts of each character.
     */
    int findMarkerImproved(String s, int count) {
        int[] letters = new int[26];
        int unique = 0;

        for (int i = 0; i < s.length(); i++) {
            if (i >= count) {
                int c = s.charAt(i - count) - 'a';
                if (letters[c] > 0) {
                    letters[c]--;
                    if (letters[c] == 0) {
                        unique--;
                    }
                }
            }

            int c = s.charAt(i) - 'a';
            letters[c]++;
            if (letters[c] == 1) {
                unique++;
            }

            if (unique == count) {
                return i + 1;
            }
        }

        return -1;
    }
    
    /**
     * Processes the whole input.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        
        while (s != null) {
            System.out.println(s);            
            System.out.println();
            System.out.println("Part 1: Start of packet  = " + findMarkerImproved(s, 4));
            System.out.println("Part 2: Start of message = " + findMarkerImproved(s, 14));
            System.out.println();
            
            s = r.readLine();
        }
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.06 Tuning Trouble ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
