#script(python)
from clingo import Control,Model,Function
	
play_col = -1
winner = 0
def on_model(model):
	global play_col
	global winner
	mod = str(model)
	k = mod.find('maxScores(')
	z = mod.find('winner(')
	print('hello')
	print(mod)
	play_col = int(mod[k + len('maxScores(')])
	if z > 0:
		winner = int(mod[z + len('winner(')])

def printBoard(board):
	for i in range(5, -1, -1):
		print(board[i])
		
def makeMove(board, X,chip):
	k = X
	for i in range(len(board)):
		if board[i][X] == 0:
			board[i][X] = chip
			k = i
			break
	return board , X, k

def initBoardExternal():
	lst = []
	for i in range(7):
		for j in range(6):
			lst.append(Function("board", [i,j,0]))
	return lst
	
def main(prg):
	
	#load and set up the program
	prg.load("connect.lp")
	prg.ground([("base", [])])
	
	#initialize the board
	board = [[] for i in range(6)]
	for i in range(6):
		for j in range(7):
			board[i].append(0)
	
	
	
	#load and set up the program
	prg.load("connect.lp")
	prg.ground([("base", [])])
	
	boardInit = initBoardExternal()
	for i in boardInit:
		prg.assign_external(i,True)
	
	#go through the loop
	while True:
	
		#players move
		printBoard(board)
		print("Make your move:")
		player = int(input())
		while player not in range(0,7):
			print("Invald Move")
			player = input()
		board,X,Y = makeMove(board,player,2)
		
		#assign externals
		prg.assign_external(Function("board", [X,Y,0]),False)
		prg.assign_external(Function("board", [X,Y,2]),True)
		
		#solve and check winner
		prg.solve(on_model = on_model)
		if winner == 1:
			printBoard(board)
			print("Computer wins!")
			break
		if winner == 2:
			printBoard(board)
			print("You win!")
			break
		
		#make computer's move and assign external
		board,X,Y = makeMove(board,play_col,1)
		prg.assign_external(Function("board", [X,Y,0]),False)
		prg.assign_external(Function("board", [X,Y,1]),True)
		prg.solve(on_model = on_model)
		
		if winner == 1:
			printBoard(board)
			print("Computer wins!")
			break
		if winner == 2:
			printBoard(board)
			print("You win!")

			break
#end.