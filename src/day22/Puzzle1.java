package day22;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Day 22 "Monkey Map" part 1. Slightly messy original solution from December.
 */
public class Puzzle1 {

    char[][] map;

    int width, height;
    
    static final String[] DIR = { "East", "South", "West", "North" };
    
    /**
     * Processes the whole puzzle.
     */
    int process(BufferedReader r) throws IOException {
        ArrayList<String> list = new ArrayList();
        
        width = 0;
        
        String s = r.readLine();
        int row = 0;
        int column = s.indexOf('.');
        while (!"".equals(s)) {
            list.add(s);
            width = Math.max(width, s.length());
            s = r.readLine();
        }

        height = list.size();
        
        System.out.printf("Size is %d rows and %d columns.\n", height, width);
        
        map = new char[height][width];
        
        for (int i = 0; i < height; i++) {
            char[] c = list.get(i).toCharArray();
            System.arraycopy(c, 0, map[i], 0, c.length);
            Arrays.fill(map[i], c.length, width, ' ');
        }
        
        char[] cmds = (r.readLine() + 'S').toCharArray();
        int index = 0;
        
        int facing = 0;
        
        while (index < cmds.length) {
            int steps = 0;
            while (Character.isDigit(cmds[index])) {
                steps = steps * 10 + cmds[index++] - '0';
            }
            
            char turn = cmds[index++];
            
            System.out.println("Move " + steps + " forward, then turn " + turn);

            int deltaRow = 0;
            int deltaColumn = 0;
            
            switch (facing) {
                case 0 -> deltaColumn = 1;
                case 1 -> deltaRow = 1;
                case 2 -> deltaColumn = -1;
                case 3 -> deltaRow = -1;
            }

            for (int i = 0; i < steps; i++) {
                int newRow = row + deltaRow;
                int newColumn = column + deltaColumn;
                
                if (facing == 1) {
                    if (newRow == height || map[newRow][newColumn] == ' ') {
                        System.out.println("Overflow down");
                        newRow = 0;
                        while (newRow < height && map[newRow][newColumn] == ' ') {
                            newRow++;
                        }
                    }
                } else if (facing == 3) {
                    if (newRow < 0 || map[newRow][newColumn] == ' ') {
                        System.out.println("Overflow up");
                        newRow = height - 1;
                        while (newRow >= 0 && map[newRow][newColumn] == ' ') {
                            newRow--;
                        }
                    }
                } else if (facing == 0) {
                    if (newColumn == width || map[newRow][newColumn] == ' ') {
                        System.out.println("Overflow right");
                        newColumn = 0;
                        while (newColumn < width && map[newRow][newColumn] == ' ') {
                            newColumn++;
                        }
                    }
                } else if (facing == 2) {
                    if (newColumn < 0 || map[newRow][newColumn] == ' ') {
                        System.out.println("Overflow left");
                        newColumn = width - 1;
                        while (newColumn >= 0 && map[newRow][newColumn] == ' ') {
                            newColumn--;
                        }
                    }
                }
                
                if (map[newRow][newColumn] == '#') {
                    break;
                }
                
                row = newRow;
                column = newColumn;
                
                System.out.println("New position is " + row + " " + column);
            }
            
            if (turn == 'S') {
                break;
            }
            
            facing = (4 + facing + (turn == 'R' ? 1 : - 1)) % 4;
            System.out.println("Now facing " + DIR[facing]);
        }
        
        return 1000 * (row + 1) + 4 * (column + 1) + facing;
    }
    
}
