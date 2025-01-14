WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Gestion_Outils,ada.Directories,Ada.Characters.Handling;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Gestion_Outils,ada.Directories,Ada.Characters.Handling;

PACKAGE BODY Gestion_Personnel IS
   USE Fichier_Archives;
   use Archivage_Perso;
   use conteur_stockage;
   Function Recherche(id : T_identite;Index : integer) RETURN Boolean IS
   tab : t_registre;
   BEGIN
      Recup_Stockage(Tab);
      FOR I IN Tab'RANGE LOOP
         IF I /= Index AND THEN Tab(I).identite.Nom = id.Nom AND THEN Tab(I).identite.Prenom = id.Prenom THEN
            RETURN True;
         END IF;
      END LOOP;
      RETURN False;
   END Recherche;
   --------------------------------------------------------------------------------------
   FUNCTION Present(Nom, Prenom : T_Mot) RETURN Integer IS
      tab : t_registre;
   BEGIN
      Recup_Stockage(tab);
      FOR I IN Tab'RANGE LOOP
         IF Tab(I).identite.Nom = Nom AND THEN Tab(I).identite.Prenom = Prenom THEN
            RETURN I;
         END IF;
      END LOOP;
      return -1;
   END Present;
   -------------------------------------------------------------------------------------------
   PROCEDURE Supprimer(tab : in out t_registre;Nom, Prenom : IN T_Mot; A:Integer; Ok: OUT Boolean) IS
   BEGIN
      ok := false;
      FOR I IN Tab'RANGE LOOP
         IF i= a THEN
            Tab(I).Identite.Nom :=(OTHERS=>' ');
            Tab(I).Identite.Prenom :=(OTHERS=>' ');
            Tab(I).Vide := True;
            Ok := True; exit;
         END IF;
      END LOOP;
   END Supprimer;
   -------------------------------------------------------------------------------
   PROCEDURE Archiver(Employer : IN OUT T_Registre; nom,prenom: in T_mot) IS
      Mon_Fichier : Fichier_Archives.File_Type;
      k : integer;
      begin
      IF exists("Archive_Personnel") THEN
         Open(Mon_Fichier, APPEND_File,"Archive_Personnel");
      ELSE
         Create(Mon_Fichier, Name =>"Archive_Personnel");
      END IF;
      k:= Present(Nom, Prenom);
          if k/=-1 then
               Write(Mon_Fichier, employer(k));
         ELSE
            put("L'employer archiver est introuvable");
          END IF;
      Close (Mon_Fichier);
   END Archiver;
  ---------------------------------------------------------------------------------
   PROCEDURE Check_Archive IS
      Mon_Fichier : Fichier_Archives.File_Type;
      personne : T_personne;
      begin
      IF exists("Archive_Personnel") THEN
            Open(Mon_Fichier, In_File,"Archive_Personnel");
            WHILE not End_Of_File(Mon_Fichier) LOOP
               Read(Mon_Fichier, Personne);
               put("Employer archiver:");
               Put(personne.identite.Nom);
               Put(personne.identite.Prenom); New_Line;
            END LOOP;
            Close (Mon_Fichier);
      ELSE
         put_line("Il ya pas encore d'ancien membre");
      END IF;
   END Check_Archive;
    -------------------------------------------------------------------------------------
   Function Cherche_Doublon_Archive(ident : T_identite) return boolean IS
      Mon_Fichier : Fichier_Archives.File_Type;
      personne : T_personne;
      begin
      IF exists("Archive_Personnel") THEN
            Open(Mon_Fichier, In_File,"Archive_Personnel");
            WHILE not End_Of_File(Mon_Fichier) LOOP
               Read(Mon_Fichier, Personne);
               IF Personne.Identite = Ident THEN
                  Close (Mon_Fichier);
                  RETURN True;
               END IF;
            END LOOP;
            Close (Mon_Fichier);
            return false;
      ELSE
         return false;
      END IF;
   END Cherche_Doublon_Archive;
   -------------------------------------------------------------------------------

   PROCEDURE Enregistrer_Depart(T: in out t_registre) IS
      X,K : Integer;
      Nom, Prenom : T_Mot:=(others=>' ');
      reussi : Boolean:=false;
   BEGIN
      Put_Line("Donner le nom de la personne a supprimer");
      Get_Line(Nom, K);
      nom := to_upper(nom);
      Put_Line("Donner le prenom de la personne a supprimer");
      Get_Line(Prenom, K);
      prenom := to_upper(prenom);
      X := Present(Nom,Prenom);
      IF X /= -1 THEN
         Archiver(T,nom, prenom);
         Supprimer(T,Nom, Prenom, X, Reussi);
         IF Reussi THEN
            Put_Line("La personne a ete supprimer avec succes");
         ELSE
            Put_Line("Erreur : la suppression a echoue.");
         END IF;

      ELSE
         Put("Cette personne n'existe pas dans le registre");new_line;
      END IF;
      --Stokage_Personnel(t);
   END Enregistrer_Depart;
   -------------------------------------------------------------------------------------
   PROCEDURE Stokage_Personnel(Tab:IN OUT T_Registre) is
      Fichier_stockage : Archivage_Perso.File_Type;
   begin
      IF exists("Stockage_Personnel") THEN
         Open(Fichier_stockage, out_File,"Stockage_Personnel");
      ELSE
         Create(Fichier_stockage, Name =>"Stockage_Personnel");
      END IF;
      Write(Fichier_Stockage, Tab);
      --FOR I IN Tab'RANGE LOOP
         --if not tab(i).vide then
            --Put(Tab(I).Identite.Nom); Put(" "); Put(Tab(I).Identite.Prenom);
         --END IF;
        -- put("salu"); --put(Tab(I).Identite.Nom);
      --END LOOP;
      Close (Fichier_Stockage);
   END Stokage_Personnel;
   ----------------------------------------------------------------------------------------
   PROCEDURE Recup_Stockage(Tab: in OUT T_Registre) IS
      Fichier_stockage : Archivage_Perso.File_Type;
   begin
      IF exists("Stockage_Personnel") THEN
         Open(Fichier_stockage, in_File,"Stockage_Personnel");
         WHILE not End_Of_File(Fichier_stockage) LOOP
            read(Fichier_stockage, Tab);
         END LOOP;

--         FOR I IN Tab'RANGE LOOP
--            if not tab(i).vide then
--            Put("Nom: "); Put(Tab(I).Identite.Nom);
--               Put(" Prenom: "); Put(Tab(I).Identite.Prenom);
--            END IF;
--            put("salu");Put("Nom: "); Put(Tab(I).Identite.Nom);
--               Put(" Prenom: "); Put(Tab(I).Identite.Prenom);
--            END LOOP;
         Close (Fichier_Stockage);
      END IF;
   END Recup_Stockage;

   ----------------------------------------------------------------------------
   PROCEDURE Enregistrer_Nouveau_Membre(Tab : in out t_registre) is
      Id: T_Identite;
      Doublon, Doublon_Archive: Boolean;
      num1 : Boolean := true;
      K : Integer;
      M, max:Integer:=0;
      Fonction : T_Fonction;
      Trouver : Boolean := False;
      A : Conteur;
   BEGIN
     -- Recup_Stockage(Tab);
      Recup_stockage_count(a);
      Id.Nom := (others => ' ');
      Id.Prenom := (others => ' ');
      Put_line("Donner le nom");
      Get_Line(Id.Nom, K);
      id.Nom(1..k) := to_upper(id.nom(1..k));
      Put_line("Donner le prenom");
      Get_Line(id.prenom, K);
      Id.PreNom(1..K) := To_Upper(Id.Prenom(1..K));
      Doublon := Recherche(Id, m);
      doublon_archive := Cherche_Doublon_Archive(id);
      IF Doublon or else Doublon_Archive then
         LOOP
            Put_Line("On a un doublon, Donner un autre identifiant");
            id.Nom := (others => ' ');
            id.Prenom := (others => ' ');
            Put_Line("Donner le nom");
            Get_Line(id.nom,K);
            id.Nom(1..k) := to_upper(id.nom(1..k));
            Put_Line("Donner le prenom");
            Get_Line(id.prenom,K) ;
            id.preNom(1..k) := to_upper(id.prenom(1..k));
            Doublon := Recherche(id, m);
            doublon_archive := Cherche_Doublon_Archive(id);
         EXIT WHEN NOT Doublon and then not doublon_archive;
         END LOOP;
      END IF;
      LOOP
      BEGIN
         Put_line("Donner la fonction");
         Get_Line(S,K);
         Fonction := T_Fonction'Value(S(1..K));exit;
         EXCEPTION
            WHEN constraint_Error=>
            Put_Line("erreur de saisie, recommencez");
      END;
      END LOOP;
      FOR I IN Tab'RANGE LOOP
         IF Tab(I).Vide THEN
            trouver := true;
            Tab(I).Identite.Nom :=Id.Nom;
            Tab(I).Identite.Prenom :=Id.Prenom;
            Tab(I).Fonction := Fonction;
            A.num_tub := A.num_tub +1;
            Tab(I).Identifiant := A.num_tub;
            Stokage_Count(A);
            Tab(I).Vide := False; EXIT;
         END IF;
      END LOOP;
      if not trouver then
         Put_line("Le registre du personnel est plein, il ya plus de place");
      ELSE
         Put_Line("enregistrement reeussi");
      END IF;

      Stokage_Personnel(tab);
   END Enregistrer_Nouveau_Membre;
   ---------------------------------------------------------------------------------------
   PROCEDURE Affiche_Analyste IS
      T : T_registre;
   BEGIN
      Recup_Stockage(T);
      FOR I IN T'RANGE LOOP
         if not t(i).vide and t(i).fonction = ANALYSTE then
            Put(T(I).Identite.Nom); Put(' '); Put(T(I).Identite.Prenom);
            put(t(i).Nbr_Act_Realiser); New_Line;
         END IF;
      END LOOP;
   END Affiche_Analyste;
   ---------------------------------------------------------------------------------------
   PROCEDURE Affiche_Preleveur IS
      T : T_registre;
   BEGIN
      Recup_Stockage(T);
      FOR I IN T'RANGE LOOP
         if not t(i).vide and t(i).fonction = PRELEVEUR then
            Put(T(I).Identite.Nom); Put(' '); Put(T(I).Identite.Prenom);
            put(t(i).Nbr_Act_Realiser); New_Line;
         END IF;
      END LOOP;
   END Affiche_Preleveur;
   ---------------------------------------------------------------------------------------
   PROCEDURE Liste_Personnel IS
      T : T_registre;
   BEGIN
      Recup_Stockage(T);
      FOR I IN T'RANGE LOOP
         if not t(i).vide then
            Put(T(I).Identite.Nom); Put(' '); Put(T(I).Identite.Prenom); put(' ');put(t(i).identifiant); New_Line;

         END IF;
      END LOOP;
   END Liste_Personnel;

-------------------------------------------------------------------------------
   PROCEDURE Stokage_count(count:IN OUT conteur)is
      count_stockage : conteur_stockage.File_Type;
   begin
      IF exists("Stockage_count") THEN
         Open(count_stockage, out_File,"Stockage_count");
      ELSE
         Create(count_stockage , Name =>"Stockage_count");
      END IF;
      Write(count_stockage , count);
      Close (count_stockage);
   END Stokage_count;
   ----------------------------------------------------------------------------------------
   PROCEDURE Recup_Stockage_count(count:IN OUT conteur) IS
      count_stockage : conteur_stockage.File_Type;

   begin
      IF exists("Stockage_count") THEN
         Open(count_stockage, in_File,"Stockage_count");
         WHILE not End_Of_File(count_stockage) LOOP
            read(count_stockage, count);
         END LOOP;
         Close (count_stockage);
      END IF;
   END Recup_Stockage_count;
   -------------------------------------------------------------------------------------
   PROCEDURE Meilleur_Preleveur(T : IN OUT T_Registre) IS
      max : Integer:=0;
   BEGIN
      FOR I IN T'RANGE LOOP
         if not t(i).vide and then t(i).fonction = PRELEVEUR then
            IF T(I).Nbr_Act_Realiser > Max THEN
               Max := T(I).Nbr_Act_Realiser;
            END IF;
         END IF;

      END LOOP;
      put_line("Le(s) meilleur(s) preleveur(s) est(sont):");
      FOR I IN T'RANGE LOOP
         IF not t(i).vide and then t(i).fonction = PRELEVEUR and then T(I).Nbr_Act_Realiser = Max THEN
            put(t(i).identite.nom); put(' ');put(t(i).identite.prenom);put(" avec ");put(max);put(" prelevement");new_line;
         END IF;
      END LOOP;
   END Meilleur_Preleveur;
   ---------------------------------------------------------------------------------
   PROCEDURE Meilleur_Analyste(T : IN OUT T_Registre) IS
      max : Integer:=0;
   BEGIN
      FOR I IN T'RANGE LOOP
         if not t(i).vide and then t(i).fonction = ANALYSTE then
            IF T(I).Nbr_Act_Realiser > Max THEN
               Max := T(I).Nbr_Act_Realiser;
            END IF;
         END IF;

      END LOOP;
      put_line("Le(s) meilleur(s) analyste(s) est(sont):");
      FOR I IN T'RANGE LOOP
         IF not t(i).vide and then t(i).fonction = ANALYSTE and then T(I).Nbr_Act_Realiser = Max THEN
            put(t(i).identite.nom); put(' ');put(t(i).identite.prenom);put(" avec ");put(max);put(" Analyse");new_line;
         END IF;
      END LOOP;
   END Meilleur_Analyste;

END Gestion_Personnel;





