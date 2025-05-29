# www.jdoodle.com/online-compiler-julia

# Fonction d'évaluation
function eval(s)
    #= Prend en entrée un chemin s (ex. [1, 3, 5, ..., 1])
    calcule sa longueur totale (somme des distances entre les villes consécutives).
    La matrice d contient les distances entre les villes.
    On considère que la ville de départ est aussi celle d'arrivée (cycle fermé). =#
    dist = 0;
    for i in 1:n
        dist = dist + d[s[i],s[i+1]];
    end
    return dist;
end




# Fonction principale
function tsp()  # traveling salesman problem 

    # initialisation de la solution de départ
    println("solution de base : [1, 2,... n] : ")
    s=Vector(1:n)               # solution de base : [1, 2,... n]
    println(s)
    println("on boucle avec un retour à la ville de départ :  [1, 2,... n, 1] : ")
    s=vcat(s,1);                # on boucle avec un retour à la ville de départ :  [1, 2,... n, 1]
    println(s)
    println("on inverse la 2e moitié du voyage afin de générer une solution de base aléatoire : ")
    s=reverse(s,Int(n/2),n);    # on inverse la 2e moitié du voyage afin de générer une solution de base aléatoire
    println(s)
    println("on intitialise la liste taboue : ")
    tabu = -Inf*ones(n);        # on intitialise la liste taboue
                                # tableau dans lequel on enregistre à quelle itération chaque index a été modifié
                                # tabu[i]=iter signifie : la ville i a été modifiée à l'itération iter
    println(tabu)
    bstObj = eval(s);           # sauvegarde le coût de la solution initiale
                                # par la suite bstObj stockera la meilleure oslution courante
    println(" sol=",s," de cout ",bstObj);

    # On effectue 20 itérations maximum
    maxIter = 20;
    for iter in 1:maxIter
        println("Iteration ",iter);
        distNew  = Inf;
        sNew     = s;

        # Cette boucle fait l'évaluation du voisinage (toutes les transformations dispo).
        # On explore tous les échanges possibles entre 2 villes i et j 
        # sauf les villes de départ et arrivée.
        for i in 2:n-1
          for j in i+1:n
            # On essaye d'échanger i avec j seulement si les 2 indices
            # ne sont pas tabous depuis moins de 6 itérations.
            if tabu[i]<iter-6 && tabu[j]<iter-6
                # Si l'échange est autorisé on permute les 2 villes sur une copie de la solution courante
                println("l'échange est autorisé on permute les 2 villes ", s[i], " et ", s[j]," sur une copie de la solution courante : ")
                s2      = copy(s);
                s2[i]   = s[j];
                s2[j]   = s[i];
                println(" j'essaye sol=",s2," de cout ",eval(s2));
                if(eval(s2)<=distNew)
                    # on évalue le nouveau chemin
                    distNew = eval(s2);
                    println("on évalue le nouveau chemin : ")
                    println(distNew)                    
                    sNew = s2;  # on conserve le meilleur voisin admissible de cette itération
                    if distNew<bstObj
                        bstObj = distNew;
                    end
                end
            end
          end
        end
        # On met à jour la liste taboue
        for i = 2:n
            # les villes modifiées entre s et sNew deviennent taboues pour 6 itérations
            if s[i]!=sNew[i]
                tabu[i] = iter;
            end
        end
        println("les villes modifiées entre s et sNew deviennent taboues pour 6 itérations")
        println(tabu)
        # sNew devient la solution courante pour la prochaine itération
        s = sNew;
        println(" sol=",s," de cout ",distNew);
    end
    return bstObj;
end


#le programme principal
n = 8;
d = zeros(Int, n,n);
for i in 1:n
    for j in 1:n
        d[i,j] = min(abs(i-j),abs(i-j-n), abs(j-i-n));
    end
end
println("Matrice d : ", d)
print("val obj finale ",tsp());
