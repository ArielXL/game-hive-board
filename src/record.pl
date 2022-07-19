:- module( record, [ initRecord/7,
				  	 getTokenType/2,
			      	 getRow/2,
			      	 getColumn/2,
				  	 getColor/2,
                  	 getInBoard/2,
				  	 getStackPosition/2,
			      	 setTokenType/3,
				  	 setRow/3,
				  	 setColumn/3,
				  	 %setColor/3,
                  	 setInBoard/3,
				  	 setStackPosition/3,
					   increaseSP/2,
					   decreaseSP/2
			  	   ]
		 ).

% ------------------------------------------------------------------------- %
% ESTRUCTURA Record -> record(Token, Row , Column, Color,InBoard, StackPos) %
% ------------------------------------------------------------------------- %
% Token: pieza en la casilla actual                                         %
% Row: posicion de la fila                                                  %
% Column: posicion de la columna                                            %
% Color: color de la pieza                                                  %
% InBoard: Si es 1 es porque la ficha esta en mano, si es 0 esta en colmena %
% StackPos: si dos celdas estan ubicadas en la misma posicion, entonces     %
%           este valor actua como un indice, dando la posicion de pila      %
%           del objeto, el valor predeterminado es 0                        %
% ------------------------------------------------------------------------- %

initRecord(Token, Row, Column, Color, InBoard, StackPos, Record):-
	append([],[Token, Row, Column, Color, InBoard, StackPos],Record).

getTokenType([Token, _, _, _,_, _], Token).
getRow([_, Row, _, _,_, _], Row).
getColumn([_, _, Column, _,_, _], Column).
getColor([_, _, _, Color,_, _], Color).
getInBoard([_, _, _, _,InBoard, _], InBoard).
getStackPosition([_, _, _, _,_, StackPos], StackPos).


setTokenType(NewToken, [_, Row, Column, Color, InBoard, StackPos],[NewToken, Row, Column, Color, InBoard, StackPos]).
setRow(NewRow, [Token, _, Column, Color, InBoard, StackPos],[Token, NewRow, Column, Color, InBoard, StackPos]).
setColumn(NewColumn, [Token, Row, _, Color, InBoard, StackPos],[Token, Row, NewColumn, Color, InBoard, StackPos]).
%setColor(NewColor, [Token, Row, Column, _, InBoard, StackPos],[Token, Row, Column, NewColor, InBoard, StackPos]).
setInBoard(NewInBoard, [Token, Row, Column, Color, _, StackPos],[Token, Row, Column, Color, NewInBoard, StackPos]).
setStackPosition(NewStackPos, [Token, Row, Column, Color, InBoard,_],[Token, Row, Column, Color, InBoard, NewStackPos]).

increaseSP(Record,NewRecord):-
	getStackPosition(Record,SPR),
	NSP is SPR+1,
	setStackPosition(NSP,Record,NewRecord).

decreaseSP(Record,NewRecord):-
	getStackPosition(Record,SPR),
	NSP is SPR-1,
	setStackPosition(NSP,Record,NewRecord).
