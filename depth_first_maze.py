import random
#depth first maze algorithm
#up 0=8 (0,-1) [1,0,0,0]     (i,j-1)
#left 1=4 (-1,0) [0,1,0,0]   (i-1,j)
#right2 = 2 (1,0) [0,0,1,0]  (i+1,j)
#down 3= 1 (0,1) [ 0,0,0,1]          (i,j+1)

#x decreasing is up increasing down
#y decreasing is left and increasing right

def create_matrix(dim):
    #create a grid filled with walls
    maze=[[[1,1,1,1,False] for row in range(dim)] for col in range(dim)]
    return maze


def pop_lifo_from_stack(stack):
    if(len(stack) > 0):
        return stack.pop()
    else:
        return False
        

def check_neighbors(size,maze,cur_x,cur_y):
    x,y=cur_x,cur_y
    #returns a random possible neighbor to visit
    #(x,y,old spot wall to remove, new spot wall to remove)
    possible_legit_neighbors=[]
    #check top
    topx=x-1
    topy=y
    if(check_if_in_bounds(size,topx,topy) and check_if_visited(maze,(topx,topy))==False):   
        possible_legit_neighbors.append((topx,topy,8,1))
    #check left
    leftx=x
    lefty=y-1
    if(check_if_in_bounds(size,leftx,lefty)and check_if_visited(maze,(leftx,lefty))==False):
        possible_legit_neighbors.append((leftx,lefty,4,2))
    #check right
    rightx=x
    righty=y+1
    if(check_if_in_bounds(size,rightx,righty)and check_if_visited(maze,(rightx,righty))==False):
        possible_legit_neighbors.append((rightx,righty,2,4))
    #check bottom
    bottomx=x+1
    bottomy=y
    if(check_if_in_bounds(size,bottomx,bottomy)and check_if_visited(maze,(bottomx,bottomy))==False ):
        possible_legit_neighbors.append((bottomx,bottomy,1,8))
    if(len(possible_legit_neighbors)==1):
       return possible_legit_neighbors[0]
    elif(len(possible_legit_neighbors)>0):
       r=random.randint(0,len(possible_legit_neighbors)-1)
       return possible_legit_neighbors[r]
    else:
        return False
    
    
    
def check_if_in_bounds(size, x,y):
    if(x>=0 and y>=0 and x<size and y<size ):
        return True
    else:
        return False

def break_wall(maze,oldx,oldy,newx,newy,oldNum,newNum):
    if(oldNum == 8):
        maze[oldx][oldy][0]=0
    if(newNum == 8):
        maze[newx][newy][0]=0
    if(oldNum == 4):
        maze[oldx][oldy][1]=0
    if(newNum == 4):
        maze[newx][newy][1]=0
    if(oldNum == 2):
        maze[oldx][oldy][2]=0
    if(newNum == 2):
        maze[newx][newy][2]=0
    if(oldNum == 1):
        maze[oldx][oldy][3]=0
    if(newNum == 1):
        maze[newx][newy][3]=0
    return maze
        


def mark_as_visited(maze,x,y):
    maze[x][y][4]=True
    return maze

def check_if_visited(maze,d):
    x=d[0]
    y=d[1]
    return maze[x][y][4]

def make_maze():
    size=5
    maze= create_matrix(size)
    visited_stack=[]
    x=0 #starting x
    y=0 #starting y
    current_cell=(x,y)
    mark_as_visited(maze,x,y)
    nextCell=check_neighbors(size,maze,x,y)
    break_wall(maze,x,y,nextCell[0],nextCell[1],nextCell[2],nextCell[3])
    visited_stack.append(nextCell)
    current_cell=nextCell
    while(len(visited_stack) >0):
        x=current_cell[0]
        y=current_cell[1]
        neighbor=check_neighbors(size,maze,x,y)
        if(neighbor):
            nextCell=neighbor
            mark_as_visited(maze,nextCell[0],nextCell[1])
            break_wall(maze,x,y,nextCell[0],nextCell[1],nextCell[2],nextCell[3])
            visited_stack.append(nextCell)
            current_cell=nextCell
        else:
            current_cell=visited_stack.pop()

    print_maze(maze,size)
    print_maze_data(maze,size)
    return
           
        
def print_maze(maze,size):
    for i in range(size):
        print("")
        for j in range(size):
            if(maze[i][j][0]==1):
                print("T",end='')
            if(maze[i][j][1]==1):
                print("L",end='')
            if(maze[i][j][2]==1):
                print("R",end='')
            if(maze[i][j][3]==1):
                print("B",end='')
            print(",",end='')
    print("\n")

def print_maze_data(maze,size):
    for i in range(size):
        print("")
        for j in range(size):
            print(maze[i][j],end='')
    print("\n")
    


def main():
    make_maze()
    

main() 


    
 

    

