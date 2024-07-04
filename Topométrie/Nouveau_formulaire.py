# Nouvelles formules de topométrie
# POURNY Bruce ING1 - ENSG
# Dernière édition le jeudi 4 juillet 2024

import math

def distance(X_A:float,Y_A:float,X_M:float,Y_M:float):
    """
    Renvoie la distance euclidienne entre un point A et un point M.

    Paramètres
    -------
    X_M, Y_M (float) : coordonnées du point M.
    X_A, Y_A (float) : coordonnées du point A.

    """
    return math.sqrt((X_M-X_A)**2 + (Y_M-Y_A)**2)

def gisement(X_A:float,Y_A:float,X_M:float,Y_M:float,arr:int=4):
    """
    Calcule le gisement de la droite d'ordonnée vers la droite (AM).

    Paramètres
    -------
    X_A, Y_A (float) : coordonnées du point A.
    X_M, Y_M (float) : coordonnées du point M.
    arr (int) : arrondi des gisement et distance. Par défaut : 4.

    D'abord, saisir le point A, puis le point M.

    Sortie
    -------
    Retourne le gisement (en grades). Présence d'un arrondi.
    """
    dist = distance(X_M,Y_M,X_A,Y_A)
    intermediaire = (X_M-X_A)/(dist + Y_M - Y_A)
    gisement = (2*math.atan(intermediaire) * 200/math.pi) % 400
    return round(dist,arr), round(gisement,arr)

def rayonnement(G_AM:float,D_AM:float,X_A:float,Y_A:float,arr:int=4):
    """
    Calcule les coordonnées rayonnées du point M à partir d'un point A.

    Paramètres
    -------
    G_AM (float) : gisement AM (en grades).
    D_AM (float) : distance entre A et M.
    X_A, Y_A (float) : coordonnées du point A.
    arr (int) : arrondi des coordonnées en sortie. Par défaut : 4.

    Sortie
    -------
    Retourne le tuple de coordonnées (X_M, Y_M).
    """
    G_AM = G_AM*math.pi/200
    X_M = X_A + D_AM * math.sin(G_AM)
    Y_M = Y_A + D_AM * math.cos(G_AM)
    return round(X_M,arr), round(Y_M,arr)

def stdev_2_gis(liste:list,result:float,arr:int=4):
    stdev = 0
    for item in liste:
        stdev += (item - result)**2
    return round(stdev/(len(liste)-1),arr)


def g0_moyen(liste:list,arr:int=4):
    """
    Calcule le G0 moyen à partir de différents G0 calculés, et son écart-type.

    Paramètres
    -------
    liste (list) : liste des gisements.
    liste_dist (list) : liste des distances.
    arr (int) : arrondi du gisement en sortie. Par défaut : 4.

    Sortie
    -------
    Retourne le G0 moyen.
    """
    n = len(liste)
    g0 = round(sum(liste)/n,arr)
    print(g0, stdev_2_gis(liste, g0))
    return g0, stdev_2_gis(liste, g0)

def g0_pond(liste_gis:list,liste_dist,arr:int=4):
    """
    Calcule le G0 moyen à partir de différents G0 calculés, en pondérant par la distance aux points de mesure.

    Paramètres
    -------
    liste_gis (list) : liste des gisements.
    liste_dist (list) : liste des distances.
    arr (int) : arrondi du gisement en sortie. Par défaut : 4.

    Sortie
    -------
    Retourne le G0 pondéré.
    """
    n = len(liste_gis)
    G0_pond = 0
    for pt in range(n):
        G0_pond += liste_gis[pt]*liste_dist[pt][1]
    G0_pond = round(G0_pond/sum(liste_dist),arr)
    print(G0_pond, stdev_2_gis(liste_gis, G0_pond))
    return G0_pond, stdev_2_gis(liste_gis, G0_pond)



