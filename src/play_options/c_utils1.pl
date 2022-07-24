:- module( c_utils1, [ printRecordsInBoard/3,
                        printRInBoard/4
                   ]
         ).

:- use_module( player, [ queenAvailable/2,
                         ladybugAvailable/2,
                         anyAnt/2,
                         anyGrasshoper/2,
                         anyBeetle/2,
                         anySpider/2,
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
                         getLadybug/2
                       ]
             ).

:- use_module( 'utils/moves', [ canAnt1Move/4,
                        canAnt2Move/4,
                        canAnt3Move/4,
                        canQueenMove/4,
                        canBeetle1Move/4,
                        canBeetle2Move/4,
                        canSpider1Move/4,
                        canSpider2Move/4,
                        canLadybugMove/4
                         ] ).
:-use_module(record,[getTokenType/2,
                    getRow/2,
                    getColumn/2,
                    getColor/2,
                    getInBoard/2,
                    getStackPosition/2]).
:- set_prolog_flag(encoding, utf8).


printRecordsInBoard(Player,Records,Result):-
    printRInBoard(Player,Records,InputOption,MaxV),
    printRecordsInBoard1(InputOption,MaxV,R),
    (
        (
            R=:= -1,
            printRecordsInBoard(Player,Records,NResult),
            Result is NResult
        );
        (
            Result is InputOption    
        )
    ).

printRecordsInBoard1(InputOption,MaxV,R):-    
    integer(InputOption),
    InputOption>0,
    InputOption=<MaxV,
    R is 1.


printRecordsInBoard1(_,_,R):-    
    writeln("Debes introducir un valor válido."),
    writeln(""),
    R is -1.


printRInBoard(Player,Records,InputOption,MaxV) :-
    Counter is 0,
    writeln("Selecciona la ficha que desea mover:"),
    nth0(0,Records,QV),
    (
        (
            QV>0,
            C1 is Counter+1,
            getQueen(Player,Queen),
            getRow(Queen,RQ),
            getColumn(Queen,CQ),
            writef("%d. Abeja Reina en [ %d, %d].",[C1,RQ,CQ]),nl
        );
        (C1 is Counter)
    ),
    nth0(1,Records,A1V),
    (
        (
            A1V>0,
            C2 is C1+1,
            getAnt1(Player,A1),
            getRow(A1,RA1),
            getColumn(A1,CA1),
            writef("%d. Hormiga en [%d,%d].",[C2,RA1,CA1]),nl
        );
        (C2 is C1)
    ),
    nth0(2,Records,A2V),
    (
        (
            A2V>0,
            C3 is C2+1,
            getAnt2(Player,A2),
            getRow(A2,RA2),
            getColumn(A2,CA2),
            writef("%d. Hormiga en [%d,%d].",[C3,RA2,CA2]),nl
        );
        (C3 is C2)
    ),
    nth0(3,Records,A3V),
    (
        (
            A3V>0,
            C4 is C3+1,
            getAnt3(Player,A3),
            getRow(A3,RA3),
            getColumn(A3,CA3),
            writef("%d. Hormiga en [%d,%d].",[C4,RA3,CA3]),nl
        );
        (C4 is C3)
    ),
    nth0(4,Records,G1V),
    (
        (
            G1V>0,
            C5 is C4+1,
            getGrasshoper1(Player,G1),
            getRow(G1,RG1),
            getColumn(G1,CG1),
            writef("%d. Saltamontes en [%d,%d].",[C5,RG1,CG1]),nl
        );
        (C5 is C4)
    ),
    nth0(5,Records,G2V),
    (
        (
            G2V>0,
            C6 is C5+1,
            getGrasshoper2(Player,G2),
            getRow(G2,RG2),
            getColumn(G2,CG2),
            writef("%d. Saltamontes en [%d,%d].",[C6,RG2,CG2]),nl
        );
        (C6 is C5)
    ),
    nth0(6,Records,G3V),
    (
        (
            G3V>0,
            C7 is C6+1,
            getGrasshoper3(Player,G3),
            getRow(G3,RG3),
            getColumn(G3,CG3),
            writef("%d. Saltamontes en [%d,%d].",[C7,RG3,CG3]),nl
        );
        (C7 is C6)
    ),
    nth0(7,Records,B1V),
    (
        (
            B1V>0,
            C8 is C7+1,
            getBeetle1(Player,B1),
            getRow(B1,RB1),
            getColumn(B1,CB1),
            writef("%d. Escarabajos en [%d,%d].",[C8,RB1,CB1]),nl
        );
        (C8 is C7)
    ),
    nth0(8,Records,B2V),
    (
        (
            B2V>0,
            C9 is C8+1,
            getBeetle2(Player,B2),
            getRow(B2,RB2),
            getColumn(B2,CB2),
            writef("%d. Escarabajos en [%d,%d].",[C9,RB2,CB2]),nl
        );
        (C9 is C8)
    ),
    nth0(9,Records,S1V),
    (
        (
            S1V>0,
            C10 is C9+1,
            getSpider1(Player,S1),
            getRow(S1,RS1),
            getColumn(S1,CS1),
            writef("%d. Araña en [%d,%d].",[C10,RS1,CS1]),nl
        );
        (C10 is C9)
    ),
    nth0(10,Records,S2V),
    (
        (
            S2V>0,
            C11 is C10+1,
            getSpider2(Player,S2),
            getRow(S2,RS2),
            getColumn(S2,CS2),
            writef("%d. Araña en [%d,%d].",[C11,RS2,CS2]),nl
        );
        (C11 is C10)
    ),
    nth0(11,Records,LV),
    (
        (
            LV>0,
            C12 is C11+1,
            getLadybug(Player,L),
            getRow(L,RL),
            getColumn(L,CL),
            writef("%d. Mariquita en [%d,%d].",[C12,RL,CL]),nl
        );
        (C12 is C11)
    ),
    MaxV is C12,
    read(InputOption).