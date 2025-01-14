WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Gestion_Outils,Ada.Characters.Handling, sequential_io;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Gestion_Outils,Ada.Characters.Handling;

PACKAGE Gestion_Personnel IS
   N : Constant Integer:= 5;
  Type T_Fonction IS (analyste,preleveur);
   S : String(1..10);
   K : Integer;
   TYPE T_Personne IS RECORD
      Identite : T_identite;
      Fonction : T_Fonction;
      Identifiant: integer:=0;
      Nbr_Act_Realiser : Integer:=0;
      Vide : Boolean:=True;
   END RECORD;
   TYPE Conteur IS RECORD
      Num_Tub,Id_Perso:integer :=0;
      Num_Foie,Num_Rein,Num_Coeur,Num_Poumon,Num_Cerveau : Integer :=0;
      Num_Vache,Num_Lapin,Num_Mouton,Num_Porc,Num_Canard : Integer :=0;
      Total_Prelev, Total_Ana : Integer:=0;
      Num_Ech : integer :=1;
   END RECORD;

   TYPE T_Registre IS ARRAY(1..N) OF T_Personne;
   Function Recherche(id : T_identite;index : integer) RETURN Boolean;
   FUNCTION Present(Nom, Prenom : T_Mot) RETURN Integer;
   PROCEDURE Supprimer(tab : in out t_registre;Nom, Prenom : IN T_Mot; A:Integer; Ok: OUT Boolean);
   PROCEDURE Enregistrer_Depart(T:in out t_registre);
   PACKAGE Fichier_Archives IS NEW Sequential_Io(T_Personne);
   PROCEDURE Archiver(Employer : IN OUT T_Registre; nom,prenom:T_mot);
   FUNCTION Cherche_Doublon_Archive(Ident : T_Identite) RETURN Boolean;
   PROCEDURE Check_Archive;
   PACKAGE Archivage_Perso IS NEW Sequential_Io(T_registre);
   PROCEDURE Enregistrer_Nouveau_Membre(Tab : in out T_registre);
   PROCEDURE Stokage_Personnel(Tab:IN OUT T_Registre);
   PROCEDURE Affiche_Analyste;
   PROCEDURE Affiche_Preleveur;
   PROCEDURE Liste_Personnel;
   PROCEDURE Recup_Stockage(Tab: IN OUT T_Registre);
   PACKAGE conteur_stockage IS NEW Sequential_Io(conteur);
   PROCEDURE Recup_Stockage_Count(Count:IN OUT conteur);
   PROCEDURE Stokage_count(count:IN OUT conteur);
   PROCEDURE Meilleur_Preleveur(T : IN OUT T_Registre);
   PROCEDURE Meilleur_Analyste(T : IN OUT T_Registre);

END Gestion_Personnel;




