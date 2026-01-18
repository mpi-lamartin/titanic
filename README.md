# Titanic - Prédiction de Survie

## Description du Problème

Le naufrage du Titanic est l'une des catastrophes maritimes les plus célèbres de l'histoire. Le 15 avril 1912, lors de son voyage inaugural, le Titanic a coulé après avoir heurté un iceberg, causant la mort de 1502 des 2224 passagers et membres d'équipage.

L'objectif est de prédire si un passager a survécu, en fonction de ses données personnelles (genre, âge, classe du billet...).

## Structure des Données

### Fichiers

- `data/train.csv` : Données d'entraînement avec les étiquettes de survie (891 passagers)
- `data/test.csv` : Données de test sans étiquettes (418 passagers)

### Description des Variables

| Variable | Description | Type |
|----------|-------------|------|
| `PassengerId` | Identifiant unique du passager | Entier |
| `Survived` | Survie (0 = Non, 1 = Oui) | Entier (uniquement dans train.csv) |
| `Pclass` | Classe du billet (1 = 1ère, 2 = 2ème, 3 = 3ème) | Entier |
| `Name` | Nom du passager | Chaîne |
| `Sex` | Sexe (`male` ou `female`) | Chaîne |
| `Age` | Âge en années | Flottant (peut être manquant) |
| `SibSp` | Nombre de frères/sœurs ou conjoints à bord | Entier |
| `Parch` | Nombre de parents/enfants à bord | Entier |
| `Ticket` | Numéro du billet | Chaîne |
| `Fare` | Prix du billet | Flottant |
| `Cabin` | Numéro de cabine | Chaîne (souvent manquant) |
| `Embarked` | Port d'embarquement (C = Cherbourg, Q = Queenstown, S = Southampton) | Chaîne |

### Notes sur les Variables

- **Pclass** : Un indicateur du statut socio-économique (1 = Haute, 2 = Moyenne, 3 = Basse)
- **Age** : L'âge est fractionnel si inférieur à 1. Si l'âge est estimé, il est sous la forme xx.5
- **SibSp** : Définitions des relations familiales :
  - Frère/Sœur = frère, sœur, demi-frère, demi-sœur
  - Conjoint = mari, femme (maîtresses et fiancés ignorés)
- **Parch** : Définitions des relations familiales :
  - Parent = mère, père
  - Enfant = fille, fils, belle-fille, beau-fils
  - Certains enfants voyageaient uniquement avec une nourrice, donc Parch=0 pour eux

## Structure du Code OCaml

```
src/
├── csv_loader.ml    # Module de chargement des données CSV
├── women_survive.ml # Exemple de classification simple
└── id3.ml           # Algorithme ID3 (arbre de décision)
```

### Module `csv_loader.ml`

Ce module fournit :
- Le type `passenger` représentant un passager
- Des fonctions pour parser les fichiers CSV
- Des fonctions utilitaires (filtrage, statistiques)

### Exemple `women_survive.ml`

Un classificateur simple basé sur l'observation historique que "les femmes et les enfants d'abord" était la règle lors de l'évacuation :
- Toutes les femmes sont prédites comme survivantes (1)
- Tous les hommes sont prédits comme non-survivants (0)

Ce modèle simple atteint environ **78.68%** de précision sur les données d'entraînement.

### Algorithme `id3.ml`

Implémentation de l'algorithme **ID3** (Iterative Dichotomiser 3) pour construire un arbre de décision :

**Principe :**
1. Calculer l'**entropie** de l'ensemble de données
2. Pour chaque attribut, calculer le **gain d'information** (réduction d'entropie)
3. Sélectionner l'attribut avec le meilleur gain d'information
4. Créer un nœud de décision et partitionner les données
5. Répéter récursivement jusqu'aux conditions d'arrêt

**Attributs utilisés :**
- `Sex` : sexe du passager
- `Pclass` : classe du billet (1, 2 ou 3)
- `AgeGroup` : groupe d'âge (child, young, adult, senior, unknown)
- `FamilySize` : taille de la famille (alone, small, large)
- `Embarked` : port d'embarquement (C, Q, S)
- `FareGroup` : groupe tarifaire (low, medium, high, very_high)

**Formules mathématiques :**

L'entropie mesure l'impureté d'un ensemble :
$$H(S) = -\sum_{c \in \{0,1\}} p_c \log_2(p_c)$$

Le gain d'information pour un attribut $A$ :
$$IG(S, A) = H(S) - \sum_{v \in \text{valeurs}(A)} \frac{|S_v|}{|S|} H(S_v)$$

## Compilation et Exécution

### Compilation

```bash
# Avec Dune
dune build

# Ou avec Make
make build
```

### Exécution

```bash
# Modèle simple (women survive)
dune exec src/women_survive.exe
# ou
make run

# Algorithme ID3
dune exec src/id3.exe
# ou
make id3
```

## Format de Soumission

Il faut soumettre sur Kaggle un fichier `submission.csv` qui doit contenir exactement les prévisions pour les 418 entrées du fichier test.csv, plus une ligne d'en-tête :

```csv
PassengerId,Survived
892,0
893,1
894,0
...
```

