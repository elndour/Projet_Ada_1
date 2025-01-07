WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse;

PACKAGE Gestion_tube IS

  type T_lieu is (refrigerateur,congelateur);

   Type T_endroit is RECORD
       Lieu:T_lieu;
       Numero:integer;
       rempli:boolean;
   END RECORD;

  TYPE T_tube IS RECORD
     Numero_tube : integer;
     Endroit:T_endroit ;
     Analyser : boolean:=false ;
     detruit:boolean:=false;
     Analyse:T_Analyse;

  END RECORD;

  FUNCTION Comparer_Date(Date1,Date2 : T_Date) RETURN Boolean;

END Gestion_tube;