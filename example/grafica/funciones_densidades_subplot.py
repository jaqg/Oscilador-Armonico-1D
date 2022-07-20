# |------------------------------------|
# | Autor: José Antonio Quiñonero Gris |
# | Fecha de creacion: 11/03/2022      |
# |____________________________________|

# Librerias
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os

plt.style.use('mine')

# --------------
# --- INICIO ---
# --------------

nombre_grafica = os.path.basename(__file__).replace(".py", ".pdf")

fichero_entrada                 = './../data/in-OA1D_example.dat'
fichero_funciones_propias       = './../data/out-funciones_propias.dat'
fichero_densidades_probabilidad = './../data/out-densidades_probabilidad.dat'
fichero_potencial               = './../data/out-potencial.dat'
fichero_energias_propias        = './../data/out-energias_propias.dat'

k, nmax, xmin, xmax, dx = np.loadtxt(fichero_entrada, unpack=True, skiprows=1)
x, phi0, phi1, phi2, phi3, phi4, phi5 = np.loadtxt(fichero_funciones_propias, unpack=True, skiprows=1)
x, dphi0, dphi1, dphi2, dphi3, dphi4, dphi5 = np.loadtxt(fichero_densidades_probabilidad, unpack=True, skiprows=1)
x, V = np.loadtxt(fichero_potencial, unpack=True, skiprows=1)
n, E = np.loadtxt(fichero_energias_propias, unpack=True, skiprows=1)

# -----------------
# --- FUNCIONES ---
# -----------------
# Puntos de corte
def xpc(E,k):
    xpc = np.sqrt(2*E/k)
    return xpc

# ---------------
# --- GRAFICA ---
# ---------------
xmin = -5
xmax = 5
ymin = 0
ymax = 7

fig, axs = plt.subplots(1,2, sharey=True)

for i in range(len(axs)):
    axs[i].plot(x, V, label=r'$V(x)$', color='grey')
    for j in range(len(E)):
        axs[i].hlines(y = E[j], xmin=-xpc(E[j],k), xmax=xpc(E[j],k), color='k', lw=1.0)

axs[0].plot(x, phi0, label=r'$\varphi_0(x)$')
axs[0].plot(x, phi1, label=r'$\varphi_1(x)$')
axs[0].plot(x, phi2, label=r'$\varphi_2(x)$')
axs[0].plot(x, phi3, label=r'$\varphi_3(x)$')
axs[0].plot(x, phi4, label=r'$\varphi_4(x)$')
axs[0].plot(x, phi5, label=r'$\varphi_5(x)$')

axs[1].plot(x, dphi0, label=r'$\left| \varphi_0(x) \right|^2$')
axs[1].plot(x, dphi1, label=r'$\left| \varphi_1(x) \right|^2$')
axs[1].plot(x, dphi2, label=r'$\left| \varphi_2(x) \right|^2$')
axs[1].plot(x, dphi3, label=r'$\left| \varphi_3(x) \right|^2$')
axs[1].plot(x, dphi4, label=r'$\left| \varphi_4(x) \right|^2$')
axs[1].plot(x, dphi5, label=r'$\left| \varphi_5(x) \right|^2$')

transparencia = 0.5
axs[1].fill_between(x, dphi0, E[0], alpha=transparencia)
axs[1].fill_between(x, dphi1, E[1], alpha=transparencia)
axs[1].fill_between(x, dphi2, E[2], alpha=transparencia)
axs[1].fill_between(x, dphi3, E[3], alpha=transparencia)
axs[1].fill_between(x, dphi4, E[4], alpha=transparencia)
axs[1].fill_between(x, dphi5, E[5], alpha=transparencia)

axs[1].text(xmin+xmin/4.5, E[0], '$v=0$', fontsize=12, horizontalalignment='center', verticalalignment='center')
axs[1].text(xmin+xmin/4.5, E[1], '$v=1$', fontsize=12, horizontalalignment='center', verticalalignment='center')
axs[1].text(xmin+xmin/4.5, E[2], '$v=2$', fontsize=12, horizontalalignment='center', verticalalignment='center')
axs[1].text(xmin+xmin/4.5, E[3], '$v=3$', fontsize=12, horizontalalignment='center', verticalalignment='center')
axs[1].text(xmin+xmin/4.5, E[4], '$v=4$', fontsize=12, horizontalalignment='center', verticalalignment='center')
axs[1].text(xmin+xmin/4.5, E[5], '$v=5$', fontsize=12, horizontalalignment='center', verticalalignment='center')

axs[0].set(title=r'$\psi_v(x)$', xlabel=r'$x\ (a_0)$', ylabel=r'$E\ (\mathrm{Ha})$')
axs[1].set(title=r'$\left| \psi_v(x) \right|^2$', xlabel=r'$x\ (a_0)$')

for i in range(len(axs)):
    axs[i].set_xlim(xmin,xmax)
    axs[i].set_ylim(ymin,ymax)

plt.savefig(nombre_grafica, transparent='True', bbox_inches='tight')
