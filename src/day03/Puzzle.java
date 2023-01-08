package day03;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 3 "Rucksack Reorganization" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Returns a long representing the letters in the given string as a bitset.
     */
    static long strToSet(String s) {
        long l = 0;
        
        for (char c: s.toCharArray()) {
            if (Character.isLowerCase(c)) {
                l |= 1l << (c - 'a');
            } else {
                l |= 1l << (c - 'A' + 26);
            }
        }
        
        return l;
    }

    /**
     * Returns the sum of all priorities contained in the given long value.
     */
    static int setToInt(long l) {
        int i = 1;
        int p = 0;
        
        while (l != 0) {
            if ((l & 1) == 1) {
                p += i;
            }
            
            l = l >> 1;
            i++;
        }
        
        return p;
    }
    
    /**
     * Returns the priority sum according to the rules of part 1.
     */
    int sum1(String s) {
        int l = s.length() / 2;
        return setToInt(strToSet(s.substring(0, l)) & strToSet(s.substring(l))); 
    }

    /**
     * Returns the priority sum according to the rules of part 2.
     */
    int sum2(String s, String t, String u) {
        return setToInt(strToSet(s) & strToSet(t) & strToSet(u));
    }
    
    /**
     * Solves the puzzle for the input coming from the given reader.
     */    
    void solve(BufferedReader r) throws IOException {
        int part1 = 0;
        int part2 = 0;
        
        String s = r.readLine();
        while (s != null) {
            String t = r.readLine();
            String u = r.readLine();
    
            part1 += sum1(s) + sum1(t) + sum1(u);
            part2 += sum2(s, t, u);
            
            s = r.readLine();
        }

        System.out.printf("Part 1: sum of priorities is %4d\n", part1);
        System.out.printf("Part 2: sum of priorities is %4d\n", part2);
    }
    
    /**
     * Provides the canonical entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.03 Rucksack Reorganization ***");
        System.out.println();
        
        new Puzzle().solve(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
