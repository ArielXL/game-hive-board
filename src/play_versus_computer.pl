:- module( play_versus_computer, [ playVersusComputer/0 ] ).

:- set_prolog_flag(encoding, utf8).

:- use_module( player, [ initPlayer/2,
                         hasAnyInHand/2,
                         queenAvailable/2,
                         ladybugAvailable/2,
                         anyAnt/2,
                         anyGrasshoper/2,
                         anyBeetle/2,
                         anySpider/2,
                         retAllPositionsInBoard/2,
                         retAllRecordInBoard/2,getColorP/2
                       ]
             ).

:- use_module( 'utils/printer', [ printBoard/2,printEnd/1,printTabla/0]).
:- use_module( 'utils/tools', [ chooseColor/1 ] ).
:- use_module( 'utils/options_selector', [ moveOrPutToken/5,
                                           bothOptions/1,
                                           firstOption/1,
                                           secondOption/1,
                                           noOptions/1,
                                           canPlayOption1/3,
                                           canPlayOption2/3
                                         ]
             ).
:- use_module( 'play_options/hand_play', [ handMeth/3,
                                           playInPos/5,
                                           handQueenConditionMeth/3
                                         ]
             ).

:- use_module( 'play_options/cells_play', [ cellsMeth/5,
                                            recordsThatCanBeMoved/4,
                                            moveToPos/6,
                                            getRecordToPlay/4
                                          ]
             ).

:- use_module( 'play_options/selector', [ selectPositionFromAvailables/2 ] ).
:- use_module( 'utils/positions', [ adjAll/2,
                                    adjNoCommon/3,
                                    setPCoordinates/3,
                                    queenSurrounded/3,
                                    gameOverCheck/5,
                                    getBoardRecords/3
                                  ]
             ).

:- use_module( record, [ getInBoard/2,
                         getRow/2,
                         getColumn/2,
                         getTokenType/2
                       ]
             ).

:- use_module( 'utils/options_selector', [ canPlayOption1/3,canPlayOption2/3]).

playerPlay(Board, Player1, Player2, NewPlayer1, NewPlayer2, Positions, TurnCount, Option) :-
    %Select choice to play
    %printBoard(Board),
    moveOrPutToken(Board, Player1, TurnCount, Positions, Option),
    % colocar una pieza desde la mano
    (
        (
            Option =:= 1,
            handMeth(Player1, Positions, NewPlayer1),
            NewPlayer2 = Player2
        );
        % mover una pieza en el tablero
        (
            Option =:= 2,
            cellsMeth(Board,Player1, Player2, NewPlayer1, NewPlayer2)
            % printOptions(Board, PlayerColor)
        );
        % poner la reina en el tablero xq es turno 4
        (
            Option =:= 3,
            handQueenConditionMeth(Player1, Positions, NewPlayer1),
            NewPlayer2 = Player2
        );
        % caso en que no puedo jugar
        (
            Option =:= 0,
            NewPlayer1 = Player1,
            NewPlayer2 = Player2
        )
    ).

getTokenTypeRandom(Player, RandomToken, R) :-
    random(1, 7, RandomToken),
    queenAvailable(Player, Queen),
    anyAnt(Player, Ants),
    anyGrasshoper(Player,Grasshopers),
    anyBeetle(Player, Beetles),
    anySpider(Player, Spiders),
    ladybugAvailable(Player, Ladybug),
    (
        (
            ( RandomToken =:= 1, Queen > 0, R is Queen );
            ( RandomToken =:= 2, Ants > 0, R is Ants );
            ( RandomToken =:= 3, Grasshopers > 0, R is Grasshopers );
            ( RandomToken =:= 4, Beetles > 0, R is Beetles );
            ( RandomToken =:= 5, Spiders > 0, R is Spiders );
            ( RandomToken =:= 6, Ladybug > 0, R is Ladybug )
        );
        (
            getTokenTypeRandom(Player, _, _)
        )
    ).

playComputerPut(_, FirstPlayer, SecondPlayer, NewFirstPlayer) :-
    getTokenTypeRandom(FirstPlayer, Option, R),
    adjNoCommon(FirstPlayer, SecondPlayer, Positions),
    length(Positions, LengthPositions),
    random(0, LengthPositions, RandomPos),
    nth0(RandomPos, Positions, Position),
    playInPos(Position, Option, R, FirstPlayer, NewFirstPlayer).

getListSize([], Count, ListLength) :- ListLength is Count.
getListSize([R|Rs], Count, ListLength) :-
    length(R, LR),
    (
        (
            LR =:= 0,
            getListSize(Rs, Count, ListLength)
        );
        (
            C is Count + 1,
            getListSize(Rs, C, ListLength)
        )
    ).

playComputerMove(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer) :-
    recordsThatCanBeMoved(Board, FirstPlayer, Records, PositionsListForRecord),
    getListSize(PositionsListForRecord, 0, FLength),
    random(0, FLength, PosSelected1),
    PosSelected is PosSelected1+1,
    getRecordToPlay(Records, PosSelected, -1, PosToMove),
    nth0(PosToMove, PositionsListForRecord, Pos),
    length(Pos, LPos),
    random(0, LPos, R),
    nth0(R, Pos, E),
    moveToPos(E, PosToMove, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer).

playComputer(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, _, Option) :-
    adjNoCommon(FirstPlayer, SecondPlayer, Positions),
    canPlayOption1(FirstPlayer, Positions, Option1),
    canPlayOption2(Board, FirstPlayer, Option2),
    (
        (
            Option1 =:= 1,
            Option2 =:= 1,
            random(0, 2, Option),
            (
                (
                    % si random = 0 => coloca pieza
                    Option =:= 0,
                    playComputerPut(Board, FirstPlayer, SecondPlayer, NewFirstPlayer),
                    NewSecondPlayer = SecondPlayer
                );
                (
                    % si random = 1 => mueve pieza
                    playComputerMove(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer)
                )
            )
        );
        (
            Option1 =:= 1,
            firstOption(Option),
            playComputerPut(Board, FirstPlayer, SecondPlayer, NewFirstPlayer),
            NewSecondPlayer = SecondPlayer
        );
        (
            Option2 =:= 1,
            secondOption(Option),
            playComputerMove(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer)
        );
        (
            noOptions(Option),
            NewFirstPlayer = FirstPlayer,
            NewSecondPlayer = SecondPlayer
        )
    ).

playGamer(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, Turn, Option) :-
    adjNoCommon(FirstPlayer, SecondPlayer, Positions),
    playerPlay(Board, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, Positions, Turn, Option).

% si IsWhite es 1 entonces juega la PC primero
loopPlayVersusComputer(FirstPlayer, SecondPlayer, Turn, IsWhite) :-
    Turn1 is Turn + 1,
    (
        (
            % la PC juega primero
            IsWhite =:= 1,
            write("\33[2J"),
            writeln("TURNO DE LAS FICHAS BLANCAS"),
            writeln(""),
            getBoardRecords(FirstPlayer, SecondPlayer, Board1),
            playComputer(Board1, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, Turn1, Option1),

            getBoardRecords(NewFirstPlayer, NewSecondPlayer, Board2),
            gameOverCheck(NewFirstPlayer,NewSecondPlayer,Board2,IsOver1,Winner1),
            (
                (IsOver1=:=1,write("\33[2J"),printBoard(Board2,High2),writef("\33[0;%dH",[High2]),printEnd(Winner1));
                (
                    write("\33[2J"),
                    writeln(""),
                    writeln("TURNO DE LAS FICHAS NEGRAS"),
                    writeln(""),

                    printBoard(Board2, High2),
                    writef("\33[0;%dH", [High2]),
                    playGamer(Board2, NewSecondPlayer, NewFirstPlayer, NNewSecondPlayer, NNewFirstPlayer, Turn1, Option2),
                    getBoardRecords(NNewFirstPlayer,NNewSecondPlayer,Board3),
                    gameOverCheck(NNewFirstPlayer,NNewSecondPlayer,Board3,IsOver2,Winner2),
                    (
                        (IsOver2=:=1,write("\33[2J"),printBoard(Board3,High3),writef("\33[0;%dH",[High3]),printEnd(Winner2));
                        %No pudieron jugar ninguno de los dos por lo que el juego termino en tabla
                        (Option1=:=0,Option2=:=0,printTabla());
                        (loopPlayVersusComputer(NNewFirstPlayer, NNewSecondPlayer, Turn1, IsWhite))
                    )    
                )
            )
            
        );
        (
            write("\33[2J"),
            % la PC juega de segundo
            writeln("TURNO DE LAS FICHAS BLANCAS"),
            writeln(""),
            getBoardRecords(FirstPlayer, SecondPlayer, Board1),
            printBoard(Board1, High1),
            writef("\33[0;%dH", [High1]),
            playGamer(Board1, FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, Turn1, Option1),
            
            getBoardRecords(NewFirstPlayer, NewSecondPlayer, Board2),
            gameOverCheck(NewFirstPlayer,NewSecondPlayer,Board2,IsOver1,Winner1),
            (
                (IsOver1=:=1,write("\33[2J"),printBoard(Board2,High2),writef("\33[0;%dH",[High2]),printEnd(Winner1));
                (
                    write("\33[2J"),
                    writeln(""),
                    writeln("TURNO DE LAS FICHAS NEGRAS"),
                    writeln(""),
                    playComputer(Board2, NewSecondPlayer, NewFirstPlayer, NNewSecondPlayer, NNewFirstPlayer, Turn1, Option2),
                    getBoardRecords(NNewFirstPlayer,NNewSecondPlayer,Board3),
                    gameOverCheck(NNewFirstPlayer,NNewSecondPlayer,Board3,IsOver2,Winner2),
                    (
                        (IsOver2=:=1,write("\33[2J"),printBoard(Board3,High3),writef("\33[0;%dH",[High3]),printEnd(Winner2));
                        %No pudieron jugar ninguno de los dos por lo que el juego termino en tabla
                        (Option1=:=0,Option2=:=0,printTabla());
                        (loopPlayVersusComputer(NNewFirstPlayer, NNewSecondPlayer, Turn1, IsWhite))
                    )    
                )
            )

        )
    ).

firstPlayer(FirstPlayer, SecondPlayer, NewFirstPlayer, NNewSecondPlayer) :-
    write("\33[2J"),
    writeln("TURNO DE LAS FICHAS BLANCAS"),
    writeln(""),
    FirstRecord = [ [0,0] ],
    playerPlay([], FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer, FirstRecord,1,_),
    write("\33[2J"),
    writeln(""),
    writeln("TURNO DE LAS FICHAS NEGRAS"),
    writeln(""),
    getBoardRecords(NewFirstPlayer, NewSecondPlayer, Board),
    printBoard(Board,High),
    writef("\33[0;%dH",[High]),

    adjAll([0,0], AdjacentPositions),
    length(AdjacentPositions, L),
    random(0, L, Random),
    nth0(Random, AdjacentPositions, Position),
    % siempre la PC pone la reina de primera
    playInPos(Position, 1, _, NewSecondPlayer, NNewSecondPlayer),
    write("LA COMPUTADORA HA JUGADO ABEJA REINA EN "),
    writeln(Position).

% juega la PC primero
firstComputer(FirstPlayer, SecondPlayer, NNewFirstPlayer, NewSecondPlayer) :-
    % siempre la PC pone la reina de primera
    playInPos([0, 0], 1, _, FirstPlayer, NewFirstPlayer),

    write("\33[2J"),
    writeln(""),
    writeln("TURNO DE LAS FICHAS NEGRAS"),
    writeln(""),
    getBoardRecords(NewFirstPlayer, SecondPlayer, Board),
    printBoard(Board,High),
    writef("\33[0;%dH",[High]),
    adjAll([0,0], AdjacentPositions),
    playerPlay(Board, SecondPlayer, NewFirstPlayer, NewSecondPlayer, NNewFirstPlayer, AdjacentPositions,1,_).

playVersusComputer() :-
    write("\33[2J"),
    writeln("USTED HA ELEGIDO JUGAR CONTRA LA COMPUTADORA."),
    writeln(""),
    initPlayer(0, FirstPlayer),
    initPlayer(1, SecondPlayer),
    chooseColor(IsWhite),
    (
        (
            IsWhite =:= 1,
            firstComputer(FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer),
            loopPlayVersusComputer(NewFirstPlayer, NewSecondPlayer, 1, IsWhite)
        );
        (
            firstPlayer(FirstPlayer, SecondPlayer, NewFirstPlayer, NewSecondPlayer),
            loopPlayVersusComputer(NewFirstPlayer, NewSecondPlayer, 1, IsWhite)
        )
    ).
