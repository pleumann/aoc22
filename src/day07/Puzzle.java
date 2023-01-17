package day07;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 7 "No Space Left on Device" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Minimum bytes we need to free for the update.
     */
    int missing;

    /**
     * Result for part 1, sum of small directories.
     */
    int bestSum;
    
    /**
     * Result for part 2, size of directory to be deleted..
     */    
    int bestSize = Integer.MAX_VALUE;
    
    /**
     * Name of directory be deleted.
     */
    String bestName;
    
    /**
     * Recursively parses the input, traversing directories and updating stats
     * in the process. Returns the total size of a directory.
     */
    int handleDir(BufferedReader r, String dir) throws IOException {
        int size = 0;
        
        String s = r.readLine();
        while (s != null && !s.equals("$ cd ..")) {
            if (s.startsWith("$ cd ")) {
                size += handleDir(r, dir + s.substring(5) + "/");
            } else if (s.equals("$ ls")) {
                // Nothing do to
            } else {
                String[] a = s.split((" "));
                if (!a[0].equals("dir")) {
                    size += Integer.parseInt(a[0]);
                }
            }
            
            s = r.readLine();
        }
        
        if (size <= 100000) {
            bestSum += size;
        }
        
        if (size >= missing && size <= bestSize) {
            bestSize = size;
            bestName = dir;
        }
        
        return size;
    }
    
    /**
     * Processes the whole input.
     */
    void process(String file) throws IOException {
        System.out.println("Traversing directories...");
        
        BufferedReader r = new BufferedReader(new FileReader(file));
        r.readLine();
        int used = handleDir(r, "/");
       
        missing = 30000000 - (70000000 - used);
        bestSize = Integer.MAX_VALUE;

        System.out.println();
        System.out.println("Allocated bytes: " + used);
        System.out.println("Required bytes : " + missing);
        System.out.println("Small dir sum  : " + bestSum + " (part 1 result)");
        System.out.println();
        System.out.println("Traversing directories...");
        
        r = new BufferedReader(new FileReader(file));
        r.readLine();
        handleDir(r, "/");

        System.out.println();
        System.out.println("Dir to delete  : " + bestName);
        System.out.println("Resulting bytes: " + bestSize + " (part 2 result)");
    }
        
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.07 No Space Left on Device ***");
        System.out.println();
        
        new Puzzle().process(args[0]);
        
        System.out.println();
    }
    
}
