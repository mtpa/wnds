# Defining and Visualizing Simple Networks (Python)

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# load package into the workspace for this program
import networkx as nx
import matplotlib.pyplot as plt  # 2D plotting
import numpy as np

# -------------------------
# star (undirected network)
# -------------------------
# define graph object for undirected star network
# adding one link at a time for pairs of nodes
star = nx.Graph()
star.add_edge('Amy', 'Bob')
star.add_edge('Amy', 'Dee')
star.add_edge('Amy', 'Joe')
star.add_edge('Amy', 'Lea')
star.add_edge('Amy', 'Max')
star.add_edge('Amy', 'Tia')

# examine the degree of each node
print(nx.degree(star))

# plot the star network and degree distribution 
fig = plt.figure()
nx.draw_networkx(star, node_size = 2000, node_color = 'yellow')
plt.show()

fig = plt.figure()
plt.hist(nx.degree(star).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()

# create an adjacency matrix object for the star network
# use nodelist argument to order the rows and columns
star_mat = nx.adjacency_matrix(star,\
    nodelist = ['Amy', 'Bob', 'Dee', 'Joe', 'Lea', 'Max', 'Tia'])
print(star_mat)  # undirected networks are symmetric

# determine the total number of links for the star network (n-1)
print(star_mat.sum()/2)

# ---------------------------
# circle (undirected network)
# ---------------------------
# define graph object for undirected circle network
# using a list of links for pairs of nodes
circle = nx.Graph()
circle.add_edges_from([('Abe', 'Bea'), ('Abe', 'Rob'), ('Bea', 'Dag'),\
    ('Dag', 'Eve'), ('Eve', 'Jim'), ('Jim', 'Kat'), ('Kat', 'Rob')])
    
# examine the degree of each node
print(nx.degree(circle))
    
# plot the circle network and degree distribution 
fig = plt.figure()
nx.draw_networkx(circle, node_size = 2000, node_color = 'yellow')
plt.show()

fig = plt.figure()
plt.hist(nx.degree(circle).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()

# create an adjacency matrix object for the circle network
# use nodelist argument to order the rows and columns
circle_mat = nx.adjacency_matrix(circle,\
    nodelist = ['Abe', 'Bea', 'Dag', 'Eve', 'Jim', 'Kat', 'Rob'])
print(circle_mat)  # undirected networks are symmetric

# determine the total number of links for the circle network 
print(circle_mat.sum()/2)

# -------------------------
# line (undirected network)
# -------------------------
# define graph object for undirected line network
# using a list of links for pairs of nodes
line = nx.Graph()
line.add_edges_from([('Ali', 'Ben'), ('Ali', 'Ela'), ('Ben', 'Ian'),\
    ('Ela', 'Mya'), ('Ian', 'Roy'), ('Mya', 'Zoe')])
    
# examine the degree of each node
print(nx.degree(line))

# plot the line network and degree distribution 
fig = plt.figure()
nx.draw_networkx(line, node_size = 2000, node_color = 'yellow')
plt.show()

fig = plt.figure()
plt.hist(nx.degree(line).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()

# create an adjacency matrix object for the line network
# use nodelist argument to order the rows and columns
line_mat = nx.adjacency_matrix(line,\
    nodelist = ['Ali', 'Ben', 'Ela', 'Ian', 'Mya', 'Roy', 'Zoe'])
print(line_mat)  # undirected networks are symmetric

# determine the total number of links for the line network (n-1)
print(line_mat.sum()/2)

# ---------------------------
# clique (undirected network)
# ---------------------------
# define graph object for undirected clique
a_clique = nx.Graph()
a_clique.add_edges_from([('Ada', 'Ala'), ('Ada', 'Ami'), ('Ada', 'Ana'),\
('Ada', 'Ann'), ('Ada', 'Ara'), ('Ada', 'Ava'), ('Ala', 'Ami'),\
('Ala', 'Ana'), ('Ala', 'Ann'), ('Ala', 'Ara'), ('Ala', 'Ava'),\
('Ami', 'Ana'),('Ami', 'Ann'), ('Ami', 'Ara'), ('Ami', 'Ava'),\
('Ana', 'Ann'), ('Ana', 'Ara'), ('Ana', 'Ava'),\
('Ann', 'Ara'), ('Ann', 'Ava'), ('Ara', 'Ava')])

# examine the degree of each node
print(nx.degree(a_clique))

# plot the clique and degree distribution 
fig = plt.figure()
nx.draw_networkx(a_clique, node_size = 2000, node_color = 'yellow',\
    pos = nx.circular_layout(a_clique))
plt.show()

fig = plt.figure()
plt.hist(nx.degree(a_clique).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()

# create an adjacency matrix object for the line network
# use nodelist argument to order the rows and columns
a_clique_mat = nx.adjacency_matrix(a_clique,\
    nodelist = ['Ada', 'Ala', 'Ami', 'Ana', 'Ann', 'Ara', 'Ava'])
print(a_clique_mat)  # undirected networks are symmetric

# determine the total number of links for the clique n(n-1)/2
print(a_clique_mat.sum()/2)

# -------------------------------
# tree (directed network/digraph)
# -------------------------------
# define graph object for undirected tree network
# using a list of links for pairs of from-to nodes
tree = nx.DiGraph()
tree.add_edges_from([('Art', 'Bev'), ('Art', 'Dan'), ('Bev', 'Fay'),\
    ('Bev', 'Lee'), ('Dan', 'Mia'), ('Mia', 'Sal'), ('Mia', 'Van')])
    
# examine the degree of each node
print(nx.degree(tree))    
    
# create an adjacency matrix object for the line network
# use nodelist argument to order the rows and columns
tree_mat = nx.adjacency_matrix(tree,\
    nodelist = ['Art', 'Bev', 'Dan', 'Fay', 'Lee', 'Mia', 'Sal', 'Van'])
print(tree_mat)  # directed networks are not symmetric

# determine the total number of links for the tree 
# upper triangle only has values
print(tree_mat.sum())

# plot the degree distribution 
fig = plt.figure()
plt.hist(nx.degree(tree).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()
    
# examine alternative layouts for plotting the tree 
# plot the network/graph with default layout 
fig = plt.figure()
nx.draw_networkx(tree, node_size = 2000, node_color = 'yellow')
plt.show()

# spring layout
fig = plt.figure()
nx.draw_networkx(tree, node_size = 2000, node_color = 'yellow',\
    pos = nx.spring_layout(tree))
plt.show()

# circlular layout
fig = plt.figure()
nx.draw_networkx(tree, node_size = 2000, node_color = 'yellow',\
    pos = nx.circular_layout(tree))
plt.show()

# shell/concentric circles layout
fig = plt.figure()
nx.draw_networkx(tree, node_size = 2000, node_color = 'yellow',\
    pos = nx.shell_layout(tree))
plt.show()

# spectral layout
fig = plt.figure()
nx.draw_networkx(tree, node_size = 2000, node_color = 'yellow',\
    pos = nx.spectral_layout(tree))
plt.show()

# Gephi provides interactive network plots 
# dump the graph object in GraphML format for input to Gephi
nx.write_graphml(tree,'tree_to_gephi.graphml')

# Suggestions for the student: Define alternative network structures.    
# Use matplotlib to create their plots. Create the corresponding 
# adjacency matrices and compute network descriptive statistics,
# beginning with degree centrality. Plot the degree distribution
# for each network.  Read about Gephi and try interactive plots.
