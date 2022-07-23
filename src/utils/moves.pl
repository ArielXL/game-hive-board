:- module( moves, [queenMoves/3,
                    antMoves/4,
                    grasshoperMoves/4,
                    beetleMoves/4,
                    spiderMoves/4,
                    ladybugMoves/3,
                    canAnt1Move/4,
                    canAnt2Move/4,
                    canAnt3Move/4,
                    canQueenMove/4,
                    canBeetle1Move/4,
                    canBeetle2Move/4,
                    canGrasshoper1Move/4,
                    canGrasshoper2Move/4,
                    canGrasshoper3Move/4,
                    canSpider1Move/4,
                    canSpider2Move/4,
                    canLadybugMove/4
                     ] ).

:- use_module('./record', [ getTokenType/2,
						   getColor/2,
						   getRow/2,
						   getColumn/2,
                           getInBoard/2,
                           getStackPosition/2
						 ]
			 ).
:- use_module('./player',[getQueen/2,
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
                     getLadybug/2]).     

:- use_module(positions,[adjPosNorth/3,
                       	adjPosSouth/3,
						adjPosNEast/3,
						adjPosNWest/3,
						adjPosSEast/3,
						adjPosSWest/3,
						adjAll/2,
						getAllAdj/2,
						adjNoCommon/3,
                        commonAdj/3,
						getPCoordinates/3,
						extremNorth/3,
						extremSouth/3,
						extremNEast/3,
						extremNWest/3,
						extremSEast/3,
						extremSWest/3,
						setPCoordinates/3,
						spiderCase1/3,
						ladybugCase1/3,
                        dfs/4,
                        dfs1/4,
                        breakPoint/3]).


%PDF ejemplo
%  Pos                                Board                                         Positions
%([2,-2], [[0,0],[1,0],[3,0],[2,0],[4,-3],[5,-4],[3,-1],[1,-1],[2,-2],[3,-3]], [[1,-2],[3,-2],[2,-1],[2,-3]])
queenMoves(Player,Board,Positions):-
    getQueen(Player,Queen),
    getStackPosition(Queen,SP),
    (
        (SP=\=0,Positions=[]);
        (getRow(Queen,Row),
            getColumn(Queen,Column),
            setPCoordinates(Row,Column,Pos),
            breakPoint(Pos,Board,IsBreakPoint),
            (
                (IsBreakPoint=:=1,Positions=[]);
                adjAll(Pos,Adj),
                %quitar ocupadas
                subtract(Adj,Board,R1),
                %quitar las que no puedo deslizar
                commonAdj(R1,R1,R2),
                %quitar las que aisladas
                delete(Board,Pos,NB),
                commonAdj(R2,NB,Positions)
                
            )
        )
    ).
%PDF ejemplo
%  Pos                                Board                                         Positions
%([3,-1], [[0,0],[1,0],[3,0],[2,0],[4,-3],[5,-4],[3,-1],[1,-1],[2,-2],[3,-3]],[[4,-2],[3,-2],[3,0],[2,0],[4,-1],[2,-1]])
beetleMoves(Player,Board,BC,Positions):-
    (
        (BC=:=2,getBeetle2(Player,Beetle));
        (getBeetle1(Player,Beetle))
    ),
    getStackPosition(Beetle,SP),
    (
        (SP=\=0,Positions=[]);
        (   
            getRow(Beetle,Row),
            getColumn(Beetle,Column),
            setPCoordinates(Row,Column,Pos),
            breakPoint(Pos,Board,IsBreakPoint),
            (
                (IsBreakPoint=:=1,Positions=[]);
                (
                    adjAll(Pos,Adj),
                    %quitar las que aisladas
                    delete(Board,Pos,NB),
                    commonAdj(Adj,NB,Positions))
                )

            )
          
    ).
%Ejemplo de conferencia Incorrecto
antMoves(Player,Board,BC,Positions):-
    (
        (BC=:=3,getAnt3(Player,Ant));
        (BC=:=2,getAnt2(Player,Ant));
        (getAnt1(Player,Ant))
    ),
    getStackPosition(Ant,SP),
    (
        (SP=\=0,Positions=[]);
        %for record on Board, record not taked, record available
        (   getRow(Ant,Row),
            getColumn(Ant,Column),
            setPCoordinates(Row,Column,Pos),
            breakPoint(Pos,Board,IsBreakPoint),
            (
                (IsBreakPoint=:=1,Positions=[]);
                (
                    adjAll(Pos,Adj),
                    %quitar ocupadas
                    subtract(Adj,Board,R1),
                    %quitar las que no puedo deslizar
                    commonAdj(R1,R1,R2),
                    dfs1(R2,Board,[],DFSR),
                    %quitar las que aisladas
                    delete(Board,Pos,NB),
                    commonAdj(DFSR,NB,Positions)
                )    
            )
    )
    ).
%PDF ejemplo
%  Pos                                Board                                         Positions
%([0,-2], [[0,0],[1,1],[0,2],[-1,2],[-1,1],[-2,2],[1,-2],[-2,1],[-1,-2],[0,-2],[0,-1]],[[-2,-2],[2,-2],[0,1]])
grasshoperMoves(Player,Board,BC,Positions):-
    (
        (BC=:=3,getGrasshoper3(Player,Grasshoper));
        (BC=:=2,getGrasshoper2(Player,Grasshoper));
        (getGrasshoper1(Player,Grasshoper))
    ),
    (
    getStackPosition(Grasshoper,SP),
    (
        (SP=\=0,Positions=[]);
        %for record on Board, record not taked, record available
        (
            getRow(Grasshoper,Row),
            getColumn(Grasshoper,Column),
            setPCoordinates(Row,Column,Pos),
            breakPoint(Pos,Board,IsBreakPoint),
            (
            (IsBreakPoint=:=1,Positions=[]);
            (
                    adjPosNorth(Row,Column,North),
                    adjPosSouth(Row,Column,South),
                    adjPosNEast(Row,Column,NEast),
                    adjPosNWest(Row,Column,NWest),
                    adjPosSEast(Row,Column,SEast),
                    adjPosSWest(Row,Column,SWest),
                    ((member(North, Board),extremNorth(Board,North,A1));A1=[]),
                    ((member(South, Board),extremSouth(Board,South,A2));A2=[]),
                    ((member(NEast, Board),extremNEast(Board,NEast,A3));A3=[]),
                    ((member(NWest, Board),extremNWest(Board,NWest,A4));A4=[]),
                    ((member(SEast, Board),extremSEast(Board,SEast,A5));A5=[]),
                    ((member(SWest, Board),extremSWest(Board,SWest,A6));A6=[]),
                    append([],[A1,A2,A3,A4,A5,A6],P),
                    delete(P,[],Positions)
            )    
        )    
                )
    )
    ).
%PDF ejemplo
%  Pos                                Board                                         Positions
%([-3,4], [[0,0],[-1,1],[-2,2],[0,1],[0,2],[0,3],[-1,4],[-2,5],[-2,4],[-3,4]],[[-1,2],[-1,3],[-2,1],[-2,6],[-3,6],[-3,3],[-3,5],[-3,2]])
spiderMoves(Player,Board,BC,Positions):-
    %CheckBreak POint
    (
        (BC=:=2,getSpider2(Player,Spider));
        (getSpider1(Player,Spider))
    ),
    getStackPosition(Spider,SP),
    (
        (SP=\=0,Positions=[]);
        (   getRow(Spider,Row),
            getColumn(Spider,Column),
            setPCoordinates(Row,Column,Pos),
            breakPoint(Pos,Board,IsBreakPoint),
            (
                (IsBreakPoint=:=1,Positions=[]);
                (
                    spiderCase1(Pos,Board,Positions)
                )    
            )
        )
    ).
%PDF ejemplo
%  Pos                                Board                                         Positions
%([4,-1],[[0,0],[1,0],[1,-1],[2,-2],[3,-3],[4,-3],[2,0],[3,-1],[3,0],[4,-2],[4,-1]],[[2,-1],[2,1],[1,1],[3,1],[4,0],[5,-3],[5,-2],[3,-2],[5,-4],[4,-4]])
ladybugMoves(Player,Board,Positions):-
    getLadybug(Player,Ladybug),
    getStackPosition(Ladybug,SP),
    (
        (SP=\=0,Positions=[]);
        (   getRow(Ladybug,Row),
            getColumn(Ladybug,Column),
            setPCoordinates(Row,Column,Pos)),
            breakPoint(Pos,Board,IsBreakPoint),
            (
                (IsBreakPoint=:=1,Positions=[]);
                (
                   ladybugCase1(Pos,Board,Positions)
                )
            )
                   
    ).

canQueenMove(Board,Player,CQM,QPos):-
    getQueen(Player,Queen),
    getInBoard(Queen,InBoard),
    (
        (InBoard=:=1,QPos=[],CQM is 0);
        (
            queenMoves(Player,Board,QPos),
            length(QPos,CQM)
        )
    ).

canAnt1Move(Board,Player,AQM,APos):-
    getAnt1(Player,Ant),
    getInBoard(Ant,InBoard),
    (
        (InBoard=:=1,APos=[],AQM is 0);
        (
            antMoves(Player,Board,1,APos),
            length(APos,AQM)
        )
    ).

canAnt2Move(Board,Player,AQM,APos):-
    getAnt2(Player,Ant),
    getInBoard(Ant,InBoard),
    (
        (InBoard=:=1,APos=[],AQM is 0);
        (
            antMoves(Player,Board,2,APos),
            length(APos,AQM)
        )
    ).

canAnt3Move(Board,Player,AQM,APos):-
    getAnt3(Player,Ant),
    getInBoard(Ant,InBoard),
    (
        (InBoard=:=1,APos=[],AQM is 0);
        (
            antMoves(Player,Board,3,APos),
            length(APos,AQM)
        )
    ).
canGrasshoper1Move(Board,Player,GQM,GPos):-
    getGrasshoper1(Player,Grasshoper),
    getInBoard(Grasshoper,InBoard),
    (
        (InBoard=:=1,GPos=[],GQM is 0);
        (
            grasshoperMoves(Player,Board,1,GPos),
            length(GPos,GQM)
        )
    ).
canGrasshoper2Move(Board,Player,GQM,GPos):-
    getGrasshoper2(Player,Grasshoper),
    getInBoard(Grasshoper,InBoard),
    (
        (InBoard=:=1,GPos=[],GQM is 0);
        (
            grasshoperMoves(Player,Board,2,GPos),
            length(GPos,GQM)
        )
    ).
canGrasshoper3Move(Board,Player,GQM,GPos):-
    getGrasshoper3(Player,Grasshoper),
    getInBoard(Grasshoper,InBoard),
    (
        (InBoard=:=1,GPos=[],GQM is 0);
        (
            grasshoperMoves(Player,Board,3,GPos),
            length(GPos,GQM)
        )
    ).

canBeetle1Move(Board,Player,BQM,BPos):-
    getBeetle1(Player,Beetle),
    getInBoard(Beetle,InBoard),
    (
        (InBoard=:=1,BPos=[],BQM is 0);
        (
            beetleMoves(Player,Board,1,BPos),
            length(BPos,BQM)
        )
    ).

canBeetle2Move(Board,Player,BQM,BPos):-
    getBeetle2(Player,Beetle),
    getInBoard(Beetle,InBoard),
    (
        (InBoard=:=1,BPos=[],BQM is 0);
        (
            beetleMoves(Player,Board,2,BPos),
            length(BPos,BQM)
        )
    ).

canSpider1Move(Board,Player,SQM,SPos):-
    getSpider1(Player,Spider),
    getInBoard(Spider,InBoard),
    (
        (InBoard=:=1,SPos=[],SQM is 0);
        (
            spiderMoves(Player,Board,1,SPos),
            length(SPos,SQM)
        )
    ).

canSpider2Move(Board,Player,SQM,SPos):-
    getSpider2(Player,Spider),
    getInBoard(Spider,InBoard),
    (
        (InBoard=:=1,SPos=[],SQM is 0);
        (
            spiderMoves(Player,Board,2,SPos),
            length(SPos,SQM)
        )
    ).

canLadybugMove(Board,Player,LQM,LPos):-
    getLadybug(Player,Ladybug),
    getInBoard(Ladybug,InBoard),
    (
        (InBoard=:=1,LPos=[],LQM is 0);
        (
            ladybugMoves(Player,Board,LPos),
            length(LPos,LQM)
        )
    ).