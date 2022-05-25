from matplotlib.pyplot import axes    # (at top of module)
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

datos = pd.read_csv('discografia.csv')
verano = datos[datos['Album'] == 'Un Verano Sin Ti']
tour = datos[datos['Album'] == 'EL ULTIMO TOUR DEL MUNDO']
salir = datos[datos['Album'] == 'LAS QUE NO IBAN A SALIR']
hago = datos[datos['Album'] == 'YHLQMDLG']
pre = datos[datos['Album'] == 'X 100PRE']
oasis = datos[datos['Album'] == 'OASIS']


plt.rcParams["figure.autolayout"] = True
fig = plt.figure(figsize =(10, 7))
 
# Creating plot
data = pd.DataFrame({"Un verano sin ti":verano['Tempo'], "El ultimo tour del mundo":tour['Tempo'], "Las que no iban a salir":salir['Tempo'], "YHLQMDLG":hago['Tempo'], "X 100PRE":pre['Tempo'], "OASIS":oasis['Tempo']})
ax = data[['Un verano sin ti', 'El ultimo tour del mundo', 'Las que no iban a salir', 'YHLQMDLG', 'OASIS', 'X 100PRE']].plot(kind='box')
plt.title('Análisis del tempo de los álbumes')
plt.ylabel('Tempo')
 
# show plot
plt.show()