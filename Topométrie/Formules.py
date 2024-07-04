# Formules de topométrie pour le partiel et autres occasions
# POURNY Bruce ING1 - ENSG
# Dernière édition le mercredi 20 mars 2024.

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
    Retourne le gisement (en grades). Présence d'un arrondi, à défaut 
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

def extraction_lols(L:list,n:int=0):
    """
    Crée une liste des n-ièmes éléments d'une sous-liste.

    Exemple
    -------
    extraction_lols( [(1,2),(3,4)] ,1) => [2,4]

    Paramètres
    -------
    L (list of lists) : une liste de listes.
    n : le n-ième élément à extraire de chaque sous-liste

    Sortie
    -------
    Retourne la liste des éléments de sous-liste.
    """
    return [elmt[n] for elmt in L]

def g0_moyen(liste:list,arr:int=4):
    """
    Calcule le G0 moyen à partir de différents G0 calculés.

    Paramètres
    -------
    liste (list of lists) : liste de listes du couple (distance, gisement) pour chaque G0 calculé.
    arr (int) : arrondi du gisement en sortie. Par défaut : 4.

    Sortie
    -------
    Retourne le G0 moyen.
    """
    liste = extraction_lols(liste,1)
    n = len(liste)
    return round(sum(liste)/n,arr)

def g0_pond(liste:list,arr:int=4):
    """
    Calcule le G0 moyen à partir de différents G0 calculés, en pondérant par la distance aux points de mesure.

    Paramètres
    -------
    liste (list of lists) : liste de listes du couple (distance, G0) pour chaque G0 calculé. (NB : chaque sous-liste peut contenir d'autres éléments après les deux premiers, ils seront ignorés par l'algorithme).
    arr (int) : arrondi du gisement en sortie. Par défaut : 4.

    Sortie
    -------
    Retourne le G0 pondéré.
    """
    liste_distances = extraction_lols(liste,0)
    n = len(liste_distances)
    G0_pond = 0
    for pt in range(n):
        G0_pond += liste[pt][0]*liste[pt][1]
    return round(G0_pond/sum(liste_distances),arr)

def g0_en_input(X_A:float,Y_A:float,type:str='pond',arr:int=4):
    """
    Permet de calculer le G0 moyen/pondéré d'une station à partir de plusieurs points, dont les coordonnées sont saisies en input.

    A chaque boucle, on demande à l'utilisateur le tuple (X_M, Y_M, lecture pt M) et on renvoie le tuple (distance station->point, G0, gisement).
    On peut arrêter lors des inputs avec 'STOP'.
    A la fin, on retourne le G0 moyen/pondéré et la liste des points si besoin. 

    Paramètres
    -------
    X_A, Y_A (float) : coordonnées du point A.
    type (str) : type de G0 obtenu. 'moyen' pour un G0 moyen, 'pond' pour un G0 pondéré. Par défaut 'pond'
    arr (int) : arrondi du gisement en sortie. Par défaut : 4.
    """

    X_M,Y_M,L_AM = 0,0,0
    liste_points = []
    while X_M != 'STOP' or Y_M != 'STOP' or  L_AM != 'STOP':
        X_M = input()
        if X_M == 'STOP':
            break
        Y_M = input()
        if Y_M == 'STOP':
            break
        L_AM = input()
        if L_AM == 'STOP':
            break

        D_AM = distance(X_A,Y_A,float(X_M),float(Y_M))
        G_AM = gisement(X_A,Y_A,float(X_M),float(Y_M))
        G0_M = G_AM[1] - float(L_AM)

        liste_points.append((D_AM,G0_M,G_AM))
        print(round(D_AM,arr),round(G0_M,arr),round(G_AM[1],arr))
    
    if type == 'pond':
        G0_final = g0_pond(liste_points,arr)
    if type == 'moyen':
        G0_final = g0_moyen(liste_points,arr)
        
    return G0_final, liste_points
