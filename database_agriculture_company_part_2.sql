SET SERVEROUTPUT ON

--1.Sa se afiseze clientii si culturile contractate cu acestia
DECLARE
CURSOR curs IS SELECT cl.id_client, cl.nume numeClient, c.nume numeCultura
                FROM clienti_ag cl, culturi c, contracte_ag con
                WHERE cl.id_client = con.id_client AND con.id_cultura = c.id_cultura
                GROUP BY cl.id_client, cl.nume, c.nume
                ORDER BY cl.id_client;
BEGIN
FOR vrec IN curs
    LOOP
    DBMS_OUTPUT.PUT_LINE(vrec.id_client||' '||vrec.numeClient||' '||vrec.numeCultura);
    END LOOP;
END;
/

--2.Daca un muncitor a lucrat pe 2 sau mai multe terenuri diferite, 
--sa i se mareasca salariul cu 5% si sa se afiseze cate marimi de salarii au avut loc
DECLARE
CURSOR curs IS SELECT m.id_muncitor, count(distinct p.id_teren) nrTerenuri
                FROM muncitori m, planificare_activitati p, terenuri_agricole t
                WHERE m.id_muncitor = p.id_muncitor AND t.id_teren = p.id_teren
                GROUP BY m.id_muncitor;
vrec curs%rowtype;
v_nr_mariri number(4) := 0;
BEGIN
IF not curs%isopen THEN
    OPEN curs;
END IF;
FETCH curs into vrec;
WHILE not curs%notfound
    LOOP
    IF vrec.nrTerenuri > 1 THEN
        UPDATE muncitori 
        SET salariu = salariu * 1.05
        WHERE id_muncitor = vrec.id_muncitor;
        v_nr_mariri := v_nr_mariri + SQL%ROWCOUNT;
    END IF;
    FETCH curs into vrec;
    END LOOP;
DBMS_OUTPUT.PUT_LINE('S-au efectuat '||v_nr_mariri||' mariri de salariu');
ROLLBACK;
END;
/

--3. sa se categoriseasca arendatorii pe baza valorii arendei
DECLARE
   v_val  arendatori.val_arenda%type;
   v_id_ar arendatori.id_arendator%type := 1;
   v_cat   varchar2(150);
BEGIN
   FOR v_row IN (SELECT * FROM arendatori)
   LOOP
      v_val := v_row.val_arenda;
      CASE
         WHEN v_val < 1000 THEN v_cat := 'Profituri mici';
         WHEN v_val BETWEEN 1000 AND 2000 THEN v_cat := 'Profituri medii';
         ELSE v_cat := 'Profituri mari';
      END CASE;
      DBMS_OUTPUT.PUT_LINE(v_row.id_arendator || ' ' || v_row.nume || ' ' || v_row.val_arenda || ' ' || v_cat);
   END LOOP;
END;
/

--4. Toate culturile de Porumb de anul acesta s-au dovedit a fi extrem de profitabile;
--in aceasta circumstanta oferim un bonus de 100 u.m. arendatorilor pe terenul carora am plantat
--vreun tip de cultura de porumb si afisam informatii (bonus afisam separat)
DECLARE
  CURSOR curs IS SELECT a.id_arendator, a.nume numeA, a.val_arenda, t.id_teren, c.id_cultura, c.nume numeC
                  FROM arendatori a, terenuri_agricole t, culturi c
                  WHERE a.id_arendator = t.id_arendator AND t.id_cultura = c.id_cultura
                  GROUP BY a.id_arendator, a.nume, a.val_arenda, t.id_teren, c.id_cultura, c.nume
                  ORDER BY a.id_arendator;
  vrec curs%rowtype;
BEGIN
  FOR vrec IN curs
  LOOP
    IF vrec.numeC like 'Porumb%' THEN
        DBMS_OUTPUT.PUT_LINE(vrec.id_arendator||' '||vrec.numeA||' '||vrec.val_arenda||' '||vrec.id_teren||' '||vrec.id_cultura||' '||vrec.numeC||' Bonus = 100');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vrec.id_arendator||' '||vrec.numeA||' '||vrec.val_arenda||' '||vrec.id_teren||' '||vrec.id_cultura||' '||vrec.numeC);
    END IF;
  END LOOP;
END;
/

--5. Pentru id-ul terenului introdus de la tastatura, afiseaza arendatorul si muncitorii aferenti
DECLARE
v_id terenuri_agricole.id_teren%type := &id;
CURSOR curs IS SELECT t.id_teren, m.nume numeM, a.nume numeA
                FROM terenuri_agricole t, muncitori m, arendatori a, planificare_activitati p
                WHERE a.id_arendator = t.id_arendator AND t.id_teren = p.id_teren AND p.id_muncitor = m.id_muncitor
                GROUP BY t.id_teren, m.nume, a.nume;
vrec curs%rowtype;
BEGIN
    FOR vrec IN curs
    LOOP
        IF vrec.id_teren = v_id THEN
            DBMS_OUTPUT.PUT_LINE('Pe terenul '||vrec.id_teren||' munceste '||vrec.numeM||' apartinand lui '||vrec.numeA);
        END IF;
    END LOOP;
END;
/

--6. Identifica care este cea mai ieftina cultura si afiseaza numele, pretul, suprafata si coordonatele gps aferent
--culturilor cu cea mai ieftina cultura
DECLARE
    CURSOR curs IS SELECT c.id_cultura, c.nume, c.pret, t.suprafata, t.coordonate_gps
                    FROM culturi c, terenuri_agricole t
                    WHERE c.id_cultura = t.id_cultura AND c.pret = (SELECT MIN(pret) FROM culturi)
                    ORDER BY c.id_cultura;
BEGIN
    FOR vrec in curs
    LOOP
        DBMS_OUTPUT.PUT_LINE(vrec.id_cultura||' '||vrec.nume||' are pretul '||vrec.pret||' si este cultivata pe o suprafata de '||vrec.suprafata ||' ha la coordonatele '||vrec.coordonate_gps);
    END LOOP;
END;
/




--1. Verificati daca exista muncitori care sunt in acelasi timp si arendatori, prin introducerea cnp-ului acestuia de la tastatura si afisati salariul + val_arenda
--in cazul in care nu exista muncitorul cu numele introdus, tratati exceptia. in cazul in care mai multi muncitori au acelasi nume, tratati exceptia.
--ex 1: 5011821786333  ;;  ex 2: 5049276093851
SET SERVEROUTPUT ON;

insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (12, 'Ghita', 'Valentin', '5049276093851', to_date('26-03-2023','dd-mm-yyyy'), 2000, '0754632121', 'ghi_val@yahoo.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (12, 'Ghita', 'Valentin', '5049276093851', 300, '0754632121', 'ghi_val@yahoo.com');

DECLARE
    v_cnp muncitori.cnp%type := '&cnpMuncitor';
    v_salariu muncitori.salariu%type;
    v_val_arenda arendatori.val_arenda%type;
BEGIN
    SELECT m.salariu, a.val_arenda INTO v_salariu, v_val_arenda 
                FROM muncitori m, arendatori a
                WHERE m.cnp = v_cnp AND a.cnp = v_cnp;
    DBMS_OUTPUT.PUT_LINE('Muncitorul cu cnp '||v_cnp||' este si arendator! Salariu : '||v_salariu||' Val_arenda : '||v_val_arenda);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Muncitorul cu cnp '||v_cnp||' nu exista sau nu este si arendator');
END;
/

--2. Afisati id-urile clientilor care au contractat culturi care au ocupat o suprafata mai mare sau egala cu o suprafata citita de la tastatura
--si abordati eroarea in care suprafata este mai mare decat orice teren agricol pe care il lucreaza firma
--ex 1: 2 ;; ex 2: 8 ;; ex 3: 100 
DECLARE
    v_sup terenuri_agricole.suprafata%type := &suprafata;
    CURSOR curs IS SELECT c.id_client, t.suprafata
                    FROM clienti_ag c, terenuri_agricole t, contracte_ag co, culturi cu
                    WHERE c.id_client = co.id_client and co.id_cultura = cu.id_cultura and cu.id_cultura = t.id_cultura;
    v_rec curs%rowtype;
    v_nr number := 0;
    exp_sup exception;
BEGIN
    FOR v_rec in curs
    LOOP
        IF v_rec.suprafata >= v_sup THEN
            v_nr := v_nr + 1;
            DBMS_OUTPUT.PUT_LINE(v_rec.id_client);
        END IF;
    END LOOP;
    IF v_nr = 0 THEN
        raise exp_sup;
    END IF;
EXCEPTION
    WHEN exp_sup THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista firme care au contractat culturi care au ocupat o suprafata mai mare sau egala cu '||v_sup||' ha');
END;
/

--3. Afisati pentru arendatorul al carui id este citit de la tastatura numele culturii care se afla pe terenul lui si gestionati erorile in care un arendator introdus nu are
--asociat un teren agricol sau un arendator are mai multe terenuri
--ex 1: 1    ;;   ex 2: 2   ;;   ex 3: 13
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (13, 'Atila', 'Vultur', '5039672321233', to_date('26-03-2023','dd-mm-yyyy'), 3000, '0737692456', 'ati_vul@yahoo.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (13, 'Atila', 'Vultur', '5039672321233', 400, '0737692456', 'ati_vul@yahoo.com');

DECLARE
    v_i number := &idArendator;
    v_numeA arendatori.nume%type;
    v_numeC culturi.nume%type;
    terenuri_excep EXCEPTION;
    PRAGMA EXCEPTION_INIT(terenuri_excep, -01422);
BEGIN
    SELECT a.nume, c.nume INTO v_numeA, v_numeC
                FROM arendatori a, terenuri_agricole t, culturi c
                WHERE a.id_arendator = v_i AND a.id_arendator = t.id_arendator AND t.id_cultura = c.id_cultura;
    DBMS_OUTPUT.PUT_LINE(v_numeA||' - '||v_numeC);
    v_i := v_i + 1;
EXCEPTION
    WHEN terenuri_excep THEN
        DBMS_OUTPUT.PUT_LINE('Arendatorul '||v_numeA||' are mai multe terenuri in arenda');
    WHEN NO_DATA_FOUND THEN
        SELECT nume INTO v_numeA FROM arendatori WHERE id_arendator = v_i;
        DBMS_OUTPUT.PUT_LINE('Arendatorul '||v_numeA||' nu are un teren asociat');
END;
/

--4. Minimul pe economie a crescut la valoarea introdusa de utilizator de la tastatura. Niciun muncitor nu poate avea un salariu mai mic decat minimul pe economie.
--Toti salariatii care au salariul mai mic decat minimul pe economie vor avea setat noul salariu la minimul pe economie. Toti angajatii care au salariul mai mic decat
--2*noul_minim_pe_economie vor avea salariul marim cu 30%; Pentru a compensa pentru pierderile financiare, salariatii care au salariul peste 3*noul_minim_pe_economie 
--vor suferi o diminuare de salariu de 5%; Firma nu isi permite o crestere totala a salariilor mai mare de 150% din salariile curente. Gestionati eroarea
--aferenta falimentului si afisati noile situatii salariale si cate modificari au luat loc;
--ex 1: 3000    ;;    ex 2: 9999

DECLARE
    v_val number := &nouMinimPeEconomie;
    v_totSalCur number := 0;
    v_totSalNoi number := 0;
    v_nr number := 0;
    v_salariu muncitori.salariu%type;
    CURSOR curs IS SELECT id_muncitor, nume, prenume, salariu
                    FROM muncitori;
    v_rec curs%rowtype;
    faliment_excep exception;
    PRAGMA EXCEPTION_INIT(faliment_excep, -20999);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Vechea situatie salariala:');
    FOR v_rec in curs
    LOOP
        v_totSalCur := v_totSalCur + v_rec.salariu;
        DBMS_OUTPUT.PUT_LINE(v_rec.nume||' '||v_rec.prenume||' - '||v_rec.salariu);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Noua situatie salariala:');
    FOR v_rec in curs
    LOOP
        CASE 
            WHEN v_rec.salariu < v_val THEN 
                UPDATE muncitori SET salariu = v_val WHERE id_muncitor = v_rec.id_muncitor;
                v_nr := v_nr + 1;
            WHEN v_rec.salariu BETWEEN v_val AND 2*v_val THEN 
                UPDATE muncitori SET salariu = salariu * 1.3 WHERE id_muncitor = v_rec.id_muncitor;
                v_nr := v_nr + 1;
            WHEN v_rec.salariu > 3*v_val THEN
                UPDATE muncitori SET salariu = salariu * 0.95 WHERE id_muncitor = v_rec.id_muncitor;
                v_nr := v_nr + 1;
            ELSE
                v_nr := v_nr;
        END CASE;
        SELECT salariu INTO v_salariu FROM muncitori WHERE id_muncitor = v_rec.id_muncitor;
        v_totSalNoi := v_totSalNoi + v_salariu;
        DBMS_OUTPUT.PUT_LINE(v_rec.nume||' '||v_rec.prenume||' - '||v_salariu);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    IF v_totSalNoi <= v_totSalCur * 1.5 THEN
        DBMS_OUTPUT.PUT_LINE('Au avut loc '||v_nr||' modificari');
    ELSE 
        RAISE_APPLICATION_ERROR(-20999, 'Firma intra in faliment!');
    END IF;
    ROLLBACK;
EXCEPTION
    WHEN faliment_excep THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END;
/

select id_muncitor, nume, prenume, salariu from muncitori order by salariu;




SET SERVEROUTPUT ON;

--pachet cu 3 proceduri
CREATE OR REPLACE PACKAGE pachet_proceduri
AS
    PROCEDURE update_info (a_id IN arendatori.id_arendator%type, a_nr IN arendatori.telefon%type, a_email IN arendatori.email%type);
    PROCEDURE raise_salary (m_id IN muncitori.id_muncitor%type, perc IN NUMBER);
    PROCEDURE whos_terrain (t_id IN terenuri_agricole.id_teren%type);
END pachet_proceduri;
/

CREATE OR REPLACE PACKAGE BODY pachet_proceduri
AS
    PROCEDURE update_info
    (a_id IN arendatori.id_arendator%type, a_nr IN arendatori.telefon%type, a_email IN arendatori.email%type)
    IS
        ex EXCEPTION;
    BEGIN
        UPDATE arendatori SET telefon = a_nr, email = a_email WHERE id_arendator = a_id;
        IF SQL%NOTFOUND THEN
            RAISE ex;
        END IF;
    EXCEPTION
        WHEN ex THEN
            DBMS_OUTPUT.PUT_LINE('Id-ul nu exista pentru niciun arendator');
    END;
    
    PROCEDURE raise_salary
    (m_id IN muncitori.id_muncitor%type, perc IN NUMBER)
    IS
        ex EXCEPTION;
    BEGIN
        UPDATE muncitori SET salariu = (salariu * perc / 100) + salariu WHERE id_muncitor = m_id;
        IF SQL%NOTFOUND THEN
            RAISE ex;
        END IF;
    EXCEPTION
        WHEN ex THEN
            DBMS_OUTPUT.PUT_LINE('Muncitorul cu id-ul '||m_id||' nu exista');
    END;
    
    PROCEDURE whos_terrain
    (t_id IN terenuri_agricole.id_teren%type)
    IS
        v_nume arendatori.nume%type;
        v_prenume arendatori.prenume%type;
    BEGIN
        SELECT nume, prenume INTO v_nume, v_prenume FROM arendatori, terenuri_agricole WHERE arendatori.id_arendator = terenuri_agricole.id_teren AND t_id = terenuri_agricole.id_teren;
        DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_prenume);
    END;
END;
/

--1. Procedura update_info care verifica daca arendatorul cu id-ul dat exista
--si daca exista, ii updateaza numarul de telefon si emailul cu informatiile primite
--ca parametri
select * from arendatori;

EXECUTE pachet_proceduri.update_info(14, 0654333111, 'nue_bn@yahoo.com');
EXECUTE pachet_proceduri.update_info(13, 0637692456, 'vul_ati@yahoo.com');

select * from arendatori where id_arendator = 13;

rollback;

--2) Procedura raise_salary care mareste salariul unui muncitor cu id primit ca parametru
--cu un procent primit ca parametru
EXECUTE pachet_proceduri.raise_salary(1, 5);
EXECUTE pachet_proceduri.raise_salary(15, 5);
select * from muncitori where id_muncitor = 1;

rollback;

--3) Procedura whos_terrain care primind id-ul unui teren agricol afiseaza informatii despre
--arendatorul care il detine.
EXECUTE pachet_proceduri.whos_terrain(4);

--pachet cu 3 proceduri
CREATE OR REPLACE PACKAGE pachet_functii
AS
    FUNCTION terrain_work (v_id IN terenuri_agricole.id_teren%type) RETURN BOOLEAN;
    FUNCTION calc_total_pj RETURN NUMBER;
    FUNCTION cultura_pe_teren (v_id IN arendatori.id_arendator%type) RETURN varchar2;
    FUNCTION creare_email (v_nume IN muncitori.nume%type, v_prenume IN muncitori.prenume%type) RETURN muncitori.email%type;
END pachet_functii;
/

CREATE OR REPLACE PACKAGE BODY pachet_functii
AS
    FUNCTION terrain_work
    (v_id IN terenuri_agricole.id_teren%type)
    RETURN BOOLEAN
    IS
        aux_id terenuri_agricole.id_teren%type;
    BEGIN
        SELECT id_muncitor INTO aux_id FROM planificare_activitati WHERE id_teren = v_id;
        IF v_id is null THEN
            RETURN false;
        ELSE
            RETURN true;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ID inexistent pentru terenurile agricole');
        WHEN TOO_MANY_ROWS THEN
            RETURN true;
    END;
    
    FUNCTION calc_total_pj
    RETURN NUMBER
    IS
    v_valoare NUMBER(20) := 0;
    BEGIN
        SELECT SUM(c.valoare) INTO v_valoare
            FROM contracte_ag c
            JOIN clienti_ag ca ON c.id_client = ca.id_client
            WHERE ca.tip = 'pj'
            GROUP BY ca.tip;
        RETURN v_valoare;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN v_valoare;
    END;
    
    FUNCTION cultura_pe_teren
    (v_id IN arendatori.id_arendator%type)
    RETURN varchar2
    IS
        v_nume culturi.nume%type;
    BEGIN
        SELECT c.nume INTO v_nume
            FROM culturi c 
            JOIN terenuri_agricole ta ON c.id_cultura = ta.id_cultura 
            JOIN arendatori a ON ta.id_arendator = a.id_arendator
            WHERE a.id_arendator = v_id;
        RETURN v_nume;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN ' nu are plantat nimic pe teren';
        WHEN TOO_MANY_ROWS THEN
            RETURN ' are cel putin 2 culturi diferite plantate pe teren';
    END;
    
    FUNCTION creare_email
    (v_nume IN muncitori.nume%type, v_prenume IN muncitori.prenume%type)
    RETURN muncitori.email%type
    IS
    v_email muncitori.email%type;
    BEGIN
        v_email := LOWER(SUBSTR(v_nume,1,3))||'_'||LOWER(SUBSTR(v_prenume,1,3))||'@yahoo.com';
        return v_email;
    END;
END;
/

--4)Functia terrain_work care returneaza true sau false in functie daca terenul e lucrat de muncitori sau nu
DECLARE
    v_result boolean;
BEGIN
    v_result := pachet_functii.terrain_work(1);
    CASE v_result
        WHEN TRUE THEN
            DBMS_OUTPUT.PUT_LINE('true');
        ELSE
            DBMS_OUTPUT.PUT_LINE('false');
    END CASE;
END;
/

--5) Functia calc_total_pj care calculeaza valoarea totala a tuturor contractelor cu persoane juridice
DECLARE
    v_valoare NUMBER(20);
BEGIN
    v_valoare := pachet_functii.calc_total_pj;
    DBMS_OUTPUT.PUT_LINE('Valoarea totala a contractelor facute cu persoane juridice este '||v_valoare);
END;
/

--6) Functi cultura_pe_teren care ne returneaza daca se afla cultura pe terenul arendatorului, si daca da ce cultura (una) sau mesaj ca se afla mai multe
DECLARE
    v_id arendatori.id_arendator%type := &idArendator;
    v_nume varchar2(200) := null;
BEGIN
    v_nume := pachet_functii.cultura_pe_teren(v_id);
    IF v_nume is not null THEN
        DBMS_OUTPUT.PUT_LINE('Arendatorul cu id-ul '||v_id||' '||v_nume);
    END IF;
END;
/

--7) Functia creare_email care returneaza un varchar2 semnificand o adresa de email in functie de numele si prenumele muncitorului
DECLARE
    v_id muncitori.id_muncitor%type := &idMuncitor;
    v_email muncitori.email%type;
    v_nume muncitori.nume%type;
    v_prenume muncitori.prenume%type;
BEGIN
    SELECT nume, prenume INTO v_nume, v_prenume FROM muncitori WHERE id_muncitor = v_id;
    v_email := pachet_functii.creare_email(v_nume, v_prenume);
    DBMS_OUTPUT.PUT_LINE('Muncitorul '||v_nume||' '||v_prenume||' primeste email-ul : '||v_email);
END;
/



SET SERVEROUTPUT ON;

--1. Declansatorul asign_work care la introducerea unui nou muncitor in baza de date, cauta sa vada daca exista vreun teren fara activitate 
--si asigeaza muncitorului o astfel de activitate

CREATE OR REPLACE TRIGGER t_assign_work
AFTER
INSERT
ON muncitori
FOR EACH ROW
DECLARE
    v_id_teren terenuri_agricole.id_teren%TYPE;
    CURSOR curs_id_teren IS SELECT id_teren
                    FROM terenuri_agricole
                    WHERE id_teren NOT IN (
                        SELECT id_teren FROM planificare_activitati)
                    ORDER BY id_teren
                    FETCH FIRST 1 ROW ONLY;
BEGIN
    OPEN curs_id_teren;
    FETCH curs_id_teren INTO v_id_teren;
    IF curs_id_teren%FOUND THEN
        insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (:NEW.id_muncitor, v_id_teren, SYSDATE+1, 'Planificare teren');
        DBMS_OUTPUT.PUT_LINE('Muncitorului cu id-ul '||:NEW.id_muncitor||' i s-a asignat o activitate in planificare_activitati');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER t_assign_work
AFTER INSERT ON muncitori
FOR EACH ROW
DECLARE
    v_id_teren terenuri_agricole.id_teren%TYPE;
    v_count INTEGER := 0;
BEGIN
    FOR teren_rec IN (
        SELECT id_teren
        FROM terenuri_agricole
        WHERE id_teren NOT IN (
            SELECT id_teren
            FROM planificare_activitati
        )
        ORDER BY id_teren
    )
    LOOP
        v_count := v_count + 1;
        v_id_teren := teren_rec.id_teren;

        INSERT INTO planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate)
        VALUES (:NEW.id_muncitor, v_id_teren, SYSDATE + 1, 'Planificare teren');

        DBMS_OUTPUT.PUT_LINE('Muncitorului cu id-ul ' || :NEW.id_muncitor || ' i s-a asignat o activitate in planificare_activitati');

        EXIT WHEN v_count = 1;
    END LOOP;
END;
/

describe muncitori;
select * from muncitori order by id_muncitor;
describe planificare_activitati;

insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values 
(99, 'AAAAA', 'BBBBB', '999999999', SYSDATE, 9999, '0999999999', 'ggggggg@ggg');

select * from planificare_activitati;

select * from terenuri_Agricole;

rollback;

delete from muncitori where id_muncitor = 99;
delete from planificare_activitati where id_muncitor = 99;


--2. Triggerul t_add_terrain care la introducerea unui nou arendator adauga automat un teren cu id-ul = id-ul maxim al terenurilor + 1 fara informatii suplimentare
CREATE OR REPLACE TRIGGER t_add_terrain
AFTER 
INSERT 
ON arendatori
FOR EACH ROW
DECLARE
    v_id_teren terenuri_agricole.id_teren%TYPE;
    v_id_arendator terenuri_agricole.id_arendator%TYPE;
    --v_id_cultura terenuri_agricole.id_cultura%TYPE;
    --v_coordonate_gps terenuri_agricole.coordonate_gps%TYPE;
    --v_suprafata terenuri_agricole.suprafata%TYPE;
BEGIN
        SELECT MAX(id_teren) + 1 INTO v_id_teren FROM terenuri_agricole;
        v_id_arendator := :NEW.id_arendator;
        DBMS_OUTPUT.PUT_LINE('Un teren fara detalii urmeaza a se crea: ');
        --v_id_cultura := &enter_id_cultura;
        --v_coordonate_gps := '&enter_coordonate_gps';
        --v_suprafata := &enter_suprafata;
        INSERT INTO terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata)
            VALUES (v_id_teren, v_id_arendator, NULL, NULL, NULL);
        DBMS_OUTPUT.PUT_LINE('Pentru arendatorul cu id-ul '||v_id_arendator||' s-a adaugat terenul corespunzator. Nu uita sa actualizezi datele complete pentru teren');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Check tables structures, restrictions, and if the ids are valid. (for example, id_cultura needs to exist already)');
END;
/

select * from arendatori;
select * from terenuri_agricole;

insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (55, 'GGGGG', 'TTTTT', '098908900', 1234, '09999999', 'GGG@TTT');

rollback;


--3. Trigger t_check_quantity care verifica atunci cand se doreste sa se faca sau modifice un nou contract, daca noua valoare contractata din cultura este disponibila, si se
--actualizeaza cantitatea decat daca se poate face inserarea, altfel nu se accepta inserarea / modificarea

select * from culturi;
ALTER TABLE culturi ADD cantitate number(8) DEFAULT 1000;
ALTER TABLE culturi DROP COLUMN cantitate;

CREATE OR REPLACE TRIGGER t_check_quantity
BEFORE INSERT OR UPDATE OF cantitate_vanduta
ON contracte_ag
FOR EACH ROW
DECLARE
  v_cantitate culturi.cantitate%TYPE;
BEGIN
  SELECT cantitate INTO v_cantitate FROM culturi WHERE id_cultura = :new.id_cultura;

  IF v_cantitate < :new.cantitate_vanduta THEN
    RAISE_APPLICATION_ERROR(-20101, 'Cantitatea disponibila nu este suficienta pentru a incheia contractul');
  ELSIF INSERTING THEN
    UPDATE culturi SET cantitate = cantitate - :new.cantitate_vanduta WHERE id_cultura = :new.id_cultura;
  ELSE
    UPDATE culturi SET cantitate = cantitate + :old.cantitate_vanduta - :new.cantitate_vanduta WHERE id_cultura = :new.id_cultura;
  END IF;
END;
/

describe contracte_ag;
select * from contracte_ag;

insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (11, 6, SYSDATE, 99, 320000, 1001);

UPDATE contracte_ag
SET cantitate_vanduta = 2000
WHERE id_client = 1 AND id_cultura = 3;

UPDATE contracte_ag
SET cantitate_vanduta = 999
WHERE id_client = 1 AND id_cultura = 3;

select cantitate from culturi where id_cultura = 3;

rollback;



SET SERVEROUTPUT ON;

--cursor implicit care afiseaza adresele de email ale muncitorilor
DECLARE
  v_email muncitori.email%TYPE;
BEGIN
  FOR rec IN (SELECT email FROM muncitori) LOOP
    v_email := rec.email;
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
  END LOOP;
END;
/

--cursor explicit CU paramtri care afiseaza informatii despre un muncitor cu un id dat ca parametru
DECLARE
  CURSOR c_muncitor (p_id_muncitor IN muncitori.id_muncitor%TYPE) IS
    SELECT * FROM muncitori WHERE id_muncitor = p_id_muncitor;
  v_muncitor muncitori%ROWTYPE;
  v_id_muncitor muncitori.id_muncitor%TYPE := 1; 
BEGIN
  OPEN c_muncitor(v_id_muncitor);
  FETCH c_muncitor INTO v_muncitor;  
  IF c_muncitor%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_muncitor.id_muncitor);
    DBMS_OUTPUT.PUT_LINE('Nume: ' || v_muncitor.nume);
    DBMS_OUTPUT.PUT_LINE('Prenume: ' || v_muncitor.prenume);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Muncitor not found.');
  END IF;
  CLOSE c_muncitor;
END;
/

--cursor implicit cu care se calculeaza salariul mediu al muncitorilor
DECLARE
  v_total_salariu NUMBER := 0;
  v_count NUMBER := 0;
  v_avg_salariu NUMBER;
BEGIN
  FOR rec IN (SELECT salariu FROM muncitori) LOOP
    v_total_salariu := v_total_salariu + rec.salariu;
    v_count := v_count + 1;
  END LOOP;
  
  IF v_count > 0 THEN
    v_avg_salariu := v_total_salariu / v_count;
    DBMS_OUTPUT.PUT_LINE('Average Salary: ' || TRUNC(v_avg_salariu));
  ELSE
    DBMS_OUTPUT.PUT_LINE('No muncitori found.');
  END IF;
END;
/

--acest block foloseste un cursor CU parametri pentru a prelua detaliile contractului pentru un anumit client dat ca perametru
DECLARE
  CURSOR c_contracte_ag (p_id_client IN clienti_ag.id_client%TYPE) IS
    SELECT *
    FROM contracte_ag
    WHERE id_client = p_id_client;
  v_id_client clienti_ag.id_client%TYPE := 1;
  v_contract contracte_ag%ROWTYPE;
BEGIN
  OPEN c_contracte_ag(v_id_client);
  LOOP
    FETCH c_contracte_ag INTO v_contract;
    EXIT WHEN c_contracte_ag%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('ID Client: ' || v_contract.id_client);
    DBMS_OUTPUT.PUT_LINE('ID Cultura: ' || v_contract.id_cultura);
    DBMS_OUTPUT.PUT_LINE('Data Contract: ' || v_contract.data_contract);
  END LOOP;
  
  CLOSE c_contracte_ag;
END;
/

--cursor implicit care afiseaza id-urile si nr terenurilor arendatorilor
DECLARE
  v_id_arendator terenuri_agricole.id_arendator%TYPE;
  v_count NUMBER;
BEGIN
  FOR rec IN (SELECT id_arendator, COUNT(*) AS teren_count FROM terenuri_agricole GROUP BY id_arendator) LOOP
    v_id_arendator := rec.id_arendator;
    v_count := rec.teren_count;
    DBMS_OUTPUT.PUT_LINE('Arendator ID: ' || v_id_arendator);
    DBMS_OUTPUT.PUT_LINE('Number of Terenuri: ' || v_count);
    DBMS_OUTPUT.PUT_LINE('-------------------');
  END LOOP;
END;
/







