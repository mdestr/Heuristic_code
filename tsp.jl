n = 10 # 10 villes
d = rand(1:9,n,n) # distances entre les villes
s = zeros(Int,n+1)
for i in 1:n
    s[i] = i
end
s[n+1]=1 # on revient à Paris

# Somme de toutes les valeurs    
function evalSol(sol) #sol comporte n+1 valeurs
    totDist=0
    for i in 1:n
        totDist = totDist + d[sol[i],sol[i+1]]
    end
    return totDist
end

function tsp()
   # évaluation de la solution candidate courante
   global s
   while true # Tant que l'amélioration est possible on continue
       distStart = evalSol(s)
       nDist = distStart
       # on cherche 2 villes à inverser pour améliorer la somme des distances courante
       for i in 2:n # villes i, à partir de 2 car on n'échange jamais la ville de départ [1] vu que c'est aussi la ville d'arrivée
           for j in i+1:n # villes j
              s2    = copy(s)       
              s2[i] = s[j]
              s2[j] = s[i]
              if evalSol(s2)<nDist # si on améliore la nouvelle distance
                   nDist = evalSol(s2) # la nouvelle distance prend la valeur améliorée
                   s     = s2 # on change de solution candidate 
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
