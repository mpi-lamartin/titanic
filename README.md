# Titanic - Prédiction de Survie

## Description du Problème

Le naufrage du Titanic est l'une des catastrophes maritimes les plus célèbres de l'histoire. Le 15 avril 1912, lors de son voyage inaugural, le Titanic a coulé après avoir heurté un iceberg, causant la mort de 1502 des 2224 passagers et membres d'équipage.

L'objectif est de prédire si un passager a survécu, en fonction de ses données personnelles (genre, âge, classe du billet...).

## Structure des Données

### Fichiers

- `data/train.csv` : Données d'entraînement avec les étiquettes de survie (891 passagers)
- `data/test.csv` : Données de test sans étiquettes (418 passagers)

### Description des Variables

Le type `passenger` représentant un passager du Titanic est défini dans `csv_loader.ml` :

type passenger = {
  passenger_id : int;
  survived : int option;  (* None pour les données de test *)
  pclass : int;
  name : string;
  sex : string;
  age : float option;
  sibsp : int;
  parch : int;
  ticket : string;
  fare : float option;
  cabin : string option;
  embarked : string option;
}

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

### Module `csv_loader.ml`

Ce module fournit :
- Le type `passenger` représentant un passager
- Des fonctions `load_train_data : string -> passenger list` et `load_test_data : string -> passenger list` pour permettent de récupérer les données d'entraînements et de test sous forme de listes de passagers.

### Exemple `women_survive.ml`

Un classificateur simple basé sur l'observation historique que "les femmes et les enfants d'abord" était la règle lors de l'évacuation :
- Toutes les femmes sont prédites comme survivantes (1)
- Tous les hommes sont prédits comme non-survivants (0)

Ce modèle simple atteint environ **77%** de précision.

## Compilation et Exécution

Voir le fichier Makefile pour les détails.

### Compilation

```bash
# Avec Make
make build
```

### Exécution

```bash
# Modèle simple (women survive)
make run
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

## Suggestions

- Réfléchir aux attributs à utiliser (certains ne sont peut-être pas utiles). Regarder des statistiques sur les données. Convertir les données en vecteurs (male/female -> 0/1). Standardiser les données. Séparer les données d'entraînements pour tester.
- Algorithme des $k$ plus proches voisins : Pour quel $k$ ? Quelle distance ?
- Algorithme ID3 : à adapter pour utiliser des attributs non-binaires.
- Algorithme des $k$-moyennes et CHA : a priori pas adapté car il s'agit ici de classification supervisé. Mais on peut quand même les appliquer en ignorant l'attribut Survived.   
- Combiner plusieurs algorithmes (en conservant la prédiction majoritaire).
