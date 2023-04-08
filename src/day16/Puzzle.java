package day16;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Day 16 "Proboscidea Volcanium" parts 1 and 2.
 */
public class Puzzle {
    
    /**
     * Represents a valve.
     */
    class Valve {
        
        String name;
        
        int rate;
        
        ArrayList<String> tunnelNames;

        Valve[] tunnels;
        
        boolean open, openForBest;
        
        Valve(String s) {
            tunnelNames = new ArrayList();
            
            String[] a = s.split(" |=|; |, ");
            name = a[1];
            rate = Integer.parseInt(a[5]);
            
            for (int i = 10; i < a.length; i++) {
                tunnelNames.add(a[i]);
            }
            
            if (rate != 0) {
                maximumFlow += rate;
            }
        }
        
        void resolve() {
            tunnels = new Valve[tunnelNames.size()];
            for (int i = 0; i < tunnels.length; i++) {
                tunnels[i] = valvesByName.get(tunnelNames.get(i));
            }
        }
        
    }
    
    /**
     * Mapping of valve names to objects.
     */
    HashMap<String, Valve> valvesByName = new HashMap();
    
    /**
     * Flow if all valves are open.
     */
    int maximumFlow;
    
    /**
     * Best pressure release value so far.
     */
    int bestResult = 0;

    /**
     * Recursive function that handles scoring, pruning and movement.
     */
    void recurse(Valve curr, Valve prev, int time, int flow, int total) {
        total = total + flow;
        time--;
        
        if (time == 0) {
            if (total > bestResult) {
                System.out.print(".");
                bestResult = total;
                
                for (Valve v: valvesByName.values()) {
                    v.openForBest = v.open;
                }
            }
            
            return;
        }
        
        if (total + time * maximumFlow < bestResult) {
            return;
        }

        if (!curr.open && curr.rate != 0) {
            curr.open = true;
            recurse(curr, curr, time, flow + curr.rate, total);
            curr.open = false;
        } else /* remove for example */ {
            for (Valve v: curr.tunnels) {
                if (v != prev) {
                    recurse(v, curr, time, flow, total);
                }
            }
        }
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        String s = r.readLine();
        while (s != null) {
            Valve v = new Valve(s);
            valvesByName.put(v.name, v);
            s = r.readLine();
        }
        
        for (Valve v: valvesByName.values()) {
            v.resolve();
        }
        
        Valve start = valvesByName.get("AA");
        
        // First trip: We go on our own for 30 minutes.
        recurse(start, null, 30, 0, 0);
        int alone = bestResult;
        bestResult = 0;

        // Second trip: We go on our own for 26 minutes.
        recurse(start, null, 26, 0, 0);
        int you = bestResult;
        bestResult = 0;
        
        // We keep track of which valves we already opened.
        for (Valve v: valvesByName.values()) {
            if (v.openForBest) {
                maximumFlow -= v.rate;
                v.rate = 0;
            }
        }

        // Third trip: Elephant goes for 26 minutes and does the remaining work.
        recurse(start, null, 26, 0, 0);
        int elephant = bestResult;
        
        System.out.println();
        System.out.println();
        System.out.println("Part 1: " + alone);
        System.out.println("Part 2: " + (you + elephant) + " = " + you + " + " + elephant);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.16 Proboscidea Volcanium ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
