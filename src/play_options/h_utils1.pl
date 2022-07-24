:- module( utils1, [ printRecords/3,
                    printRecords1/8,
                     printRO/8
                   ]
         ).

:- use_module( player, [ queenAvailable/2,
                         ladybugAvailable/2,
                         anyAnt/2,
                         anyGrasshoper/2,
                         anyBeetle/2,
                         anySpider/2
                       ]
             ).

:- set_prolog_flag(encoding, utf8).

printRecords(Player,OptionPRO,R):-
    printRO(Player,OptionPROT,Queen,Ants,Grasshopers,Beetles,Spiders,Ladybugs),
    printRecords1(OptionPROT,TR,Queen,Ants,Grasshopers,Beetles,Spiders,Ladybugs),
    (
        (
            TR=:= -1,
            printRecords(Player,NOP,NR),
            OptionPRO is NOP,
            R is NR
        );
        (
            OptionPRO is OptionPROT,
            R is TR
        )
    ).

printRecords1(OptionPRO,R,Queen,Ants,Grasshopers,Beetles,Spiders,Ladybugs):-    
    integer(OptionPRO),
    OptionPRO<7,
    OptionPRO>0,
    ((OptionPRO=:=1,Queen>0, R is Queen);
    (OptionPRO=:=2,Ants>0,R is Ants);
    (OptionPRO=:=3,Grasshopers>0,R is Grasshopers);
    (OptionPRO=:=4,Beetles>0,R is Beetles);
    (OptionPRO=:=5,Spiders>0,R is Spiders);
    (OptionPRO=:=6,Ladybugs>0,R is Ladybugs)).

printRecords1(_,R,_,_,_,_,_,_):-    
    writeln("Debes introducir un valor válido."),
    writeln(""),
    R is -1.
    
printRO(Player,OptionPRO,Queen,Ants,Grasshopers,Beetles,Spiders,Ladybug) :-
    writeln("Selecciona la ficha que desea jugar (las que no tengan valor cero):"),
    queenAvailable(Player, Queen),
    write("1. Abeja Reina x"), writeln(Queen), 
    anyAnt(Player, Ants),
    write("2. Hormiga x"), writeln(Ants),
    anyGrasshoper(Player,Grasshopers),
    write("3. Saltamonte x"), writeln(Grasshopers),
    anyBeetle(Player, Beetles),
    write("4. Escarabajo x"), writeln(Beetles),
    anySpider(Player, Spiders),
    write("5. Araña x"), writeln(Spiders),
    ladybugAvailable(Player, Ladybug),
    write("6. Mariquita x"), writeln(Ladybug),
    read(OptionPRO).
