:- module( cells_play, [ cellsMeth/5,
    recordsThatCanBeMoved/4,
    moveToPos/6,
    getRecordToPlay/4
                       ]
         ).

:- use_module(record,[getColumn/2,getRow/2,increaseSP/2]).
:- use_module(c_utils1,[printRecordsInBoard/3]).
:- use_module( player, [ updQueen/4,
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
                        increaseAll/4,
                        decreaseAll/4,
                        getBeetle1/2,
                        getBeetle2/2,
                        setBeetle1/3,
                        setBeetle2/3
				       ]
		     ).
:- use_module('utils/positions',[retFromBoardPositions/3,getPCoordinates/3]).
:- use_module(selector,[selectPositionFromAvailables/2]).            
:- use_module('utils/moves', [canAnt1Move/4,
    canAnt2Move/4,
    canAnt3Move/4,
    canQueenMove/4,
    canBeetle1Move/4,
    canBeetle2Move/4,
    canGrasshoper1Move/4,
    canGrasshoper2Move/4,
    canGrasshoper3Move/4,
    canSpider1Move/4,
    canSpider2Move/4,
    canLadybugMove/4
                                 ] ).
:- set_prolog_flag(encoding, utf8).

%Meths

%Records dice cuales puedo mover y positions hacia donde
recordsThatCanBeMoved(IBoard,Player,Records,PositionsListForRecord):-
    retFromBoardPositions(IBoard,[],Board),
    canQueenMove(Board,Player,QQM,QPos),
    canAnt1Move(Board,Player,A1QM,A1Pos),
    canAnt2Move(Board,Player,A2QM,A2Pos),
    canAnt3Move(Board,Player,A3QM,A3Pos),
    canGrasshoper1Move(Board,Player,G1QM,G1Pos),
    canGrasshoper2Move(Board,Player,G2QM,G2Pos),
    canGrasshoper3Move(Board,Player,G3QM,G3Pos),
    canBeetle1Move(Board,Player,B1QM,B1Pos),
    canBeetle2Move(Board,Player,B2QM,B2Pos),
    canSpider1Move(Board,Player,S1QM,S1Pos),
    canSpider2Move(Board,Player,S2QM,S2Pos),
    canLadybugMove(Board,Player,LQM,LPos),
    %            Q  A1   A2  A3   G1   G2   G3   B1   B2   S1    S2   L  
    append([],[QQM,A1QM,A2QM,A3QM,G1QM,G2QM,G3QM,B1QM,B2QM,S1QM,S2QM,LQM],Records),
    append([],[QPos,A1Pos,A2Pos,A3Pos,G1Pos,G2Pos,G3Pos,B1Pos,B2Pos,S1Pos,S2Pos,LPos],PositionsListForRecord).

%Da el index de la posicion del record o sea de la ficha a jugar 
getRecordToPlay(_,0,StartPos,Result):- Result is StartPos.    
getRecordToPlay([R|Rs],InputValue,StartPos,Result):-
    NSP is StartPos+1,
    (
        (
            R>0,
            NIV is InputValue-1,
            getRecordToPlay(Rs,NIV,NSP,Result)

        );
        (
            getRecordToPlay(Rs,InputValue,NSP,Result)
        )
    ).



beetleCase(NRow,NCol,ORow,OCol,Player,NewPlayer):-
    increaseAll(Player,NRow,NCol,NP1),
    decreaseAll(NP1,ORow,OCol,NewPlayer).
    

moveToPos(Pos, RecordToMove, Player,OtherPlayer, NewPlayer,NewOtherPlayer):-
    getPCoordinates(Pos,R,C),
    (
    ( RecordToMove =:= 0, updQueen(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer
    );
    ( RecordToMove =:= 1, updAnt1(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 2, updAnt2(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 3, updAnt3(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 4, updGrasshoper1(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 5, updGrasshoper2(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 6, updGrasshoper3(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:= 7, 
        getBeetle1(Player,B1),
        getRow(B1,B1R),
        getColumn(B1,B1C),
        %Actualizame los que me puse arriba de mi jugador
        beetleCase(R,C,B1R,B1C,Player,TPlayer),
        %Acyualizame los que m puse arriba del otro jugador
        beetleCase(R,C,B1R,B1C,OtherPlayer,NewOtherPlayer),
        updBeetle1(TPlayer, BPlayer, R, C),
        getBeetle1(BPlayer,NB),
        increaseSP(NB,FinalBeetle),
        setBeetle1(FinalBeetle,BPlayer,NewPlayer)
    );
    ( RecordToMove =:= 8,
        getBeetle2(Player,B2),
        getRow(B2,B2R),
        getColumn(B2,B2C),
        %Actualizame los que me puse arriba de mi jugador
        beetleCase(R,C,B2R,B2C,Player,TPlayer),
        %Acyualizame los que m puse arriba del otro jugador
        beetleCase(R,C,B2R,B2C,OtherPlayer,NewOtherPlayer),
        updBeetle2(TPlayer, BPlayer, R, C),
        getBeetle2(BPlayer,NB),
        increaseSP(NB,FinalBeetle),
        setBeetle2(FinalBeetle,BPlayer,NewPlayer)
        );
    ( RecordToMove =:= 9, updSpider1(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:=10, updSpider2(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer);
    ( RecordToMove =:=11, updLadybug(Player, NewPlayer, R, C),NewOtherPlayer=OtherPlayer)
    ).

cellsMeth(Board,Player1,Player2,NewPlayer1,NewPlayer2):-
    recordsThatCanBeMoved(Board,Player1,Records,PositionsListForRecord),
    %Devuelve todas las fichas que se pueden Mover
    printRecordsInBoard(Player1,Records,InputValue),
    %Obtiene la ficha que selecciono que va a jugar jugador
    getRecordToPlay(Records,InputValue,-1,PosToMove),
    %Devuelve las posibles posiciones a mover
    nth0(PosToMove,PositionsListForRecord,Positions),
    writeln(""),
    selectPositionFromAvailables(Positions,PosSelected),
    nth0(PosSelected,Positions,Pos),
    moveToPos(Pos,PosToMove,Player1,Player2,NewPlayer1,NewPlayer2).