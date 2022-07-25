:-module(selector,[selectPositionFromAvailables/2]).
:- use_module('utils/positions',[getPCoordinates/3]).
:- set_prolog_flag(encoding, utf8).

printPosition(Row,Column,Counter):-
    write(Counter),
    write(". ["),
    write(Row),
    write(","),
    write(Column),
    writeln("].").

printPosiblePositions([],_).
printPosiblePositions([R|Rs],Counter):-
    getPCoordinates(R,Row,Column),
    NCounter is Counter+1,
    printPosition(Row,Column,NCounter),
    printPosiblePositions(Rs,NCounter).

selectPositionFromAvailables(Positions,Result):-
    writeln("Posibles Posiciones:"),
    printPosiblePositions(Positions,0),
    read(Option),
    selectPositionFromAvailables1(Positions,Option,TR),
    (
       (
           (TR=:= -1,
           selectPositionFromAvailables(Positions,NR),
            Result is NR)
       );
       (
           (Result is TR)
       )
    ).

selectPositionFromAvailables1(Positions,Option,Result):-
    length(Positions,L),
    integer(Option),
    Option>0,
    Option=<L,
    Result is Option-1.
    

selectPositionFromAvailables1(_,_,Result):-
    writeln("Debes introducir un valor válido."),
    writeln(""),
    Result is -1.
