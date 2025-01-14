WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_Outils, gestion_Personnel,Ada.Characters.Handling,Gestion_Date,gestion_tube,gestion_echantillon,Ada.Characters.Handling;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_Outils,gestion_Personnel,Ada.Characters.Handling,Gestion_Date,gestion_tube,gestion_echantillon,Ada.Characters.Handling;

PROCEDURE Principale IS

   Tab : T_Registre;
   C : Character;
   Date_du_jour : T_Date;
   Tube : T_Tube;
   Registre_Prelevement:T_registre_Prelevement;
   Nbr_Ech_Att: Integer:=0;
   Int : Integer;
   Co : Conteur;
   Refri:T_Refrigerateur;
   congel:t_congelateur;
BEGIN
   Date_Du_Jour.Jour := 19;
   Date_Du_Jour.mois := 12;
   Date_Du_Jour.annee:= 2024;
   Put("La date du jour est: ");Afficher_Date(Date_du_jour); new_line;
   Loop
      new_line;put("**********************************************************************************************");new_line;
      Put_Line("A-Enregistrer un nouveau membre du personnel");
      Put_Line("B-Enregistrer le depart d'un membre du personnel");
      Put_Line("C-Enregistrer un nouveau prelevement");
      Put_Line("D-Enregistrer une nouvelle analyse");
      Put_Line("Visualisez:");
      Put_Line("E-La liste du personnel actuel");
      Put_Line("F-La liste des anciens personnels");
      Put_Line("G-La liste des preleveur");
      Put_Line("H-La liste des analyste");
      Put_Line("I-La liste des echantillons:");
      Put_Line("J-Visualiser une echantillon :Version nombre de tube");
      Put_Line("K-Visualiser une echantillon :Version complete");
      Put_Line("L-Identite du (des) meilleurs preleveurs");
      Put_Line("M-Identite du (des) meilleurs analystes");
      Put_Line("N-Nombre de prelevement par type organe");
      Put_Line("O-Nombre de prelevement par type d'animaux");
      Put_Line("P-Le nombre totale de prelevement");
      Put_Line("Q-Le nombre totale d'Analyse");
      Put_Line("R-La liste des echantillons archiver");
      Put_Line("S-La liste des echantillon pour lesquels aucune analyse n'a ete realise");
      Put_Line("T-La liste des echantillon en attente sur un type animal donne:");
      Put_Line("U-La liste des echantillons archives pour lesquels les analyses ont ete majoritairement negatives");
      put_line("Z-Passer au lendemain");
      Put_line("X-Pour Quitter");
      Get(C); Skip_Line;
      C:=To_Upper(C);
      Recup_Stockage(Tab);
      Recup_Stockage_Ech(Registre_Prelevement);
      Recup_Stockage_count(co);
      CASE C IS
         WHEN 'A' =>
            Enregistrer_Nouveau_Membre(tab);
         WHEN 'B' =>
            Enregistrer_Depart(tab);
         WHEN 'C' =>
            Enregistrer_Tableau_Echantillons(Registre_Prelevement,tab,nbr_ech_att,Date_du_jour);
         WHEN 'D' =>
            Enregistrer_Analyse(Registre_Prelevement, Tab,Date_du_jour);
         WHEN 'E' =>
            Liste_Personnel;
         WHEN 'F' =>
            Check_Archive;
         WHEN 'G' =>
            Affiche_Preleveur;
         WHEN 'H'  =>
            Affiche_Analyste;
         WHEN 'I'  =>
            Affich_Echantillon(Registre_Prelevement);
         WHEN 'J' =>
            Affiche_Echantillon_V1(Registre_Prelevement,Int);
         WHEN 'K' =>
            Affiche_Echantillon_V2(Registre_Prelevement);
         WHEN 'L' =>
            Meilleur_Preleveur(Tab);
         WHEN 'M' =>
            Meilleur_Analyste(Tab);
         WHEN 'N' =>
            Nbr_Prelev_Organe(co);
         WHEN 'O' =>
            Nbr_Prelev_Animaux(co);
         WHEN 'P' =>
            Nbr_Total_Prelev(Co);
         WHEN 'Q' =>
            Nbr_Total_Analyse(Co);
         WHEN 'R' =>
            Check_Archive_Ech;
         WHEN 'S' =>
            Ech_Sans_Analyse (Registre_Prelevement);
         WHEN 'T' =>
            Ana_Par_Animal (Registre_Prelevement);
         WHEN 'U' =>
            Archive_maj_negatif;
         WHEN 'Z' =>
            Passer_Lendemain(Date_Du_Jour);
            Afficher_Date(Date_Du_Jour);new_line;
            Verifier_Et_Detruire_Echantillons(Registre_Prelevement,Date_Du_Jour);
            incremente_Palce(Registre_Prelevement,refri,congel);new_line;
         WHEN OTHERS => NULL;
      END CASE;
      Stokage_Personnel(Tab);
      Stokage_Echantillon(Registre_Prelevement);
      --stokage_count(a);
      --Recup_Stockage(tab);
      EXIT WHEN C ='X';
   END LOOP;


END;