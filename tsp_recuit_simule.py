import marimo

__generated_with = "0.13.11"
app = marimo.App(width="medium")


@app.cell
def _():
    return


@app.cell
def _():
    import numpy as np
    import matplotlib.pyplot as plt
    import random as rd

    # Paramètres
    N = 20  # Nombre de points à générer

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

    # Affichage final
    plt.show()
    return


if __name__ == "__main__":
    app.run()
