:- use_module(library(random)).

:- initialization(main).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                LOJA                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iniciar_loja(HA, HL, NewHA, NewHL) :-
    gerar_item(HA, HL, W),
    gerar_item(HA, HL, A),
    gerar_item(HA, HL, I),
    mensagem_loja(W, A, I, Res),
    (X, Y) = Res,
    NewHA is X, NewHL is Y.

mensagem_loja(W, A, I, Res) :- 
    write("Bem Vindo à Loja"), nl,
    write("Qual item você deseja comprar?"), nl,
    write("[1] Arma     "), write(W), nl,
    write("[2] Armadura "), write(A), nl,
    write("[3] Arma     "), write(I), nl,
    write("[4] Não vou comprar nada"), nl, nl,
    ler_inteiro(Num), nl, operacao(Num, W, A, I, Res).

ler_inteiro(X) :-
    read_line_to_codes(user_input, Codes),
    string_to_atom(Codes, Atom),
    atom_number(Atom, X).

operacao(1, W, A, I, W).
operacao(2, W, A, I, A).
operacao(3, W, A, I, I).
operacao(4, W, A, I, (0,0)).
operacao(_, W, A, I, Res) :-
    write("Entrada Inválida. Insira outro valor."), nl,
    mensagem_loja(W, A, I, Res).

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
%                               GERADOR                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

fluxo_batalha(HA, HL, Coin, Round, Exp) :-
    gerar_inimigo(Exp).

inicio_batalha() :-
    gerar_heroi(HA, HL),
    coin(Res), fluxo_batalha(HA, HL, Res, 0, 0).

valida_CK("Cara", 1, 1).
valida_CK("Coroa", 0, 1).
valida_CK(_, _, 0).

coin(Resultado) :- 
    write("Jogue Cara ou Coroa para decidir quem inicia atacando."), nl,
    write("Escolha 'Cara' ou 'Coroa':"), nl,
    write("PS: Se você inserir algum valor inválido, perde."), nl,
    read(Escolha), nl, valida_CK(Escolha, Resultado).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                MENU                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

redireciona(1) :- iniciar_batalhas().
redireciona(2) :- ver_instrucoes().
redireciona(3) :- ver_recordes().
redireciona(4) :- sair().
redireciona(_) :- 
    write("Entrada Inválida. Insira outro valor."), nl,
    mensagem_batalha().

mensagem_inicial() :- write("Bem Vindo ao XIAQ"), nl.
mensagem_batalha() :- 
    write("[1] Iniciar batalha"), nl,
    write("[2] Ver Instruções"), nl,
    write("[3] Visualizar Recordes"), nl,
    write("[4] Sair"), nl, nl,
    read(Entrada), nl, redireciona(Entrada).

main :- mensagem_inicial(), mensagem_batalha().
