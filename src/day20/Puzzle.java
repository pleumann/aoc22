package day20;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Day 18 "Boiling Boulders" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Represents a single number including its location in the "mixed" list.
     */
    class Node {
        
        long value;
        
        Node previous, next;
        
        Node(long i) {
            value = i;
            
            previous = this;
            next = this;
        }
        
        Node(long i, Node prev, Node next) {
            value = i;
            
            prev.next = this;
            previous = prev;

            next.previous = this;
            this.next = next;
        }

        void move(Node previous, Node next) {
            if (previous == this || next == this) {
                return;
            }
            
            this.previous.next = this.next;
            this.next.previous = this.previous;

            this.previous = previous;
            this.previous.next = this;
            
            this.next = next;
            this.next.previous = this;
        }
        
        void mix() {
            Node node = this;
            
            if (value > 0) {
                for (int j = 0; j < value % (count - 1); j++) {
                    node = node.next;
                }
                
                move(node, node.next);
            } else if (value < 0) {
                for (int j = 0; j < (-value) % (count - 1); j++) {
                    node = node.previous;
                }
 
                move(node.previous, node);
            }
        }
        
        void dump() {
            Node node = this;
            do {
                System.out.print(node.value + " -> ");
                node = node.next;
            } while (node != this);
            System.out.println();
        }
        
    }
    
    int count;
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r, long factor, int rounds) throws IOException {
        ArrayList<Node> list = new ArrayList();
        
        String s = r.readLine();
        
        Node first = new Node(Long.parseLong(s) * factor);        
        list.add(first);
        Node last = first;
        Node zero = null;
        count = 1;
        
        s = r.readLine();
        while (s != null) {
            last = new Node(Long.parseLong(s) * factor, last, first);
            list.add(last);
            if (last.value == 0) {
                zero = last;
            }
            count++;
            s = r.readLine();
        }

        System.out.println(count + " numbers total.");

        System.out.println();

        for (int i = 1; i <= rounds; i++) {        
            System.out.println("Round #" + i + "...");
            for (int j = 0; j < list.size(); j++) {
                list.get(j).mix();
            }
        }
        
        System.out.println();
        
        long sum = 0;

        Node node = zero;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 1000; j++) {
                node = node.next;
            }
            System.out.println(1000 * (i + 1) + "th number is " + node.value + ".");
            sum += node.value;
        }
        
        System.out.println();
        System.out.println("Sum is " + sum + ".");
        System.out.println();
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.20 Grove Positioning System ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])), 1, 1);
        new Puzzle().process(new BufferedReader(new FileReader(args[0])), 811589153, 10);
    }
    
}
