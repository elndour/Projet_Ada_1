WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils;


PACKAGE BODY Gestion_Analyse IS

 -- Vérification de la validité de l'analyste

   FUNCTION Est_Analyste_Valide(Identifiant : T_identite; T: T_Registre) RETURN integer IS
    valeur:integer:=-1;
   BEGIN
      FOR i in T_Registre'RANGE LOOP
         IF T(i).Identite = Identifiant AND T(I).Fonction = Analyste THEN
            valeur:= T(i).Identifiant;
         END IF;
      END LOOP;
      return valeur;

   END Est_Analyste_Valide;

END Gestion_Analyse;