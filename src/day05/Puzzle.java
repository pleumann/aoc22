package day05;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Stack;

/**
 * Day 5 "Supply Stacks" parts 1 and 2.
 */
public class Puzzle {

    /**
     * Number of stacks available, not all have to be used.
     */
    static final int STACKS = 10;
    
    /**
     * Stacks of crates for part 1.
     */
    Stack<Character>[] stacks = new Stack[STACKS];

    /**
     * Stacks of crates for part 2.
     */
    Stack<Character>[] stacks2 = new Stack[STACKS];
    
    /**
     * Initializes the puzzle object.
     */
    Puzzle() {
        for (int i = 0; i < STACKS; i++) {
            stacks[i] = new Stack();
            stacks2[i] = new Stack();
        }
    }

    void dump() {
        for (Stack s: stacks) {
            for (int i = 0; i < s.size(); i++) {
                System.out.print(s.get(i));
            }
            System.out.println();
        }

        System.out.println();

        for (Stack s: stacks2) {
            for (int i = 0; i < s.size(); i++) {
                System.out.print(s.get(i));
            }
            System.out.println();
        }
    }
    
    /**
     * Moves a number of crates from one stack to another according to the rules
     * of part 1 (reverse order).
     */
    void move(int count, int from, int to) {
        for (int i = 0; i < count; i++) {
            stacks[to - 1].push(stacks[from - 1].pop());
        }

    }

    /**
     * Moves a number of crates from one stack to another according to the rules
     * of part 2 (existing order).
     */
    void move2(int count, int from, int to) {
        Stack<Character> temp = new Stack();
        
        for (int i = 0; i < count; i++) {
            temp.push(stacks2[from - 1].pop());
        }
        
        for (int i = 0; i < count; i++) {
            stacks2[to - 1].push(temp.pop());
        }
    }
    
    /**
     * Processes the whole input.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        while (s.contains("[")) {
            for (int i = 0; i < s.length() / 4 + 1; i++) {
                char c = s.charAt(4 * i + 1);
                if (c != ' ') {
                    stacks[i].add(0, c);
                    stacks2[i].add(0, c);
                }
            }
            
            s = r.readLine();
        }
 
        s = r.readLine(); // Consume empty line
        s = r.readLine();
        
        while (s != null) {
            System.out.println(s);
            
            String[] a = s.split(("[a-z ]+"));
            int count = Integer.parseInt(a[1]);
            int from = Integer.parseInt(a[2]);
            int to = Integer.parseInt(a[3]);
                    
            move(count, from, to);
            move2(count, from, to);
            
            s = r.readLine();
        }
        
        System.out.println();
        
        System.out.print("Part 1: Crates on top are ");
        for (Stack t: stacks) {
            if (!t.isEmpty()) {
                System.out.print(t.peek());
            }
        }
        System.out.println();

        System.out.print("Part 2: Crates on top are ");
        for (Stack t: stacks2) {
            if (!t.isEmpty()) {
                System.out.print(t.peek());
            }
        }
        System.out.println();
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.05 Supply Stacks ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
