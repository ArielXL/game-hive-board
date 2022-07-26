:- module( options_selector, [ bothOptions/1,
                               firstOption/1,
                               secondOption/1,
                               noOptions/1,
                               moveOrPutToken/5,
                               canPlayOption1/3,
                               canPlayOption2/3
                             ]
         ).

:- use_module(positions,[retFromBoardPositions/3]).
:- use_module( player, [ hasAnyInHand/2,
                            queenAvailable/2,
                            retAllRecordInBoard/2 ] ).

:- use_module(play_options/cells_play,[recordsThatCanBeMoved/4]).                        
:- use_module( moves, [
                        canAnt1Move/4,
                        canAnt2Move/4,
                        canAnt3Move/4,
                        canQueenMove/4,
                        canBeetle1Move/4,
                        canBeetle2Move/4,
                        canGrasshoper1Move/4,
                        canGrasshoper2Move/4,
                        canGrasshoper3Move/4,
                        canLadybugMove/4,
                        canSpider1Move/4,
                        canSpider2Move/4] ).

%Meths
queenCondition():-
    writeln("Tienes que poner a la reina porque ya estás en el cuarto turno."), 
    writeln("").

printBothChoices():-    
    writeln("Selecciona la opción deseada:"), 
    writeln("1. Colocar una ficha de la mano."), 
    writeln("2. Mover una ficha en el tablero.").

bothOptions(OptionBO):-
    printBothChoices(),
    read(Option),
    bothOptions1(Option,Result),
    (
        (Result=:= -1, bothOptions(NOption),OptionBO is NOption);
        (OptionBO is Option)
    ),
    writeln("").

bothOptions1(OptionBO,Result):-
    number(OptionBO),
    (OptionBO=:=1;OptionBO=:=2),
    Result is 1.

bothOptions1(_,Result):- 
    writeln("Debes introducir valor 1 ó 2."),writeln(""),Result is -1.


firstOption(OptionF):-
    writeln("Solo puedes colocar una ficha de la mano."), 
    writeln(""),
    OptionF is 1.

secondOption(OptionS):-
    writeln("Solo puedes mover una ficha en el tablero."), 
    writeln(""),
    OptionS is 2.

noOptions(OptionNO):-
    writeln("No puedes jugar en este turno."),
    writeln(""),
    OptionNO is 0.

%Chequear si puede agregar alguna ficha 1 si se puede 0 eoc
canPlayOption1(Player1,Positions,Option):-
    hasAnyInHand(Player1,R),
    (
        (R=:=0,Option is 0);
        (length(Positions, LP),
            (
            (LP>0, Option is 1);
            (Option is 0)
            )
        )
    ).    

%Chequear si puede mover alguna ficha del tablero 1 si se puede 0 eoc
canPlayOption2(Board,Player1,Option):-
    queenAvailable(Player1,R),
    (
        (
            %Solo se puede mover cuando la reina en el tablero
            R=:=0,                
            recordsThatCanBeMoved(Board,Player1,X,_),
            hasValueNoZero(X,Option)
            
        );
        Option is 0
    ).
hasValueNoZero([],Result):-Result is 0.
hasValueNoZero([R|Rs],Result):-
    (
        (R=\=0,Result is 1);
        (hasValueNoZero(Rs,Result))
    ).
%Checkear el caso que hay que poner obligaroriamente a la reina
checkQueenCondition(Player1,TurnCount,Option):-
    (TurnCount=:=4,queenAvailable(Player1,R),R=:=1, Option is 1);
    Option is 0.

moveOrPutToken(Board,Player1,TurnCount,Positions,Option):-
    checkQueenCondition(Player1,TurnCount,C1R),
    (
        (C1R=:=1, queenCondition(),Option is 3);
        canPlayOption1(Player1,Positions,Option1),
        canPlayOption2(Board,Player1,Option2),
        (

            (Option1=:=1,Option2=:=1,bothOptions(Option));
            (Option1=:=1,firstOption(Option));
            (Option2=:=1,secondOption(Option));
            (noOptions(Option))
        )
    ).