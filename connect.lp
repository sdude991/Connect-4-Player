%board(width,height,value)

%value as 0 means empty, 1 filled by comp, 2 filled by player
%board(0,5,0).board(1,5,0).board(2,5,0).board(3,5,0).board(4,5,0).board(5,5,0).board(6,5,0).
%board(0,4,0).board(1,4,0).board(2,4,0).board(3,4,0).board(4,4,0).board(5,4,0).board(6,4,0).
%board(0,3,0).board(1,3,0).board(2,3,0).board(3,3,0).board(4,3,0).board(5,3,0).board(6,3,0).
%board(0,2,0).board(1,2,0).board(2,2,0).board(3,2,0).board(4,2,0).board(5,2,0).board(6,2,0).
%board(0,1,0).board(1,1,0).board(2,1,0).board(3,1,0).board(4,1,0).board(5,1,0).board(6,1,0).
%board(0,0,0).board(1,0,0).board(2,0,2).board(3,0,0).board(4,0,1).board(5,0,0).board(6,0,1).

#external board(0..6,0..5,0..2).

d(-1,-1).d(-1,0).d(-1,1).d(0,-1).d(0,1).d(1,-1).d(1,0).d(1,1).


chip(0..2).
x(0..6).
y(0..5).
outX(-1).outX(7).
outY(-1).outY(6).


topColumn(X,Y):- Y = 0, board(X,Y,0).
topColumn(X,Y):-
	board(X,Y-1,1..2),
	board(X,Y,0),
	board(X,Y+1,0).
	
	

dirCount(X,Y,C,Dx,Dy,Val):-
	chip(C),
	d(Dx,Dy),
	outX(X),
	y(Y),	
	Val = 0.

dirCount(X,Y,C,Dx,Dy,Val):-
	chip(C),
	d(Dx,Dy),
	x(X),
	outY(Y),
	Val = 0.
	
dirCount(X,Y,C,Dx,Dy,Val):-
	chip(C),
	d(Dx,Dy),
	outX(X),
	outY(Y),
	Val = 0.

dirCount(X,Y,C,Dx,Dy,Val):-
	chip(C),
	d(Dx,Dy),
	board(X,Y,C),
	dirCount(X+Dx,Y+Dy,C,Dx,Dy,V),
	Val = V+1.

dirCount(X,Y,C,Dx,Dy,Val):-
	chip(C),
	K != C,
	d(Dx,Dy),
	board(X,Y,K),
	Val = 0.

score(X,V):-
	topColumn(X,Y),
	dirCount(X+1,Y+1,2, 1, 1,V1),
	dirCount(X+1,Y,  2, 1, 0,V2),
	dirCount(X+1,Y-1,2, 1,-1,V3),
	dirCount(X,  Y+1,2, 0, 1,V4),
	dirCount(X,  Y-1,2, 0,-1,V5),	
	dirCount(X-1,Y+1,2, -1,1,V6),	
	dirCount(X-1,Y,  2, -1,0,V7),	
	dirCount(X-1,Y-1,2, -1,-1,V8),	
	V = V1+V2+V3+V4+V5+V6+V7+V8.

maxScores(Out):-
	score(6,V),
	maxScoreHlp(5,6,V,Out,Score).
	
maxScoreHlp(-1,Ms,Mv,Ms,Mv):-
	score(Ms,Mv).

maxScoreHlp(X,Ms,Mv,S,V):-
	score(Ms,Mv),
	score(X,V2),
	V2 < Mv,
	K = X-1,
	maxScoreHlp(K,Ms,Mv,S,V).
maxScoreHlp(X,Ms,Mv,S,V):-
	score(Ms,Mv),
	score(X,V2),
	V2 >= Mv,
	K = X-1,
	maxScoreHlp(K,X,V2,S,V).
	
	
winner(C):-
	C != 0,
	d(Dx,Dy),
	x(X),
	x(Y),
	dirCount(X,Y,C,Dx,Dy,V),
	V >= 4.


#show maxScores/1.
#show winner/1.
