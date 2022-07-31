:- module( play_between_players, [ playBetweenTwoPlayers/0,loopPlayBetweenPlayers/3,playerPlay/8]).

:- use_module( player, [ initPlayer/2,hasAnyInHand/2,retAllPositionsInBoard/2,retAllRecordInBoard/2]).
:- use_module( 'utils/printer', [ printBoard/2,printEnd/1,printTabla/0]).
:- use_module( 'utils/options_selector', [ moveOrPutToken/5 ] ).
:- use_module( 'play_options/hand_play', [ handMeth/3,handQueenConditionMeth/3]).
:- use_module( 'play_options/cells_play', [ cellsMeth/5 ] ).
:- use_module( 'utils/positions', [ adjAll/2,adjNoCommon/3,getBoardRecords/3,gameOverCheck/5]).

:- set_prolog_flag(encoding, utf8).

playerPlay(Board,Player1,Player2, NewPlayer1,NewPlayer2, Positions,TurnCount,Option) :-
    %Select choice to play
    %printBoard(Board),
    moveOrPutToken(Board,Player1,TurnCount, Positions,Option),
    
    % colocar una pieza desde la mano
    (
        ( Option =:= 1,handMeth(Player1, Positions, NewPlayer1),NewPlayer2=Player2
        );
        % mover una pieza en el tablero
        ( Option =:= 2,cellsMeth(Board,Player1, Player2,NewPlayer1,NewPlayer2)
                          % printOptions(Board, PlayerColor)
        );
        % Poner la reina en el tablero xq es turno 4
        ( Option =:= 3,handQueenConditionMeth(Player1,Positions,NewPlayer1),NewPlayer2=Player2
        %Caso en que no puedo jugar                            
        );
        (   Option =:= 0,
            NewPlayer1 = Player1,
            NewPlayer2=Player2
        )
    ).

loopPlayBetweenPlayers(FirstPlayer, SecondPlayer, Turn) :-
    Turn1 is Turn + 1,
    adjNoCommon(FirstPlayer, SecondPlayer, Positions),
    write("\33[2J"),
    writeln(""),
    writeln("TURNO DE LAS FICHAS BLANCAS"),
    writeln(""),
    getBoardRecords(FirstPlayer,SecondPlayer,Board1),
    printBoard(Board1,High1),
    writef("\33[0;%dH",[High1]),
    playerPlay(Board1,FirstPlayer,SecondPlayer ,NewFirstPlayer,NewSecondPlayer, Positions,Turn1,Option1),

    getBoardRecords(NewFirstPlayer,NewSecondPlayer,Board2),
    gameOverCheck(NewFirstPlayer,NewSecondPlayer,Board2,IsOver1,Winner1),
    (
        (IsOver1=:=1,write("\33[2J"),printBoard(Board2,High2),writef("\33[0;%dH",[High2]),printEnd(Winner1));
        (
            write("\33[2J"),
            writeln(""),
            writeln("TURNO DE LAS FICHAS NEGRAS"),
            writeln(""),

            printBoard(Board2,High2),
            writef("\33[0;%dH",[High2]),
            adjNoCommon(NewSecondPlayer, NewFirstPlayer, NPositions),
            playerPlay(Board2,NewSecondPlayer,NewFirstPlayer,NNewSecondPlayer,NNewFirstPlayer, NPositions,Turn1, Option2),

            %Option 2 is 0 es que no pudo jugar este jugador
            getBoardRecords(NNewFirstPlayer,NNewSecondPlayer,Board3),
            gameOverCheck(NNewFirstPlayer,NNewSecondPlayer,Board3,IsOver2,Winner2),
            (
                (IsOver2=:=1,write("\33[2J"),printBoard(Board3,High3),writef("\33[0;%dH",[High3]),printEnd(Winner2));
                (Option1=:=0,Option2=:=0,printTabla());
                (loopPlayBetweenPlayers(NNewFirstPlayer,NNewSecondPlayer,Turn1))
            )    
        )
    ).
    

firstTurn(FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer) :-
    FirstRecord = [[0, 0]],
    write("\33[2J"),
    writeln(""),
    writeln("TURNO DE LAS FICHAS BLANCAS"),
    writeln(""),
    playerPlay([],FirstPlayer,SecondPlayer, NewFirstPlayer, _,FirstRecord,1,_),
    write("\33[2J"),
    writeln(""),
    writeln("TURNO DE LAS FICHAS NEGRAS"),
    writeln(""),
    getBoardRecords(NewFirstPlayer,SecondPlayer,Board),
    printBoard(Board,High),
    writef("\33[0;%dH",[High]),
    adjAll([0,0], AdjacentPositions),
    playerPlay(Board,SecondPlayer, NewFirstPlayer,NewSecondPlayer,_, AdjacentPositions,1,_).

playBetweenTwoPlayers():-
    write("\33[2J"),
    writeln("USTED HA ELEGIDO JUGAR ENTRE DOS JUGADORES."), 
    writeln(""),
    initPlayer(0, FirstPlayer),
    initPlayer(1, SecondPlayer),
    firstTurn(FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer),
    loopPlayBetweenPlayers(NewFirstPlayer, NewSecondPlayer, 1).
