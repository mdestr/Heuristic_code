# Fonction de constructoin de la matrice de distances
function init_m(n)
    # D’abord, on fixe d(i,j)=2 pour chaque i,j
    d = fill(2, n, n)
    println(d)

    # Par la suite on définit d(i,j)=1 si...
    for i in 1:n
        for j in 1:n
            if abs(i-j) == 2 || abs(i-j) == n - 2
                d[i, j] = 1;
            end
        end
    end

    # Finalement, on fixe d(i,j)=10 si...
    for i in 1:n
        for j in 1:n
            if abs(i-j) == 1 || abs(i-j) == n - 1
                d[i, j] = 10;
            end
        end
    end    

    return d
end

# Fonction d'évaluation
function eval(s)
    #= Prend en entrée un chemin s (ex. [1, 3, 5, ..., 1])
    calcule sa longueur totale (somme des distances entre les villes consécutives).
    La matrice d contient les distances entre les villes.
    La ville de départ est aussi celle d'arrivée. =#
    dist = 0;
    for i in 1:n
        dist = dist + d[s[i],s[i+1]];
    end
    return dist;
end

# Fonction de vérification de segments interdits
function segmentInterdit(sol)
    for i in 1:n-2
        if sol[i+1] == sol[i]-1 && sol[i+2] == sol[i]-2
            println("!!!!!!!!!!!! Segment interdit dans la solution : ", sol)
            return true
        end
    end
    return false
end

# Fonction d'exploration
function tsp()  # traveling salesman problem 

    # initialisation de la solution de départ
    println("solution de base : [1, 2,... n] : ")
    s=Vector(1:n)
    println(s)
    println("on boucle avec un retour à la ville de départ :  [1, 2,... n, 1] : ")
    s=vcat(s,1);
    println(s)
    println("on intitialise la liste taboue : ")
    tabu = -Inf*ones(n);        # On y enregistre à quelle itération chaque index a été modifié
                                # => tabu[i]=iter signifie : la ville i a été modifiée à l'itération iter
    println(tabu)
    nbTabu = 4
    bstObj = eval(s);           # sauvegarde le coût de la solution initiale
                                # par la suite bstObj stockera la meilleure oslution courante
    println(" sol=",s," de cout ",bstObj);

    # On effectue 20 itérations maximum
    maxIter = 20;
    for iter in 1:maxIter
        println();
        println("##########################################");
        println("##########################################");
        println("Iteration ",iter);
        distNew  = Inf;
        sNew     = s;

        # Cette boucle fait l'évaluation du voisinage (toutes les transformations dispo).
        # On explore tous les échanges possibles entre 2 villes i et j 
        # sauf les villes de départ et arrivée.
        for i in 2:n-1
          for j in i+1:n
            # On essaye d'échanger i avec j seulement si les 2 indices
            # ne sont pas tabous depuis moins de nbTabu itérations.
            if tabu[i]<iter-nbTabu && tabu[j]<iter-nbTabu
                # Si l'échange est autorisé on permute les 2 villes sur une copie de la solution courante
                println("l'échange est autorisé on permute les 2 villes ", s[i], " et ", s[j]," sur une copie de la solution courante : ")
                s2      = copy(s);
                s2[i]   = s[j];
                s2[j]   = s[i];

                # On évalue seulement s'il n'y a pas de segments interdits
                if !segmentInterdit(s2)
                    println(" j'essaye sol=",s2," de cout ",eval(s2));
                    if(eval(s2)<=distNew)
                        println("on évalue le nouveau chemin : ")
                        distNew = eval(s2);
                        println(distNew)                    
                        sNew = s2;  # on conserve le meilleur voisin admissible de cette itération
                        if distNew<bstObj
                            bstObj = distNew;
                        end
                    end
                end
            end
          end
        end
        # On met à jour la liste taboue
        for i = 2:n
            # les villes modifiées entre s et sNew deviennent taboues pour nbTabu itérations
            if s[i]!=sNew[i]
                tabu[i] = iter;
            end
        end
        println("les villes modifiées entre s et sNew deviennent taboues pour ", nbTabu, " itérations")
        println(tabu)
        # sNew devient la solution courante pour la prochaine itération
        s = sNew;
        println("Solution = ", s)
        println("Cout ", bstObj);
    end
    return bstObj
end


#le programme principal
n = 10
d = init_m(n)

println("Matrice d : ", d)
print("val obj finale : ",tsp());