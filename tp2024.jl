#= On considère n villes sur la carte de France, notées 1, 2,... n. 
On connait la distance entre chaque deux villes. 
Trouver le circuit de distance minimale: il faut partir de la ville 0, 
visiter chaque autre ville exactement une fois et revenir à la ville de départ.
À partir de ce problème (le voyageur de commerce standard), on ajoute une contrainte : 
il est interdit de visiter une après l’autre trois villes consécutives. 
Le circuit ne peut pas contenir un segment [i, i+1, i+2]. 
Il est interdit, par exemple de visiter la ville 4, suivie de la ville 5 et suivie de la ville 6. =#

n = 10 # 10 villes
d = rand(1:9,n,n) # distances entre les villes
s = zeros(Int,n+1)
# Pour une matrice de distances asymétrique
for i in 1:n
    s[i] = i
end
s[n+1]=1 # on revient à Paris

show(stdout, "text/plain", d)
println("\n")

# Pour une matrice de distances symétrique
for i in 1:n
    for j in i+1:n
        d[i,j] = d[j,i]  # Rendre symétrique
    end
end

show(stdout, "text/plain", d)
println("\n")

# Somme de toutes les valeurs    
function evalSol(sol) # sol comporte n+1 valeurs
    totDist=0
    for i in 1:n
        totDist = totDist + d[sol[i],sol[i+1]]
    end
    return totDist
end

function illegalSol(sol, i_courant)
    for i in 1:i_courant
    val1 = sol[i]
    val2 = sol[i+1]
    val3 = sol[i+2]
    if sol[i+1] == sol[i]+1 && sol[i+2] == sol[i]+2
        return true
    end
   end
   return false
end

function tsp()
   # évaluation de la solution candidate courante
   global s
   while true # Tant que l'amélioration est possible on continue
       distStart = evalSol(s)
       nDist = distStart
       # on cherche 2 villes à inverser pour améliorer la somme des distances courante
       for i in 2:n # villes i, à partir de 2 car on n'échange jamais la ville de départ [1] 
                    # vu que c'est aussi la ville d'arrivée
           for j in i+1:n # villes j
              s2    = copy(s)       
              s2[i] = s[j]
              s2[j] = s[i]
              if evalSol(s2)<nDist # si on améliore la nouvelle distance
                if i>=3 
                    if illegalSol(s2, i) == false
                        nDist = evalSol(s2) # la nouvelle distance prend la valeur améliorée
                        s = s2 # on change de solution candidate 
                    end
                else
                    nDist = evalSol(s2) # la nouvelle distance prend la valeur améliorée
                    s = s2 # on change de solution candidate
                end
                println(nDist," ",s)
              end
           end
       end
       if nDist == distStart
            break;
       end
   end
end
tsp()

