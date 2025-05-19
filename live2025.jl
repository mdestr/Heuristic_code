# www.jdoodle.com/online-compiler-julia
function eval(s)
    dist = 0;
    for i in 1:n
        dist = dist + d[s[i],s[i+1]];
    end
    return dist;
end
function tsp()  # traveling salesman problem 
    s=Vector(1:n)
    s=vcat(s,1);
    s=reverse(s,Int(n/2),n);
    println(s);
    bstObj = eval(s);
    println(" sol=",s," de cout ",bstObj);
    maxIter = 20;
    for iter in 1:maxIter
        println("Iteration ",iter);
        distInit = eval(s);
        distNew  = distInit;
        sNew     = s;
        # cette boucle fait l'évaluation du voisinage 
        # (toutes les transformations dispo)
        for i in 2:n-1
            j=i+1
            # on essaye d'échanger i avec j
            s2      = copy(s);
            s2[i]   = s[j];
            s2[j] = s[i];
            println(" j'essaye sol=",s2," de cout ",eval(s2));
            if(eval(s2)<=distNew)
                distNew = eval(s2);
                sNew = s2;
                if distNew<bstObj
                    bstObj = distNew;
                end
            end
        end
        s = sNew;
        println(" sol=",s," de cout ",distNew);
        if(distNew==distInit)
            println(" Minimum local trouvé. Stop");
            return distInit;
        end
    end
    return bstObj;
end
# le programme principal
n = 4;
d = rand(1:9, n,n);
println(d)
d = d+d' # symétrie
println(d)
print("val obj finale ",tsp());





