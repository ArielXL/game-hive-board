:- module( player, [ initPlayer/2,
                     increaseAll/4,
                     decreaseAll/4,
                     retAllRecordInBoard/2,
                     retAllPositionsInBoard/2,
                     getColorP/2,
                     getQueen/2,
                     getAnt1/2,
                     getAnt2/2,
                     getAnt3/2,
                     getGrasshoper1/2,
                     getGrasshoper2/2,
                     getGrasshoper3/2,
                     getBeetle1/2,
                     getBeetle2/2,
                     getSpider1/2,
                     getSpider2/2,
                     getLadybug/2,
                     setQueen/3,
                     setAnt1/3,
                     setAnt2/3,
                     setAnt3/3,
	                 setGrasshoper1/3,
                     setGrasshoper2/3,
                     setGrasshoper3/3,
	                 setBeetle1/3,
                     setBeetle2/3,
	                 setSpider1/3,
                     setSpider2/3,
	                 setLadybug/3,
                     updQueen/4,
                     updAnt1/4,
                     updAnt2/4,
                     updAnt3/4,
                     updGrasshoper1/4,
                     updGrasshoper2/4,
                     updGrasshoper3/4,
                     updBeetle1/4,
                     updBeetle2/4,
                     updSpider1/4,
                     updSpider2/4,
                     updLadybug/4,
                     hasAnyInHand/2,
                     queenAvailable/2,
                     ladybugAvailable/2,
                     anyAnt/2,
                     anyGrasshoper/2,
                     anyBeetle/2,
                     anySpider/2
                   ]
         ).

:- use_module( record, [ initRecord/7,
				         getTokenType/2,
                         getRow/2,
                         getColumn/2,
                         getInBoard/2,
                         getStackPosition/2,
                         setTokenType/3,
                         setRow/3,
                         setColumn/3,
                         setInBoard/3,
                         setStackPosition/3,
                         increaseSP/2,
                         decreaseSP/2
			  	       ]
		     ).

:- use_module( "utils/positions", [ setPCoordinates/3 ] ).

% ------------------------------------------------------------------------ %
% ESTRUCTURA Player -> player(Queen, Ants, Beetle,                         %
%                        Grasshoper, Ladybug, Spider)  %
% ------------------------------------------------------------------------ %
% Queen: total de abeja reina en el tablero                                %
% Ants: total de hormigas en el tablero                                    %
% Beetle: total de escarabajos en el tablero                               %
% Grasshoper: total de saltamontes en el tablero                          %
% Ladybug: total de mariquitas en el tablero                               %
% Spider: total de arañas en el tablero                                    %
% ------------------------------------------------------------------------ %

initPlayer(Color, Player):-
    initRecord(queen,      0, 0, Color, 1, 0, Queen),
    initRecord(ant,        0, 0, Color, 1, 0, Ant1),
    initRecord(ant,        0, 0, Color, 1, 0, Ant2),
    initRecord(ant,        0, 0, Color, 1, 0, Ant3),
    initRecord(grasshoper, 0, 0, Color, 1, 0, Grasshoper1),
    initRecord(grasshoper, 0, 0, Color, 1, 0, Grasshoper2),
    initRecord(grasshoper, 0, 0, Color, 1, 0, Grasshoper3),
    initRecord(beetle,     0, 0, Color, 1, 0, Beetle1),
    initRecord(beetle,     0, 0, Color, 1, 0, Beetle2),
    initRecord(spider,     0, 0, Color, 1, 0, Spider1),
    initRecord(spider,     0, 0, Color, 1, 0, Spider2),
    initRecord(ladybug,    0, 0, Color, 1, 0, Ladybug),
    append([],[Color,Queen,Ant1,Ant2,Ant3,Grasshoper1,Grasshoper2,Grasshoper3,Beetle1,Beetle2,Spider1,Spider2,Ladybug],Player).

getColorP([Color,_   ,_,   _,   _,              _,            _, _,           _,      _,       _,        _,        _      ], Color).
getQueen([_,   Queen,_,   _,   _,              _,            _, _,           _,      _,       _,        _,        _      ], Queen).
getAnt1([_,   _,    Ant1,_,   _,              _,            _, _,           _,      _,       _,        _,        _      ], Ant1).
getAnt2([_,   _,    _,   Ant2,_,              _,            _, _,           _,      _,       _,        _,        _      ], Ant2).
getAnt3([_,   _,    _,   _,   Ant3,           _,            _, _,           _,      _,       _,        _,        _      ], Ant3).
getGrasshoper1([_,   _,    _,   _,   _,    Grasshoper1,            _, _,           _,      _,       _,        _,        _      ], Grasshoper1).
getGrasshoper2([_,   _,    _,   _,   _,    _,            Grasshoper2, _,           _,      _,       _,        _,        _      ], Grasshoper2).
getGrasshoper3([_,   _,    _,   _,   _,    _,            _,           Grasshoper3, _,      _,       _,        _,        _      ], Grasshoper3).
    getBeetle1([_,   _,    _,   _,   _,    _,            _,           _,           Beetle1,_,       _,        _,        _      ], Beetle1).
    getBeetle2([_,   _,    _,   _,   _,    _,            _,           _,           _,       Beetle2,_,        _,        _      ], Beetle2).
    getSpider1([_,   _,    _,   _,   _,    _,            _,           _,           _,       _,       Spider1, _,        _      ], Spider1).
    getSpider2([_,   _,    _,   _,   _,    _,            _,           _,           _,       _,       _,       Spider2,  _      ], Spider2).
    getLadybug([_,   _,    _,   _,   _,    _,            _,           _,           _,       _,       _,       _,        Ladybug], Ladybug).

      setColor(New,[_    ,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[New  ,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
      setQueen(New,[Color,   _    ,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   New  ,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
       setAnt1(New,[Color,   Queen,    _   ,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    New ,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
       setAnt2(New,[Color,   Queen,    Ant1,   _   ,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   New ,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
       setAnt3(New,[Color,   Queen,    Ant1,   Ant2,   _   ,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   New ,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
setGrasshoper1(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   _          , Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   New        , Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
setGrasshoper2(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, _          , Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, New        , Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
setGrasshoper3(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, _          ,Beetle1,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, New        ,Beetle1,Beetle2, Spider1,Spider2,Ladybug ]).
    setBeetle1(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,_      ,Beetle2, Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,New    ,Beetle2, Spider1,Spider2,Ladybug ]).
    setBeetle2(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,_      , Spider1,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,New    , Spider1,Spider2,Ladybug ]).
    setSpider1(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2,       _,Spider2,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, New    ,Spider2,Ladybug ]).
    setSpider2(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,_      ,Ladybug ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,New    ,Ladybug ]).
    setLadybug(New,[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,_       ],[Color,   Queen,    Ant1,   Ant2,   Ant3,   Grasshoper1, Grasshoper2, Grasshoper3,Beetle1,Beetle2, Spider1,Spider2,New     ]).

retAllPositionsInBoard(Player,R):-
    (
    (getQueen(Player,Q),getInBoard(Q,I1),I1=:=0,getRow(Q,R1),
    getColumn(Q,C1),setPCoordinates(R1,C1,V1),append([],V1,L1));
    L1=[]),
    (
    (getAnt1(Player,A1),getInBoard(A1,I2),I2=:=0,getRow(A1,R2),
    getColumn(A1,C2),setPCoordinates(R2,C2,V2),append([],V2,L2));
    L2=[]),
    (    
    (getAnt2(Player,A2),getInBoard(A2,I3),I3=:=0,getRow(A2,R3),
    getColumn(A2,C3),setPCoordinates(R3,C3,V3),append([],V3,L3));
    L3=[]),
    (    
    (getAnt3(Player,A3),getInBoard(A3,I4),I4=:=0,getRow(A3,R4),
    getColumn(A3,C4),setPCoordinates(R4,C4,V4),append([],V4,L4));
    L4=[]),
    (
    (getGrasshoper1(Player,G1),getInBoard(G1,I5),I5=:=0,getRow(G1,R5),
    getColumn(G1,C5),setPCoordinates(R5,C5,V5),append([],V5,L5));
    L5=[]),
    (
    (getGrasshoper2(Player,G2),getInBoard(G2,I6),I6=:=0,getRow(G2,R6),
    getColumn(G2,C6),setPCoordinates(R6,C6,V6),append([],V6,L6));
    L6=[]),
    (
    (getGrasshoper3(Player,G3),getInBoard(G3,I7),I7=:=0,getRow(G3,R7),
    getColumn(G3,C7),setPCoordinates(R7,C7,V7),append([],V7,L7));
    L7=[]),
    (
    (getBeetle1(Player,B1),getInBoard(B1,I8),I8=:=0,getRow(B1,R8),
    getColumn(B1,C8),setPCoordinates(R8,C8,V8),append([],V8,L8));
    L8=[]),
    (
    (getBeetle2(Player,B2),getInBoard(B2,I9),I9=:=0,getRow(B2,R9),
    getColumn(B2,C9),setPCoordinates(R9,C9,V9),append([],V9,L9));
    L9=[]),
    (
    (getSpider1(Player,S1),getInBoard(S1,I10),I10=:=0,getRow(S1,R10),
    getColumn(S1,C10),setPCoordinates(R10,C10,V10),append([],V10,L10));
    L10=[]),
    (
    (getSpider2(Player,S2),getInBoard(S2,I11),I11=:=0,getRow(S2,R11),
    getColumn(S2,C11),setPCoordinates(R11,C11,V11),append([],V11,L11));
    L11=[]),
    (
    (getLadybug(Player,L),getInBoard(L,I12),I12=:=0,getRow(L,R12),
    getColumn(L,C12),setPCoordinates(R12,C12,V12),append([],V12,L12));
    L12=[]),
    append([],[L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12],T),
    delete(T, [], R).
    
retAllRecordInBoard(Player,R):-
    getQueen(Player,Q),getInBoard(Q,I1),
    (
        (I1=:=0,append([],Q,L1));
        (L1=[])
    ),
    getAnt1(Player,A1),getInBoard(A1,I2),
    (
        (I2=:=0,append([],A1,L2));
        (L2=[])
    ),
    getAnt2(Player,A2),getInBoard(A2,I3),
    (    
        (I3=:=0,append([],A2,L3));
        (L3=[])
    ),
    getAnt3(Player,A3),getInBoard(A3,I4),
    (    
        (I4=:=0,append([],A3,L4));
        (L4=[])
    ),
    getGrasshoper1(Player,G1),getInBoard(G1,I5),
    (
        (I5=:=0,append([],G1,L5));
        (L5=[])
    ),
    getGrasshoper2(Player,G2),getInBoard(G2,I6),
    (
        (I6=:=0,append([],G2,L6));
        (L6=[])
    ),
    getGrasshoper3(Player,G3),getInBoard(G3,I7),
    (
        (I7=:=0,append([],G3,L7));
        (L7=[])
    ),
    getBeetle1(Player,B1),getInBoard(B1,I8),
    (
        (I8=:=0,append([],B1,L8));
        (L8=[])
    ),
    getBeetle2(Player,B2),getInBoard(B2,I9),
    (
        (I9=:=0,append([],B2,L9));
        (L9=[])
    ),
    getSpider1(Player,S1),getInBoard(S1,I10),
    (
        (I10=:=0,append([],S1,L10));
        (L10=[])
    ),
    getSpider2(Player,S2),getInBoard(S2,I11),
    (
        (I11=:=0,append([],S2,L11));
        (L11=[])
    ),
    getLadybug(Player,L),getInBoard(L,I12),
    (
        (I12=:=0,append([],L,L12));
        (L12=[])
    ),
    append([],[L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12],T),
    delete(T, [], R).

queenAvailable(Player,R):-
    getQueen(Player,Queen),
    getInBoard(Queen,R).

ant1Available(Player,R):-
    getAnt1(Player,A1),
    getInBoard(A1,R).

ant2Available(Player,R):-
    getAnt2(Player,A1),
    getInBoard(A1,R).

ant3Available(Player,R):-
    getAnt3(Player,A1),
    getInBoard(A1,R).

grasshoper1Available(Player,R):-
    getGrasshoper1(Player,G),
    getInBoard(G,R).

grasshoper2Available(Player,R):-
    getGrasshoper2(Player,G),
    getInBoard(G,R).

grasshoper3Available(Player,R):-
    getGrasshoper3(Player,G),
    getInBoard(G,R).

beetle1Available(Player,R):-
    getBeetle1(Player,B),
    getInBoard(B,R).

beetle2Available(Player,R):-
    getBeetle2(Player,B),
    getInBoard(B,R).

spider1Available(Player,R):-
    getSpider1(Player,S),
    getInBoard(S,R).

spider2Available(Player,R):-
    getSpider2(Player,S),
    getInBoard(S,R).

ladybugAvailable(Player,R):-
    getLadybug(Player,LB),
    getInBoard(LB,R).

anyAnt(Player,R):- 
    (ant3Available(Player,A3),A3=:=1,R is 3);
    (ant2Available(Player,A2),A2=:=1,R is 2);
    (ant1Available(Player,A1),A1=:=1,R is 1);
    R is 0.

anyGrasshoper(Player,R):- 
    (grasshoper3Available(Player,A3),A3=:=1,R is 3);
    (grasshoper2Available(Player,A2),A2=:=1,R is 2);
    (grasshoper1Available(Player,A1),A1=:=1,R is 1);
    R is 0.

anyBeetle(Player,R):- 
    (beetle2Available(Player,A2),A2=:=1,R is 2);
    (beetle1Available(Player,A1),A1=:=1,R is 1);
    R is 0.

anySpider(Player,R):- 
    (spider2Available(Player,A2),A2=:=1,R is 2);
    (spider1Available(Player,A1),A1=:=1,R is 1);
    R is 0.

hasAnyInHand(Player,R):-
    (queenAvailable(Player,R1),R1=:=1,R is 1);
    (anyAnt(Player,R2),R2=:=1,R is 1);
    (anyGrasshoper(Player,R3),R3=:=1,R is 1);
    (anyBeetle(Player,R4),R4=:=1,R is 1);
    (anySpider(Player,R5),R5=:=1,R is 1);
    (ladybugAvailable(Player,R6),R6=:=1,R is 1);
    R is 0.

hasQueenPos(Player,Row,Column,A):-
    queenAvailable(Player,A1),
    (A1=:=0,A is 0);
    (getQueen(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasAnt1Pos(Player,Row,Column,A):-
    ant1Available(Player,A1),
    (A1=:=0,A is 0);
    (getAnt1(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasAnt2Pos(Player,Row,Column,A):-
    ant2Available(Player,A1),
    (A1=:=0,A is 0);
    (getAnt2(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasAnt3Pos(Player,Row,Column,A):-
    ant3Available(Player,A1),
    (A1=:=0,A is 0);
    (getAnt3(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasGrasshoper1Pos(Player,Row,Column,A):-
    grasshoper1Available(Player,A1),
    (A1=:=0,A is 0);
    (getGrasshoper1(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasGrasshoper2Pos(Player,Row,Column,A):-
    grasshoper2Available(Player,A1),
    (A1=:=0,A is 0);
    (getGrasshoper2(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasGrasshoper3Pos(Player,Row,Column,A):-
    grasshoper3Available(Player,A1),
    (A1=:=0,A is 0);
    (getGrasshoper3(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasBeetle1Pos(Player,Row,Column,A):-
    beetle1Available(Player,A1),
    (A1=:=0,A is 0);
    (getBeetle1(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasBeetle2Pos(Player,Row,Column,A):-
    beetle2Available(Player,A1),
    (A1=:=0,A is 0);
    (getBeetle2(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasSpider1Pos(Player,Row,Column,A):-
    spider1Available(Player,A1),
    (A1=:=0,A is 0);
    (getSpider1(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasSpider2Pos(Player,Row,Column,A):-
    spider2Available(Player,A1),
    (A1=:=0,A is 0);
    (getSpider2(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

hasLadybugPos(Player,Row,Column,A):-
    ladybugAvailable(Player,A1),
    (A1=:=0,A is 0);
    (getLadybug(Player,Q),
    getRow(Q,R),
    getColumn(Q,C),
    Row=:=R,
    Column=:=C,A is 1);
    A is 0.

updQueen(Player,NewPlayer,Row,Column):-
    getQueen(Player,Queen),
    setRow(Row,Queen,NQueen),
    setColumn(Column,NQueen,NNQueen),
    setInBoard(0,NNQueen,FQueen),
    setQueen(FQueen,Player,NewPlayer).

updAnt1(Player,NewPlayer,Row,Column):-
    getAnt1(Player,Ant),
    setRow(Row,Ant,NA),
    setColumn(Column,NA,NNA),
    setInBoard(0,NNA,FA),
    setAnt1(FA,Player,NewPlayer).

updAnt2(Player,NewPlayer,Row,Column):-
    getAnt2(Player,Ant),
    setRow(Row,Ant,NA),
    setColumn(Column,NA,NNA),
    setInBoard(0,NNA,FA),
    setAnt2(FA,Player,NewPlayer).

updAnt3(Player,NewPlayer,Row,Column):-
    getAnt3(Player,Ant),
    setRow(Row,Ant,NA),
    setColumn(Column,NA,NNA),
    setInBoard(0,NNA,FA),
    setAnt3(FA,Player,NewPlayer).

updGrasshoper1(Player,NewPlayer,Row,Column):-
    getGrasshoper1(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setGrasshoper1(FV,Player,NewPlayer).

updGrasshoper2(Player,NewPlayer,Row,Column):-
    getGrasshoper2(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setGrasshoper2(FV,Player,NewPlayer).

updGrasshoper3(Player,NewPlayer,Row,Column):-
    getGrasshoper3(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setGrasshoper3(FV,Player,NewPlayer).

updBeetle1(Player,NewPlayer,Row,Column):-
    getBeetle1(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setBeetle1(FV,Player,NewPlayer).

updBeetle2(Player,NewPlayer,Row,Column):-
    getBeetle2(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setBeetle2(FV,Player,NewPlayer).

updSpider1(Player,NewPlayer,Row,Column):-
    getSpider1(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setSpider1(FV,Player,NewPlayer).

updSpider2(Player,NewPlayer,Row,Column):-
    getSpider2(Player,V),
    setRow(Row,V,NV),
    setColumn(Column,NV,NNV),
    setInBoard(0,NNV,FV),
    setSpider2(FV,Player,NewPlayer).

updLadybug(Player,NewPlayer,Row,Column):-
    getLadybug(Player,P),
    setRow(Row,P,NP),
    setColumn(Column,NP,NNP),
    setInBoard(0,NNP,FP),
    setLadybug(FP,Player,NewPlayer).

increaseAll(Player,Row,Column,NewPlayer):-
    getQueen(Player,Queen),
    getRow(Queen,Row1),
    getColumn(Queen,Column1),
    getInBoard(Queen,IBQ),
    (
        (IBQ=:=0,Row=:=Row1,Column=:=Column1,increaseSP(Queen,NQueen),setQueen(NQueen,Player,NP1));
        (setQueen(Queen,Player,NP1))
    ),
    getAnt1(Player,A1),
    getRow(A1,A1Row),
    getColumn(A1,A1Col),
    getInBoard(A1,IBA1),
    (
        (IBA1=:=0,Row=:=A1Row,Column=:=A1Col,increaseSP(A1,NA1),setAnt1(NA1,NP1,NP2));
        (setAnt1(A1,NP1,NP2))
    ),
    getAnt2(Player,A2),
    getRow(A2,A2Row),
    getColumn(A2,A2Col),
    getInBoard(A2,IBA2),
    (
        (IBA2=:=0,Row=:=A2Row,Column=:=A2Col,increaseSP(A2,NA2),setAnt2(NA2,NP2,NP3));
        (setAnt2(A2,NP2,NP3))
    ),
    getAnt3(Player,A3),
    getRow(A3,A3Row),
    getColumn(A3,A3Col),
    getInBoard(A3,IBA3),
    (
        (IBA3=:=0,Row=:=A3Row,Column=:=A3Col,increaseSP(A3,NA3),setAnt3(NA3,NP3,NP4));
        (setAnt3(A3,NP3,NP4))
    ),
    getGrasshoper1(Player,G1),
    getRow(G1,G1Row),
    getColumn(G1,G1Col),
    getInBoard(G1,IBG1),
    (
        (IBG1=:=0,Row=:=G1Row,Column=:=G1Col,increaseSP(G1,NG1),setGrasshoper1(NG1,NP4,NP5));
        (setGrasshoper1(G1,NP4,NP5))
    ),
    getGrasshoper2(Player,G2),
    getRow(G2,G2Row),
    getColumn(G2,G2Col),
    getInBoard(G2,IBG2),
    (
        (IBG2=:=0,Row=:=G2Row,Column=:=G2Col,increaseSP(G2,NG2),setGrasshoper2(NG2,NP5,NP6));
        (setGrasshoper2(G2,NP5,NP6))
    ),
    getGrasshoper3(Player,G3),
    getRow(G3,G3Row),
    getColumn(G3,G3Col),
    getInBoard(G3,IBG3),
    (
        (IBG3=:=0,Row=:=G3Row,Column=:=G3Col,increaseSP(G3,NG3),setGrasshoper3(NG3,NP6,NP7));
        (setGrasshoper3(G3,NP6,NP7))
    ),
    getBeetle1(Player,B1),
    getRow(B1,B1Row),
    getColumn(B1,B1Col),
    getInBoard(B1,IBB1),
    (
        (IBB1=:=0,Row=:=B1Row,Column=:=B1Col,increaseSP(B1,NB1),setBeetle1(NB1,NP7,NP8));
        (setBeetle1(B1,NP7,NP8))
    ),
    getBeetle2(Player,B2),
    getRow(B2,B2Row),
    getColumn(B2,B2Col),
    getInBoard(B2,IBB2),
    (
        (IBB2=:=0,Row=:=B2Row,Column=:=B2Col,increaseSP(B2,NB2),setBeetle2(NB2,NP8,NP9));
        (setBeetle2(B2,NP8,NP9))
    ),
    getSpider1(Player,S1),
    getRow(S1,S1Row),
    getColumn(S1,S1Col),
    getInBoard(S1,IBS1),
    (
        (IBS1=:=0,Row=:=S1Row,Column=:=S1Col,increaseSP(S1,NS1),setSpider1(NS1,NP9,NP10));
        (setSpider1(S1,NP9,NP10))
    ),
    getSpider2(Player,S2),
    getRow(S2,S2Row),
    getColumn(S2,S2Col),
    getInBoard(S2,IBS2),
    (
        (IBS2=:=0,Row=:=S2Row,Column=:=S2Col,increaseSP(S2,NS2),setSpider2(NS2,NP10,NP11));
        (setSpider2(S2,NP10,NP11))
    ),
    getLadybug(Player,LB),
    getRow(LB,LBRow),
    getColumn(LB,LBCol),
    getInBoard(LB,IBLB),
    (
        (IBLB=:=0,Row=:=LBRow,Column=:=LBCol,increaseSP(LB,NLB),setLadybug(NLB,NP11,NewPlayer));
        (setLadybug(LB,NP11,NewPlayer))
    ).

decreaseAll(Player,Row,Column,NewPlayer):-
    getQueen(Player,Queen),
    getRow(Queen,Row1),
    getColumn(Queen,Column1),
    getInBoard(Queen,IBQ),
    (
        (IBQ=:=0,Row=:=Row1,Column=:=Column1,decreaseSP(Queen,NQueen),setQueen(NQueen,Player,NP1));
        (setQueen(Queen,Player,NP1))
    ),
    getAnt1(Player,A1),
    getRow(A1,A1Row),
    getColumn(A1,A1Col),
    getInBoard(A1,IBA1),
    (
        (IBA1=:=0,Row=:=A1Row,Column=:=A1Col,decreaseSP(A1,NA1),setAnt1(NA1,NP1,NP2));
        (setAnt1(A1,NP1,NP2))
    ),
    getAnt2(Player,A2),
    getRow(A2,A2Row),
    getColumn(A2,A2Col),
    getInBoard(A2,IBA2),
    (
        (IBA2=:=0,Row=:=A2Row,Column=:=A2Col,decreaseSP(A2,NA2),setAnt2(NA2,NP2,NP3));
        (setAnt2(A2,NP2,NP3))
    ),
    getAnt3(Player,A3),
    getRow(A3,A3Row),
    getColumn(A3,A3Col),
    getInBoard(A3,IBA3),
    (
        (IBA3=:=0,Row=:=A3Row,Column=:=A3Col,decreaseSP(A3,NA3),setAnt3(NA3,NP3,NP4));
        (setAnt3(A3,NP3,NP4))
    ),
    getGrasshoper1(Player,G1),
    getRow(G1,G1Row),
    getColumn(G1,G1Col),
    getInBoard(G1,IBG1),
    (
        (IBG1=:=0,Row=:=G1Row,Column=:=G1Col,decreaseSP(G1,NG1),setGrasshoper1(NG1,NP4,NP5));
        (setGrasshoper1(G1,NP4,NP5))
    ),
    getGrasshoper2(Player,G2),
    getRow(G2,G2Row),
    getColumn(G2,G2Col),
    getInBoard(G2,IBG2),
    (
        (IBG2=:=0,Row=:=G2Row,Column=:=G2Col,decreaseSP(G2,NG2),setGrasshoper2(NG2,NP5,NP6));
        (setGrasshoper2(G2,NP5,NP6))
    ),
    getGrasshoper3(Player,G3),
    getRow(G3,G3Row),
    getColumn(G3,G3Col),
    getInBoard(G3,IBG3),
    (
        (IBG3=:=0,Row=:=G3Row,Column=:=G3Col,decreaseSP(G3,NG3),setGrasshoper3(NG3,NP6,NP7));
        (setGrasshoper3(G3,NP6,NP7))
    ),
    getBeetle1(Player,B1),
    getRow(B1,B1Row),
    getColumn(B1,B1Col),
    getInBoard(B1,IBB1),
    (
        (IBB1=:=0,Row=:=B1Row,Column=:=B1Col,decreaseSP(B1,NB1),setBeetle1(NB1,NP7,NP8));
        (setBeetle1(B1,NP7,NP8))
    ),
    getBeetle2(Player,B2),
    getRow(B2,B2Row),
    getColumn(B2,B2Col),
    getInBoard(B2,IBB2),
    (
        (IBB2=:=0,Row=:=B2Row,Column=:=B2Col,decreaseSP(B2,NB2),setBeetle2(NB2,NP8,NP9));
        (setBeetle2(B2,NP8,NP9))
    ),
    getSpider1(Player,S1),
    getRow(S1,S1Row),
    getColumn(S1,S1Col),
    getInBoard(S1,IBS1),
    (
        (IBS1=:=0,Row=:=S1Row,Column=:=S1Col,decreaseSP(S1,NS1),setSpider1(NS1,NP9,NP10));
        (setSpider1(S1,NP9,NP10))
    ),
    getSpider2(Player,S2),
    getRow(S2,S2Row),
    getColumn(S2,S2Col),
    getInBoard(S2,IBS2),
    (
        (IBS2=:=0,Row=:=S2Row,Column=:=S2Col,decreaseSP(S2,NS2),setSpider2(NS2,NP10,NP11));
        (setSpider2(S2,NP10,NP11))
    ),
    getLadybug(Player,LB),
    getRow(LB,LBRow),
    getColumn(LB,LBCol),
    getInBoard(LB,IBLB),
    (
        (IBLB=:=0,Row=:=LBRow,Column=:=LBCol,decreaseSP(LB,NLB),setLadybug(NLB,NP11,NewPlayer));
        (setLadybug(LB,NP11,NewPlayer))
    ).