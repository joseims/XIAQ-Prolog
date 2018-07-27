:- use_module(library(random)).

%:- initialization(main).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                LOJA                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iniciar_loja(HA, HL, NewHA, NewHL) :-
    gerar_item(HA, HL, W),
    gerar_item(HA, HL, A),
    mensagem_loja(W, A, HA, HL, Res),
    (X, Y) = Res,
    NewHA is X, NewHL is Y.

mensagem_loja(W, A, HA, HL, Res) :- 
    write("Bem Vindo à Loja"), nl,
    write("Qual item você deseja comprar?"), nl,
    write("[1] Arma     "), write(W), nl,
    write("[2] Armadura "), write(A), nl,
    write("[3] Não vou comprar nada"), nl, nl,
    read(Num), nl, operacao(Num, W, A, HA, HL, Res).


operacao(1, W, A, HA, HL, W).
operacao(2, W, A, HA, HL, A).
operacao(3, W, A, HA, HL, (HA, HL)).
operacao(_, W, A, HA, HL, Res) :-
    write("Entrada Inválida. Insira outro valor."), nl,
    mensagem_loja(W, A, HA, HL, Res).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               RANKING                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inserePontuacao(pontuacao, origem, [pontuacao|origem]). 
ordenaRanking(ranking,ordenado) :- sort(ranking, ordenado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             GERADOR ITEM                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

soma(X, Y, Res) :- Res is X + Y.

gerar_item(STR, HP, I) :-
    soma(STR, 20, MaxSTR),
    soma(HP, 20, MaxHP),
    random(STR, MaxSTR, NewSTR),
    random(HP, MaxHP, NewHP),
    I = (NewSTR, NewHP).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             GERADOR MONSTRO                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


getItem([H|T], 0, H). 
getItem([H|T], Numero, Item) :-  K is Numero - 1, getItem(T, K, Item).



monstro(Name) :- nomeMonstro(X),alteradorMonstro(Y),string_concat(X,Y,Name).

nomeMonstro(Nome) :- Monstros = ['Ladrão','Dragão','Golem','Gosma', 'Vampiro','Lobisomen','Rato gigante'],
 random(0,5,X), getItem(Monstros, X, Nome),!. 

alteradorMonstro(Alterer) :- Alteradores = [' Pacifista',' Burro',' Cego',' Imaginário',' Sem Pernas', ' Invisivel', ' Gigantesco',
    ' de 3 cabeças', ' Aterrorizante',' Cabeludo',' Rochoso',' Assassino', ''], random(0,11,X), getItem(Alteradores,X,Alterer),!. 

aumentaAtributo(X,Y) :- Y is 1.5*X.

gerar_inimigo(HP, ATQ) :-
    gera_hp(HP), gera_atq(ATQ).



gera_hp(HP) :-
    HP is 15.

gera_atq(ATQ) :-
    ATQ is 15.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               BATALHA                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HA - Hero Attack
% HL - Hero Life
% EA - Enemy Attack
% EL - Enemy Life
% Coin - Coin Toss result
% Res - Result, 1 the Hero wins, 0 the Enemy wins
batalha(HA, HL, EA, EL, Coin, Res) :- EL / HA > HL / EA -> Res is 0;
    EL / HA < HL / EA -> Res is 1;
    Res is Coin.




fluxo_batalha(HA, HL, Coin, Round) :-
    monstro(Nome),
    write("Você encontrou um "),write(Nome),nl,
    gerar_inimigo(EL,EA),
    batalha(HA,HL,EA,EL,Coin,Res),
    result(Res,HA,HL,Round).


result(Res,HA,HL,Round) :- Res = 1 -> ganhou(HA,HL,Round);perdeu.


ganhou(HA,HL,Round) :- 
    write("Parabens você ganhou a luta! Você venceu o Round "),
    soma(1,Round,ProxRound),
    write(Round),nl,
    inicio_batalha(HA,HL,ProxRound).

perdeu :- 
    writeln("Não foi dessa vez :("),
     mensagem_inicial(), mensagem_batalha().



inicio_batalha(HA,HL,6):- 
    writeln("Você venceu 5 batalhas consecutivas! Vá para a loja melhorar seus equipamentos"),
    iniciar_loja(HA,HL,NewHA,NewHL),
    inicio_batalha(NewHA,NewHL,0).


inicio_batalha(HA,HL,Round) :-
    writeln("A batalha vai começar!"),
    coin(Res),
    fluxo_batalha(HA, HL, Res, Round).


jogo :-
    gerar_heroi(HA,HL),
    inicio_batalha(HA,HL,0).





ck(Res) :-
    random(0,2,Res),
    msg_ck(Res).

msg_ck(1) :- 
    writeln("O resultado foi cara! :)").

msg_ck(0) :- 
    writeln("O resultado foi coroa! :(").



coin(Resultado) :- 
    write("Vamos decidir quem começa em um Cara ou Coroa"), nl,
    write("Cara você ganha, Coroa você perde"),nl,
    ck(Resultado).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               HEROI                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gerar_heroi(HA,HL):-
HA is 25, HL is 25.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                MENU                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

redireciona(1) :- jogo.
redireciona(2) :- ver_instrucoes().
redireciona(3) :- ver_recordes().
redireciona(4) :- sair().
redireciona(_) :- 

    write("Entrada Inválida. Insira outro valor."), nl,
    mensagem_batalha().

mensagem_inicial :- write("Bem Vindo ao XIAQ"), nl.
mensagem_batalha :- 
    write("[1] Iniciar batalha"), nl,
    write("[2] Ver Instruções"), nl,
    write("[3] Visualizar Recordes"), nl,
    write("[4] Sair"), nl, nl,
    read(Entrada), nl, redireciona(Entrada).

main :- mensagem_inicial, mensagem_batalha.
