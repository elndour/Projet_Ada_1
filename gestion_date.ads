WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;


PACKAGE Gestion_Date IS

    NBJR:integer:=3;
    NBJC:integer:=5;

   SUBTYPE T_Mois IS Integer RANGE 1..12 ;
   SUBTYPE T_Jour IS Integer RANGE 1..31 ;

TYPE T_Date IS RECORD

   Jour : T_Jour ;
   Mois : T_Mois ;
   Annee :Positive ;

END RECORD;

FUNCTION Est_Bissextile(Annee : Positive) RETURN Boolean;
FUNCTION date_Valide(Date : T_Date) RETURN Boolean;
PROCEDURE saisir_DATE (date: out T_date);
PROCEDURE Afficher_Date(Date : T_Date);
PROCEDURE passer_lendemain(Date : in out T_Date);
PROCEDURE Date_destruction_R(Date : in out T_Date);
PROCEDURE Date_destruction_C(Date : in out T_Date);

END Gestion_Date;







