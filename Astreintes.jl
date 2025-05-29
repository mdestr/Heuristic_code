using Random

# --- Données d'entrée ---
agents = ["Seb", "Ger", "Chi", "Kev", "Man", "And"]
weeks = 18:29
nb_agents = length(agents)
nb_weeks = length(weeks)

# Matrice de disponibilité (1 = dispo, 0 = indispo)
dispo = [
    1 1 1 0 1 1 1 0 1 1 1 1;  # Seb
    1 0 1 1 1 0 1 1 1 0 1 1;  # Ger
    0 0 0 1 0 0 0 0 1 0 0 1;  # Chi
    1 1 1 0 0 1 1 1 1 0 1 1;  # Kev
    1 0 1 0 0 1 1 1 1 1 1 1;  # Man
    1 1 0 1 1 0 0 1 0 1 1 1   # And
]

# --- Fonction de coût ---
function compute_cost(x)
    astreintes = [sum(x[a, :]) for a in 1:nb_agents]
    equilibre = maximum(astreintes) - minimum(astreintes)

    indispo = sum(x[a, w] * (1 - dispo[a, w]) for a in 1:nb_agents, w in 1:nb_weeks)

    consecutives = sum(x[a, w] * x[a, w+1] for a in 1:nb_agents, w in 1:nb_weeks-1)

    return 100 * equilibre + 1000 * indispo + 50 * consecutives
end

# --- Génère une solution voisine ---
function generate_neighbor(x)
    x_new = deepcopy(x)
    w = rand(1:nb_weeks)
    a_old = findfirst(a -> x[a, w] == 1, 1:nb_agents)

    # Trouver un agent alternatif disponible
    possibles = [a for a in 1:nb_agents if a != a_old && dispo[a, w] == 1 &&
                 (w == 1 || x[a, w-1] == 0) &&
                 (w == nb_weeks || x[a, w+1] == 0)]

    if !isempty(possibles)
        a_new = rand(possibles)
        x_new[a_old, w] = 0
        x_new[a_new, w] = 1
    end

    return x_new
end

# --- Affiche le planning final ---
function print_solution(x)
    println("Plan d'astreintes :")
    println("Semaine Personne")
    for (w_idx, week) in enumerate(weeks)
        for a in 1:nb_agents
            if x[a, w_idx] == 1
                println(week, "      ", agents[a])
            end
        end
    end

    println("\nNombre d'astreintes par personne :")
    for a in 1:nb_agents
        n = sum(x[a, :])
        println(agents[a], " : ", n, " astreinte", n > 1 ? "s" : "")
    end
end

# --- Main ---
function main()
    # Initialisation aléatoire (respecte disponibilité + évite consécutives si possible)
    x = zeros(Int, nb_agents, nb_weeks)
    for w in 1:nb_weeks
        possibles = [a for a in 1:nb_agents if dispo[a, w] == 1 &&
                     (w == 1 || x[a, w-1] == 0) &&
                     (w == nb_weeks || x[a, w+1] == 0)]
        if isempty(possibles)
            possibles = [a for a in 1:nb_agents if dispo[a, w] == 1]
        end
        if !isempty(possibles)
            a = rand(possibles)
            x[a, w] = 1
        else
            a = rand(1:nb_agents)
            x[a, w] = 1  # forcé malgré indisponibilité (pénalisé par le coût)
        end
    end

    # Recuit simulé
    T = 1000.0
    T_min = 1e-2
    alpha = 0.95
    steps_per_temp = 1000

    best_x = deepcopy(x)
    best_cost = compute_cost(x)

    while T > T_min
        for _ in 1:steps_per_temp
            x_new = generate_neighbor(x)
            Δ = compute_cost(x_new) - compute_cost(x)
            if Δ < 0 || rand() < exp(-Δ / T)
                x = x_new
                if compute_cost(x) < best_cost
                    best_x = deepcopy(x)
                    best_cost = compute_cost(x)
                end
            end
        end
        T *= alpha
    end

    print_solution(best_x)
end

main()
