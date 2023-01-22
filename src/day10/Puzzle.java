package day10;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 10 "Cathode-Ray Tube" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Processes the whole input.
     */
    void process(BufferedReader r) throws IOException {
        
        int cycle = 0;              // Current cycle
        int x = 1;                  // Register value
        int v = 0;                  // Value for "delayed add"
        boolean waitState = false;  // For 2-cycle instructions

        int signal = 0;             // Sum of signal strengths
        int measureAt = 20;         // Next data point to measure

        int beamPos = 1;            // Current beam position
        
        String s = r.readLine();
        while (s != null) {
            cycle += 1;

            // Signal strength measurement (part 1)
            if (cycle == measureAt) {
                signal += cycle * x;
                if (measureAt <= 280) measureAt += 40;
            }

            // CRT output generation (part 2)
            if (x >= beamPos -2 && x <= beamPos) {
                System.out.print("#");
            } else {
                System.out.print(" ");
            }
            beamPos++;
            if (beamPos == 41) {
                beamPos = 1;
                System.out.println();
            }

            // Instruction handling
            if (waitState) {
                x += v;
                waitState = false;
            } else {
                if (s.startsWith("noop")) {
                } else if (s.startsWith("addx")) {
                    v = Integer.parseInt(s.substring(5));
                    waitState = true;
                }

                s = r.readLine();
            }       
        }
        
        System.out.println();
        System.out.println("Signal strengths: " + signal);
    }    
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.10 Cathode-Ray Tube ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
