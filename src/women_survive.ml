(** Classification Titanic : toutes les femmes survivent *)

open Csv_loader

let predict p = if p.sex = "female" then 1 else 0

let accuracy data =
  let correct = List.filter (fun p -> p.survived = Some (predict p)) data in
  float_of_int (List.length correct) /. float_of_int (List.length data)

let generate_submission data filename =
  let oc = open_out filename in
  Printf.fprintf oc "PassengerId,Survived\n";
  List.iter (fun p -> Printf.fprintf oc "%d,%d\n" p.passenger_id (predict p)) data;
  close_out oc

let () =
  let train = load_train_data "data/train.csv" in
  let test = load_test_data "data/test.csv" in
  Printf.printf "Train: %d, Test: %d\n" (List.length train) (List.length test);
  Printf.printf "Précision (train): %.2f%%\n" (accuracy train *. 100.0);
  generate_submission test "submission.csv";
  Printf.printf "Soumission générée: submission.csv\n"
