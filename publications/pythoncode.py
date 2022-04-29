# -*- coding: utf-8 -*-
"""PythonCode.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1TlrWdtuXJEgL8F6MycTD0okHBltCmXA_
"""


from pymongo import MongoClient
import pprint
import networkx as nx
import pandas as pd
from matplotlib.pyplot import figure
import matplotlib.pyplot as plt
from bokeh.plotting import figure, show, output_file
from bokeh.models import HoverTool, ColumnDataSource
from bokeh.tile_providers import get_provider, Vendors

db_uri = "mongodb+srv://etudiant:ur2@clusterm1.0rm7t.mongodb.net/"
client = MongoClient(db_uri)
db = client["publications"]

print(db.list_collection_names())

coll = db["hal_irisa_2021"]
query = coll.aggregate([{"$unwind" : "$authors"},
         {"$group" : {"_id" : {"Name" :"$authors.name", "First_Name" : "$authors.firstname"}, "nombres_publications" : {"$sum" : 1}}},
         {"$sort" : {"nombres_publications": -1}},
         {"$limit": 20}])

second_query = coll.aggregate([{"$unwind" : "$authors"},
         {"$group" : {"_id" : {"Name" :"$authors.name", "First_Name" : "$authors.firstname", "Titre" : "$title"}}}])

list_nom = []
list_prnom = []
liste_nbpublication = []
liste_titre = []
for author in query:
   list_nom.append(author['_id']["Name"])
   list_prnom.append(author['_id']["First_Name"])
   liste_nbpublication.append(author["nombres_publications"])

df = pd.DataFrame(liste_nbpublication)
df['Nom'] = list_nom
df['Prenom'] = list_prnom
df.columns = ['Nb_Publications', 'Nom', 'Prenom']

list_nom_merge = []
list_pnom_merge = []
list_publi_merge = []

for author in second_query:
  if author['_id']["Name"] in list_nom:
    if author['_id']["First_Name"] in list_prnom:
          list_nom_merge.append(author['_id']["Name"])
          list_pnom_merge.append(author['_id']["First_Name"])
          list_publi_merge.append(author['_id']["Titre"])

df2 = pd.DataFrame(list_publi_merge)
df2['Nom'] = list_nom_merge
df2['Prenom'] = list_pnom_merge
df2.columns = ['Publications', 'Nom', 'Prenom']

df_author_publi = pd.merge(df, df2, on='Prenom')
df_author_publi.pop("Nom_y")
df_author_publi.columns = ['Nb_Publications', 'Nom', 'Prenom', 'Publications']
print(df_author_publi)

nom_unique = df_author_publi["Nom"].unique()
#print(nom_unique)

G = nx.Graph()

G = nx.from_pandas_edgelist(df_author_publi, 'Nom', 'Nb_Publications')
plt.figure(figsize=(10, 8))
nx.draw_shell(G, with_labels=True)

Lefèvre = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Lefèvre':
    #print(row['Publications'])
    Lefèvre.append(row['Publications'])

Pacchierotti = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Pacchierotti':
    #print(row['Publications'])
    Pacchierotti.append(row['Publications'])

Pontonnier = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Pontonnier':
    #print(row['Publications'])
    Pontonnier.append(row['Publications'])

Jézéquel = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Jézéquel':
    #print(row['Publications'])
    Jézéquel.append(row['Publications'])

Guillemot = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Guillemot':
    #print(row['Publications'])
    Guillemot.append(row['Publications'])


Fromont = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Fromont':
    #print(row['Publications'])
    Fromont.append(row['Publications'])

Lécuyer = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Lécuyer':
    #print(row['Publications'])
    Lécuyer.append(row['Publications'])


Busnel = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Busnel':
    #print(row['Publications'])
    Busnel.append(row['Publications'])

Giordano = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Giordano':
    #print(row['Publications'])
    Giordano.append(row['Publications'])


Pettré = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Pettré':
    #print(row['Publications'])
    Pettré.append(row['Publications'])

Ferré = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Ferré':
    #print(row['Publications'])
    Ferré.append(row['Publications'])


Legeai = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Legeai':
    #print(row['Publications'])
    Legeai.append(row['Publications'])


Olivier = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Olivier':
    #print(row['Publications'])
    Olivier.append(row['Publications'])


Bannier = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Bannier':
    #print(row['Publications'])
    Bannier.append(row['Publications'])


Dumont = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Dumont':
    #print(row['Publications'])
    Dumont.append(row['Publications'])


Maumet = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Maumet':
    #print(row['Publications'])
    Maumet.append(row['Publications'])

Rubino = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Rubino':
    #print(row['Publications'])
    Rubino.append(row['Publications'])


Martin = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Martin':
    #print(row['Publications'])
    Martin.append(row['Publications'])


Gribonval = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Gribonval':
    #print(row['Publications'])
    Gribonval.append(row['Publications'])

Combemale = []
for index, row in df_author_publi.iterrows():
  if row['Nom'] == 'Combemale':
    #print(row['Publications'])
    Combemale.append(row['Publications'])


def common_elements(list1, list2):
    result = []
    for element in list1:
      for elem in list2:
        if element == elem:
            result.append(element)
    return result

######### Cas pour Lefèvre et répété pour chaque auteur #############
print('*'*75)
if print(len(common_elements(Combemale, Lefèvre))) != 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Lefèvre_Sébastien')
print('*'*75)
if print(len(common_elements(Combemale, Pacchierotti))) != 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Pacchierotti_Claudio')
print('*'*75)
if print(len(common_elements(Combemale, Pontonnier)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Pontonnier_Charles')
print('*'*75)
if print(len(common_elements(Combemale, Jézéquel)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Jézéquel_Jean_Marc')
print('*'*75)
if print(len(common_elements(Combemale, Busnel)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Busnel_Yann')   
print('*'*75)
if print(len(common_elements(Combemale, Lécuyer)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Lécuyer_Anatole')
print('*'*75)
if print(len(common_elements(Combemale, Guillemot)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Guillemot_Christine')
print('*'*75)
if print(len(common_elements(Combemale, Fromont)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Fromont_Elisa')
print('*'*75)
if print(len(common_elements(Combemale, Olivier)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Olivier_Anne_Hélène')
print('*'*75)
if print(len(common_elements(Combemale, Giordano)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Giordano_PaoloRobuffo')
print('*'*75)
if print(len(common_elements(Combemale, Legeai)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Legeai_Fabrice')
print('*'*75)
if print(len(common_elements(Combemale, Maumet)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Maumet_Camille')
print('*'*75)
if print(len(common_elements(Combemale, Bannier)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Bannier_Elise')
print('*'*75)
if print(len(common_elements(Combemale, Pettré)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Pettré_Julien')
print('*'*75)
if print(len(common_elements(Combemale, Dumont)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Dumont_Georges')
print('*'*75)
if print(len(common_elements(Combemale, Ferré)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Ferré_Jean_Christophe')
print('*'*75)
if print(len(common_elements(Combemale, Martin)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Martin_Arnaud')
print('*'*75)
if print(len(common_elements(Combemale, Rubino)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Rubino_Gerardo')
print('*'*75)
if print(len(common_elements(Combemale, Gribonval)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Siegel_Anne')
print('*'*75)
if print(len(common_elements(Combemale, Combemale)))!= 0:
  with open('author.txt', 'w') as f:
    f.write('Lefèvre_Sébastien Combemale_Benoit')

g3 = nx.read_edgelist("data/authors.txt", create_using=nx.DiGraph)

node_color = []
pr = nx.pagerank(g3)
    
for node in pr.values():
    if node < 0.014557806498951585 :
            node_color.append('green')
    elif node == 0.09704593558042568:
            node_color.append('red')
    else :
            node_color.append('yellow')
        
plt.figure(figsize=[15,15])
nx.draw_networkx(g3, arrows=True, \
                     node_size=[v*30000 for v in pr.values()], \
                     with_labels=True, node_color = node_color)
plt.show()