/* POKEMON - LEGENDS OF LOGIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARTE 1. POKEDEX

Pokemones. De estos conocemos sus tipos.
    -Pikachu es de tipo Eléctrico.
    -Charizard es de tipo Fuego.
    -Venusaur es de tipo Planta.
    -Blastoise es de tipo Agua.
    -Snorlax es de tipo Normal.
    -Rayquaza es de tipo Dragón y de tipo Volador.
    -De Arceus no se conoce su tipo.

Entrenadores: En el camino nos encontramos con otros entrenadores. De estos conocemos que pokemones tienen:
    -Ash, tiene un Pikachu y un Charizard.
    -Brock, tiene un Snorlax.
    -Misty, tiene un Blastoise, Venusaur y un Arceus

Modelar en Prolog la información recopilada hasta ahora y modelar lo necesario para poder consultar:
    1) Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo.
    2) Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene.
    3) Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene. 
*/
esTipo(pikachu, electrico).
esTipo(charizard, fuego).
esTipo(venusaur,  planta).
esTipo(blastoise, agua).
esTipo(snorlax, normal).
esTipo(rayquaza, dragon).
esTipo(rayquaza, volador).

tieneA(ash, pikachu).
tieneA(ash, charizard).
tieneA(brock, snorlax).
tieneA(misty, blastoise).
tieneA(misty, venusaur).
tieneA(misty, arceus).

% predicado auxiliar generador de pokemones:
estaEnNuestraPokedex(Pokemon):- esTipo(Pokemon, _).
estaEnNuestraPokedex(Pokemon):- tieneA(_, Pokemon).

% predicado auxiliar generador de entrenadores:
esEntrenador(Alguien):- tieneA(Alguien, _).

% 1)
esTipoMultiple(Pokemon):-
    esTipo(Pokemon, Tipo1),
    esTipo(Pokemon, Tipo2),
    Tipo1 \= Tipo2. % "tiene más de un tipo" es lo mismo que "tiene al menos dos tipos distintos".
% 2)
nadieLoTiene(Pokemon):-
    estaEnNuestraPokedex(Pokemon), % para unificar variable y hacer inversible el predicado.
    not(tieneA(_, Pokemon)). % "nadie lo tiene" es lo mismo que "no existe alguien que lo tenga".

esLegendario(Pokemon):-
    esTipoMultiple(Pokemon),
    nadieLoTiene(Pokemon).
% 3)
esUnicoEnSuTipo(Pokemon):-
    esTipo(Pokemon, Tipo), % para unificar variable y hacer inversible el predicado.
    forall((esTipo(OtroPoke, OtroTipo), Pokemon \= OtroPoke), OtroTipo \= Tipo).

esMisterioso(Pokemon):- esUnicoEnSuTipo(Pokemon).
esMisterioso(Pokemon):- nadieLoTiene(Pokemon).
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARTE 2. MOVIMIENTOS.

Movimientos. Hasta ahora conocemos las siguientes clases de movimientos:
    -Físicos: Son de una determinada potencia.
    -Especiales: Además de tener una potencia, son de un determinado tipo.
    -Defensivos: Reducen el daño recibido. Tienen un porcentaje de reducción.

Ejemplos de algunos movimientos que pueden usar los pokemones:
    -Pikachu puede usar Mordedura (movimiento físico con 95 de potencia) 
    e Impactrueno (movimiento especial de tipo Eléctrico con 40 de potencia). 
    -Charizard puede usar Garra Dragón (movimiento especial de tipo Dragón con 100 de potencia) 
    y también puede usar Mordedura.
    -Blastoise puede usar Protección (movimiento defensivo que reduce el daño de ataques un 10%) 
    y Placaje (movimiento físico con 50 de potencia).
    -Arceus puede usar Impactrueno, Garra Dragón, Protección, Placaje 
    y Alivio (movimiento defensivo que reduce el daño de ataques un 100%).
    -Snorlax no puede usar ningún movimiento.

Modelar en Prolog la información recopilada hasta ahora y modelar lo necesario para poder consultar:
    1) El daño de ataque de un movimiento, lo cual se calcula de la siguiente forma:
        -En los movimientos físicos, es su potencia.
        -En los movimientos defensivos es 0.
        -En los movimientos especiales está dado por su potencia multiplicado:
            -por 1.5 si es un tipo básico (fuego, agua, planta o normal).
            -por 3 si es de tipo Dragón.
            -por 1 en cualquier otro caso.
    2) La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los daños de ataque 
    de los movimientos que puede usar.
    3) Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva 
    total superior a 200 o son misteriosos.
*/
movimiento(mordedura, fisico(95)).
movimiento(impactrueno, especial(electrico, 40)).
movimiento(garraDragon, especial(dragon, 100)).
movimiento(proteccion, defensivo(10)).
movimiento(placaje, fisico(50)).
movimiento(alivio, defensivo(100)).

puedeUsar(pikachu, mordedura).
puedeUsar(pikachu, impactrueno).
puedeUsar(charizard, garraDragon).
puedeUsar(charizard, mordedura).
puedeUsar(blastoise, proteccion).
puedeUsar(blastoise, placaje).
puedeUsar(arceus, impactrueno).
puedeUsar(arceus, garraDragon).
puedeUsar(arceus, proteccion).
puedeUsar(arceus, placaje).
puedeUsar(arceus, alivio).

% 1)
ataque(Movimiento, Danio):-
    movimiento(Movimiento, fisico(Potencia)),
    Danio is Potencia.

ataque(Movimiento, Danio):-
    movimiento(Movimiento, defensivo(_)),
    Danio is 0.

ataque(Movimiento, Danio):-
    movimiento(Movimiento, especial(Tipo, Potencia)),
    esBasico(Tipo),
    Danio is Potencia * (1.5).

ataque(Movimiento, Danio):-
    movimiento(Movimiento, especial(dragon, Potencia)),
    Danio is Potencia * 3.

ataque(Movimiento, Danio):-
    movimiento(Movimiento, especial(Tipo, Potencia)),
    noEsBasicoNiDragon(Tipo),
    Danio is Potencia.

esBasico(fuego).
esBasico(agua).
esBasico(planta).
esBasico(normal).

noEsBasicoNiDragon(Tipo):-
    movimiento(_, especial(Tipo, _)),
    not(esBasico(Tipo)),
    Tipo \= dragon.

% 2)
capacidadOfensiva(Pokemon, Capacidad):-
    estaEnNuestraPokedex(Pokemon),
    findall(Danio, (puedeUsar(Pokemon, Movimiento), ataque(Movimiento, Danio)), ListaDanios),
    sum_list(ListaDanios, Capacidad).

% 3)
esPicante(Alguien):-
    esEntrenador(Alguien), % para unificar variable y hacer inversible el predicado.
    forall((tieneA(Alguien, Pokemon), capacidadOfensiva(Pokemon, Capacidad)), Capacidad>200).

esPicante(Alguien):-
    esEntrenador(Alguien), % para unificar variable y hacer inversible el predicado.
    forall(tieneA(Alguien, Pokemon), esMisterioso(Pokemon)).
