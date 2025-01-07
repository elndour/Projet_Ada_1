WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

PACKAGE Gestion_Outils IS

   subtype T_mot is string(1..20);
   TYPE T_identite IS RECORD
      Nom,Prenom: T_mot := (others => ' ');
   END RECORD;

END Gestion_Outils;




