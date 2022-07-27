:- module( hand_play, [ handMeth/3,
                        handQueenConditionMeth/3,
                        playInPos/5
                      ]
         ).
:-use_module(selector,[selectPositionFromAvailables/2]).
:- use_module( h_utils1, [ printRecords/3 ] ).
:- use_module( player, [
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
                         updLadybug/4
                        ]
             ).
:- use_module(utils/positions,[getPCoordinates/3]).            
:- set_prolog_flag(encoding, utf8).

%Meth

playInPos(Pos, TType, TNumber, Player, NewPlayer):-
    getPCoordinates(Pos,R,C),
    (
    ( TType =:= 1, updQueen(Player, NewPlayer, R, C));
    ( TType =:= 2, TNumber =:= 3, updAnt3(Player, NewPlayer, R, C));
    ( TType =:= 2, TNumber =:= 2, updAnt2(Player, NewPlayer, R, C));
    ( TType =:= 2, TNumber =:= 1, updAnt1(Player, NewPlayer, R, C));
    ( TType =:= 3, TNumber =:= 3, updGrasshoper3(Player, NewPlayer, R, C));
    ( TType =:= 3, TNumber =:= 2, updGrasshoper2(Player, NewPlayer, R, C));
    ( TType =:= 3, TNumber =:= 1, updGrasshoper1(Player, NewPlayer, R, C));
    ( TType =:= 4, TNumber =:= 2, updBeetle2(Player, NewPlayer, R, C));
    ( TType =:= 4, TNumber =:= 1, updBeetle1(Player, NewPlayer, R, C));
    ( TType =:= 5, TNumber =:= 2, updSpider2(Player, NewPlayer, R, C));
    ( TType =:= 5, TNumber =:= 1, updSpider1(Player, NewPlayer, R, C));
    ( TType =:= 6, updLadybug(Player, NewPlayer, R, C))
    ).
    

handMeth(Player, Positions,NewPlayer) :-
    printRecords(Player, Op, R),
    writeln(""),
    selectPositionFromAvailables(Positions,IndexR),
    nth0(IndexR,Positions,Pos),
    playInPos(Pos, Op, R, Player, NewPlayer).

handQueenConditionMeth(Player,Positions,NewPlayer):-
    selectPositionFromAvailables(Positions,  IndexR),
    nth0(IndexR,Positions,Pos),
    getPCoordinates(Pos,Row,Column),
    updQueen(Player,NewPlayer,Row,Column).
