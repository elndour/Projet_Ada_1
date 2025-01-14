WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;


PACKAGE BODY Gestion_Date IS

 -- Fonction pour determiner si une annee est bissextile

   FUNCTION Est_Bissextile(Annee : Positive)
        RETURN Boolean IS
        Bool:Boolean:=false;
     BEGIN

         IF (Annee MOD 4 = 0 AND Annee MOD 100 /= 0) OR (Annee MOD 400 = 0)THEN
           Bool:=true;
         END IF;
         RETURN Bool;

      END Est_Bissextile;

 -- Fonction pour valider le nombre de jour d'une date donn�e et donc de valide la date

      FUNCTION date_Valide(Date : T_Date) RETURN Boolean IS
         TYPE T_Jour_dans IS ARRAY (1..12) OF Integer ;
           Bool:Boolean:=true;
           Jours_Dans_Mois:T_Jour_dans;

        BEGIN
                for i in 1..12 LOOP
                    if i=4 or i=6 or i=9 or i=11 THEN
                       Jours_Dans_Mois(i):=30;
                    elsif i=2 THEN
                       Jours_Dans_Mois(i):=28;
                    else
                        Jours_Dans_Mois(i):=31;
                END IF;
               IF Est_Bissextile(date.annee) THEN
                  Jours_Dans_Mois(2) := 29;
                     END IF;
              END loop;
               IF Date.Jour > Jours_Dans_Mois(Date.Mois) THEN
                  Bool:=false;
                      END IF;
           RETURN Bool;

        END Date_Valide;

-- Proc�dure pour saisir une date

        PROCEDURE saisir_DATE (date: out T_date) IS

        BEGIN
      loop
              loop
              begin
                 put("donner le jour");
                 Get(Date.Jour);skip_line;exit;
                 EXCEPTION
                 when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
                 WHEN constraint_Error=> skip_line;
                     Put_Line("erreur de saisie, recommencez");
              end;
              end loop;

              loop
              begin
                 put("donner le mois");
                 Get(Date.Mois);skip_line; exit;
                 EXCEPTION
                 when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
                 WHEN constraint_Error=> skip_line;
                     Put_Line("erreur de saisie, recommencez");
              end;
              end loop;
              loop
              begin
                 put("donner l'annee");
                 Get(Date.Annee);skip_line; exit;
                 EXCEPTION
                 when Ada.Text_IO.data_error => skip_line;Put_Line("erreur de saisie, recommencez");
                 WHEN constraint_Error=> skip_line;
                     Put_Line("erreur de saisie, recommencez");
              end;
              end loop;

      exit WHEN Date_Valide(Date) AND THEN Date.Jour <= 31 AND THEN Date.Mois <= 12 AND THEN Date.Annee >0;
   END LOOP;
END saisir_DATE;
 -- Proc�dure pour afficher une date

        PROCEDURE Afficher_Date(Date : IN T_Date) IS

           BEGIN

              Put(Date.Jour);
              CASE Date.Mois IS
                 WHEN 1 =>
                    put(" JANVIER");
                 WHEN 2 =>
                    put(" FEVRIER");
                 WHEN 3 =>
                    put(" MARS");
                 WHEN 4 =>
                    put(" AVRIL");
                 WHEN 5 =>
                    put(" MAI");
                 WHEN 6 =>
                    put(" JUIN");
                 WHEN 7 =>
                    put(" JUILLET");
                 WHEN 8 =>
                    put(" AOUT");
                 WHEN 9 =>
                    put(" SEPTEMBRE");
                 WHEN 10 =>
                    put(" OCTOBRE");
                 WHEN 11 =>
                    put(" NOVEMBRE");
                 WHEN 12 =>
                    Put(" DECEMBRE");
                 WHEN OTHERS=>
                       NULL;
              END CASE;
               put(Date.Annee);
           END Afficher_Date;

     PROCEDURE passer_lendemain(Date : in out T_Date) IS

        BEGIN

                    if Date.Mois IN 4|6|9|11 THEN

                       if date.jour = 30 THEN
                          date.jour:=1;
                          date.Mois:=date.Mois+1;
                       else
                             Date.Jour:=Date.Jour+1;
                        END if;
                    elsif Date.Mois=2 THEN
                        IF Est_Bissextile(date.annee) THEN

                           if date.jour = 29 THEN
                              date.jour:=1;
                              date.Mois:=date.Mois+1;
                           else
                               Date.Jour:=Date.Jour+1;
                           END if;

                        else
                            if date.jour = 28 THEN
                             date.jour:=1;
                             date.Mois:=date.Mois+1;
                           else
                           Date.Jour:=Date.Jour+1;
                          END IF;
                        end if;
                    else

                        if date.jour = 31 THEN
                          date.jour:=1;
                            if date.Mois =12 THEN
                            date.Mois:=1;
                            date.annee:=date.annee+1;
                            else
                            date.Mois:=date.Mois+1;
                            END if;
                         else
                             Date.Jour:=Date.Jour+1;
                        END if;
                END IF;



        END passer_lendemain;

         PROCEDURE Date_destruction_R(Date : in out T_Date) IS

          BEGIN

                    if Date.Mois IN 4|6|9|11 THEN

                       if (date.jour+NBJR) > 30 THEN
                          date.jour:= NBJR-(30-date.jour);
                          date.Mois:=date.Mois+1;
                       else
                             Date.Jour:=Date.Jour+NBJR;
                        END if;
                    elsif Date.Mois=2 THEN
                        IF Est_Bissextile(date.annee) THEN

                           if (date.jour+NBJR) > 29 THEN
                              date.jour:=NBJR-(29-date.jour);
                              date.Mois:=date.Mois+1;
                           else
                               Date.Jour:=Date.Jour+NBJR;
                           END if;

                        else
                            if (date.jour+NBJR) > 28 THEN
                             date.jour:=NBJR-(28-date.jour);
                             date.Mois:=date.Mois+1;
                            else
                             Date.Jour:=Date.Jour+NBJR;
                            END IF;
                        end if;
                    else

                        if (date.jour+NBJR) > 31 THEN
                          date.jour:=NBJR-(31-date.jour);
                            if date.Mois =12 THEN
                            date.Mois:=1;
                            date.annee:=date.annee+1;
                            else
                            date.Mois:=date.Mois+1;
                            END if;
                        else
                             Date.Jour:=Date.Jour+NBJR;
                        END if;
                END IF;



        END Date_destruction_R;

        -- fonction comparer 02 date;

         PROCEDURE Date_destruction_C(Date : in out T_Date) IS

          BEGIN

                    if Date.Mois IN 4|6|9|11 THEN

                       if (date.jour+NBJC) > 30 THEN
                          date.jour:= NBJC-(30-date.jour);
                          date.Mois:=date.Mois+1;
                       else
                             Date.Jour:=Date.Jour+NBJR;
                        END if;
                    elsif Date.Mois=2 THEN
                        IF Est_Bissextile(date.annee) THEN

                           if (date.jour+NBJC) > 29 THEN
                              date.jour:=NBJC-(29-date.jour);
                              date.Mois:=date.Mois+1;
                           else
                               Date.Jour:=Date.Jour+NBJC;
                           END if;

                        else
                            if (date.jour+NBJC) > 28 THEN
                             date.jour:=NBJC-(28-date.jour);
                             date.Mois:=date.Mois+1;
                            else
                             Date.Jour:=Date.Jour+NBJC;
                            END IF;
                        end if;
                    else

                        if (date.jour+NBJC) > 31 THEN
                          date.jour:=NBJC-(31-date.jour);
                            if date.Mois =12 THEN
                            date.Mois:=1;
                            date.annee:=date.annee+1;
                            else
                            date.Mois:=date.Mois+1;
                            END if;
                        else
                             Date.Jour:=Date.Jour+NBJC;
                        END if;
                END IF;



        END Date_destruction_C;

END Gestion_Date;








