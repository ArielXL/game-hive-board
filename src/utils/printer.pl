
:- module( printer, [ printBoard/2,
    printTabla/0,printEnd/1
]
).

:- use_module(player,[retAllRecordInBoard/2,
    retAllPositionsInBoard/2]).

:- use_module(record, [ getRow/2,
    getColumn/2,
    initRecord/7,
    getStackPosition/2,
    getColor/2,
    getTokenType/2
]
).

:- use_module( positions, [ getPCoordinates/3,
    adjPosNorth/3,
    adjPosSouth/3,
    adjPosNEast/3,
    adjPosNWest/3,
    adjPosSEast/3,
    adjPosSWest/3,
    setPCoordinates/3,
    forEachBoardByStackPos/2,
    findAll/3,
    getMinColumn/2,
	getMinRow/2,
	getMaxColumn/2,
	getMaxRow/2,
	mySort/6] ).

:- use_module(tools, [max/3]).

:- set_prolog_flag(encoding, utf8).
% ------------------------------------------------------------------------ %
% ESTRUCTURA Printer                                                       %
% ------------------------------------------------------------------------ %
% printBoard: imprime el tablero en la consola                             %
% printVariable: imprime una determinada variable con un mensaje al inicio %
% printOptions: lista una determinada cantidad de opciones                 %
% ------------------------------------------------------------------------ %



printBoard(Board,BoardHigh):-
    getMinRow(Board, MinimumRow),
    getMaxRow(Board, MaximumRow),
    getMinColumn(Board, MinimumColumn),
    getMaxColumn(Board, MaximumColumn),
    
    MaximumRow1 is MaximumRow + 1,
    T1 is abs(MaximumRow-MinimumRow)*5,
    T2 is abs(MaximumColumn-MinimumColumn)*5,
    max(T1,T2,T3),
    BoardHigh is T3+10,
    MaximumColumn1 is MaximumColumn + 1,
    mySort(Board, Z, MinimumRow, MaximumRow1, MinimumColumn, MaximumColumn1),
    
    %Kitar las que tienen escarabajos arriba
    forEachBoardByStackPos(Z, NewBoard),
    subtract(Z, NewBoard, F),
    length(F,LF),
    (
        %Siempre voy a colocar de la 7 en adelante
        (   LF>0,
            nth0(0, F, First),
            getColumn(First,CC),
            SPosRow is 3,
            K is abs(CC-MinimumColumn),
            SPosCol is (K*5)+5,
            prettyPrint(First,F,SPosRow,SPosCol,[],_)
        );
        (
            write("")
        )
    ).


prettyPrint(R,Board,RIndex,CIndex,Visited,V):-
    getRow(R,Row),
    getColumn(R,Column),
    getColor(R,Color),
    getTokenType(R,Token),
    append(Visited,[R],Visited1),
    p(CIndex,RIndex,Row,Column,Token,Color),
    
    %Ver si hay que printera el Norte
    adjPosNorth(Row,Column,North),
    %Buscar si esta en Board
    findAll(Board,North,Result1),
    subtract(Result1,Visited1,RN),
    length(RN,LRN),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRN=\=0,
         nth0(0, RN,FRN),
         RNIndex is RIndex-4,
         prettyPrint(FRN,Board,RNIndex,CIndex,Visited1,NVisited));
         (append([],Visited1,NVisited))
    ),
    
    %Ver si hay que printera el Sur
    adjPosSouth(Row,Column,South),
    %Buscar si esta en Board
    findAll(Board,South,Result2),
    subtract(Result2,NVisited,RS),
    length(RS,LRS),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRS=\=0,
         nth0(0, RS,FRS),
         RSIndex is RIndex+4,
         prettyPrint(FRS,Board,RSIndex,CIndex,NVisited,SVisited));
        (append([],NVisited,SVisited))
    ),

    %Ver si hay que printera el Noreste
    adjPosNEast(Row,Column,NEast),
    %Buscar si esta en Board
    findAll(Board,NEast,Result3),
    subtract(Result3,SVisited,RNE),
    length(RNE,LRNE),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRNE=\=0,
         nth0(0, RNE,FRNE),
         RNEIndex is RIndex-2,
         CNEIndex is CIndex+5,
         prettyPrint(FRNE,Board,RNEIndex,CNEIndex,SVisited,NEVisited));
        (append([],SVisited,NEVisited))
    ),

    %Ver si hay que printera el Noroeste
    adjPosNWest(Row,Column,NWest),
    %Buscar si esta en Board
    findAll(Board,NWest,Result4),
    subtract(Result4,NEVisited,RNW),
    length(RNW,LRNW),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRNW=\=0,
         nth0(0, RNW,FRNW),
         RNWIndex is RIndex-2,
         CNWIndex is CIndex-5,
         prettyPrint(FRNW,Board,RNWIndex,CNWIndex,NEVisited,NWVisited));
        (append([],NEVisited,NWVisited))
    ),
    
    %Ver si hay que printera el sureste
    adjPosSEast(Row,Column,SEast),
    %Buscar si esta en Board
    findAll(Board,SEast,Result5),
    subtract(Result5,NWVisited,RSE),
    length(RSE,LRSE),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRSE=\=0,
         nth0(0, RSE, FRSE),
         RSEIndex is RIndex+2,
         CSEIndex is CIndex+5,
         prettyPrint(FRSE,Board,RSEIndex,CSEIndex,NWVisited,SEVisited));
        (append([],NWVisited,SEVisited))
    ),

    %Ver si hay que printera el suroeste
    adjPosSWest(Row,Column,SWest),
    %Buscar si esta en Board
    findAll(Board,SWest,Result6),
    subtract(Result6,SEVisited,RSW),
    length(RSW,LRSW),
    (
        %RN tiene aki siempre tamano 1 o 0
        (LRSW=\=0,
         nth0(0, RSW, FRSW),
         RSWIndex is RIndex+2,
         CSWIndex is CIndex-5,
         prettyPrint(FRSW,Board,RSWIndex,CSWIndex,SEVisited,SWVisited));
        (append([],SEVisited,SWVisited))
    ),
    append([],SWVisited,V).

%write("\33[2J") to clean try (10,10) start print
%X0 column Y0 Row
p(X0,Y0,R,Co,Token,Color):-
    X is X0+2,
    Y is Y0,
    X1 is X0+1,
    Y1 is Y0+1,
    X2 is X0,
    Y2 is Y0+2,
    X3 is X0,
    Y3 is Y0+3,
    X4 is X0+1,
    Y4 is Y0+4,
    format(atom(Row),'~|~` t~d~` t~3+',[R]),
    format(atom(Col),'~|~` t~d~` t~3+',[Co]),
    ( 
        ( Token= queen, B = 'R' );
        ( Token= ant, B = 'H' );
        ( Token= grasshoper, B = 'S' );
        ( Token= beetle, B = 'E' );
        ( Token= spider, B = 'A' );
        ( Token= ladybug, B = 'M' )
    ),
    ((Color =:=0, C='B');(C='N')),
    writef("\33[%d;%dH___\33[%d;%dH/%w-%w\\\33[%d;%dH/F:%w\\\33[%d;%dH\\C:%w/\33[%d;%dH\\___/",[X,Y,X1,Y1,B,C,X2,Y2,Row,X3,Y3,Col,X4,Y4]).


printTabla():-
    writeln("El juego ha terminado en Tabla.").

printEnd(WinnerColor):-
    (
        (WinnerColor=:=0,
        writeln("HAN GANADO LAS FICHAS BLANCAS"),
        writeln(""),
        writeln("INTRODUZCA UNA TECLA PARA CONTINUAR"),
        read(_)
        );
        (WinnerColor=:=1,
        writeln("HAN GANADO LAS FICHAS NEGRAS"),
        writeln(""),
        writeln("INTRODUZCA UNA TECLA PARA CONTINUAR"),
        read(_)
        )
    ).                                
