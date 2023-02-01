matrix = []
len_Row=0
len_Col=0
visible = 0

with open("input.txt", "r") as inputPuzzle8:
    liste = inputPuzzle8.read().split("\n")
    #print("Liste: ", liste)

for i in liste:
    #print(i)
    row = list(i.strip(""))
    len_Col=len(i)
    matrix.append(row)
    len_Row=len(liste)

len_row = 99
len_col = 99

print("length of row", len_Row)
print("length of column", len_Col)
#print(matrix)

for i in range(1,(len_Row-1)):
    for j in range(1,(len_Col-1)):
        print("i-j:", i, j)
        visibleOben=0
        visibleRechts=0
        visibleUnten=0
        visibleLinks=0

        counterOben=0
        counterRechts=0
        counterUnten=0
        counterLinks=0
        
        #oben
        for x in range(0,i):
            if matrix[i][j] > matrix[x][j]:
                #print("oben:", "matrix[",x,"][",j,"]", "=", matrix[x][j])
                counterOben+=1
        #print("counterOben:",counterOben)
        if counterOben == i:
            visibleOben = 1
            #print("visible oben!")

        #rechts
        for x in range(j+1,len_Row):
            if matrix[i][j] > matrix[i][x]:
                #print("rechts:", "matrix[",i,"][",x,"]", "=", matrix[i][x])
                counterRechts+=1 
        #print("counterRechts:",counterRechts)
        if counterRechts == len_Row-(j+1):
            visibleRechts = 1
            #print("visible rechts!")
                   
        #unten
        for x in range(i+1,len_Col):
            if matrix[i][j] > matrix[x][j]:
                #print("unten:", "matrix[",x,"][",j,"]", "=", matrix[x][j])
                counterUnten +=1 
                #break                   
        #print("counterUnten:",counterUnten)
        if counterUnten == len_Col-(i+1):
            visibleUnten = 1
            #print("visible unten!")

        #links
        for x in range(0,j):
            if matrix[i][j] > matrix[i][x]:
                #print("links:", "matrix[",i,"][",x,"]", "=", matrix[i][x])
                counterLinks +=1    
                #break 
        #print("counterLinks:",counterLinks)
        if counterLinks == j:
            visibleLinks = 1
            #print("visible links!")         

        if visibleOben + visibleRechts + visibleUnten + visibleLinks !=0:
            visible+=1   
        #print("visible",visible)
        #print("")
                     
edge = 2*len_Row + 2*(len_Col-2)
print("edge:", edge)    
print("visible interor:", visible)
print("visible all together:", visible+edge)