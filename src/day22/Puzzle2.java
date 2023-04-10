package day22;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Day 22 "Monkey Map" part 2. Slightly messy original solution from December.
 */
public class Puzzle2 {
    
    char[][] map;
    
    int width, height, size;
    
    static final String[] DIR = { "East", "South", "West", "North" };
    
    /**
     * Adds a mirror that deflects our path if we managed to leave the populated
     * parts of the map (i.e. the actual die net). Note row and column are on
     * the (broader) scale of whole dice sides here, not individual positions
     * on the map. Type can be either '/' or '\'.
     */
    void mirror(int row, int column, char type) {
        row = row * size;
        column = column * size;

        if (type == '/') {
            for (int i = 0; i < size; i++) {
                map[row + i][column + i] = '/';
            }
        } else {
            for (int i = 0; i < size; i++) {
                map[row + size - 1 - i][column + i] = '\\';
            }
        }
    }
    
    /**
     * Processes the whole puzzle.
     */
    int process(BufferedReader r) throws IOException {
        ArrayList<String> list = new ArrayList();
        
        width = 0;
        
        String s = r.readLine();
        while (!"".equals(s)) {
            list.add(s);
            width = Math.max(width, s.length());
            s = r.readLine();
        }

        height = list.size();
        
        System.out.printf("Size is %d rows and %d columns.\n", height, width);
        
        if (width / 3 * 4 == height) {
            System.out.println("Format is 4 by 3");
            size = width / 3;
        } else if (width / 4 * 3 == height) {
            System.out.println("Format is 3 by 4");
            size = width / 4;
        } else {
            throw new RuntimeException("Oops! Unknown format.");
        }
    
        System.out.println("Size of side is " + size + " x " + size);

        int row = 2 * size;
        int column = 2 * size + list.get(0).indexOf('.');
        
        height = height + 4 * size;
        width = width + 4 * size;
        
        map = new char[height][width];

        for (int i = 0; i < height; i++) {
            Arrays.fill(map[i], ' ');
        }
        
        for (int i = 0; i < list.size(); i++) {
            char[] c = list.get(i).toCharArray();
            System.arraycopy(c, 0, map[i + 2 * size], 2 * size, c.length);
        }
        
        if (size < 50) {
            mirror(2, 3, '/');
            mirror(3, 5, '\\');
            mirror(4, 3, '/');
            mirror(1, 2, '/');
            mirror(1, 4, '\\');
            mirror(5, 2, '\\');
            mirror(5, 4, '/');
            mirror(2, 6, '\\');
            mirror(4, 6, '/');
            mirror(3, 1, '/');
            mirror(6, 1, '\\');
            mirror(6, 5, '/');
        } else {
            mirror(1, 0, '/');
            mirror(1, 3, '\\');
            mirror(1, 4, '/');
            mirror(1, 6, '\\');
            mirror(2, 1, '/');
            mirror(2, 5, '\\');
            mirror(3, 2, '/');
            mirror(3, 4, '/');
            mirror(4, 1, '\\');
            mirror(4, 5, '/');
            mirror(5, 0, '\\');
            mirror(5, 3, '/');
            mirror(6, 2, '\\');
            mirror(6, 6, '/');
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

            for (int i = 0; i < steps; i++) {
                int facing2 = facing;
                
                switch (facing) {
                    case 0 -> deltaColumn = 1;
                    case 1 -> deltaRow = 1;
                    case 2 -> deltaColumn = -1;
                    case 3 -> deltaRow = -1;
                }

                int newRow = row + deltaRow;
                int newColumn = column + deltaColumn;

                if (map[newRow][newColumn] != '.' && map[newRow][newColumn] != '#') {
                    System.out.println("Overflow at "+ newRow + " " + newColumn);

                    while (map[newRow][newColumn] != '.' && map[newRow][newColumn] != '#') {
                        if (map[newRow][newColumn] == '/') {
                            System.out.println("Deflect / at " + newRow + " " + newColumn);
                            facing2 = switch (facing2) {
                                case 0 -> 3;
                                case 1 -> 2;
                                case 2 -> 1;
                                case 3 -> 0;
                                default -> -1; 
                            };
                        } else if (map[newRow][newColumn] == '\\') {
                            System.out.println("Deflect \\ at " + newRow + " " + newColumn);
                            facing2 = switch (facing2) {
                                case 0 -> 1;
                                case 1 -> 0;
                                case 2 -> 3;
                                case 3 -> 2;
                                default -> -1; 
                            };
                        }
                        
                        deltaRow = 0;
                        deltaColumn = 0;
                        switch (facing2) {                                
                            case 0 -> deltaColumn = 1;
                            case 1 -> deltaRow = 1;
                            case 2 -> deltaColumn = -1;
                            case 3 -> deltaRow = -1;
                        }

                        newRow = newRow + deltaRow;
                        newColumn = newColumn + deltaColumn;
                    }
                    
                    System.out.println("Reentrance at "+ newRow + " " + newColumn);
                }
                
                if (map[newRow][newColumn] == '#') {
                    break;
                }

                facing = facing2;
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
        
        row = row - 2 * size;
        column = column - 2 * size;
        
        return 1000 * (row + 1) + 4 * (column + 1) + facing;
        
    }
    
}
