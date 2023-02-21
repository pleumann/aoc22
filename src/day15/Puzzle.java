package day15;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Day 15 "Beacon Exclusion Zone" parts 1 and 2.
 */
public class Puzzle {
    
    static final int YY = 2000000;
    
    /**
     * Represents a [from,to[ range. Provides intersection and subtraction.
     */
    static class Range {
        
        int from, to;
        
        Range(int from, int to) {
            this.from = from;
            this.to = to;
        }
        
        /**
         * Intersects this range with the other one. Returns the resulting
         * range, or null if the ranges don't intersect.
         */
        Range intersect(Range other) {
            if (to <= other.from || from >= other.to) {
                // System.out.println(this + " * " + other + " = null");
                return null;
            }

            Range i = new Range(Math.max(from, other.from), Math.min(to, other.to));
            
            // System.out.println(this + " * " + other + " = " + i);
            
            return i;
        }

        /**
         * Subtracts the other range from this one, puts the pieces (if any)
         * into the corresponding list.
         */
        void subtract(Range other, ArrayList<Range> pieces) {
            // System.out.println(this + " - " + other + " ... ");
            // Fast track.
            Range i = intersect(other);
            if (i == null) {
                pieces.add(this);
                return;
            }
            
            Range r1 = intersect(new Range(other.to, Integer.MAX_VALUE));
            if (r1 != null) {
                pieces.add(r1);
            }
            
            Range r2 = intersect(new Range(Integer.MIN_VALUE, other.from));
            if (r2 != null) {
                pieces.add(r2);
            }
        }
        
        @Override
        public String toString() {
            return String.format("Range: %d-%d", from, to);
        }
    }

    /**
     * Represents a sensor.
     */
    static class Sensor {
        int x, y, bx, by, d;
        
        /**
         * Creates a sensor from the line of the input file.
         */
        public Sensor(String s) {
            // Sensor at x=2, y=18: closest beacon is at x=-2, y=15
            
            int p = s.indexOf('=');
            int q = s.indexOf(',', p + 1);
            
            x = Integer.parseInt(s.substring(p + 1, q));
            
            p = s.indexOf('=', q + 1);
            q = s.indexOf(':', p + 1);
            
            y = Integer.parseInt(s.substring(p + 1, q));

            p = s.indexOf('=', q + 1);
            q = s.indexOf(',', p + 1);
            
            bx = Integer.parseInt(s.substring(p + 1 , q));

            p = s.indexOf('=', q + 1);
            q = s.length();

            by = Integer.parseInt(s.substring(p + 1, q));
            
            d = Math.abs(bx - x) + Math.abs(by - y);
        }
        
        /**
         * Returns the range of columns that this sensor affects in the given
         * row, or null if it's too far away.
         */
        Range getRange(int y) {
            int l = d - Math.abs(y - this.y);
            
            if (l < 0) {
                return null;
            }
            
            return new Range(x - l, x + l + 1);
        }
        
        @Override
        public String toString() {
            return String.format("Sensor: x=%10d y=%10d bx=%10d by=%10d d=%10d", x, y, bx, by, d);
        }
    }
    
    /**
     * Returns an intersection-free (i.e. non-overlapping) list of ranges for
     * all sensors and the given row.
     */
    ArrayList<Range> getRangesForCoord(ArrayList<Sensor> sensors, int y) {
        ArrayList<Range> ranges = new ArrayList();
        
        for (Sensor se: sensors) {
            //System.out.println(se);
            Range rn = se.getRange(y);
            // System.out.println("New range: " + rn);
            if (rn != null) {
                ArrayList<Range> pieces = new ArrayList();
                
                for (Range ro: ranges) {
                    ro.subtract(rn, pieces);
                }
                
                // System.out.println("" + ranges2.size() + " pieces");
                
                ranges = pieces;
                
                if (se.by == y) {
                    ranges.add(new Range(rn.from, se.bx));
                    ranges.add(new Range(se.bx + 1, rn.to));
                } else {
                    ranges.add(rn);
                }
            }
        }
        
        return ranges;
    }
    
    /**
     * Processes the whole puzzle.
     */
    void process(BufferedReader r) throws IOException {
        ArrayList<Sensor> sensors = new ArrayList();
        
        // Load data
        String s = r.readLine();
        while (s != null) {
            Sensor sensor = new Sensor(s);
            sensors.add(sensor);
            System.out.println(sensor);
            s = r.readLine();
        }

        System.out.println();

        // Get intersection-free list of ranges affecting the given row.
        ArrayList<Range> ranges = getRangesForCoord(sensors, YY);
        
        int count = 0;
        
        // Add up impossible beacon positions.
        for (Range ra: ranges) {
            count += ra.to - ra.from;
        }
        
        System.out.println("Part 1: " + count);
        
        for (int i = 2 * YY; i >= 0; i--) {
            // Get intersection-free list of ranges affecting the given row.
            ranges = getRangesForCoord(sensors, i);

            // Subtract ranges from the "all" range.
            ArrayList<Range> possible = new ArrayList();
            possible.add(new Range(0, 2 * YY + 1));        
            for (Range ra: ranges) {
                ArrayList<Range> pieces = new ArrayList();
                for (Range ra2: possible) {
                    ra2.subtract(ra, pieces);
                }
                possible = pieces;
            }
            
            // Add up possible beacon positions.
            count = 0;
            for (Range ra: possible) {
                count += ra.to - ra.from;
            }

            // If it's excactly one we found our beacon.
            if (count == 1) {
                System.out.println("Part 2: " + ((long)i + 4000000 * (long)possible.get(0).from));
                return;
            }
        
        }
        
        throw new RuntimeException("Oops!");
    }
    
    /**
     * Provides the main entry point.
     */
    public static void main(String[] args) throws IOException {
        System.out.println();
        System.out.println("*** AoC 2022.15 Beacon Exclusion Zone ***");
        System.out.println();
        
        new Puzzle().process(new BufferedReader(new FileReader(args[0])));
    }
    
}
