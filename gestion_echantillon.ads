WITH Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse,Gestion_Tube, sequential_io;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO,gestion_personnel,gestion_date,Gestion_Outils,Gestion_Analyse,Gestion_Tube;

Package gestion_Echantillon is
     X:integer:=4;     y:integer:=6;
     p:integer:=5;
     Nbr_Max_Echantillon : Integer := ((X+Y)*P)/5;
     Date_Du_Jour : T_date;
    Type T_organe is (foie,rein,coeur,poumon,cerveau) ;
    Type T_Animaux is (vaches,lapins,moutons,porcs,canards) ;
    Type Registre_tube is array (1..5) of T_tube ;

--PACKAGE Archives_echantillon IS NEW Sequential_Io(T_echantillon);
 --USE Archives_echantillon;

--PROCEDURE Archiver_echantillon(Echantillon : IN OUT T_echantillon) IS
 --   Mon_Fichier : Archives_echantillon.File_Type;

    TYPE T_echantillon IS RECORD
        Id_echantillon : integer:=0 ;
        Animal : T_animaux ;
        Organe : T_organe ;
        identite_preleveur:T_identite;
        Id_preleveur : integer ;
        Nbr_Tubes : integer:=0 ;
        Listes_Tubes : Registre_Tube ;
        date_prelevement : T_date;
        Date_Perimer : T_Date;
    END RECORD;
    Type T_registre_Prelevement is array (1..nbr_max_echantillon) of t_echantillon;
    TYPE Refrigerateur_type IS RECORD
       Tube : T_Tube;
       Nbre_Place : integer :=5;
    END record ;
    TYPE congelateur_type IS RECORD
       Tube : T_Tube;
       Nbre_Place: integer:=5;
    END record ;

    TYPE T_Refrigerateur IS ARRAY (1..4) OF Refrigerateur_type;
    Type T_Congelateur is array (1..6) of congelateur_type;

    FUNCTION Est_Preleveur_Valide(Identifiant : T_identite; T: T_Registre) RETURN integer;
    function Places_Disponibles_R(Refri : T_Refrigerateur) return Integer;
    function Places_Disponibles_C(congel : T_Congelateur) return Integer;
    function Tous_Tubes_Analyses(ECHANTILLON : T_REGISTRE_PRELEVEMENT; num:integer)  return Boolean;
    PROCEDURE Affiche_Echantillon_V1(Tab : IN T_Registre_Prelevement; int: out integer);
    procedure Verifier_Et_Detruire_Echantillons(Registre : in out T_Registre_Prelevement; Date_J: T_Date);
    PROCEDURE Enregistrer_Tableau_Echantillons(Echantillon : IN OUT T_Registre_Prelevement;T: IN OUT T_Registre;Nbr_Ech_Att : IN OUT Integer;DateJ: IN T_Date);
    PACKAGE Stockage_Echantillon IS NEW Sequential_Io(T_Registre_Prelevement);
    PROCEDURE Stokage_Echantillon(Ech:IN OUT T_Registre_prelevement);
    PROCEDURE Recup_Stockage_Ech(Ech:IN OUT T_Registre_Prelevement);
    PROCEDURE Affiche_Echantillon_V2(Tab : IN T_Registre_Prelevement);
    PROCEDURE Affich_Echantillon(Ech:IN T_Registre_Prelevement);
    PACKAGE Stockage_Refrigerateur IS NEW Sequential_Io(T_Refrigerateur);
    PACKAGE Stockage_Congelateur IS NEW Sequential_Io(T_Congelateur);
    PROCEDURE Stokage_Refri(Refri:IN OUT T_Refrigerateur);
    PROCEDURE Recup_Stockage_Refri(Refri:IN OUT T_Refrigerateur);
    PROCEDURE Stokage_Congel(Congel:IN OUT T_Congelateur);
    PROCEDURE Recup_Stockage_Congel(Congel:IN OUT T_Congelateur);
    PROCEDURE Enregistrer_Analyse(Ech : IN OUT T_Registre_Prelevement;T:IN OUT T_Registre;Datej: IN T_Date);
    PROCEDURE Nbr_Prelev_Organe(A : IN Conteur);
    PROCEDURE Nbr_Prelev_Animaux(A : IN Conteur);
    PROCEDURE Nbr_Total_Prelev(A : IN Conteur);
    PROCEDURE Nbr_Total_Analyse(A : IN Conteur);
    PACKAGE stockage_ech IS NEW Sequential_Io(t_echantillon);
    PROCEDURE Archive_Echantillon(ech:IN OUT T_registre_Prelevement; k: in integer );
    PROCEDURE Check_Archive_Ech;
    procedure incremente_Palce(Registre : in out T_Registre_Prelevement; refri: in out T_refrigerateur; congel: in out t_congelateur);
    PROCEDURE Supprimer_Ech( Ech : IN OUT T_Registre_Prelevement; N : IN Integer);
    PROCEDURE Ech_Sans_Analyse (Tab:IN OUT T_Registre_Prelevement);
    PROCEDURE Ana_Par_Animal (Tab:IN OUT T_Registre_Prelevement);
    PROCEDURE Archive_maj_negatif;

end gestion_Echantillon ; 