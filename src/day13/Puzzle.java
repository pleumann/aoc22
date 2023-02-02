package day13;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Day 13 "Distress Signal" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Base class for nodes. Handles parsing and comparing.
     */
    abstract static class Node {

        /**
         * The input we parse.
         */
        static char[] input;
        
        /**
         * Our current parsing position.
         */
        static int position;
        
        /**
         * Recursively parses the input and builds up the node structure.
         */
        static Node parse() {
            char c = input[position];
            
            if (c == '[') {
                position++;
                Inner i = new Inner();

                if (input[position] != ']') {
                    i.nodes.add(parse());
   
                    while (input[position] == ',') {
                        position++;
                        i.nodes.add(parse());
                    }
                }

                if (input[position] != ']') {
                    throw new RuntimeException("']' expected at " + position);
                }
                position++;
                
                return i;
            } else {
                Leaf l = new Leaf();
                
                c = input[position];
                if (!Character.isDigit(c)) {
                    throw new RuntimeException("'0-9' expected at " + position);
                }
                l.value = c - '0';
                position++;
                c = input[position];
                while (Character.isDigit(c)) {
                    l.value = 10 * l.value + c - '0';
                    position++;
                    c = input[position];
                }
                
                return l;
            }
        }
        
        /**
         * Parses the given string and returns the corresponding node structure.
         */
        static Node parse(String s) {
            input = s.toCharArray();
            position = 0;
            
            return parse();
        }
        
        /**
         * Compares two nodes according to the puzzle rules.
         */
        static int compare(Node l, Node r) {
            if (l instanceof Leaf ll && r instanceof Leaf rl) {
                return ll.value - rl.value;
            }

            if (l instanceof Leaf) {
                Inner i = new Inner();
                i.nodes.add(l);
                return compare(i, r);
            } else if (r instanceof Leaf) {
                Inner i = new Inner();
                i.nodes.add(r);
                return compare(l, i);
            }

            if (l instanceof Inner li && r instanceof Inner ri) {
                int common = Math.min(li.nodes.size(), ri.nodes.size());

                for (int i = 0; i < common; i++) {
                    int j = compare(li.nodes.get(i), ri.nodes.get(i));
                    if (j != 0) {
                        return j;
                    }
                }

                return li.nodes.size() - ri.nodes.size();
            }
            
            throw new RuntimeException("Oops!");
        }   
    }

    /**
     * Represents an inner node (that has children).
     */
    static class Inner extends Node {
        ArrayList<Node> nodes = new ArrayList();
    }
    
    /**
     * Represents a leaf node (that has a value).
     */
    static class Leaf extends Node {
        int value;
    }

    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        int index = 1;
        int count = 0;
        
        ArrayList<Node> list = new ArrayList();
        
        String s = r.readLine();
        while (s != null) {
            String t = r.readLine();
            r.readLine();
            
            Node sn = Node.parse(s);
            Node rn = Node.parse(t);
            int j = Node.compare(sn, rn);
            if (j < 0) {
                count += index;
            }

            System.out.print('.');
            
            list.add(sn);
            list.add(rn);
            
            s = r.readLine();
            index++;
        }

        System.out.println();
        System.out.println();
        System.out.printf("Part 1: Sum of right-order packet indices is %5d.\n", count);
        
        Node d1 = Node.parse("[[2]]");
        list.add(d1);
        Node d2 = Node.parse("[[6]]");
        list.add(d2);

        list.sort((Node o1, Node o2) -> Node.compare(o1, o2));
        
        int i = list.indexOf(d1) + 1;
        int j = list.indexOf(d2) + 1;
        
        System.out.printf("Part 2: Product of divider packet indices is %5d.\n", i * j);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.13 Distress Signal ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
