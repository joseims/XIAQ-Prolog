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

% W is weapon
% A is armor
mensagem_loja(W, A, HA, HL, Res) :-
    Msg1 = "Bem Vindo à Loja",
    Msg2 = "Qual item você deseja comprar?",
    Msg6 = "             Atq, HP",
    Msg3 = "[1] Arma     ",
    Msg4 = "[2] Armadura ",
    Msg5 = "[3] Não vou comprar nada",
    write(Msg1), log(Msg1), log("\n"), nl,
    write(Msg2), log(Msg2), log("\n"), nl,
    write(Msg6), log(Msg6), log("\n"), nl,
    write(Msg3), log(Msg3),
    write(W), log(W), log("\n"), nl,
    write(Msg4), log(Msg4),
    write(A), log(A), log("\n"), nl,
    write(Msg5), log(Msg5), log("\n\n"), nl, nl,
    read(Num), log(Num), log("\n"), nl,
    operacao(Num, W, A, HA, HL, Res).


operacao(1, W, A, HA, HL, W).
operacao(2, W, A, HA, HL, A).
operacao(3, W, A, HA, HL, (HA, HL)).
operacao(_, W, A, HA, HL, Res) :-
    Msg = "Entrada Inválida. Insira outro valor.",
    write(Msg), log(Msg), log("\n"), nl,
    mensagem_loja(W, A, HA, HL, Res).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               RANKING                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ver_recordes(K) :- write(K), nl, mensagem_batalha(K).

inserePontuacao(Pontuacao, Origem, Ordenado) :- K = [Pontuacao|Origem],
    sort(K, Ordenado).

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
	Y is 1.032*X.

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

fluxo_batalha(HA, HL, EL, EA, Coin, Round, K) :-
    monstro(Nome),
    Msg = "Você encontrou um ",
    write(Msg), log(Msg),
    write(Nome), log(Nome), log("\n"), nl,
    atualizar_inimigo(EL, EA, NewEL, NewEA),
    batalha(HA, HL, NewEA, NewEL, Coin, Res),
    result(Res, HA, HL, NewEA, NewEL, Round, K).

result(Res, HA, HL, EA, EL, Round, K) :- 
	Res = 1 -> ganhou(HA, HL, EA, EL, Round, K);
	perdeu(EL, EA, K).

ganhou(HA,HL,EA, EL, Round, K) :- 
    Msg = "Parabens você ganhou a luta! Você venceu o Round ", 
    write(Msg), log(Msg),
    soma(1, Round, ProxRound),
    write(Round), log(Round), log("\n\n"), nl, nl,
    inicio_batalha(HA, HL, EA, EL, ProxRound, K).

perdeu(EL, EA, K) :- 
    Msg = "Não foi dessa vez :(",
    M2 = "O monstro mais forte que você derrotou tinha: HP: ",
    M3 = " Ataque: ",
    writeln(Msg), log(Msg), log("\n"),
    writeln(M2), write(EL),
    log(M2), log(EL),
    write(M3), write(EA),
    log(M3), log(EA), log("\n"),
    inserePontuacao(EL, K, Result),
    mensagem_batalha(Result).

inicio_batalha(HA, HL, EA, EL, 6, K):- 
    Msg = "Você venceu 5 batalhas consecutivas! Vá para a loja melhorar seus equipamentos",
    writeln(Msg), log(Msg), log("\n"),
    iniciar_loja(HA, HL, NewHA, NewHL),
    inicio_batalha(NewHA, NewHL, EA, EL, 0, K).

inicio_batalha(HA, HL, EA, EL, Round, K) :-
    Msg = "A batalha vai começar!",
    writeln(Msg), log(Msg), log("\n"),
    coin(Res),
    fluxo_batalha(HA, HL, EA,EL, Res, Round, K).

jogo(K) :-
	seleciona_dificuldade(X),
    gerar_heroi(HA, HL, X),
    gerar_inimigo_base(EA, EL),
    inicio_batalha(HA, HL, EA, EL, 0, K).

seleciona_dificuldade(X) :-
    M1 = "Selecione a dificuldade:",
    M2 = "[1] Fácil",
    M3 = "[2] Médio",
    M4 = "[3] Difícil",
	write(M1), log(M1), log("\n"), nl,
	write(M2), log(M2), log("\n"), nl,
    write(M3), log(M3), log("\n"), nl,
    write(M4), log(M4), log("\n"), nl,
    read(X), nl.

gerar_inimigo_base(EA, EL) :- 
	EA is 15, 
	EL is 15.

ck(Res) :-
    random(0, 2, Res),
    msg_ck(Res).

msg_ck(1) :- 
    Msg = "O resultado foi cara! :)",
    writeln(Msg), log(Msg), log("\n").

msg_ck(0) :- 
    Msg = "O resultado foi coroa! :(",
    writeln(Msg), log(Msg), log("\n").

coin(Resultado) :- 
    M1 = "Vamos decidir quem começa em um Cara ou Coroa",
    M2 = "Cara você ganha, Coroa você perde",
    write(M1), log(M1), log("\n"), nl,
    write(M2), log(M2), log("\n"), nl,
    ck(Resultado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                MENU                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sair.

ver_instrucoes(K) :- 
    M1 = "O jogo se dá através de sucessivas lutas contra monstros!",
    M2 = "A cada 5 vitórias você poderá ir para loja ficar mais forte!",
    M3 = "Dê o seu melhor para obter o maior numero de pontos possíveis!",
	writeln(M1), log(M1), log("\n"),
	writeln(M2), log(M2), log("\n"),
	writeln(M3), log(M3), log("\n\n"), nl,
	mensagem_batalha(K).

redireciona(1, K) :- jogo(K).
redireciona(2, K) :- ver_instrucoes(K).
redireciona(3, K) :- ver_recordes(K).
redireciona(4, _) :- sair.
redireciona(_, _) :- 
    M1 = "Entrada Inválida. Insira outro valor.",
    write(M1), log(M1), log("\n"), nl,
    mensagem_batalha(K).

mensagem_inicial() :-
    nl, M1 = "\nBem Vindo ao XIAQ",
    write(M1), log(M1), log("\n"), nl.

mensagem_batalha(K) :- 
    M1 = "[1] Iniciar batalha",
    M2 = "[2] Ver Instruções",
    M3 = "[3] Visualizar Recordes",
    M4 = "[4] Sair",
    write(M1), log(M1), log("\n"), nl,
    write(M2), log(M2), log("\n"), nl,
    write(M3), log(M3), log("\n"), nl,
    write(M4), log(M4), log("\n\n"), nl, nl,
    read(Entrada), log(Entrada), log("\n"), nl, redireciona(Entrada, K).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                LOG                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

log(Text) :-
	open('log.txt', append, Stream),
	write(Stream, Text),
	close(Stream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                MAIN                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :- mensagem_inicial(), K = [], mensagem_batalha(K).