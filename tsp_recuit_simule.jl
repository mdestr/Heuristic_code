using Random

# Calcule la distance totale d'une route donnée selon la matrice des distances
function total_distance(route, distance_matrix)
    n = length(route)
    # On boucle sur chaque ville et on ajoute la distance vers la suivante (la dernière revient à la première)
    sum(distance_matrix[route[i], route[i % n + 1]] for i in 1:n)
end

# Génère une route aléatoire (permutation des indices des villes)
function random_route(num_cities)
    shuffle(1:num_cities)
end

# Génère un voisin en échangeant deux villes au hasard dans la route
function swap_neighbor(route)
    new_route = copy(route)
    i, j = rand(1:length(route), 2)
    new_route[i], new_route[j] = new_route[j], new_route[i]
    return new_route
end

# Algorithme de recuit simulé pour le TSP
function simulated_annealing(distance_matrix; temp_init=10000.0, cooling_rate=0.995, max_iter=1000, print_every=100)
    # Initialisation : on part d'une route aléatoire
    current_route = random_route(size(distance_matrix,1))
    current_cost = total_distance(current_route, distance_matrix)
    best_route = copy(current_route)
    best_cost = current_cost

    println("Solution initiale : ", current_route, " | Distance : ", current_cost)

    temperature = temp_init

    for iter in 1:max_iter
        # Générer une solution voisine en échangeant deux villes
        neighbor_route = swap_neighbor(current_route)
        neighbor_cost = total_distance(neighbor_route, distance_matrix)

        # Calcul de la différence de coût entre la solution voisine et la solution courante
        delta = neighbor_cost - current_cost

        # Si la solution voisine est meilleure, on l'accepte toujours
        if delta < 0
            println("Itération $iter : Amélioration trouvée ! Nouvelle distance : $neighbor_cost")
        # Si elle est moins bonne, on l'accepte avec une certaine probabilité dépendant de la température
        elseif exp(-delta/temperature) > rand()
            println("Itération $iter : Solution moins bonne acceptée (delta = $delta) à température = $temperature")
        end

        # Critère d'acceptation (toujours si meilleure, parfois si moins bonne)
        if delta < 0 || exp(-delta/temperature) > rand()
            current_route = neighbor_route
            current_cost = neighbor_cost

            # Mise à jour du meilleur chemin trouvé si nécessaire
            if current_cost < best_cost
                best_route = copy(current_route)
                best_cost = current_cost
                println("Itération $iter : Nouveau meilleur ! Route : $best_route | Distance : $best_cost")
            end
        end

        # Affichage régulier de l'état de la recherche
        if iter % print_every == 0 || iter == 1
            println("Itération $iter : Température = $temperature | Meilleure distance = $best_cost")
        end

        # Refroidissement de la température
        temperature *= cooling_rate
    end

    println("\nFin du recuit simulé.")
    println("Meilleure route trouvée : ", best_route)
    println("Distance totale : ", best_cost)
    return best_route, best_cost
end

# Exemple d'utilisation avec une matrice 5x5
distance_matrix = [
    0 2 9 10 5;
    2 0 6 4 8;
    9 6 0 7 3;
    10 4 7 0 1;
    5 8 3 1 0
]

# Lancer l'algorithme avec affichage détaillé
route_opt, distance_opt = simulated_annealing(distance_matrix, temp_init=10000, cooling_rate=0.995, max_iter=500, print_every=50)
