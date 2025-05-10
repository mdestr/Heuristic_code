import random
n = 10
d=[random.choices(range(0,1000), k=n) for _ in range(n)]
s = [i for i in range(0,n)]+[0];

def evalSol(sol):
    totDist = 0
    for i in range(n):
        totDist = totDist + d[sol[i]][sol[i+1]]
    return totDist

def tsp():
    global s
    print("distance initiale=",evalSol(s))
    while True:
        dStart = evalSol(s)
        nDist  = dStart;
        for i in range(1,n):
            for j in range(i+1,n):
                #print("J'essaye permuter ",i," et ", j, "\n");
                s2 = s.copy()
                s2[i] = s[j]
                s2[j] = s[i] 
                if evalSol(s2)<nDist:
                    nDist = evalSol(s2)
                    s  = s2.copy()
                    print("nDist=",nDist, "par Ã©change de:", s[i], " et ",s[j])
        if nDist == dStart:
            print("distance finale=",dStart)
            break

tsp()
