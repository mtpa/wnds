# Visualizing Networks---Understanding Organizations (R)

# bring in packages we rely upon for work in predictive analytics
library(igraph)  # network/graph methods
library(network)  # network representations
library(intergraph)  # for exchanges between igraph and network

# ----------------------------------------------------------
# Preliminary note about data preparation
#
# The first two records of the original link file
# contains vertices referenced by a zero index.
# For R network algorithms we need to ensure that
# these the from- and to-node identifiers are 
# treated as character strings, not integers.

# ----------------------------------------------------------
# Read in list of links... (from-node, to-node) pairs
# ----------------------------------------------------------
all_enron_links <- read.table('enron_email_links.txt', header = FALSE)
cat("\n\nNumber of Links on Input: ", nrow(all_enron_links))
# check the structure of the input data data frame
print(str(all_enron_links))

# convert the V1 and V2 to character strings
all_enron_links$V1 <- as.character(all_enron_links$V1)
all_enron_links$V2 <- as.character(all_enron_links$V2)

# ensure that no e-mail links are from an executive to himself/herself
# i.e. eliminate any nodes that are self-referring 
enron_links <- subset(all_enron_links, subset = (V1 != V2))
cat("\n\nNumber of Valid Links: ", nrow(enron_links))

# create network object from the links
# multiple = TRUE allows for multiplex links/edges
# because it is possible to have two or more links
# between the same two nodes (multiple e-mail messages
# between the same two people)
enron_net <- network(as.matrix(enron_links),
    matrix.type = "edgelist", directed = TRUE, multiple = TRUE)
# create graph object with intergraph function asIgraph()
enron_graph <- asIgraph(enron_net)
# name the nodes noting that the first identifer on input was "0"
node_index <- as.numeric(V(enron_graph))
V(enron_graph)$name <- node_name <- as.character(V(enron_graph) - 1)
# node name lookup table
node_reference_table <- data.frame(node_index, node_name, stringsAsFactors = FALSE)
print(str(node_reference_table))
print(head(node_reference_table))

# consider the subgraph of all people that node "1"
# communicates with by e-mail (mail in or out)
# node "1" corresponds to node index 2 in R
ego_1_mail <- induced.subgraph(enron_graph, 
    neighborhood(enron_graph, order = 1, nodes = 2)[[1]])
# examine alternative layouts for plotting the ego_1_mail 
pdf(file = "fig_ego_1_mail_network_four_ways.pdf", width = 5.5, height = 5.5)
par(mfrow = c(1,1))  # four plots on one page
set.seed(9999)  # for reproducible results
plot(ego_1_mail, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25,
    layout = layout.fruchterman.reingold)
title("Fruchterman-Reingold Layout")   
set.seed(9999)  # for reproducible results
plot(ego_1_mail, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25, 
    layout = layout.kamada.kawai)  
title("Kamada-Kawai Layout")    
set.seed(9999)  # for reproducible results
plot(ego_1_mail, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25, 
    layout = layout.circle)
title("Circle Layout")     
set.seed(9999)  # for reproducible results
plot(ego_1_mail, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25,
    layout = layout.reingold.tilford)    
title("Reingold-Tilford Layout")       
dev.off()

set.seed(9999)  # for reproducible results
pdf(file = "fig_ego_1_mail_network.pdf", width = 8.5, height = 11)
plot(ego_1_mail, vertex.size = 15, vertex.color = "yellow", 
    vertex.label.cex = 0.9, edge.arrow.size = 0.25, 
    edge.color = "black", layout = layout.kamada.kawai)
dev.off()

# examine the degree of each node in the complete Enron e-mail network
# and add this measure (degree centrality) to the node reference table
node_reference_table$node_degree <- degree(enron_graph)
print(str(node_reference_table))
print(head(node_reference_table))

# sort the node reference table by degree and identify the indices
# of the most active nodes (those with the most links)
sorted_node_reference_table <- 
    node_reference_table[sort.list(node_reference_table$node_degree, 
        decreasing = TRUE),]
# check on the sort
print(head(sorted_node_reference_table))
print(tail(sorted_node_reference_table))

# select the top K executives... set K 
K <- 50

# identify a subset of K Enron executives based on e-mail-activity 
top_node_indices <- sorted_node_reference_table$node_index[1:K]
top_node_names <- sorted_node_reference_table$node_name[1:K]
print(top_node_indices)
print(top_node_names)

# define a top nodes reference table as subset of complete reference table
top_node_reference_table <- subset(node_reference_table, 
    subset = (node_name %in% top_node_names))
print(str(top_node_reference_table))
print(head(top_node_reference_table))

# construct the subgraph of the top K executives
top_enron_graph <- induced.subgraph(enron_graph, top_node_indices)
# examine alternative layouts for plotting the top_enron_graph 
pdf(file = "fig_top_enron_graph_four_ways.pdf", width = 5.5, height = 5.5)
par(mfrow = c(1,1))  # four plots on one page
set.seed(9999)  # for reproducible results
plot(top_enron_graph, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25,
    layout = layout.fruchterman.reingold)
title("Fruchterman-Reingold Layout")   
set.seed(9999)  # for reproducible results
plot(top_enron_graph, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25, 
    layout = layout.kamada.kawai)  
title("Kamada-Kawai Layout")    
set.seed(9999)  # for reproducible results
plot(top_enron_graph, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25, 
    layout = layout.circle)
title("Circle Layout")     
set.seed(9999)  # for reproducible results
plot(top_enron_graph, vertex.size = 10, vertex.color = "yellow", 
    vertex.label = NA, edge.arrow.size = 0.25,
    layout = layout.reingold.tilford)    
title("Reingold-Tilford Layout")       
dev.off()

# let's use the Kamada-Kawai layout for the labeled plot
set.seed(9999)  # for reproducible results
pdf(file = "fig_top_enron_graph.pdf", width = 8.5, height = 11)
plot(top_enron_graph, vertex.size = 15, vertex.color = "yellow", 
    vertex.label.cex = 0.9, edge.arrow.size = 0.25, 
    edge.color = "darkgray", layout = layout.kamada.kawai)
dev.off()

# a clique is a subset of nodes that are fully connected
# (links between all pairs of nodes in the subset)
# perform a census of cliques in the top_enron_graph
table(sapply(cliques(top_enron_graph), length))  # shows two large cliques

# the two largest cliques have thirteen nodes/executives
# let's identify those cliques
two_cliques <- 
    cliques(top_enron_graph)[sapply(cliques(top_enron_graph), length) == 13]

# show the new index values for the top cliques... note the overlap 
print(two_cliques)

# finding our way to the executive core of the company
# note index numbers are reset by the induced.subgraph() function
# form a new subgraph from the union of the top two cliques
core_node_indices_new <- unique(unlist(two_cliques))
non_core_node_indices_new <- setdiff(1:K, core_node_indices_new)
set_node_colors <- rep("white", length = K)
set_node_colors[core_node_indices_new] <- "darkblue"
set_label_colors <- rep("black", length = K)
set_label_colors[core_node_indices_new] <- "white"

# again use the Kamada-Kawai layout for the labeled plot
# but this time we use white for non-core and blue for core nodes
set.seed(9999)  # for reproducible results
pdf(file = "fig_top_enron_graph_with_core.pdf", width = 8.5, height = 11)
plot(top_enron_graph, vertex.size = 15, 
    vertex.color = set_node_colors, 
    vertex.label.color = set_label_colors,
    vertex.label.cex = 0.9, edge.arrow.size = 0.25, 
    edge.color = "darkgray", layout = layout.kamada.kawai)
dev.off()

# check on the tree/hierarchy to search for the source of power
set.seed(9999)  # for reproducible results
plot(top_enron_graph, vertex.size = 15, vertex.color = "white", 
    vertex.label.cex = 0.9, edge.arrow.size = 0.25,
    layout = layout.reingold.tilford)  # node name 314?  
    
# compute centrality idices for the top executive nodes
# begin by expressing the adjacency matrix in standard matrix form
top_enron_graph_mat <- as.matrix(get.adjacency(top_enron_graph))
top_node_reference_table$betweenness <- 
    betweenness(top_enron_graph)  # betweenness centrality
top_node_reference_table$evcent <- 
    evcent(top_enron_graph)$vector  # eigenvalue centrality
print(str(top_node_reference_table))
print(top_node_reference_table)  # data for top executive nodes

# Suggestions for the student:  Experiment with techniques for identifying
# core executive groupings and sources of power in the organization. 
# Could it be that node 314, a node not in the core group , 
# is the true source of power in the organization?
# What do indices of centrality suggest about possible sources
# of power, influence, or importance in the Enron network?
# Try other network visualizations for the Enron e-mail network.
# Note that nowhere in our analysis so far have we looked at the 
# number of e-mails sent from one player/node to another. 
# All we have are binary links. If there is at least one e-mail between 
# a pair of nodes, we have drawn a link between those nodes. 
# Perhaps that is why everything looks like spaghetti or a ball of string.
# There is much that can be done with the Enron e-mail corpus.
# We could work with the original Enron e-mail case data, assigning
# executive names (not just numbers) to the nodes. We could
# explore methods of text analytics using the e-mail message text.


