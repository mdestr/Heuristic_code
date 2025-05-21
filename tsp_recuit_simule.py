import marimo

__generated_with = "0.13.11"
app = marimo.App(width="medium")


@app.cell
def _():
    import numpy as np
    import matplotlib.pyplot as plt
    import random as rd
    return np, plt


@app.cell
def _(np, plt):
    # Paramètres
    # Nombre de villes (points à générer)
    N = 5
    # La température initiale doit être élevée
    T0 = 15
    T = T0
    # Température minimum pour arrêter le recuit
    #Tmin = 1e-2
    Tmin = 9
    # Paramètre pour calculer la décroissance de la température
    # tau doit être assez grand pour que le refroidissement soit suffisamment lent, 
    # mais pas trop pour ne pas avoir trop de calcul
    tau = 1e2
    # Probabilité d'accepter ou non la solution
    beta = 1e-1
    k=0
    t=0

    # calcul de la fonction coût
    def fonction_cout():
        global chemin
        energie = 0.0
        #xy = np.concatenate((x[chemin], y[chemin]))
        xy = np.column_stack((x[chemin], y[chemin]))
        print('x = ', x)
        print('y = ', y)
        print('coordonnées x et y : ', xy)
        energie = np.sum(np.sqrt(np.sum((xy -np.roll(xy,-1,axis=0))**2,axis=1)))
        return energie

    def deplacement(ville1, ville2):
        # déplacement aléatoire
        global chemin
        Min = min(ville1, ville2)
        Max = max(ville1, ville2)
        chemin[Min:Max] = chemin[Min:Max].copy()[::-1]
        return
    


    # choix du chemin initial
    x=np.random.uniform(0,1,N)
    y=np.random.uniform(0,1,N)
    chemin = np.arange(N)

    cout = fonction_cout()

    print('k = ', k, 'Chemin Hamiltonien : ', chemin)
    print('Coût du chemin = Distance du chemin = ', cout)

    while k<N:
        plt.plot(x, y, x[chemin], y[chemin], marker='o', color='k')
        k+=1

    # Affichage final
    plt.show()

    '''
    # Initialisation du graphique
    plt.figure(figsize=(8, 8))
    plt.title(f"Génération de {N} points aléatoires")
    plt.xlim(0, 1)
    plt.ylim(0, 1)
    plt.grid(True, alpha=0.3)

    # Génération et affichage des points
    for _ in range(N):
        x = rd.uniform(0, 1)
        y = rd.uniform(0, 1)
        plt.plot(x, y, marker='o', color='r', markersize=8)
    '''
    return


if __name__ == "__main__":
    app.run()
