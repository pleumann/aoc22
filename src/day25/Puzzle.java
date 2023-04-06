package day25;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 25 "Full of Hot Air" part 1.
 */
public class Puzzle {

    /**
     * Converts a snafu number to a decimal number. Nothing special here.
     */
    long snafuToDecimal(String snafu) {
        long l = 0;
        
        for (char c: snafu.toCharArray()) {
            l = l * 5 + switch(c) {
                case '0' -> 0;
                case '1' -> 1;
                case '2' -> 2;
                case '-' -> -1;
                case '=' -> -2;
                default -> throw new RuntimeException("Oops!"); 
            };
        }
        
        return l;
    }

    /**
     * Converts a decimal number to a snafu number by first adding the snafu
     * number 222...222 of same length, then using normal modulo rules, then
     * converting back. Not sure if it's *the* way to do it, but it seemed quite
     * straighforward.
     */
    String decimalToSnafu(long decimal) {
        long place = 1;
        long adjusted = decimal;
        while (place < decimal) {
            adjusted = adjusted + 2 * place;
            place = place * 5;
        }
        
        StringBuilder sb = new StringBuilder();
        
        while (adjusted != 0) {
            int mod = (int)(adjusted % 5);
            sb.insert(0, switch (mod) {
                case 4 -> '2';
                case 3 -> '1';
                case 2 -> '0';
                case 1 -> '-';
                case 0 -> '=';
                default -> throw new RuntimeException("Oops!");
            });
            adjusted = adjusted / 5;
        }
        
        return sb.toString();        
    }

    /*    
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        long sum = 0;

        System.out.println("               Snafu    Decimal");
        System.out.println("--------------------------------------");

        String s = r.readLine();
        while (s != null) {
            long decimal = snafuToDecimal(s);
            System.out.printf("%20s -> %d\n", s, decimal);
            sum += decimal;
            s = r.readLine();
        }
        
        System.out.println("--------------------------------------");
        System.out.printf("%20s <- %d\n", decimalToSnafu(sum), sum);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.25 Full of Hot Air ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
