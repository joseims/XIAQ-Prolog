:- use_module(library(random)).

:- initialization(main).

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
getItem([H|T], Numero, Item) :- 
	K is Numero - 1, 
	getItem(T, K, Item).

monstro(Name) :- 
	nomeMonstro(X), 
	alteradorMonstro(Y), 
	string_concat(X, Y, Name).

nomeMonstro(Nome) :- 
	Monstros = ['Ladrão', 'Dragão', 'Golem', 'Gosma', 'Vampiro', 'Lobisomen', 'Rato gigante'],
	random(0, 5, X), 
	getItem(Monstros, X, Nome),!. 

alteradorMonstro(Alterer) :- 
	Alteradores = [' Pacifista', ' Burro', ' Cego', ' Imaginário', ' Sem Pernas', ' Invisivel', ' Gigantesco',
    			   ' de 3 cabeças', ' Aterrorizante', ' Cabeludo', ' Rochoso', ' Assassino', ''], 
    random(0, 11, X), 
    getItem(Alteradores, X, Alterer),!. 

aumentaAtributo(X,Y) :- 
	Y is 1.05*X.

atualizar_inimigo(HP, ATQ, NewHP, NewATQ) :-
    gera_hp(HP, NewHP), 
    gera_atq(ATQ, NewATQ).

gera_hp(HP, NewHP) :-
    aumentaAtributo(HP, X),
    random(0,5,Rand),
    soma(Rand, X, NewHP).

gera_atq(ATQ, NewATQ) :-
    aumentaAtributo(ATQ, X),
    random(0,5,Rand),
    soma(Rand, X, NewATQ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           GERADOR HEROI                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gerar_heroi(HA, HL, 1) :- 
	HA is 500, HL is 500.

gerar_heroi(HA, HL, 2) :- 
	HA is 250, HL is 250.

gerar_heroi(HA, HL, _) :- 
	HA is 100, HL is 100.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               BATALHA                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HA - Hero Attack
% HL - Hero Life
% EA - Enemy Attack
% EL - Enemy Life
% Coin - Coin Toss result
% Res - Result, 1 the Hero wins, 0 the Enemy wins

batalha(HA, HL, EA, EL, Coin, Res) :- 
	EL / HA > HL / EA -> Res is 0;
    EL / HA < HL / EA -> Res is 1;
    Res is Coin.

fluxo_batalha(HA, HL, EL, EA, Coin, Round) :-
    monstro(Nome),
    write("Você encontrou um "), write(Nome), nl,
    atualizar_inimigo(EL, EA, NewEL, NewEA),
    batalha(HA, HL, NewEA, NewEL, Coin, Res),
    result(Res, HA, HL, NewEA, NewEL, Round).

result(Res, HA, HL, EA, EL, Round) :- 
	Res = 1 -> ganhou(HA, HL, EA, EL, Round);
	perdeu.

ganhou(HA,HL,EA, EL, Round) :- 
    write("Parabens você ganhou a luta! Você venceu o Round "),
    soma(1, Round, ProxRound),
    write(Round), nl, nl,
    inicio_batalha(HA, HL, EA, EL, ProxRound).

perdeu :- 
    writeln("Não foi dessa vez :("),
    main.

inicio_batalha(HA, HL, EA, EL, 6):- 
    writeln("Você venceu 5 batalhas consecutivas! Vá para a loja melhorar seus equipamentos"),
    iniciar_loja(HA, HL, NewHA, NewHL),
    inicio_batalha(NewHA, NewHL, EA, EL, 0).

inicio_batalha(HA, HL, EA, EL, Round) :-
    writeln("A batalha vai começar!"),
    coin(Res),
    fluxo_batalha(HA, HL, EA,EL, Res, Round).

jogo :-
	seleciona_dificuldade(X),
    gerar_heroi(HA, HL, X),
    gerar_inimigo_base(EA, EL),
    inicio_batalha(HA, HL, EA, EL, 0).

seleciona_dificuldade(X) :-
	write("Selecione a dificuldade:"), nl,
	write("[1] Fácil"), nl,
    write("[2] Médio"), nl,
    write("[3] Difícil"), nl,
    read(X), nl.

gerar_inimigo_base(EA, EL) :- 
	EA is 15, 
	EL is 15.

ck(Res) :-
    random(0, 2, Res),
    msg_ck(Res).

msg_ck(1) :- 
    writeln("O resultado foi cara! :)").

msg_ck(0) :- 
    writeln("O resultado foi coroa! :(").

coin(Resultado) :- 
    write("Vamos decidir quem começa em um Cara ou Coroa"), nl,
    write("Cara você ganha, Coroa você perde"), nl,
    ck(Resultado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                MENU                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sair.

ver_instrucoes :- 
	writeln("O jogo se dá através de sucessivas lutas contra monstros!"), 
	writeln("A cada 5 vitórias você poderá ir para loja ficar mais forte!"),
	writeln("Dê o seu melhor para obter o maior numero de pontos possíveis!"), nl,
	main.

redireciona(1) :- jogo.
redireciona(2) :- ver_instrucoes.
redireciona(3) :- ver_recordes.
redireciona(4) :- sair.
redireciona(_) :- 
    write("Entrada Inválida. Insira outro valor."), nl,
    mensagem_batalha().

mensagem_inicial :- nl, write("Bem Vindo ao XIAQ"), nl.
mensagem_batalha :- 
    write("[1] Iniciar batalha"), nl,
    write("[2] Ver Instruções"), nl,
    write("[3] Visualizar Recordes"), nl,
    write("[4] Sair"), nl, nl,
    read(Entrada), nl, redireciona(Entrada).

main :- mensagem_inicial, mensagem_batalha.
