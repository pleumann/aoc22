package day19;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Day 19 "Not Enough Minerals" parts 1 and 2.
 */
public class Puzzle {
    
    class Blueprint {

        /**
         * Resource type comstants.
         */
        static final int ORE = 0;
        static final int CLAY = 1;
        static final int OBSIDIAN = 2;
        static final int GEODE = 3;

        /**
         * Contains the current blueprint.
         */
        int cost[][] = new int[4][4];

        /**
         * Maximum robots we need of each type.
         */
        int limit[] = new int[4];

        /**
         * Resource we have of each type.
         */
        int resources[] = new int[4];

        /**
         * Robots we have of each type.
         */
        int robots[] = new int[4];

        /**
         * Best total number of geodes we achieved at each round.
         */
        int[] best = new int[33];

        /**
         * Creates a blueprint from the given line of input.
         */
        Blueprint(String s) {
            robots[ORE] = 1;

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

            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 4; j++) {
                    limit[i] = Math.max(limit[i], cost[j][i]);
                }
            }
            
            limit[GEODE] = Integer.MAX_VALUE;
        }

        /**
         * Returns the resource integer for the given name, for blueprint
         * parsing.
         */
        int resourceIndex(String s) {
            switch (s) {
                case "ore":
                    return ORE;
                case "clay":
                    return CLAY;
                case "obsidian":
                    return OBSIDIAN;
                case "geode":
                    return GEODE;
                default:
                    throw new RuntimeException("Invalid resource " + s);
            }
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
         * Checks whether we can build a robot of the given type.
         */
        boolean shouldBuild(int what) {
            return robots[what] < limit[what];
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

        /**
         * Copies an array.
         */
        void move(int[] src, int[] dst) {
            System.arraycopy(src, 0, dst, 0, 4);
        }

        /**
         * Simulates the given number of rounds using a depth-first approach.
         */
        void simulate(int rounds) {
            int[] savedRobots = new int[4];
            int[] savedResources = new int[4];
            
            int geodes = resources[GEODE];

            if (geodes > best[rounds]) {
                System.out.println("New best " + geodes + " at round " + rounds + "!");
                best[rounds] = geodes;
            }
            
            if (rounds == 0) {
                return;
            }

            int existing = rounds * robots[GEODE];
            int potential = (rounds - 1) * rounds / 2;
            if (geodes + existing + potential <= best[0]) {
                return;
            }

            for (int i = ORE; i <= GEODE; i++) {
                if (shouldBuild(i)) {
                    move(robots, savedRobots);
                    move(resources, savedResources);
                    
                    int remaining = rounds;
                    boolean possible = false;
                    do {
                        possible = canBuild(i);
                        collect();
                        remaining--;
                    } while (!(possible || remaining == 0));
                    
                    if (possible) {
                        build(i);
                    }
                    simulate(remaining);
                    
                    move(savedRobots, robots);
                    move(savedResources, resources);
                }
            }
        }   
    }

    /**
     * Result for part 1.
     */
    int part1 = 0;

    /**
     * Result for part 2.
     */
    int part2 = 1;

    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        int num = 1;

        String s = r.readLine();
        while (s != null) {
            System.out.println("--- Blueprint #" + num + " ---");
            Blueprint bp = new Blueprint(s);

            if (num < 4) {
                bp.simulate(32);
                part1 += num * bp.best[8];
                part2 *= bp.best[0];
                System.out.println("Best geodes: " + bp.best[8] + " / " + bp.best[0]);
            } else {
                bp.simulate(24);
                part1 += num * bp.best[0];
                System.out.println("Best geodes: " + bp.best[0]);
            }

            System.out.println();

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

        new Puzzle().process(new BufferedReader(new FileReader(args[0])));

        System.out.println();
    }

}
