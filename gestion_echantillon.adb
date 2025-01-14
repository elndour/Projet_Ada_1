WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse,Gestion_Tube,ada.Directories,Ada.Characters.Handling;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse,Gestion_Tube,ada.Directories,Ada.Characters.Handling;

PACKAGE BODY gestion_Echantillon IS
   USE Stockage_Echantillon;
   USE Stockage_Refrigerateur;
   USE Stockage_Congelateur;
   use stockage_ech;
-- Fonction verification de l'identite du preleveur

   FUNCTION Est_Preleveur_Valide(Identifiant : T_Identite; T: T_Registre) RETURN Integer IS
    valeur:integer:=-1;
   BEGIN
      FOR i in T_Registre'RANGE LOOP
         IF T(i).Identite = Identifiant AND T(I).Fonction = Preleveur THEN
            valeur:= T(i).Identifiant;
         END IF;
      END LOOP;
      return valeur;

   END Est_Preleveur_Valide;
   -----------------------------------------------------------------------------
   PROCEDURE Affiche_Echantillon_V1(Tab : IN T_Registre_Prelevement; int : out integer) IS
   Id : Integer;
   trouv : boolean :=false;
   BEGIN
   Put("Identifiant:  ");
   Get(Id); Skip_Line;
   FOR I IN Tab'RANGE LOOP
      IF Tab(I).Id_Echantillon = Id THEN
         int := id;
         Put("Il s'agit d'un echantillon de "); Put(t_organe'image(Tab(Id).Organe)); Put(" recolte sur un(e) ");
         Put(T_Animaux'Image(Tab(Id).Animal));New_Line;
         Put("le"); Afficher_Date(Tab(Id).Date_Prelevement);
         put(" par ");put(tab(id).identite_Preleveur.prenom);put(" ");put(tab(id).identite_Preleveur.Nom); New_Line;
         Put(Tab(Id).Nbr_Tubes); Put(" tubes ont ete crees ");
         trouv := true; EXIT;
      END IF;
   END LOOP;
   IF NOT Trouv THEN
      Put_line("L'Identifiant ne fait pas partie des identifiants dans echantillons : invalide");
   END IF;

   END Affiche_Echantillon_V1;
  ---------------------------------------------------------------------------------
PROCEDURE Affiche_Echantillon_V2(Tab : IN T_Registre_Prelevement) IS
   int : integer;
   BEGIN
      Affiche_Echantillon_V1(Tab,int);
      Put_Line("les voici");
      FOR I IN 1..Tab(Int).Nbr_Tubes LOOP
         IF Tab(Int).Listes_Tubes(I).Analyser THEN
           -- ech(i).listes_tubes(j).analyser := True;
            Put("identifiant du tube: "); Put(tab(int).listes_tubes(i).numero_tube); New_Line;
            Put("Stockage dans le "); Put(T_Lieu'Image(Tab(int).Listes_Tubes(I).Endroit.Lieu));
            Put(" numero "); Put(Tab(Int).Listes_Tubes(I).Endroit.Numero);New_Line;
            Put("Date a laquelle l'analyse a ete realiser: ");
            Afficher_Date(Tab(Int).Listes_Tubes(I).Analyse.Date_Analyse); New_Line;
            Put("identite de l'analyste: "); Put(Tab(Int).Listes_Tubes(I).Analyse.Identite_Analyste.Nom);
            put(' ');Put(Tab(Int).Listes_Tubes(I).Analyse.Identite_Analyste.preNom);New_Line;
            Put("Resultat de l'analyse: "); Put (T_resultat'image(Tab(Int).Listes_Tubes(I).Analyse.Resultat)); New_Line;
         ELSE
            Put("identifiant du tube: "); Put(tab(int).listes_tubes(i).numero_tube); New_Line;
            Put("Stockage dans le "); Put(T_Lieu'Image(Tab(int).Listes_Tubes(I).Endroit.Lieu));
            Put(" numero "); Put(Tab(Int).Listes_Tubes(I).Endroit.Numero);New_Line;
            Put_Line("Tube en attente d'analyse");
            Put("Sa date de peremption est le");Afficher_Date(Tab(Int).Date_Perimer); New_Line;
         END IF;
      END LOOP;
   END Affiche_Echantillon_V2;
--fonction compter le nombre de places disponibles dans le refrigerateur
   function Places_Disponibles_R(Refri : T_Refrigerateur) return Integer is
         Total : Integer := 0;
   begin
        for J in Refri'Range loop
            Total := Total + Refri(J).Nbre_Place;
        end loop;
        return Total;
end Places_Disponibles_R;
   --------------------------------------------------------------------------------
--fonction compter le nombre de places disponibles dans le refrigerateur
   function Places_Disponibles_C(congel : T_Congelateur) return Integer is
         Total : Integer := 0;
   begin
        for J in congel'Range loop
            Total := Total + congel(J).Nbre_Place;
        end loop;
        return Total;
end Places_Disponibles_C;
---------------------------------------------------------------------------------
--foction qui verifie est ce que tous les tubes sont analyses ou detruit.
function Tous_Tubes_Analyses(ECHANTILLON : T_REGISTRE_PRELEVEMENT; num:integer)  return Boolean is
         bool:boolean:=false;
--         bool2:boolean:=false;
--         bool1:boolean:=false;
         ana:integer:=0;
begin
   -- Parcourir tous les tubes de l'échantillon

   for I in 1..Echantillon(num).Nbr_Tubes loop
      -- Si un tube n'est pas analysé, retourner False
      if Echantillon(num).Listes_Tubes(I).analyser OR Echantillon(num).Listes_Tubes(I).detruit then
             ana:=ana+1;
      end if;
   end loop;
      if ana=Echantillon(num).Nbr_Tubes then
         bool:=true;
      end if;
      return bool; --retourne false si tous les tubes sont analyse ou detruits.
end Tous_Tubes_Analyses;
   -------------------------------------------------------------------------------
-- procedure pour detruire les tubes non analyses
procedure Verifier_Et_Detruire_Echantillons(Registre : in out T_Registre_Prelevement; Date_J: T_Date) is
begin
   for I in Registre'Range loop
      -- Vérifier si la date de péremption est égale à la date de prélèvement
      if Comparer_Date(Registre(I).Date_perimer,Date_J) then
         -- Vérifier si les tubes ne sont pas analysés
         for J in 1..Registre(I).Nbr_Tubes loop
            if not Registre(I).Listes_Tubes(J).analyser then
              -- Marquer le tube comme détruit
               Registre(I).Listes_Tubes(J).Detruit := True;
               Registre(I).Listes_Tubes(J).analyse.identite_analyste.nom:=(others=>' ');
               Registre(I).Listes_Tubes(J).analyse.identite_analyste.prenom:=(others=>' ');
               Registre(I).Listes_Tubes(J).analyse.identifiant_analyste:=0;
               new_line;
               Put("Le Tube "); put(J); put (" de l'echchantillon "); put(i); put(" a ete detruit."); new_line;
            end if;
         end loop;
      end if;
   end loop;
end Verifier_Et_Detruire_Echantillons;
   -------------------------------------------------------------------------------
--procedure enregister tableau echantillon.
procedure Enregistrer_Tableau_Echantillons(echantillon : in out T_Registre_Prelevement;T: in out T_Registre;Nbr_Ech_Att : in out Integer;dateJ: in T_date) is
          K,Id_Preleveur:Integer;
          Refri : T_Refrigerateur;
          Congel : T_Congelateur;
          S : string(1..14);
          Reussi : Boolean;
          lieu : T_lieu;
          date:T_date;
          Id:Integer:=1;
          Ident : T_Identite;
          Trouv : Boolean:=False;
          a : conteur;
BEGIN
   Recup_Stockage_Congel(Congel);
   Recup_Stockage_refri(refri);
   Recup_Stockage_Count(A);
   for I in echantillon'Range loop
      -- Vérifier si la case est vide ou déjà utilisée
      if echantillon(I).Nbr_Tubes = 0 then
         trouv :=True;
         Put("Enregistrement de l'echantillon ");put(a.num_ech); New_Line;
      -- Vérification de l'identité du préleveur
         ident.Nom := (OTHERS => ' ');
         ident.prenom := (OTHERS => ' ');
         Put("Donner le nom du preleveur: ");
         Get_Line(Ident.Nom,K);
         ident.nom := to_upper(ident.nom);
         Put("Donner le prenom du preleveur: ");
         get_line(ident.prenom,k);
         ident.prenom := to_upper(ident.prenom);
        Id_preleveur:=Est_Preleveur_Valide(ident,T);

        if Id_preleveur=-1 THEN
        Put_Line("Soit c'est un analyste, soit l'identité n'existe pas");

        ELSE
               if nbr_ech_att > nbr_max_echantillon  then
                  Put_Line("Le nombre de place maximale est atteinte");
            ELSE

               Echantillon(i).identite_preleveur := ident;
               Nbr_Ech_Att:=Nbr_Ech_Att+1;
               Echantillon(I).Id_Echantillon := A.Num_Ech;
        -- affichage du stokgae disponibles dans le frigo ou refrigerteur;
                  Put("Nombre de places disponibles dans les refrigerateurs : ");
                  Put(Places_Disponibles_R(Refri));New_Line;
                  Put("Nombre de places disponibles dans les congelateurs : ");
                  Put(Places_Disponibles_C(Congel));New_Line;

      -- Vérification et enregisrement du nombre de tubes
                    loop
                        LOOP
                        BEGIN
                           Put_Line("Donner le nombre de tube de l'echantillon");
                           get(echantillon(i).Nbr_Tubes);skip_line; exit;
                           EXCEPTION
                           when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
                           WHEN constraint_Error=> skip_line;
                           Put_Line("erreur de saisie, recommencez");
                        END;
                        END LOOP;

                    exit WHEN echantillon(i).Nbr_Tubes > 0 or else echantillon(i).Nbr_Tubes < 6 ;
                        Put_Line("Le nombre de tubes doit etre entre 1 et 5.");
                    end loop;
                    LOOP
                    BEGIN
                       Put_Line("De quel animal l'echantillon a ete prelever");
                       get_line(s,k);
                       echantillon(i).animal:=T_animaux'value(s(1..k));exit;
                       EXCEPTION
                          WHEN constraint_Error=>
                          Put_Line("erreur de saisie, recommencez");
                     END;
                     END LOOP;
                    IF Echantillon(I).Animal = vaches THEN
                       a.num_vache := a.num_vache + 1;
                    elsif Echantillon(I).Animal = lapins then
                       a.num_lapin := a.num_lapin + 1;
                    elsif Echantillon(I).Animal = moutons then
                       a.num_mouton := a.num_mouton + 1;
                    elsif Echantillon(I).Animal = porcs then
                       a.num_porc := a.num_porc + 1;
                    else
                       a.num_canard := a.num_canard + 1;
                    end if;
                    LOOP
                    BEGIN
                       Put_Line("De quel organe l'echantillon a ete prelever");
                       get_line(s,k);
                       echantillon(i).organe:=T_organe'value(s(1..k));exit;
                       EXCEPTION
                          WHEN constraint_Error=>
                          Put_Line("erreur de saisie, recommencez");
                    END;
                    END LOOP;
                    IF echantillon(i).organe = Foie THEN
                       a.num_foie := a.num_foie + 1;
                    elsif echantillon(i).organe = coeur then
                       a.num_coeur := a.num_coeur + 1;
                    elsif echantillon(i).organe = rein then
                       a.num_rein := a.num_rein + 1;
                    elsif echantillon(i).organe = cerveau then
                       a.num_cerveau := a.num_cerveau + 1;
                    else
                       a.num_poumon := a.num_poumon + 1;
                    end if;
                    a.total_prelev := a.num_foie+a.num_coeur+a.num_rein+a.num_cerveau+a.num_poumon;
 -- Enregistrement des tubes au niveau de leur stokage.

               FOR t IN 1..Echantillon(i).Nbr_Tubes LOOP

                  echantillon(i).listes_tubes(t).numero_tube := (a.num_ech*10)+t;
                  --Stokage_count(a);
                  LOOP
                  BEGIN
                     Put_Line("donner le lieu de stockage: refrigerateur ou congelateur");
                     put("tube: ");put(echantillon(i).listes_tubes(t).numero_tube);put(" ");
                     get_line(s,k);
                     Lieu := T_Lieu'Value(S(1..K));exit;
                     EXCEPTION
                     WHEN constraint_Error=>
                     Put_Line("erreur de saisie, recommencez");
                  END;
                  END LOOP;

                  date:=datej;
                IF Lieu = REFRIGERATEUR THEN

                     FOR J IN refri'range LOOP

                           IF Refri(j).Nbre_Place > 0 THEN
                              Echantillon(i).Listes_Tubes(t).Endroit.Lieu := Lieu;
                              Echantillon(i).Listes_Tubes(t).Endroit.Numero := j;
                              Refri(J).Nbre_Place := Refri(J).Nbre_Place -1;
                              Echantillon(i).date_prelevement:=date;
                              Date_destruction_C(date);
                              Echantillon(I).Date_Perimer:=Date; new_line;
                              Put_Line("Tube stocker avec succes");
                              Stokage_refri(refri);exit;
                           END IF;
                     END LOOP;
                  ELSIF Lieu = CONGELATEUR THEN
                     --Put("Donner le numero de refrigerateur..1 ou 2 ou 3 ou 4 ou 5");
                     --   Get(N); Skip_Line;
                     FOR J IN Congel'RANGE LOOP

                              IF congel(j).Nbre_Place > 0 THEN

                                 Echantillon(i).Listes_Tubes(t).Endroit.Lieu := Lieu;
                                 Echantillon(i).Listes_Tubes(t).Endroit.Numero := j;
                                 congel(J).Nbre_Place := congel(J).Nbre_Place -1;
                                 Echantillon(i).date_prelevement:=dateJ;
                                 Date_destruction_C(date);
                                 echantillon(i).Date_perimer:=date; new_line;
                                 Put_Line("Tube stocker avec succes");
                                 Stokage_congel(congel);exit;
                              END IF;
                        END LOOP;
                     END IF;
               END LOOP;
                  Put_Line ("Prelevement enregistrer avec succes");
                  a.num_ech := a.num_ech + 1;
              -- incrementation du nombre d'actes pour cette analyste.

                  for i in T'RANGE loop
                      if T(i).Identifiant=Id_preleveur then
                         T(I).Nbr_Act_Realiser:=T(I).Nbr_Act_Realiser+1;
                         --put(T(I).Nbr_Act_Realiser);
                      end if;
               END LOOP;

         END IF;
         END IF; exit;
         put_line("Le registre des echantillons est pleins");
      end if;
   END LOOP;
   if not trouv then
      Put("La liste des echantillons: n�");
END IF;
Stokage_Echantillon(Echantillon);
Stokage_count(a);
END Enregistrer_Tableau_Echantillons;

-----------------------------------------------------------------------------------
   PROCEDURE Stokage_echantillon(ech:IN OUT T_Registre_Prelevement)is
      Echantillon_stockage : Stockage_echantillon.File_Type;
   begin
      IF exists("Stockage_echantillon") THEN
         Open(Echantillon_stockage, out_File,"Stockage_echantillon");
      ELSE
         Create(Echantillon_stockage, Name =>"Stockage_echantillon");
      END IF;
      Write(echantillon_stockage, ech);
      Close (echantillon_stockage);
   END Stokage_echantillon;
   ----------------------------------------------------------------------------------------
   PROCEDURE Recup_Stockage_ech(ech:IN OUT T_Registre_Prelevement) IS
      Echantillon_stockage : Stockage_echantillon.File_Type;
   begin
      IF exists("Stockage_echantillon") THEN
         Open(echantillon_stockage, in_File,"Stockage_echantillon");
         WHILE not End_Of_File(Echantillon_stockage) LOOP
            read(Echantillon_stockage, ech);
         END LOOP;
         Close (Echantillon_stockage);
      END IF;
   END Recup_Stockage_Ech;
   ---------------------------------------------------------------------------
   PROCEDURE Affich_Echantillon(Ech:IN T_Registre_Prelevement) IS
   trouv : boolean:=false;
   BEGIN
      --Recup_Stockage_Ech(Ech);
      FOR I IN ech'RANGE LOOP
         IF Ech(i).Nbr_Tubes /= 0 THEN
            Trouv := True;
         END IF;
      END LOOP;
      if trouv then
         put("La liste des echantillons: n�");
         FOR I IN Ech'RANGE LOOP
            IF Ech(i).Nbr_Tubes /= 0 THEN
               Put(Ech(I).Id_Echantillon); Put(",");
            END IF;
         END LOOP;
      ELSE
         Put("Il y'a pas encore d'echantillon");
      END IF;
      new_line;
   END Affich_Echantillon;
     -----------------------------------------------------------------------------------
   PROCEDURE Stokage_refri(refri:IN OUT T_refrigerateur)is
      refrigerateur_stockage : Stockage_refrigerateur.File_Type;
   begin
      IF exists("Stockage_refrigerateur") THEN
         Open(refrigerateur_stockage, out_File,"Stockage_refrigerateur");
      ELSE
         Create(refrigerateur_stockage , Name =>"Stockage_refrigerateur");
      END IF;
      Write(refrigerateur_stockage , refri);
      Close (refrigerateur_stockage);
   END Stokage_refri;
   ----------------------------------------------------------------------------------------
   PROCEDURE Recup_Stockage_refri(refri:IN OUT T_refrigerateur) IS
      refrigerateur_stockage : Stockage_refrigerateur.File_Type;

   begin
      IF exists("Stockage_refrigerateur") THEN
         Open(refrigerateur_stockage, in_File,"Stockage_refrigerateur");
         WHILE not End_Of_File(refrigerateur_stockage) LOOP
            read(refrigerateur_stockage, refri);
         END LOOP;
         Close (refrigerateur_stockage);
      END IF;
   END Recup_Stockage_refri;
   ---------------------------------------------------------------------------
   PROCEDURE Stokage_congel(congel:IN OUT T_congelateur)is
      congelateur_stockage : Stockage_congelateur.File_Type;
   begin
      IF exists("Stockage_congelateur") THEN
         Open(congelateur_stockage, out_File,"Stockage_congelateur");
      ELSE
         Create(congelateur_stockage , Name =>"Stockage_congelateur");
      END IF;
      Write(congelateur_stockage , congel);
      Close (congelateur_stockage);
   END Stokage_congel;
   ----------------------------------------------------------------------------------------
   PROCEDURE Recup_Stockage_congel(congel:IN OUT T_congelateur) IS
      congelateur_stockage : Stockage_congelateur.File_Type;

   begin
      IF exists("Stockage_congelateur") THEN
         Open(congelateur_stockage, in_File,"Stockage_congelateur");
         WHILE not End_Of_File(congelateur_stockage) LOOP
            read(congelateur_stockage, congel);
         END LOOP;
         Close (congelateur_stockage);
      END IF;
   END Recup_Stockage_congel;
   ---------------------------------------------------------------------------

   PROCEDURE Enregistrer_Analyse(ech : IN OUT T_registre_prelevement;T:in out t_registre;datej: in T_date) IS
   k,id_analyste:integer;
   date:T_date:=datej;
   Date_Ana:T_Date;
   Ident : T_Identite;
   NTUB,numTub, num_Ech : integer;
   s : string(1..13);
   A: Conteur;
   bool:boolean:=false;
   BEGIN
         recup_stockage_count(a);
      -- verification de l'identite de l'analyste.
             ident.Nom := (others => ' ');
             ident.Prenom := (others => ' ');

             Put("Donner le nom de l'analyste: ");
             get_line(ident.nom,k);
             ident.nom := to_upper(ident.nom);
             Put("Donner le prenom de l'analyste: ");
             get_line(ident.prenom,k);
             ident.prenom := to_upper(ident.prenom);
             id_analyste:=Est_Analyste_Valide(ident,T);

        if id_analyste=-1 THEN
        Put_Line("Soit c'est un preleveur, soit l'identitte n'existe pas");

        ELSE
            -- saisi de la date d'analyse.

             Put_Line("Saisie de la date de l'analyse");
             saisir_DATE(date_ana);
             if Comparer_Date(date_ana,date) then
--                loop
--                begin
--                   Put_Line("Saisir les numero de l'echantillon et du tube");
--                   put("numero echantillon: ");
--                   get(numEch); skip_line; exit;
--                   EXCEPTION
--                   when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
--                   WHEN constraint_Error=> skip_line;
--                     Put_Line("erreur de saisie, recommencez");
--                 end;
--                 end loop;
                loop
               BEGIN
                   LOOP
                   put("numero tube: ");
                   Get(NTUB); Skip_Line;
                   EXIT WHEN NTUB >10;
                   Put_line("le numero tube doit etre superieur a 10");
                   put("numero tube: ");
                   end loop;
                   Num_Ech:=NTUB/10;
                   numtub:=NTUB mod 10;EXIT;
                   EXCEPTION
                   when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
                   WHEN constraint_Error=> skip_line;
                     Put_Line("erreur de saisie, recommencez");
                end;
                end loop;

                         if ech(num_ech).nbr_tubes > 0 then
                             if numTub <=  ech(num_ech).nbr_tubes then
                               if not ech(num_ech).listes_tubes(numTub).analyser then
                                  if not ech(num_ech).listes_tubes(numTub).detruit then
                                     Ech(num_ech).Listes_Tubes(numtub).Analyser := True;
                                     loop
                                     begin
                                        put_line("Donner le resultat de l'analyse");
                                        Get_Line(S,K);
                                        ech(num_ech).listes_tubes(numTub).analyse.resultat := t_resultat'value(s(1..k));exit;
                                        EXCEPTION
                                        WHEN constraint_Error =>
                                          Put_Line("erreur de saisie, recommencez");
                                     end;
                                     end loop;
                                     a.total_ana := a.total_ana + 1;
                                     ech(num_ech).listes_tubes(numTub).analyse.resultat := T_resultat'value(s(1..k));
                                     ech(num_ech).listes_tubes(numTub).analyse.Date_Analyse:=date_ana;
                                     ech(num_ech).listes_tubes(numTub).Analyse.Identite_Analyste.Prenom := Ident.Prenom;
                                     ech(num_ech).listes_tubes(numTub).Analyse.Identite_Analyste.Nom := ident.nom;
                                     --ech(i).listes_tubes(j).Analyse.Identifiant_analyste := id_analyste;
                                     IF Tous_Tubes_Analyses(Ech,Num_ech)THEN
                                        Archive_Echantillon(Ech, Num_Ech);
                                        Supprimer_Ech(ech, num_ech);
                                        Put_line("Tous les tubes de l'echantillon sont analyses, archiver et supprimer");
                                     END IF;
                                     Put_Line("Analyse enregistree avec succes.");

                                     -- incrementation du nombre d'actes pour cette analyste.
                                     for i in T'RANGE loop
                                        if T(i).Identifiant=id_analyste then
                                           T(I).Nbr_Act_Realiser:=T(I).Nbr_Act_Realiser+1;
                                        end if;
                                     end loop;

                                   else
                                      put_line("Le tube a ete detruit");
                                   end if;
                                else
                                    put_line("Le tube est deja analyser");
                                end if;
                             else
                                put_line("Le tube n'existe pas dans l'echantillon donnee");
                         END IF;
                         ELSE
                              Put_Line("L'echantillon que vous avez donnee n'existe pas");
                      END IF;
                 else
                     Put_line("La date n'est pas la date du jour");
               END IF;
            end if;

       Stokage_Count(A);

   END Enregistrer_Analyse;
  ----------------------------------------------------------------------------------------
    PROCEDURE Nbr_Prelev_Organe(a: in conteur) IS

    BEGIN
       Put("Foie: ");Put(A.Num_Foie);Put("-Reins ");Put(a.num_rein);
       Put("-Coeur ");put(A.Num_coeur);Put("-Poumons ");Put(A.Num_Poumon);put("-Cerveau ");Put(A.Num_Cerveau);
    END Nbr_Prelev_Organe;
    -----------------------------------------------------------------------------------
    PROCEDURE Nbr_Prelev_Animaux(A : IN Conteur)IS
    BEGIN
       Put("Vache: ");Put(A.Num_vache);Put("-Lapin: ");Put(A.Num_lapin);
       Put("-Mouton: "); put(A.Num_mouton);Put("-Porc ");Put(A.Num_Porc);put("-Canard: ");Put(A.Num_Canard); new_line;
    END Nbr_Prelev_Animaux;
  ------------------------------------------------------------------------------------
  PROCEDURE Nbr_total_prelev(A : IN Conteur)IS
    BEGIN
       put("Nombre total de prelevement: ");put(a.total_prelev); new_line;
    END Nbr_Total_Prelev;

    -------------------------------------------------------------------------------
    PROCEDURE Nbr_total_Analyse(A : IN Conteur)IS
    BEGIN
       put("Nombre total d'analyse: ");put(a.total_ana); new_line;
    END Nbr_Total_Analyse;

------------------------------------------------------------------------------
   PROCEDURE Archive_Echantillon(ech:IN OUT T_registre_Prelevement; k: in integer )is
      ech_stockage : stockage_ech.File_Type;
   begin
      IF exists("Archive_echantillon") THEN
         Open(ech_stockage, out_File,"Archive_echantillon");
      ELSE
         Create(ech_stockage, APPEND_File,Name =>"Archive_echantillon");
      END IF;

         Write(ech_stockage, ech(k));

      Close (ech_stockage);
   END Archive_echantillon;
   ----------------------------------------------------------------------------------------
   PROCEDURE Check_Archive_ech IS
      ech_stockage : stockage_ech.File_Type;
      ech : t_echantillon;
      begin
      IF exists("Archive_echantillon") THEN
            Open(ech_stockage, In_File,"Archive_echantillon");
            WHILE not End_Of_File(ech_stockage) LOOP
               Read(ech_stockage, ech);
               Put("La liste des echantillons archiver: ");
               put(ech.id_echantillon); put(' ');
            END LOOP;
            Close (ech_stockage);
      ELSE
         put_line("Il ya pas encore d'ancien membre");
      END IF;
   END Check_Archive_ech;
    -------------------------------------------------------------------------------------
    -- procedure qui incremente le nombre de places disponibles dans le lieu de stockage ou le tube a ete detruit ou analyser;
   procedure incremente_Palce(Registre : in out T_Registre_Prelevement; refri: in out T_refrigerateur; congel: in out t_congelateur) is
      begin
                for I in Registre'Range loop
                   for J in 1..Registre(I).Nbr_Tubes loop
                     IF  Registre(I).Listes_Tubes(J).Detruit and Registre(I).Listes_Tubes(J).numero_tube /=0 THEN
                         IF  Registre(I).Listes_Tubes(J).Endroit.Lieu=Congelateur  THEN
                             congel(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place:=congel(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place+1;
                             put("le nbre de place du congelateur"); put(Registre(I).Listes_Tubes(J).Endroit.numero);
                             Put(" est augmenter de 1"); New_Line;
                             put( congel(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place);
                             Registre(I).Listes_Tubes(J).numero_tube:=0;
                         ELSE
                             refri(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place:=refri(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place+1;
                             put("le nbre de place du refrigerateur"); put(Registre(I).Listes_Tubes(J).Endroit.numero);
                             Put(" est augmenter de 1"); New_Line;
                             put(refri(Registre(I).Listes_Tubes(J).Endroit.numero).nbre_place);
                             Registre(I).Listes_Tubes(J).numero_tube:=0;
                         END IF;
                      END IF;
                    END LOOP;
                END LOOP;

      END Incremente_Palce;
      -----------------------------------------------------------------------------------------------------
      PROCEDURE Supprimer_Ech( Ech : IN OUT T_Registre_Prelevement; n : in integer)is
          BEGIN
            Ech(N).Id_Echantillon:=0;
            Ech(N).identite_preleveur.nom:=(others=>' ');
            Ech(N).Identite_Preleveur.Prenom:=(OTHERS=>' ');
            Ech(N).nbr_tubes:=0;
      END Supprimer_Ech;

--------------------------------------------------------------------------------------------------------
    procedure ech_sans_analyse (tab:IN out T_registre_Prelevement) is
        bool:boolean;
    BEGIN
         for i in tab'range loop
            bool:= false ;
            if tab(i).Nbr_Tubes > 0  then
               for j in 1..tab(i).Nbr_Tubes loop
                  if (tab(i).listes_tubes(j).Analyser) then
                      bool:=true;
                  end if;
               end loop;
               if not bool then
               put("Echantillon: "); put(tab(i).id_echantillon);new_line;
               end if;
            end if;
       END LOOP;
       IF Bool THEN
          Put("Tous les echantillon ont au moins un tube analyser");
       END IF;
   end ech_sans_analyse;
--------------------------------------------------------------------------------------------------------
procedure Ana_par_animal (tab:IN out T_registre_Prelevement) is
            animale:T_Animaux;
            s:string(1..10);
            bool:boolean;
   begin
         Put_Line("Donner le nom de l'animal");
         get_line(s,k);
         animale:=T_Animaux'value(s(1..k));
         for i in tab'range loop
            bool:= false ;
            if tab(i).Nbr_Tubes > 0 and then tab(i).animal = animale then
               for j in 1..tab(i).Nbr_Tubes loop
                  if not (tab(i).listes_tubes(j).Analyser) then
                      bool := True;
                  end if;
               end loop;
               if bool then
                  put("Echantillon: "); put(tab(i).id_echantillon);new_line;
               end if;
            end if;
         end loop;
   end Ana_par_animal;

  ---------------------------------------------------------------------------------------------------------
   PROCEDURE Archive_maj_negatif IS
      ech_stockage : stockage_ech.File_Type;
      Ech : T_Echantillon;
      a,b : integer :=0;
      begin
      IF exists("Archive_echantillon") THEN
            Open(ech_stockage, In_File,"Archive_echantillon");
            WHILE not End_Of_File(ech_stockage) LOOP
               Read(Ech_Stockage, Ech);
               for i in 1..ech.nbr_tubes loop
                  IF Ech.Listes_Tubes(I).Analyse.resultat = negatif THEN
                     A := A +1;
                  ELSE
                     B := B + 1;
                  END IF;
               END LOOP;
               if a > b then
                  Put("Echantillon: "); Put(ech.Id_Echantillon); New_Line;
               END IF;
            END LOOP;
            Close (ech_stockage);
      ELSE
         put_line("Il ya pas encore d'ancien membre");
      END IF;
   END Archive_maj_negatif;

end gestion_Echantillon;