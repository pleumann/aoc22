package day11;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Day 11 "Monkey in the Middle" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Represents a single monkeys and its items.
     */
    class Monkey implements Comparable {
        /**
         *  The number of the monkey.
         */
        int number;
        
        /**
         * The initial items of the monkey. Needed because items change during
         * part 1.
         */
        ArrayList<Long> initialItems;
        
        /**
         * The actual items of the monkey.
         */
        ArrayList<Long> items;
        
        /**
         * The operation the monkey applies, one of '+', '-', '*' or '/'.
         */
        char opType;
        
        /**
         * The RHS argument of the operation. -1 means same as LHS argument.
         */
        long opArg;
        
        /**
         * The number to use for the divisability test.
         */
        long test;
        
        /**
         * Where the number goes after a successful test.
         */
        int ifTrue;
        
        /**
         * Where the number goes after an unsuccessful test.
         */
        int ifFalse;
        
        /**
         * The monkey's activity level.
         */
        long activity;
        
        /**
         * Parses a monkey description, initializes the object.
         */
        Monkey(BufferedReader r) throws IOException {
            String s = r.readLine();
            number = Integer.parseInt(s.substring(7, s.length() - 1));
            
            initialItems = new ArrayList();
            items = new ArrayList();
            
            s = r.readLine();
            String[] a = s.substring(18).split(", ");
            for (String t: a) {
                initialItems.add(Long.parseLong(t));
            }

            s = r.readLine();
            opType = s.charAt(23);
            try {
                opArg = Integer.parseInt(s.substring(25));
            } catch (Exception e) {
                opArg = -1;
            }

            s = r.readLine();
            test = Integer.parseInt(s.substring(21));
            s = r.readLine();
            ifTrue = Integer.parseInt(s.substring(29));
            s = r.readLine();
            ifFalse = Integer.parseInt(s.substring(30));
        }
        
        /**
         * Resets the monkey.
         */
        void reset(){
            items.clear();
            items.addAll(initialItems);
            activity = 0;
        }
        
        /**
         * Dumps the monkey's state.
         */
        void dump() {
            System.out.println("--- Monkey " + number + " ---");
            for (long i: items) {
                System.out.print(i + " ");
            }
            System.out.println();
            System.out.println(opType + " " + opArg);
            System.out.println("if true " + ifTrue +  " else " + ifFalse);
        }
        
        /**
         * Simulates the monkey according to the rules of the given part until
         * it possesses no more items.
         */
        void simulate(int part) {
            while (!items.isEmpty()) {
                long i = items.get(0);
                items.remove(0);
                
                activity++;
                
                System.out.println("Inspect " + i);
                
                if (opType == '+') {
                    i = i + (opArg == -1 ? i : opArg);
                } else {
                    i = i * (opArg == -1 ? i : opArg);
                }

                System.out.println("After operation " + i);

                if (part == 1) {
                    i = i / 3;
                } else {
                    i = i % modulus;
                }
                
                System.out.println("After divide/modulus " + i);
                
                if (i % test == 0) {
                    System.out.println("Divisible by " + test + " throw to " + ifTrue);
                    monkeys.get(ifTrue).items.add(i);
                } else {
                    System.out.println("Not divisible by " + test + " throw to " + ifFalse);
                    monkeys.get(ifFalse).items.add(i);
                }
            }
        }

        @Override
        public int compareTo(Object o) {
            if (o instanceof Monkey m) {
                long l = m.activity - activity;
                return l > 0 ? 1 : l < 0 ? -1 : 0;
            } else {
                throw new UnsupportedOperationException("Oops!");
            }
        }
    }

    /**
     * The list of all monkeys.
     */
    ArrayList<Monkey> monkeys = new ArrayList();
    
    /**
     * The modulus to apply for part 2.
     */
    long modulus = 1;
    
    /**
     * Greates common divisor.
     */
    long gcd(long x, long y) {
        while (x != y) {
            if (x < y) {
                y = y - x;
            } else {
                x = x - y;
            }
        }
        
        return x;
    }

    /**
     * Lowest common multiple.
     */
    long lcm(long x, long y) {
        return x * y / gcd(x, y);
    }

    /**
     * Loads the input.
     */
    void load(BufferedReader r) throws IOException {
        do {
            Monkey m = new Monkey(r);
            monkeys.add(m);
            m.dump();            
            modulus = lcm(modulus, m.test);
        } while (r.readLine() != null);
        
        System.out.println("Modulus is " + modulus);
    }
    
    /**
     * Simulates the monkeys according to the rules of the given part and for
     * the given number of rounds.
     */
    long solve(int part, int rounds) throws IOException {
        for (Monkey m: monkeys) {
            m.reset();
        }
        
        for (int i = 0; i < rounds; i++) {
            System.out.println();
            System.out.println("===== Round " + i + " =====");
            System.out.println();
            
            for (Monkey m: monkeys) {
                m.simulate(part);
            }
        }
        
        Monkey[] sortedMonkeys = monkeys.toArray(new Monkey[0]);
        Arrays.sort(sortedMonkeys);
        
        long a = sortedMonkeys[0].activity;
        long b = sortedMonkeys[1].activity;
        
        System.out.println("The level of monkey business is " + a * b + ".");
        
        return a * b;
    }    
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.11 Monkey in the Middle ***");
        System.out.println();
        
        Puzzle p = new Puzzle();
        p.load(new BufferedReader(new FileReader(args[0])));
        long part1 = p.solve(1, 20);
        long part2 = p.solve(2, 10000);
        
        System.out.println();
        System.out.println("Part 1: " + part1);
        System.out.println("Part 2: " + part2);
        System.out.println();
    }
    
}
