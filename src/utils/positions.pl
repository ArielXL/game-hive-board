:- module( positions, [ gameOverCheck/5,
						adjPosNorth/3,
                       	adjPosSouth/3,
						adjPosNEast/3,
						adjPosNWest/3,
						adjPosSEast/3,
						adjPosSWest/3,
						adjAll/2,
						getAllAdj/2,
						queenSurrounded/3,
						adjNoCommon/3,
						commonAdj/3,
						getPCoordinates/3,
						extremNorth/3,
						extremSouth/3,
						extremNEast/3,
						extremNWest/3,
						extremSEast/3,
						extremSWest/3,
						setPCoordinates/3,
						spiderCase1/3,
						ladybugCase1/3,
						dfs/4,
						dfs1/4,
						breakPoint/3,
						findAll/3,
						getMinColumn/2,
						getMinRow/2,
						getMaxColumn/2,
						getMaxRow/2,
						forEachBoardByColumn/3,
						forEachBoardByRow/3,
						forEachBoardByStackPos/2,
						mySort/6,
						sortByRow/4,
						sortByColumn/4,
						getBoardRecords/3,
						retFromBoardPositions/3

    				  ]
		 ).

:- use_module( record, [ 
						 getTokenType/2,
						 
						 getRow/2,
						 getColumn/2,
						 getColor/2,
						 getInBoard/2,
						 getStackPosition/2,
						 setTokenType/3,
						 setRow/3,
						 setColumn/3,
						 setInBoard/3,
						 setStackPosition/3
					   ]
			 ).
:- use_module( tools, [ min/3,
    max/3
]
).			

:- use_module( "../player", [ 
						 	  retAllRecordInBoard/2,
					   		 retAllPositionsInBoard/2,
								getQueen/2,getColorP/2
					   		]
			 ).

%Meth

getPRow([Row|_],Row).
getPColumn(L,Column):- nth0(1,L,Column).

getPCoordinates(Position,Row,Column):-
    nth0(0,Position,Row),
	nth0(1,Position,Column).

% ------------------------------------------------------------------------ %
%                            Celdas Adyacentes                             %
% ------------------------------------------------------------------------ %
%  							        1 2                                    %
% 						 	       3 0 4                                   %
%   	   						    5 6                                    %
% ------------------------------------------------------------------------ %
setPCoordinates(Row,Column,[Row,Column]).

%Pos 1
adjPosNorth(Row,Column,R):-
	RespRow is Row-1,
	RespColumn is Column,
	setPCoordinates(RespRow,RespColumn,R).

extremNorth(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosNorth(Row,Column,R1),
	(
		(member(R1, Board),extremNorth(Board,R1,V));
		(V= R1)
	).

	
%Pos 6	
adjPosSouth(Row,Column,R):-
	RespRow is Row+1,
	RespColumn is Column,
	setPCoordinates(RespRow,RespColumn,R).

extremSouth(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosSouth(Row,Column,R1),
	(
		(member(R1, Board),extremSouth(Board,R1,V));
		(V= R1)
	).

%Pos 2
adjPosNEast(Row,Column,R):-
	RespRow is Row-1,
	RespColumn is Column+1,
	setPCoordinates(RespRow,RespColumn,R).

extremNEast(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosNEast(Row,Column,R1),
	(
		(member(R1, Board),extremNEast(Board,R1,V));
		(V= R1)
	).


%Pos 3
adjPosNWest(Row,Column,R):-
	RespRow is Row,
	RespColumn is Column-1,
	setPCoordinates(RespRow,RespColumn,R).

extremNWest(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosNWest(Row,Column,R1),
	(
		(member(R1, Board),extremNWest(Board,R1,V));
		(V= R1)
	).

%Pos 4
adjPosSEast(Row,Column,R):-
	RespRow is Row,
	RespColumn is Column+1,
	setPCoordinates(RespRow,RespColumn,R).

extremSEast(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosSEast(Row,Column,R1),
	(
		(member(R1, Board),extremSEast(Board,R1,V));
		(V= R1)
	).

%Pos 5
adjPosSWest(Row, Column, R) :-
	RespRow is Row + 1,
	RespColumn is Column - 1,
	setPCoordinates(RespRow, RespColumn, R).

extremSWest(Board,Pos,V):-
	getPCoordinates(Pos,Row,Column),
	adjPosSWest(Row,Column,R1),
	(
		(member(R1, Board),extremSWest(Board,R1,V));
		(V= R1)
	).

%Da todas las celdas adyacentes a una determinada posicion
adjAll(Position, Adj) :-
	getPCoordinates(Position, Row, Column),
	adjPosNorth(Row, Column, N),
	adjPosSouth(Row, Column, S),
	adjPosNEast(Row, Column, NE),
	adjPosSEast(Row, Column, SE),
	adjPosNWest(Row, Column, NW),
	adjPosSWest(Row, Column, SW),
	append([], [N, S, NE, SE, NW, SW], Adj).

% Devuelve cuales adyacentes de una celda no son adyacentes de ninguna 
% celda del otro jugador
adjNoCommon(Player1, Player2, Answer) :-
	retAllPositionsInBoard(Player1, P1),
	getAllAdj(P1, TA),
	subtract(TA,P1,A),
	retAllPositionsInBoard(Player2, P2),
	getAllAdj(P2,B),
	subtract(A,B,TAnswer),
	subtract(TAnswer,P2,Answer).

getAllAdj([], []).
getAllAdj([R|Rs], A):-
	getAllAdj(Rs, NA),
	adjAll(R, Adj),
	union(NA,Adj,A).

%Por cada psicion adjacente vacia en el tablero asociada a P
%busca por cada adyacente de dichos adyacentes cantos comunes con P
%lo que equivale a saber si dos posiciones consecutivas de P estan vacias 
%y por tanto m podria mover hacia ellas
commonAdj([],_,[]).
commonAdj([R|Rs],PPos,O):-
	commonAdj(Rs,PPos,NO),
	adjAll(R, Adj),
	intersection(Adj, PPos, R1),
	length(R1, LR1),
	((LR1=\=0,append(NO,[R],O));append(NO,[],O)).

%Para el movimiento de la aranna este metodo da todas las posiciones a las que se puede mover
spiderCase1(Pos,Board,Result):-
	adjAll(Pos,Adj),
    %quitar ocupadas
    subtract(Adj,Board,R1),
    %quitar las que no puedo deslizar
    commonAdj(R1,R1,R2),
	delete(Board,Pos,NB),
	commonAdj(R2,NB,R3),
	spiderCase2(R3,Board,[Pos],R),
    commonAdj(R,NB,Result).

spiderCase2([],_,_,[]).
spiderCase2([R|Rs],Board,Recorrido,Result):-
	spiderCase2(Rs,Board,Recorrido,NR),
	append([R],Recorrido,NRecorrido),
	adjAll(R,Adj),
	%quitar las ocupadas
	subtract(Adj,Board,V),
	%quitar los huecos
	commonAdj(V,V,NV),
	%quitar las que ya visite
	subtract(NV,NRecorrido,NNV),
	%quitar las aisladas
	commonAdj(NNV,Board,NNNV),
	length(NNNV, L),
	(
		(
			L=\=0,
			spiderCase3(NNNV,Board,NRecorrido,RC3),
			union(NR,RC3,Result)
			%append(NR,RC3,Result)
		);
		append(NR,[],Result)
	).
spiderCase3([],_,_,[]).
spiderCase3([R|Rs],Board,Recorrido,Result):-
	%append(X,Recorrido,NRecorrido),
	spiderCase3(Rs,Board,Recorrido,NR),
	adjAll(R,Adj),
	%Quitar las oqupadas
	subtract(Adj,Board,V),
	%quitar las q no puedo deslizar
	commonAdj(V,V,NV),
	%No virar en el recorrido
	subtract(NV,Recorrido,NNV),
	length(NNV, L),
	((L=\=0,union(NR,NNV,Result));append(NR,[],Result)).
	%((L=\=0,append(NR,NNNV,Result));append(NR,[],Result)).
%Para el movimiento de la mariquita
ladybugCase1(Pos,Board,Result):-	
	adjAll(Pos,Adj),
    %quitar no ocupadas
	intersection(Adj, Board, R1),
	ladybugCase2(R1,Board,[Pos],R),
	delete(Board, Pos, NB),
    commonAdj(R,NB,Result).

ladybugCase2([],_,_,[]).
ladybugCase2([R|Rs],Board,Root,Result):-
	ladybugCase2(Rs,Board,Root,NR),
	append([R],Root,NRoot),
	adjAll(R,Adj),
	intersection(Adj, Board, V),
	subtract(V,NRoot,NV),
	length(NV, L),
	(
		(
			L=\=0,
			ladybugCase3(NV,Board,RC3),
			union(NR,RC3,Result)
		);
		append(NR,[],Result)
	).

ladybugCase3([],_,[]).
ladybugCase3([R|Rs],Board,Result):-
	ladybugCase3(Rs,Board,NR),
	adjAll(R,Adj),
	%Quitar las oqupadas
	subtract(Adj,Board,V),
	length(V, L),
	((L=\=0,union(NR,V,Result));append(NR,[],Result)).

%Para el gameOverCheck Devuelve 0 si no esta rodeada y 1 en caso contrario
queenSurrounded(Player,IBoard,Result):-
	retFromBoardPositions(IBoard,[],Board),
	getQueen(Player,Queen),
	getRow(Queen,Row),
    getColumn(Queen,Column),
    setPCoordinates(Row,Column,Pos),
	adjAll(Pos,Adj),
	subtract(Adj,Board,NBoard),
	length(NBoard,L),
	(
		(L=:=0,Result is 1);
		(Result is 0)
	).
gameOverCheck(Player1,Player2,Board,Result,Winner):-
    queenSurrounded(Player1,Board,RPlayer1),
    (
        (RPlayer1=:=1,getColorP(Player2,P2Color),Result is 1, Winner is P2Color);
        (queenSurrounded(Player2,Board,RPlayer2),
            (
                (RPlayer2=:=1,getColorP(Player1,P1Color),Result is 1, Winner is P1Color);
                (Result is 0, Winner is -1)
            )
        )
    ).

% Board([[-1,0],[0,0],[1,0],[-1,1],[-2,0],[0,-1]])
% Da 0 si no es punto critico y 1 en caso contrario 
breakPoint(Pos,Board,Result):-
	length(Board,LB),
	delete(Board, Pos,NBoard),
	length(NBoard,LNB),
	DIF is LB-LNB,
	(
		(DIF=\=1,Result is 0);
		(
			nth0(0,NBoard , First),
			dfs([First],NBoard,[],NVisited),
			length(NVisited,LNV),
			(
				(LNV=:=LNB, Result is 0);
				(Result is 1)
			)
		)
	).
	

dfs([],_,Visited,NVisited):- NVisited=Visited.
dfs([R|Rs],Board,Visited,NVisited):-
	adjAll(R,Adj),
	subtract(Board,Adj,T),
	subtract(Board,T,AdjInBoard),
	subtract(AdjInBoard,Visited,NOVisited),
	union(NOVisited,Rs,NewTail),
	dfs(NewTail,Board,[R|Visited],NVisited).
	
dfs1([],_,Visited,NVisited):- NVisited=Visited.
dfs1([R|Rs],Board,Visited,NVisited):-
	adjAll(R,Adj),
	%quitar ocupadas
    subtract(Adj,Board,AdjNoBoard),
	%quitar las que no puedo deslizar
	commonAdj(AdjNoBoard,AdjNoBoard,AdjCanMove),
	%quitar las que aisladas
	delete(Board,R,NB),
	commonAdj(AdjCanMove,NB,AdjNOAislated),
	subtract(AdjNOAislated,Visited,AdjNOVisited),
	union(AdjNOVisited,Rs,NewTail),
	dfs1(NewTail,Board,[R|Visited],NVisited).

%Me devuelve una lista con todos los records que tienen esa posicion
findAll([],_,[]).
findAll([R|Rs],Pos,Result):-
    findAll(Rs,Pos,NResult),
    getRow(R,Row),
    getColumn(R,Column),
    setPCoordinates(Row,Column,P),
    (
        (P=Pos,
        append([R],NResult,Result));
        (append([],NResult,Result))
    ).

getMinRow([], 10000).
getMinRow([BoardHead|BoardTail], MinimumRow) :-
    getMinRow(BoardTail, Minimum),
    getRow(BoardHead, Row),
    min(Row, Minimum, MinimumRow).

getMaxRow([], -10000).
getMaxRow([BoardHead|BoardTail], MaximumRow) :-
    getMaxRow(BoardTail, Maximum),
    getRow(BoardHead, Row),
    max(Row, Maximum, MaximumRow).

getMinColumn([], 10000).
getMinColumn([BoardHead|BoardTail], MinimumColumn) :-
    getMinColumn(BoardTail, Minimum),
    getColumn(BoardHead, Column),
    min(Column, Minimum, MinimumColumn).

getMaxColumn([], -10000).
getMaxColumn([BoardHead|BoardTail], MaximumColumn) :-
    getMaxColumn(BoardTail, Maximum),
    getColumn(BoardHead, Column),
    max(Column, Maximum, MaximumColumn).

forEachBoardByStackPos([], []).
forEachBoardByStackPos([BoardHead|BoardTail], SortedBoard) :-
    forEachBoardByStackPos(BoardTail, List),
    getStackPosition(BoardHead, StackPos),
    (
        ( StackPos =\= 0, append([BoardHead], List, SortedBoard) );
        ( append([], List, SortedBoard) )
    ).

mySort(_, [], Max, Max, _, _).
mySort(List, Sorted, MinRow, MaxRow, MinCol, MaxCol) :-
    Min1 is MinRow + 1,
    mySort(List, LS, Min1, MaxRow, MinCol, MaxCol),
    forEachBoardByRow(List, MinRow, SortedList),
    sortByColumn(SortedList, R, MinCol, MaxCol),
    append(R, LS, Sorted).

sortByRow(_, [], Max, Max).
sortByRow(Board, Sorted, Min, Max) :-
    Min1 is Min + 1,
    sortByRow(Board, SortedList, Min1, Max),
    forEachBoardByRow(Board, Min, List),
    append(List, SortedList, Sorted).

forEachBoardByRow([], _, []).
forEachBoardByRow([BoardHead|BoardTail], Minimum, SortedBoard) :-
    forEachBoardByRow(BoardTail, Minimum, List),
    getRow(BoardHead, Row),
    (
        ( Row =:= Minimum, append([BoardHead], List, SortedBoard) );
        ( append([], List, SortedBoard) )
    ).

sortByColumn(_, [], Max, Max).
sortByColumn(Board, Sorted, Min, Max) :-
    Min1 is Min + 1,
    sortByColumn(Board, SortedList, Min1, Max),
    forEachBoardByColumn(Board, Min, List),
    append(List, SortedList, Sorted).

forEachBoardByColumn([], _, []).
forEachBoardByColumn([BoardHead|BoardTail], Minimum, SortedBoard) :-
    forEachBoardByColumn(BoardTail, Minimum, List),
    getColumn(BoardHead, Column),
    (
        ( Column =:= Minimum, append([BoardHead], List, SortedBoard) );
        ( append([], List, SortedBoard) )
    ).

getBoardRecords(Player1,Player2,Board):-
	retAllRecordInBoard(Player1,R1),
	retAllRecordInBoard(Player2,R2),
	union(R1,R2,Board).

retFromBoardPositions([],Positions,FPositions):-FPositions =Positions.
retFromBoardPositions([X|Y],Positions,FPositions):-
    getRow(X,Row),
    getColumn(X,Column),
	setPCoordinates(Row,Column,Pos),
	retFromBoardPositions(Y,[Pos|Positions],FPositions).


