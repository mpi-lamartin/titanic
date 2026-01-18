(** Module pour charger les données CSV du Titanic *)

(** Type représentant un passager du Titanic *)
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

(** Affiche les informations d'un passager *)
let print_passenger p =
  Printf.printf "PassengerId: %d, Name: %s, Sex: %s, Survived: %s\n"
    p.passenger_id
    p.name
    p.sex
    (match p.survived with Some s -> string_of_int s | None -> "?")

(** Parse une valeur optionnelle flottante *)
let parse_float_opt s =
  if String.trim s = "" then None
  else try Some (float_of_string s) with _ -> None

(** Parse une valeur optionnelle entière *)
let parse_int_opt s =
  if String.trim s = "" then None
  else try Some (int_of_string s) with _ -> None

(** Parse une valeur optionnelle string *)
let parse_string_opt s =
  let trimmed = String.trim s in
  if trimmed = "" then None else Some trimmed

(** Sépare une ligne CSV en tenant compte des guillemets *)
let split_csv_line line =
  let len = String.length line in
  let rec aux i current fields in_quotes =
    if i >= len then
      List.rev (current :: fields)
    else
      let c = line.[i] in
      if c = '"' then
        aux (i + 1) current fields (not in_quotes)
      else if c = ',' && not in_quotes then
        aux (i + 1) "" (current :: fields) false
      else
        aux (i + 1) (current ^ String.make 1 c) fields in_quotes
  in
  aux 0 "" [] false

(** Parse une ligne du fichier train.csv *)
let parse_train_line line =
  let fields = split_csv_line line in
  match fields with
  | [pid; surv; pcl; name; sex; age; sibsp; parch; ticket; fare; cabin; embarked] ->
    Some {
      passenger_id = int_of_string pid;
      survived = parse_int_opt surv;
      pclass = int_of_string pcl;
      name = name;
      sex = sex;
      age = parse_float_opt age;
      sibsp = int_of_string sibsp;
      parch = int_of_string parch;
      ticket = ticket;
      fare = parse_float_opt fare;
      cabin = parse_string_opt cabin;
      embarked = parse_string_opt embarked;
    }
  | _ -> None

(** Parse une ligne du fichier test.csv (sans colonne Survived) *)
let parse_test_line line =
  let fields = split_csv_line line in
  match fields with
  | [pid; pcl; name; sex; age; sibsp; parch; ticket; fare; cabin; embarked] ->
    Some {
      passenger_id = int_of_string pid;
      survived = None;
      pclass = int_of_string pcl;
      name = name;
      sex = sex;
      age = parse_float_opt age;
      sibsp = int_of_string sibsp;
      parch = int_of_string parch;
      ticket = ticket;
      fare = parse_float_opt fare;
      cabin = parse_string_opt cabin;
      embarked = parse_string_opt embarked;
    }
  | _ -> None

(** Lit un fichier et retourne une liste de lignes *)
let read_lines filename =
  let ic = open_in filename in
  let rec aux acc =
    try
      let line = input_line ic in
      aux (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  aux []

(** Charge les données d'entraînement depuis train.csv *)
let load_train_data filename =
  let lines = read_lines filename in
  match lines with
  | [] -> []
  | _ :: data_lines ->  (* Ignore l'en-tête *)
    List.filter_map parse_train_line data_lines

(** Charge les données de test depuis test.csv *)
let load_test_data filename =
  let lines = read_lines filename in
  match lines with
  | [] -> []
  | _ :: data_lines ->  (* Ignore l'en-tête *)
    List.filter_map parse_test_line data_lines
