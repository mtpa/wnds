# Discovering Common Themes: POTUS Speeches (Python)

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# import packages for text processing and multivariate analysis
import os  # operating system functions
from fnmatch import fnmatch   # character string matching
import re  # regular expressions
import nltk  # draw on the Python natural language toolkit
import pandas as pd  # DataFrame structure and operations
import numpy as np  # arrays and numerical processing
import scipy
import matplotlib.pyplot as plt  # 2D plotting

# terms-by-documents matrix
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

# alternative distance metrics for multidimensional scaling
from sklearn.metrics import euclidean_distances 
from sklearn.metrics.pairwise import linear_kernel as cosine_distances
from sklearn.metrics.pairwise import manhattan_distances as manhattan_distances
from sklearn.metrics import silhouette_score as silhouette_score

from sklearn import manifold  # multidimensional scaling
from sklearn.cluster import KMeans  # cluster analysis by partitioning

# function for walking and printing directory structure
def list_all(current_directory):
    for root, dirs, files in os.walk(current_directory):
        level = root.replace(current_directory, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))

# define list of codes to be dropped from documents
# carriage-returns, line-feeds, tabs
codelist = ['\r', '\n', '\t']  

# we will drop the standard stop words
standard_stopwords = nltk.corpus.stopwords.words('english')
print(map(lambda t: t.encode('ascii'), standard_stopwords))  

# special words associated with the occasion to be dropped from analysis
# along with the usual English stopwords  
more_stopwords = ['speaker','president', 'mr', 'ms', 'mrs', 'th', 'house',\
    'representative', 'representatives', 'senate', 'senator',\
    'americans', 'american', 'america', \
    'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',\
    'united', 'states', 'us', 'we', 'applause', 'ladies', 'gentlemen',\
    'congress', 'country' 'weve', 'youve', 'member', 'members',\
    'with', 'without', 'also', 'yet', 'half', 'also', 'many', 'see', 'said'\
    'years', 'year', 'even', 'ever', 'use', 'well', 'much', 'know', 'let', 'less']    
print(map(lambda t: t.encode('ascii'), more_stopwords))   

# start with the initial list and add to it for POTUS text work 
stoplist = standard_stopwords + more_stopwords 
print(map(lambda t: t.encode('ascii'), stoplist)) 


# employ regular expressions to parse documents
# here we are working with characters and character sequences
def text_parse(string):
    # replace non-alphanumeric with space 
    temp_string = re.sub('[^a-zA-Z]', '  ', string)    
    # replace codelist codes with space
    for i in range(len(codelist)):
        stopstring = ' ' + codelist[i] + '  '
        temp_string = re.sub(stopstring, '  ', temp_string)      
    # replace single-character words with space
    temp_string = re.sub('\s.\s', ' ', temp_string)   
    # convert uppercase to lowercase
    temp_string = temp_string.lower()    
    # replace selected character strings/stop-words with space
    for i in range(len(stoplist)):
        stopstring = ' ' + str(stoplist[i]) + ' '
        temp_string = re.sub(stopstring, ' ', temp_string)        
    # replace multiple blank characters with one blank character
    temp_string = re.sub('\s+', ' ', temp_string)    
    return(temp_string)    
      
# word stemming... looking for contractions... possessives... 
# if we want to do stemming at a later time, we could use 
#     porter = nltk.PorterStemmer()  
# in a construction like this
#     words_stemmed =  [porter.stem(word) for word in initial_words]  
# we examined stemming but found the results to be undesirable

# data for POTUS example are in one directories called POTUS
# all oral State of the Union addresses after Dwight D. Eisenhower
# 52 files in all (25 Democratic, 27 Republican)
# there is no scraping requirement for working with these text data 
# but there are some comments with the text files, such as [Applause]
# because the speeches were delivered orally. Such comments need to
# be deleted from the files before additional text processing is done

# examine the directory structure to ensure POTUS is present
current_directory = os.getcwd()
list_all(current_directory)

# identify text file names of files/documents... should be 52 files
POTUS_file_names =\
    [name for name in os.listdir('POTUS') if fnmatch(name, '*.txt')]
print('\n\nNumber of files/documents:',len(POTUS_file_names))  

# extract metadata from file names for labels on plots/reports 
party_label = []  # initialize list
pres_label = []  # initialize list
year_label = []  # initialize list
for file_name in POTUS_file_names:
    file_name_less_extension = file_name.split('.')[0]
    party_label.append(file_name_less_extension.split('_')[0])
    pres_label.append(file_name_less_extension.split('_')[2])
    year_label.append(file_name_less_extension.split('_')[3])

# for numeric year in plots
year = []
for y in year_label: year.append(int(y))

# make working directory for a text corpus of parsed documents
# used for review of files and subsequent processing from files
os.mkdir('WORK_POTUS')

noutfiles = 0  # intialize count of working files for corpus
working_corpus = []  # initialize corpus with simple list structure
# work on files one at a time parsing and saving to new directory
for input_file_name in POTUS_file_names:
    # read in file
    this_file_name = input_file_name
    with open('POTUS/' + this_file_name, 'rt') as finput:        
        text = finput.read()  # text string
        clean_text = text_parse(text)
        # output file name will be the same as input file name 
        # but we store the file in the new directory WORK_POTUS
        output_file_name = "WORK_POTUS/" + input_file_name
        with open(output_file_name, 'wt') as foutput:
            foutput.write(str(clean_text))
            noutfiles = noutfiles + 1
            working_corpus.append(clean_text)  # build list-structured corpus
    
print('\nParsing complete: ', str(noutfiles) + ' files written to WORK_POTUS')
print('\nworking_corpus list: ', str(len(working_corpus)) + ' items')    
    
# terms-by-documents matrix method to be employed 
# with various numbers of top words
# check on top 200 words
tdm_method = CountVectorizer(max_features = 200, binary = True)  
# employ simple term frequency 
tdm_method = CountVectorizer(max_features = 200, binary = True)
examine_POTUS_tdm = tdm_method.fit(working_corpus)
top_200_words = examine_POTUS_tdm.get_feature_names()
# get clean printing of the top words 
print('\nTop 200 words in POTUS corpus\n')
print(map(lambda t: t.encode('ascii'), top_200_words))  # print sans unicode

# check on top 100 words
tdm_method = CountVectorizer(max_features = 100, binary = True)  
examine_POTUS_tdm = tdm_method.fit(working_corpus)
top_100_words = examine_POTUS_tdm.get_feature_names()
# get clean printing of the top words 
print('\nTop 100 words in POTUS corpus\n')
print(map(lambda t: t.encode('ascii'), top_100_words))  # print sans unicode

# check on top 50 words
tdm_method = CountVectorizer(max_features = 50, binary = True)  
examine_POTUS_tdm = tdm_method.fit(working_corpus)
top_100_words = examine_POTUS_tdm.get_feature_names()
# get clean printing of the top words 
print('\nTop 100 words in POTUS corpus\n')
print(map(lambda t: t.encode('ascii'), top_100_words))  # print sans unicode

# ------------------------------------
# Full solution with all words TF-IDF
# ------------------------------------
# alternatively, use the term frequency inverse document frequency matrix
# . . . begin by computing simple term frequency 
count_vectorizer = CountVectorizer(min_df = 1)  
term_freq_matrix = count_vectorizer.fit_transform(working_corpus)
# print vocabulary without unicode symbols... big vocabulary commented out
# print(map(lambda t: t.encode('ascii'), count_vectorizer.vocabulary_))  

# . . . then transform to term frequency times inverse document frequency
# To get TF-IDF weighted word vectors tf times idf
tfidf = TfidfTransformer()  # accept default settings
tfidf.fit(term_freq_matrix)
tfidf_matrix = tfidf.transform(term_freq_matrix)
print('Shape of term frequency/inverse document frequency matrix',\
    str(tfidf_matrix.shape))

# -----------------------------
# Try top 200 words TF-IDF
# -----------------------------
# alternatively, use the term frequency inverse document frequency matrix
# . . . begin by computing simple term frequency 
count_vectorizer = CountVectorizer(min_df = 1, max_features = 200)  
term_freq_matrix = count_vectorizer.fit_transform(working_corpus)
# print the feature names without unicode symbols... 
top_200_words = count_vectorizer.get_feature_names()
print(map(lambda t: t.encode('ascii'), top_200_words))  

# . . . then transform to term frequency times inverse document frequency
# To get TF-IDF weighted word vectors tf times idf
tfidf = TfidfTransformer()  # accept default settings
tfidf.fit(term_freq_matrix)
tfidf_matrix = tfidf.transform(term_freq_matrix)
print('Shape of term frequency/inverse document frequency matrix',\
    str(tfidf_matrix.shape))

# for input to subsequent analyses we need to choose
# either the standard terms x documents frequency matrix
# or the term frequency/inverse document frequency matrix
# we choose the latter with 200 words   
            
# ------------------------------
# Multidimensional Scaling
# ------------------------------ 
# dissimilarity measures and multidimensional scaling
# consider alternative pairwise distance metrics from sklearn modules
# euclidean_distances, cosine_distances, manhattan_distances (city-block)
# note that different metrics provide different solutions
POTUS_distance_matrix = euclidean_distances(tfidf_matrix)
# POTUS_distance_matrix = manhattan_distances(tfidf_matrix)
#POTUS_distance_matrix = cosine_distances(tfidf_matrix)    
    
mds_method = manifold.MDS(n_components = 2, random_state = 9999,\
    dissimilarity = 'precomputed')
mds_fit = mds_method.fit(POTUS_distance_matrix)  
mds_coordinates = mds_method.fit_transform(POTUS_distance_matrix) 

# plot mds solution in two dimensions using party labels
# defined by multidimensional scaling
plt.figure()
plt.scatter(mds_coordinates[:,0],mds_coordinates[:,1],\
    facecolors = 'none', edgecolors = 'none')  # points in white (invisible)
labels = party_label
for label, x, y in zip(labels, mds_coordinates[:,0], mds_coordinates[:,1]):
    plt.annotate(label, (x,y), xycoords = 'data')
plt.xlabel('First Dimension')
plt.ylabel('Second Dimension')    
plt.show()
plt.savefig('fig_text_mds_POTUS_party.pdf', 
    bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
    orientation='landscape', papertype=None, format=None, 
    transparent=True, pad_inches=0.25, frameon=None)          
    
# plot mds solution in two dimensions using President names as labels
# defined by multidimensional scaling
plt.figure()
plt.scatter(mds_coordinates[:,0],mds_coordinates[:,1],\
    facecolors = 'none', edgecolors = 'none')  # points in white (invisible)
labels = pres_label
for label, x, y in zip(labels, mds_coordinates[:,0], mds_coordinates[:,1]):
    plt.annotate(label, (x,y), xycoords = 'data')
plt.xlabel('First Dimension')
plt.ylabel('Second Dimension')    
plt.show()
plt.savefig('fig_text_mds_POTUS_pres.pdf', 
    bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
    orientation='landscape', papertype=None, format=None, 
    transparent=True, pad_inches=0.25, frameon=None)              
    
# plot mds solution in two dimensions using years as labels
# defined by multidimensional scaling
plt.figure()
plt.scatter(mds_coordinates[:,0],mds_coordinates[:,1],\
    facecolors = 'none', edgecolors = 'none')  # points in white (invisible)
labels = year_label
for label, x, y in zip(labels, mds_coordinates[:,0], mds_coordinates[:,1]):
    plt.annotate(label, (x,y), xycoords = 'data')
plt.xlabel('First Dimension')
plt.ylabel('Second Dimension')    
plt.show()
plt.savefig('fig_text_mds_POTUS_year.pdf', 
    bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
    orientation='landscape', papertype=None, format=None, 
    transparent=True, pad_inches=0.25, frameon=None)                  
    
# ------------------------------
# Cluster Analysis
# ------------------------------   
# investigate alternative numbers of clusters using silhouette score
silhouette_value = []
k = range(2,10)
for i in k:
    kmeans_model = KMeans(n_clusters = i, random_state = 9999).\
        fit(np.transpose(tfidf_matrix))
    labels = kmeans_model.labels_
    silhouette_value.append(silhouette_score(np.transpose(tfidf_matrix),\
        labels, metric = 'euclidean'))          
# highest silhouette score is for two clusters                            
                                                                                                                
# classification of words into groups for further analysis
# use transpose of the terms-by-document matrix and cluster analysis
# try two clusters/groups of words
clustering_method = KMeans(n_clusters = 2, random_state = 9999) 
clustering_solution = clustering_method.fit(np.transpose(tfidf_matrix))
cluster_membership = clustering_method.predict(np.transpose(tfidf_matrix))
word_distance_to_center = clustering_method.transform(np.transpose(tfidf_matrix))

# top words data frame for reporting k-means clustering results
top_words_data = {'word': top_200_words, 'cluster': cluster_membership,\
    'dist_to_0': word_distance_to_center[0:,0],\
    'dist_to_1': word_distance_to_center[0:,1]}
distance_name_list = ['dist_to_0','dist_to_1']    
top_words_data_frame = pd.DataFrame(top_words_data)
for cluster in range(2):
    words_in_cluster =\
        top_words_data_frame[top_words_data_frame['cluster'] == cluster] 
    sorted_data_frame =\
        top_words_data_frame.sort_index(by = distance_name_list[cluster],\
        ascending = True)
    print('\n Top Words in Cluster :',cluster,'------------------------------')
    print(sorted_data_frame[:8])  # top 8 words in each cluster

# -----------------------------------------------
# Cluster Analysis Results Suggest Common Themes
# -----------------------------------------------   
    
# Top Words in Cluster : 0 ------------------------------
#     cluster  dist_to_0  dist_to_1       word
#          0   0.150253   0.862167      since#
#          0   0.154762   0.789895       keep
#          0   0.160067   0.862156        far
#          0   0.160653   0.801106        day
#          0   0.168222   0.808046     strong
#          0   0.169240   0.843582    protect
#          0   0.171769   0.777582       high
#          0   0.173527   0.848002  important
    
# Top Words in Cluster : 1 ------------------------------
#     cluster  dist_to_0  dist_to_1     word
#           1   0.602360   0.369731     make
#           1   0.575850   0.425409     time
#           1   0.623849   0.446006     help
#           1   0.727506   0.446941   nation
#           1   0.875372   0.454196    years
#           1   0.645027   0.508289     work
#           1   0.679918   0.508682    every
#           1   0.650285   0.532537  tonight

# a two-cluster solution seems to make sense with words
# toward the center of each cluster fitting together
# let's use pairs of top words from each cluster to name the clusters
# cluster index 0: "Stay Strong"
# cluster index 1: "Help Nation"

# name the clusters in the top words data frame
cluster_to_name = {0:'Stay Strong',1:'Help Nation'}
top_words_data_frame['cluster_name'] =\
    top_words_data_frame['cluster'].map(cluster_to_name)
    
# -----------------------------------------------
# Output Results of MDS and Cluster Analysis
# -----------------------------------------------   
  
# write multidimensional scaling solution to comma-delimited text file
mds_data = {'party': party_label, 'pres': pres_label, 'year': year_label,\
    'first_dimension': list(mds_coordinates[:,0]),\
    'second_dimension': list(mds_coordinates[:,1])} 
mds_data_frame = pd.DataFrame(mds_data)
mds_data_frame.to_csv('POTUS_mds.csv')  

# write cluster analysis solution to comma-delimited text file
top_words_data_frame.to_csv('POTUS_top_words_clustering.csv')      

# -----------------------------------------------
# Create Aggregate Text Files for Presidents
# -----------------------------------------------   
# aggregate State of the Union addresses for each of  
# ten presidents formed by simple concatenation
# working from the WORK_POTUS directory of parsed text

Kennedy = ''  # initialize aggregate text string
Johnson = ''
Nixon = ''
Ford = ''
Carter = ''
Reagan = ''
BushG = ''
Clinton = ''
BushGW = ''
Obama = ''

for input_file_name in POTUS_file_names:
    # read in file
    this_file_name = input_file_name
    with open('WORK_POTUS/' + this_file_name, 'rt') as finput:        
        text = finput.read()  # text string
        file_name_less_extension = input_file_name.split('.')[0]
        pres = file_name_less_extension.split('_')[2]  # President
        # append to the appropriate President string with ' ' separator
        if pres == 'Kennedy':
            Kennedy = Kennedy + ' ' + text
        elif pres == 'Johnson':
            Johnson = Johnson + ' ' + text
        elif pres == 'Nixon':
            Nixon = Nixon + ' ' + text
        elif pres == 'Ford':
            Ford = Ford + ' ' + text    
        elif pres == 'Carter':
            Carter = Carter + ' ' + text
        elif pres == 'Reagan':
            Reagan = Reagan + ' ' + text
        elif pres == 'BushG':
            BushG = BushG + ' ' + text
        elif pres == 'Clinton':
            Clinton = Clinton + ' ' + text
        elif pres == 'BushGW':
            BushGW = BushGW + ' ' + text
        elif pres == 'Obama':
            Obama = Obama + ' ' + text    
        else: 
            print('\n\nError in processing file:',this_file_name,'\n\n')
        
# store the strings as text files in a new directory ALL_POTUS
os.mkdir('ALL_POTUS')
with open('ALL_POTUS/Kennedy.txt', 'wt')  as foutput:
    foutput.write(str(Kennedy))
with open('ALL_POTUS/Johnson.txt', 'wt') as foutput:  
    foutput.write(str(Johnson))
with open('ALL_POTUS/Nixon.txt', 'wt') as foutput:  
    foutput.write(str(Nixon))
with open('ALL_POTUS/Ford.txt', 'wt') as foutput:  
    foutput.write(str(Ford))
with open('ALL_POTUS/Carter.txt', 'wt') as foutput:  
    foutput.write(str(Carter))
with open('ALL_POTUS/Reagan.txt', 'wt') as foutput:  
    foutput.write(str(Reagan))
with open('ALL_POTUS/BushG.txt', 'wt') as foutput:  
    foutput.write(str(BushG))
with open('ALL_POTUS/Clinton.txt', 'wt') as foutput:  
    foutput.write(str(Clinton))
with open('ALL_POTUS/BushGW.txt', 'wt') as foutput:  
    foutput.write(str(BushGW))
with open('ALL_POTUS/Obama.txt', 'wt') as foutput:  
    foutput.write(str(Obama))

      

# Suggestions for the student: Use word clusters to define text
# measures that vary across addresses, Presidents, and years.
# Try word stemming prior to the definition of a 
# terms-by-documents matrix. Try longer lists of words 
# for the identified clusters. Try alternative numbers
# of top words or alternative numbers of clusters.
# Repeat the multidimensional scaling and cluster analysis
# using the aggregate text files for the ten Presidents.
# Try other methods for identifying common themes, such as
# latent semantic analysis or latent Dirichlet allocation.
# Repeat the multidimensional scaling and cluster analysis
# using the aggregate text files for the ten Presidents.
