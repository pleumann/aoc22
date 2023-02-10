package day19;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;

/**
 * Day 19 "Not Enoguh Resources" parts 1 and 2.
 */
public class PuzzleBfs {

    /**
     * Resource type comstants.
     */
    static final int ORE      = 0;
    static final int CLAY     = 1;
    static final int OBSIDIAN = 2;
    static final int GEODE    = 3;

    /**
     * Represents a state of the simulation. Can be serialized into and
     * deserialized from a long.
     */
    class State {
        
        /**
         * Resource we have of each type.
         */
        byte resources[] = new byte[4];
        
        /**
         * Robots we have of each type.
         */
        byte robots[]    = new byte[4];

        /**
         * Deserializes the state from a long.
         */
        public void set(long l) {
            for (int i = 3; i >= 0; i--) {
                robots[i] = (byte)(l & 0xff);
                l = l >> 8;
            }
            
            for (int i = 3; i >= 0; i--) {
                resources[i] = (byte)(l & 0xff);
                l = l >> 8;
            }

        }

        /**
         * Serializes the state to a long.
         */
        long get() {
            long l = 0;
            
            for (int i = 0; i < 4; i++) {
                l = (l << 8) | (resources[i] & 0xff);
            }

            for (int i = 0; i < 4; i++) {
                l = (l << 8) | (robots[i] & 0xff);
            }
            
            return l;
        }

        /**
         * Lets all our robots collect resource for this round.
         */
        void collect() {
            for (int i = 0; i < 4; i++) {
                resources[i] += robots[i];
            }
        }
        
        /**
         * Checks whether we can build a robot of the given type.
         */
        boolean canBuild(int what) {
            for (int i = 0; i < 4; i++) {
                if (resources[i] < cost[what][i]) {
                    return false;
                }
            }
            
            return true;
        }

        /**
         * Builds a robot of the given type.
         */
        void build(int what) {
            for (int i = 0; i < 4; i++) {
                resources[i] -= cost[what][i];
            }
            
            robots[what]++;
        }
        
    }

    /**
     * Contains the current blueprint.
     */
    int cost[][] = new int[4][4];

    /**
     * Contains the state of sets are in currently.
     */
    HashSet<Long> states = new HashSet();

    /**
     * Result for part 1.
     */
    int part1 = 0;
    
    /**
     * Result for part 2.
     */
    int part2 = 1;

    /**
     * Returns the resource integer for the given name, for blueprint parsing.
     */
    int resourceIndex(String s) {
        switch (s) {
            case "ore":      return ORE;
            case "clay":     return CLAY;
            case "obsidian": return OBSIDIAN;
            case "geode":    return GEODE;
            default:
                throw new RuntimeException("Invalid resource " + s);
        }
    }

    /**
     * Simulates the given number of rounds using a breadth-first approach.
     */
    void simulate(int blueprint, int rounds) {
        int geodes = 0;
        
        State t = new State();
        
        System.out.print("\n\n\n\n\n");
        
        for (int round = 1; round <= rounds; round++) {
            long mem = Runtime.getRuntime().totalMemory() / 1024;
            
            System.out.print("\033[5A");
            System.out.println("Rounds: " + round + "     ");
            System.out.println("Geodes: " + geodes + "     ");
            System.out.println("States: " + states.size() + "     ");
            System.out.println("Memory: " + mem + " kB     ");
            System.out.println();
            
            HashSet<Long> newStates = new HashSet();

            for (Long l: states) {
                int built = 0;

                for (int i = 3; i >= 0; i--) {
                    t.set(l);

                    if (t.canBuild(i)) {
                        t.collect();
                        t.build(i);
                        if (i == GEODE) {
                            i = -1;
                            built = 4;
                        } else {
                            built++;
                        }
                    } else {
                        t.collect();
                    }

                    if (t.resources[GEODE] >= geodes - 2) {
                        geodes = Math.max(geodes, t.resources[GEODE]);  
                        newStates.add(t.get());
                    }
                }

                if (built < 4) {
                    t.set(l);
                    t.collect();
                    if (t.resources[GEODE] >= geodes - 2) {
                        geodes = Math.max(geodes, t.resources[GEODE]);
                        newStates.add(t.get());
                    }
                }
            }

            states = newStates;
            
            if (round == 24) {
                part1 += blueprint * geodes;
            }
        }

        if (rounds == 32) {
            part2 *= geodes;
        }     
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        int num = 1;
        
        String s = r.readLine();
        while (s != null) {
            cost = new int[4][4];
            
            String[] a = s.split("\\: ?|\\. ?");
            for (int i = 1; i < 5; i++) {
                String[] b = a[i].split(" ");

                int type = resourceIndex(b[1]);
                int amount = Integer.parseInt(b[4]);
                int what = resourceIndex(b[5]);

                cost[type][what] = amount;

                if (b.length > 6) {
                    amount = Integer.parseInt(b[7]);
                    what = resourceIndex(b[8]);
                    cost[type][what] = amount;
                }
            }
            
            System.out.println("--- Blueprint #" + num + " ---");
            System.out.println();
            
            State state = new State();
            state.robots[ORE] = 1;
            
            states = new HashSet();
            states.add(state.get());
            
            simulate(num, num < 4 ? 32 : 24);
            
            s = r.readLine();
            num++;
        }

        System.out.println("Part 1: " + part1);
        System.out.println("Part 2: " + part2);
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.19 Not Enough Minerals ***");
        System.out.println();
        
        new PuzzleBfs().process(new BufferedReader(new FileReader(args[0])));
        
        System.out.println();
    }
    
}
