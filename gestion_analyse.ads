WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils;

PACKAGE Gestion_Analyse IS

  Type T_resultat is (positif,negatif,non_concluant) ;
  
   TYPE T_Analyse IS RECORD
      Identifiant_analyste:integer;
      Identite_Analyste : T_identite;
      Date_Analyse : T_Date;
      Resultat : T_resultat ;
   END RECORD;

   FUNCTION Est_Analyste_Valide(Identifiant : T_identite; T: T_Registre) RETURN integer;

END Gestion_Analyse;