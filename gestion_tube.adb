WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,ada.Directories;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,ada.Directories;


PACKAGE BODY Gestion_Tube IS
   use conteur_stockage;

   FUNCTION Comparer_Date(Date1,Date2 : T_Date) RETURN Boolean IS
      Valide : Boolean :=False;

   BEGIN
      IF Date1.Jour = Date2.Jour AND Date1.Mois = Date2.Mois AND Date1.Annee = Date2.Annee THEN
         Valide := True;
      END IF;
      RETURN Valide;
   END Comparer_Date;


END Gestion_Tube;
