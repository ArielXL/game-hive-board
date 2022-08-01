:- set_prolog_flag(encoding, utf8).

:- use_module( utils/welcome, [ printWelcome/1,
                                    exit/0,
                                    printTutorial/0,
                                    printInformation/0,
                                    printErrorInput/0
                                  ]
             ).

:- use_module( play_between_players, [ playBetweenTwoPlayers/0 ] ).

:- use_module( play_versus_computer, [ playVersusComputer/0 ] ).

play() :-
  write("\33[2J"),
  writeln(""),
  printWelcome(Option),
  (integer(Option),
  Option>0,
  Option<6,
  (
  (Option =:= 1, playVersusComputer(),play());
  (Option =:= 2, playBetweenTwoPlayers(),play());
  (Option =:= 3, printTutorial(),play());
  (Option =:= 4, printInformation(),play());
  (Option =:= 5, exit()));
  (printErrorInput(),play())
  ).

