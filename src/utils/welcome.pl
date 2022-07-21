:- module( welcome, [ printWelcome/1,
                      exit/0,
                      printTutorial/0,
                      printInformation/0,
                      printErrorInput/0
				    ]
		 ).

% ------------------------------------------------------------------------ %
% ESTRUCTURA Welcome                                                       %
% ------------------------------------------------------------------------ %
% printWelcome: imprime el menu principal y devuelve en Option la opcion   %
%               deseada                                                    %
% exit: sale de la aplicacion de consola                                   %
% printTutorial: imprime las reglas del juego                              %
% printInformation: imprime la informacion basica de los desarrolladores   %
% ------------------------------------------------------------------------ %

printWelcome(Option) :-
    writeln("BIENVENIDO AL JUEGO HIVE!!!"), 
    writeln(""),
    writeln("Marca la opción deseada:"),
    writeln("1. Partida contra la computadora."),
    writeln("2. Partida entre dos jugadores."),
    writeln("3. Tutorial del juego."),
    writeln("4. Información del los desarrolladores."), 
    writeln("5. Salir."), 
    read(Option), 
    writeln("").

exit().

printTutorial() :- 
    writeln("TUTORIAL DEL JUEGO"), 
    writeln(""),
    writeln("La colmena, es un juego compuesto por 24 fichas (doce negras y doce blancas) en las que se"),
    writeln(" muestran diferentes insectos, cada uno con una forma única de moverse."),
    writeln(""),
    writeln("La partida comienza cuando se coloca la primera pieza sobre la zona de juego; a medida que se van"),
    writeln("colocando el resto de las piezas se va formando un grupo de fichas al que se le denomina Colmena."),
    writeln(""),
    writeln("El objetivo del juego es rodear completamente a la Reina del oponente."), 
    writeln("El primer jugador deberá colocar una de sus fichas en el centro de la mesa; seguidamente, el otro"),
    writeln("jugador hará lo mismo colocando su pieza pegada a uno de los seis lados de la pieza del oponente."), 
    writeln(""),
    writeln("Fichas:"), 
    writeln("(1) Abeja Reina: solo puede moverse un espacio por turno."), 
    writeln(""),
    writeln("(2) Escarabajo: se mueve también un espacio por turno, pero al contrario que otros insectos, puede"),
    writeln("moverse sobre la colmena. Una ficha con un escarabajo encima no puede moverse."), 
    writeln(""),
    writeln("(3) Saltamonte: salta en línea recta desde su espacio a través de cualquier número de fichas (al menos una)"),
    writeln(" hasta el siguiente espacio libre."), 
    writeln(""),
    writeln("(2) Araña: se mueve exactamente tres espacios, sin posibilidad de retroceder."), 
    writeln(""),
    writeln("(3) Hormiga: es posiblemente la ficha más valiosa, ya que puede moverse a cualquier lugar alrededor"),
    writeln(" de la colmena tantas casillas como desee."), 
    writeln(""),
    writeln("(1) Mariquita (Extra): se mueve tres espacios, dos por encima de la Colmena y uno para bajar de ella."),
    writeln(""),
    writeln("INTRODUZCA UNA TECLA PARA CONTINUAR"),
    read(_).

printInformation() :- 
    writeln("INFORMACIÓN DE LOS DESARROLLADORES"), 
    writeln("Nombre y Apellidos: Thalia Blanco Figueras"), 
    writeln("                    Ariel Plasencia Díaz"), 
    writeln("Grupos: C-412"), 
    writeln("        C-412"), 
    writeln("Correos: lia.blanco98@gmail.com"), 
    writeln("         arielplasencia00@gmail.com"), 
    writeln(""),
    writeln("INTRODUZCA UNA TECLA PARA CONTINUAR"),
    read(_).
         
printErrorInput():-
    writeln("La entrada no es válida, tienes que introducir un valor del 1 al 5."),
    writeln("").
