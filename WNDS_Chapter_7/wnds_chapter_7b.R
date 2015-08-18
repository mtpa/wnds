# Methods of Sampling from Large Networks (R)

# install packages sna and network

# Background reference for sampling procedures: 
# Leskovec, J. & Faloutsos, C. (2006). Sampling from large graphs. 
# Proceedings of KDD '06. Available at 
# <http://cs.stanford.edu/people/jure/pubs/sampling-kdd06.pdf>

# load packages into the workspace for this program
library("sna")  # social network analysis
library("network")  # network data methods

# user-defined function for computing network statistics 
# this initial function computes network transitivity only
# additional code could be added to compute other network measures
# note that node-level measures may be converted to network measures
# by averaging across nodes
report.network.statistics <- function(selected.edges) {
    # selected.edges is a data frame of edges with two columns 
    # corresponding to FromNodeId and ToNodeId for a directed graph
    # analysis of selected.edges can begin as follows
    # create a directed network/graph (digraph)
    selected.network <- network(as.matrix(selected.edges), 
        matrix.type="edgelist",directed=TRUE)
    # convert to a selected.matrix/graph)
    selected.matrix <- as.matrix(selected.network)
    # transitivity (clustering coefficient) probability that 
    # two nodes with a # common neighbor are also linked 
    # (Consider three nodes A, B, and C. 
    # If A is linked to C and B is linked to C, 
    # what is the probability that A will be linked to B?) 
    # If value above 0.50... indicates clustering of nodes.
    network.transitivity <- 
        gtrans(selected.matrix, use.adjacency = FALSE)  
    # report results for this run
    cat("\n\n","Network statistics for N = ",
      nrow(selected.edges),"\n    Transitivity = ", 
          network.transitivity,sep="")
    }

# network data from the Wikipedia Votes case
# read in the data and set up a binary R data file
# wiki.edges = read.table("wiki_edges.txt",header=T)
# save(wiki.edges, file ="wiki_edges.Rdata") 

# with the binary data file saved in your working directory
# you are ready to load it in and begin an analysis
load("wiki_edges.Rdata")  # brings in the data frame object wiki.edges

print(str(wiki.edges))  # shows 103,689 initial observations/edges

# check to see if there are any self-referring edges 
self.referring.edges <- subset(wiki.edges, 
    subset = (FromNodeId == ToNodeId))
print(nrow(self.referring.edges))  # shows that there are no such nodes 

# this is a large network... so we will explore samples of the edges 
# begin by identifying the number of unique nodes
unique.from.nodes <- unique(wiki.edges$FromNodeId)
print(length(unique.from.nodes))  # there are 6,110 unique from-nodes
unique.to.nodes <- unique(wiki.edges$ToNodeId)
print(length(unique.to.nodes))  # shows that there are 2,381 unique to-nodes
unique.nodes <- unique(c(unique.from.nodes,unique.to.nodes))
print(length(unique.nodes))  # there are 7,115 unique nodes total

# compute the transitivity for the complete network commented out here
# report.network.statistics(selected.edges = wiki.edges)
# RESULT: Transitivity of complete network: 0.1645504

# set the sample size N by setting a proportion of the edges to be sampled
P <- .1  # what proportion will work... .10, .20, .30, or higher?
N <- trunc(P * nrow(wiki.edges))

# specify the sampling method three methods are implemented here 
# one is selected for each time the program is run
METHOD <- "RE"  # random edge sampling
# METHOD <- "RN"  # random node sampling
# METHOD <- "RNN"  # random node neighbor sampling

# seed the random number generator to obtain reporducible results
# if a loop is utilized to repeat sampling, ensure that the seed changes
# within each iteration of the loop
set.seed(9999)  # reporducible results are desired

# ------------------- random edge sampling -------------------
# Random edge (RE) sampling. Using the complete data frame with 
# each record representing an edge or connection between nodes, 
# we select N edges at random. 
if(METHOD == "RE") { # begin if-block for random edge sampling
    selected.indices <- sample(nrow(wiki.edges),N)
    selected.edges <- wiki.edges[selected.indices,]
    }  # end if-block for random edge sampling

# ------------------- random node sampling -------------------
# Random node (RN) sampling. Using the list of unique node numbers, 
# we select nodes at random without replacement. This sampling is 
# carried out using the combined set of FromNodeId and ToNodeId 
# node identifiers. The preliminary sample data frame consists 
# of all edges containing these nodes. Then we sample exactly N 
# edges or rows from the preliminary sample data frame. 
if(METHOD == "RN") { # begin if-block for random node sampling
    selected.node.indices <- 
        sample(length(unique.nodes),P*length(unique.nodes))
    selected.nodes <- unique.nodes[selected.node.indices]
    from.edge.samples <- subset(wiki.edges, 
        subset = (FromNodeId %in% selected.nodes))
    to.edge.samples <- subset(wiki.edges, 
        subset = (ToNodeId %in% selected.nodes))
    all.edge.samples <- rbind(from.edge.samples,to.edge.samples)
    selected.indices <- sample(nrow(all.edge.samples),N)
    selected.edges <- all.edge.samples[selected.indices,]
    }  # end if-block for random node sampling
  
# ------------------- random node-neighbor sampling -------------------
Random node neighbor (RNN) sampling. We begin by selecting a node at 
# random (referring to the FromNodeId values), together with all 
# of its out-going neighbors (ToNodeId values). We continue selecting 
# random FromNodeId values and their associated ToNodeId values until 
# we have N edges in the sample. 
if(METHOD == "RNN") { # begin if-block for random node neighbor sampling
    # obtain from-node values in permuted order
    permuted.from.nodes <- sample(unique.from.nodes)  
    selected.edges <- NULL  # initialize the sample data frame
    number.of.selected.edges.so.far <- 0  # initialize edge count 
    # initialize index of permuted.from.nodes
    index.of.permuted.from.node <- 0 
    while(number.of.selected.edges.so.far < N) {
        index.of.permuted.from.node <- index.of.permuted.from.node + 1
        this.selected.set.of.edges <- subset(wiki.edges, 
          subset = (FromNodeId == 
              permuted.from.nodes[index.of.permuted.from.node]))
        selected.edges <- rbind(selected.edges,this.selected.set.of.edges)
        number.of.selected.edges.so.far <- nrow(selected.edges)
        }
    # just use the first N of the selected edges  
    selected.edges <- selected.edges[1:N,]  
    }  # end if-block for random node neighbor sampling

# report on network sampling results with the 
# user-defined function report.network.statistics
cat("\n\n","Results for sampling method ", METHOD, sep="")
report.network.statistics(selected.edges)

# Suggestions for the student:
# Building on the example code, your job is to write and execute 
# a program to answer a number of questions. How large of a sample 
# is needed to obtain accurate estimates of transitivity? 
# What type of sampling method (if any) provides the best 
# estimate of transitivity for the complete network?  
# Are there other network measures that might be more accurately 
# estimated with network sampling?  Which network sampling method 
# would you recommend for work in web and network data science?
# Go on to implement other network-wide measures, such as
# closeness, betweenness, and eigenvector centrality, and
# network density (number of observed links divided by
# the total possible links).
