# Defining and Visualizing Simple Networks (R)

# begin by installing necessary package igraph 

# load package into the workspace for this program
library(igraph)  # network/graph functions

# -------------------------
# star (undirected network)
# -------------------------
# define graph object for undirected star network
# using links for pairs of nodes by number
star <- graph.formula(1-2, 1-3, 1-4, 1-5, 1-6, 1-7)
# examine the graph object
print(str(star))

# name the nodes (vertices)
V(star)$name <- c("Amy", "Bob", "Dee", "Joe", "Lea", "Max", "Tia")

# examine the degree of each node
print(degree(star))

# determine the total number of links for the star (n-1)
print(sum(degree(star))/2)

# create an adjacency matrix object for the star network
star_mat <- get.adjacency(star)
print(star_mat)  # undirected networks are symmetric

# plot the network/graph to the console
plot(star, vertex.size = 20, vertex.color = "yellow")
# plot the network/graph and degree distribution to an external file
pdf(file = "fig_star_network.pdf", width = 5.5, height = 5.5)
plot(star, vertex.size = 25, vertex.color = "yellow", edge.color = "black")
hist(degree(star), col = "darkblue", 
    xlab = "Node Degree", xlim = c(0,8), main = "",
    breaks = c(0,1,2,3,4,5,6,7,8))
dev.off()

# ---------------------------
# circle (undirected network)
# ---------------------------
# define graph object for undirected circle network
# using links for pairs of nodes by number
circle <- graph.formula(1-2, 1-7, 2-3, 3-4, 4-5, 5-6, 6-7)
# examine the graph object
print(str(circle))

# name the nodes (vertices)
V(circle)$name <- c("Abe", "Bea", "Dag", "Eve", "Jim", "Kat", "Rob")

# examine the degree of each node
print(degree(circle))

# determine the total number of links 
print(sum(degree(circle))/2)

# create an adjacency matrix object for the circle network
circle_mat <- get.adjacency(circle)
print(circle_mat)  # undirected networks are symmetric

# plot the network/graph to the console
plot(circle, vertex.size = 20, vertex.color = "yellow")
# plot the network/graph and degree distribution to an external file
pdf(file = "fig_circle_network.pdf", width = 5.5, height = 5.5)
plot(circle, vertex.size = 25, vertex.color = "yellow", edge.color = "black")
hist(degree(circle), col = "darkblue", 
    xlab = "Node Degree", xlim = c(0,8), main = "",
    breaks = c(0,1,2,3,4,5,6,7,8))
dev.off()

# -------------------------
# line (undirected network)
# -------------------------
# define graph object for undirected line network
# using links for pairs of nodes by number
line <- graph.formula(1-2, 1-3, 2-4, 3-5, 4-6, 5-7)
# examine the graph object
print(str(line))

# name the nodes (vertices)
V(line)$name <- c("Ali", "Ben", "Ela", "Ian", "Mya", "Roy", "Zoe")

# examine the degree of each node
print(degree(line))

# determine the total number of links (n-1)
print(sum(degree(line))/2)

# create an adjacency matrix object for the line network
line_mat <- get.adjacency(line)
print(line_mat)  # undirected networks are symmetric

# plot the network/graph to the console
plot(line, vertex.size = 20, vertex.color = "yellow")
# plot the network/graph and degree distribution to an external file
pdf(file = "fig_line_network.pdf", width = 5.5, height = 5.5)
plot(line, vertex.size = 25, vertex.color = "yellow", edge.color = "black")
hist(degree(line), col = "darkblue", 
    xlab = "Node Degree", xlim = c(0,8), main = "",
    breaks = c(0,1,2,3,4,5,6,7,8))
dev.off()

# ---------------------------
# clique (undirected network)
# ---------------------------
# define graph object for undirected clique
# using links for pairs of nodes by number
a_clique <- graph.formula(1-2, 1-3, 1-4, 1-5, 1-6, 1-7,
                               2-3, 2-4, 2-5, 2-6, 2-7,
                                    3-4, 3-5, 3-6, 3-7,
                                         4-5, 4-6, 4-7,
                                              5-6, 5-7,
                                                   6-7)
# examine the graph object
print(str(a_clique))

# name the nodes (vertices)
V(a_clique)$name <- c("Ada", "Ala", "Ami", "Ana", "Ann", "Ara", "Ava")

# examine the degree of each node
print(degree(a_clique))

# determine the total number of links n(n-1)/2
print(sum(degree(a_clique))/2)

# create an adjacency matrix object for the clique
# this is a matrix of ones off-diagonal... fully connected
a_clique_mat <- get.adjacency(a_clique)
print(a_clique_mat)  # undirected networks are symmetric

# plot the network/graph to the console
plot(a_clique, vertex.size = 20, vertex.color = "yellow", 
    edge.color = "black", layout = layout.circle)
# plot the network/graph and degree distribution to an external file
pdf(file = "fig_clique_network.pdf", width = 5.5, height = 5.5)
plot(a_clique, vertex.size = 25, vertex.color = "yellow", 
    edge.color = "black", layout = layout.circle)
hist(degree(a_clique), col = "darkblue", 
    xlab = "Node Degree", xlim = c(0,8), main = "",
    breaks = c(0,1,2,3,4,5,6,7,8))
dev.off()

# -------------------------------
# tree (directed network/digraph)
# -------------------------------
# define graph object for undirected tree network
# using links for pairs of nodes by number
tree <- graph.formula(1-+2, 1-+3, 2-+4, 2-+5, 3-+6, 6-+7, 6-+8)
# examine the graph object
print(str(tree))

# name the nodes (vertices)
V(tree)$name <- c("Art", "Bev", "Dan", "Fay", "Lee", "Mia", "Sal", "Van")

# examine the degree of each node
print(degree(tree))

# create an adjacency matrix object for the tree network
tree_mat <- get.adjacency(tree)
print(tree_mat)  # directed networks are not symmetric

# plot the network/graph to the console 
plot(tree, vertex.size = 20, vertex.color = "yellow", edge.color = "black")

# plot the network/graph and degree distribution to an external file
# examine alternative layouts for plotting the tree 
pdf(file = "fig_tree_network_four_ways.pdf", width = 5.5, height = 5.5)
par(mfrow = c(1,1))  # four plots on one page
plot(tree, vertex.size = 25, vertex.color = "yellow", 
    layout = layout.fruchterman.reingold, edge.color = "black")
title("Fruchterman-Reingold Layout")   
plot(tree, vertex.size = 25, vertex.color = "yellow", 
    layout = layout.kamada.kawai, edge.color = "black")  
title("Kamada-Kawai Layout")    
plot(tree, vertex.size = 25, vertex.color = "yellow", 
    layout = layout.circle, edge.color = "black")
title("Circle Layout")     
plot(tree, vertex.size = 25, vertex.color = "yellow", 
    layout = layout.reingold.tilford, edge.color = "black")    
title("Reingold-Tilford Layout")       
hist(degree(tree), col = "darkblue", 
    xlab = "Node Degree", xlim = c(0,8), main = "",
    breaks = c(0,1,2,3,4,5,6,7,8))
dev.off()

