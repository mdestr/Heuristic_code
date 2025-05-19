# www.jdoodle.com/online-compiler-julia
function eval(s)
    dist = 0;
    for i in 1:n
        dist = dist + d[s[i],s[i+1]];
    end
    return dist;
end
function tsp()  #traveling salesman problem 
    s=Vector(1:n)
    s=vcat(s,1);
    s=reverse(s,Int(n/2),n);
    tabu = -Inf*ones(n);
    println(s);
    bstObj = eval(s);
    println(" sol=",s," de cout ",bstObj);
    maxIter = 20;
    for iter in 1:maxIter
        #println("Iteration ",iter);
        distInit = eval(s);
        distNew  = Inf;
        sNew     = s;
        #cette boucle fait l'évaluation du voisinage (toutes les transformations dispo)
        for i in 2:n-1
          for j in i+1:n
            #on essaye d'échanger i avec j
            if tabu[i]<iter-6 && tabu[j]<iter-6
                s2      = copy(s);
                s2[i]   = s[j];
                s2[j] = s[i];
                #println(" j'essaye sol=",s2," de cout ",eval(s2));
                if(eval(s2)<=distNew)
                    distNew = eval(s2);
                    sNew = s2;
                    if distNew<bstObj
                        bstObj = distNew;
                    end
                end
            end
          end
        end
        for i = 2:n
            if s[i]!=sNew[i]
                tabu[i] = iter;
            end
        end
        s = sNew;
        println(" sol=",s," de cout ",distNew);
        #if(distNew==distInit)
        #    println(" Minimum local trouvé. Stop");
        #    return distInit;
        #end
    end
    return bstObj;
end
#le programme principal
n = 22;
d = zeros(Int, n,n);
for i in 1:n
    for j in 1:n
        d[i,j] = min(abs(i-j),abs(i-j-n), abs(j-i-n));
    end
end
print("val obj finale ",tsp());
