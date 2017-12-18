	%robs = [Function("pos", [Function("red"),     1,  1]),
    %Function("pos", [Function("blue"),    1, 16]),
    %Function("pos", [Function("green"),  16,  1]),
    %Function("pos", [Function("yellow"), 16, 16]),
    %Function("goal", [13])]
    %mod = None
    %prg.add("p", ["t"], "q(t).")
    %prg.load("board.lp")
    %prg.load("targets.lp")
    %prg.load("ricochet.lp")
    %prg.load("optimization.lp")
    %prg.ground([("base", [])])

    %for i in robs:
   	%    prg.assign_external(i, True)

    %prg.solve(on_model = mod)
    
    
    
#script(python)
from clingo import Control,Model,Function
	
play_col = -1
def on_model(model):
	global play_col
	for i in str(model):
		if str.isdigit(i):
			play_col = i

def printBoard(board):
	for i in range(5, -1, -1):
		print(board[i])
		
def makeMove(board, X):
	for i in range(len(board)):
		if board[i][X] == 0:
			board[i][X] = 2
			break
	return board

def initBoardExternal():
	lst = []
	for i in range(7):
		for j in range(6):
			if i == 0 and j==0:
				lst.append(Function("board", [i,j,2]))
			else:
				lst.append(Function("board", [i,j,0]))
	return lst
	
def main(prg):
	
	#initialize the board
	board = [[] for i in range(6)]
	for i in range(6):
		for j in range(7):
			board[i].append(0)
	
	board = makeMove(board,2)		
	printBoard(board)
	
	
	#load and set up the program
	prg.load("connect.lp")
	prg.ground([("base", [])])
	
	boardInit = initBoardExternal()
	for i in boardInit:
		prg.assign_external(i,True)
	prg.solve(on_model = on_model)
	prg.assign_external(Function("board", [0,1,0]),False)
	prg.assign_external(Function("board", [0,1,2]),True)
	prg.solve(on_model = on_model)
	print(play_col)
#end.