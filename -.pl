:- initialization(main).

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
    gerar_inimigo(Exp)

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