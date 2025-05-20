# Recuit simulé

Le **recuit simulé** est un algorithme d'optimisation inspiré du processus physique de refroidissement des métaux.

## Principe

Partant d'une solution initiale, on génère une **solution voisine**.  
- Si cette nouvelle solution **améliore** la solution courante, on l'accepte et on réitère le processus.
- Contrairement à la **méthode de descente pure**, si la solution **n'améliore pas** la solution courante, elle peut **tout de même être acceptée avec une certaine probabilité**.

Cette probabilité dépend de deux facteurs :
- L’**écart de valeur** entre la solution voisine et la solution courante.
- Un **paramètre de contrôle** appelé **température**.

## Rôle de la température

La température permet de contrôler le degré d’exploration, c'est-à-dire le processus de recherche du recuit simulé :

- **Au début**, la température est élevée : cela permet d’accepter plus facilement des solutions dégradantes (favorise l’exploration).
- **Progressivement**, la température est abaissée et les solutions dégradantes sont de moins en moins acceptées(favorise l’intensification).

=> **Exploration** : trouver une zone de l'espace de recherche **prometteuse**.  
=> **Intensification** : trouver la **meilleure solution** dans cette zone de recherche de taille réduite.

## Structure de l’algorithme

Deux **boucles imbriquées** :

1. **Boucle externe** : abaissement de la température pour converger vers l’optimum global.
2. **Boucle interne** : sélection du voisin selon le **critère de Metropolis**.

## Pseudo-code

```pseudo
Initialisation :
    Choisir :
        - une température de départ T = 10
        - une solution initiale x₀; k=0;
        - un paramètre de tolérance β ∈ [0,1]

Tant que l'on peut abaisser la température :                # 1ère boucle
    Tant que l'ensemble des voisins N(xk) n'est pas vide :  # 2e boucle = on peut encore explorer autour de la      
                                                            #             solution courante
        1) Générer une solution aléatoire dans le voisinage de la solution courante
            avec xk+1 € N(xk)
        2) Comparer les 2 solutions selon le critère de Metropolis (Évaluer son coût)
            On calcule la variation du coût delta F = f(xk+1)-f(xk)
        3) Si delta F <=0 le coût diminue => on accepte la nouvelle solution : 
            xk+1=k
            k=k+1
        Sinon le coût augmente => on calcule une probabilité d'acceptation P= exp-delta f/T (Metropolis) :
            on choisit aléatoirement une valeur du paramètre β € [0,1] 
            Si P>β on accepte la nouvelle solution bien qu'elle n'améliore pas la fonction coût : 
                xk+1=xk, k=k+1
            Sinon la solution est rejetée
            Fin si
        Fin si

        Répéter 1), 2) et 3) jusqu'à ce qu el'équilibre statistique soit atteint (i.e ensemble des voisins candidats traités)
    Fin tant que 2

    Abaisser la température et répéter jusqu'à ce que le systèùe soit gelé
Fin tant que 1


        