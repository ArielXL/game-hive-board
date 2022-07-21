:- module( tools, [ push/3,
			 	    pop/2,
					chooseColor/1,
					min/3,
					max/3
				  ]
		 ).

push(X, Y, [X|Y]).

pop([_|T], T).

min(X,Y,X):- X=<Y.
min(X,Y,Y):- Y<X.

max(X,Y,X):- X>=Y.
max(X,Y,Y):- Y>X.

chooseColor(IsWhite) :-
	random(1, 3, R),
	(
		(
			R =:= 1,
			IsWhite is 1
		);
		(
			IsWhite is 0
		)
	).
