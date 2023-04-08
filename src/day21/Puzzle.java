package day21;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

/**
 * Day 21 "Monkey Math" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Represents a node in the expression tree. Can be evaluated.
     */
    class Node {
        String name;
        
        char op;
        
        long value;
        
        String arg1, arg2;
        
        Node(String name, int value) {
            this.name = name;
            this.op = '#';
            this.value = value;
        }

        Node(String name, char op, String arg1, String arg2) {
            this.name = name;
            this.op = op;
            this.arg1 = arg1;
            this.arg2 = arg2;
        }
        
        Node getLeft() {
            return arg1 == null ? null : nodesByName.get(arg1);
        }

        Node getRight() {
            return arg2 == null ? null : nodesByName.get(arg2);
        }
        
        long calc() {
            Node l = getLeft();
            Node r = getRight();
            
            long v = switch (op) {
                case '+' -> l.calc() + r.calc();
                case '-' -> l.calc() - r.calc();
                case '*' -> l.calc() * r.calc();
                case '/' -> l.calc() / r.calc();
                default -> value;
            };
                       
            return v;
        }

    }
    
    /**
     * Holds all nodes by their names.
     */
    HashMap<String, Node> nodesByName = new HashMap();
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        while (s != null) {
            String[] a = s.split("\\: | ");
            if (a.length == 2) {
                Node node = new Node(a[0], Integer.parseInt(a[1]));
                nodesByName.put(node.name, node);
            } else {
                Node node = new Node(a[0], a[2].charAt(0), a[1], a[3]);
                nodesByName.put(node.name, node);
            }
            
            s = r.readLine();
        }

        Node root = nodesByName.get("root");
        Node humn = nodesByName.get("humn");

        // Part 1: Evalate the root node
        System.out.println("Part 1: " + root.calc());

        // Part 2: Find correct value for "humn" via binary search.
        long l = 0;
        long h = Long.MAX_VALUE / 1000000;
        while (l != h) {
            // System.out.println(l + "-" + h);
            long i = l + (h - l) / 2; 
            humn.value = i;
            long j = root.getRight().calc() - root.getLeft().calc();
            if (j < 0) {
                l = i + 1;
            } else if (j > 0) {
                h = i - 1;
            } else {
                System.out.println("Part 2: " + i);
                return;
            }
        }
        
        System.out.println("Oops!");        
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.21 Monkey Math ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
