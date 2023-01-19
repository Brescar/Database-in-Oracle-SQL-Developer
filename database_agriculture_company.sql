--  PROIECT BAZE DE DATE     -    GHITA VALENTIN   -    GRUPA 1053 ; SERIA D

-- 3.	Crearea tabelelor (min. 4 tabele) (1p)
create table muncitori(
id_muncitor number(3),
nume varchar2(20),
prenume varchar2(20),
cnp varchar2(20),
data_angajare date,
salariu number(4),
telefon char(10),
email varchar2(20)
);

create table arendatori(
id_arendator number(4),
nume varchar2(20),
prenume varchar2(20),
cnp varchar2(20),
val_arenda number(4),
telefon char(10),
email varchar2(20)
);

-- GHITA VALENTIN 1053D
create table culturi(
id_cultura number(2),
nume varchar2(20),
pret number(4) --pret sac de seminte care acopera 1ha de suprafata
);

create table terenuri_agricole(
id_teren number(4),
id_arendator number(4),
id_cultura number(2),
coordonate_gps varchar2(30),
suprafata number(10) --in ha
);

create table planificare_activitati(
id_muncitor number(3),
id_teren number(4),
data_activitate date,
tip_activitate varchar2(30)
);

create table clienti_ag(
id_client number(5),
tip varchar2(20),
cui varchar2(20),
cnp varchar2(20),
nume varchar2(20),
prenume varchar2(20),
telefon char(10),
email varchar2(20)
);

--GHITA VALENTIN 1053D
create table contracte_ag(
id_client number(5),
id_cultura number(2),
data_contract date,
nr_contract number(5),
valoare number(10),
cantitate_vanduta number(6) --in tone
);

--GHITA VALENTIN 1053D
describe muncitori;
describe arendatori;
describe culturi;
describe terenuri_agricole;
describe planificare_activitati;
describe clienti_ag;
describe contracte_ag;

-- 4.	Actualizarea structurii tabelelor si modificarea restrictiilor de integritate (1p)
--a) exemple pentru actualizarea structurii tabelelor
alter table Muncitori add oras varchar2(10); --adaugam un nou camp numit oras de tipul varchar2 cu dimensiunea maxima 10 caractere
alter table Muncitori drop column oras; --stergem campul oras
--GHITA VALENTIN 1053 D
alter table Arendatori modify val_arenda number(5); --daca este nevoie sa platim mai mult de 9999 (set_currency) atunci modificam number sa poata tina pana la 99999.
alter table Arendatori modify val_arenda number(4); --ne razgandim daca nu este nevoie de mai mult putem aloca memorie minima necesara campului

--b) modificarea restrictiilor de integritate (conform schemei de la pct 2.)
--GHITA VALENTIN 1053D
alter table MUNCITORI add constraint muncitori_pk_id primary key (id_muncitor);
alter table MUNCITORI add constraint muncitori_nn_nume check (nume is not null);
alter table MUNCITORI add constraint muncitori_nn_prenume check (prenume is not null);
alter table MUNCITORI add constraint muncitori_nn_cnp check (cnp is not null);
alter table MUNCITORI add constraint muncitori_uq_cnp unique(cnp);
alter table MUNCITORI add constraint muncitori_nn_salariu check (salariu is not null);
alter table MUNCITORI add constraint muncitori_nn_telefon check (telefon is not null);

select * from user_constraints where table_name = 'MUNCITORI';

--4. b) GHITA VALENTIN 1053 D

alter table ARENDATORI add constraint arendatori_pk_id primary key (id_arendator);
alter table ARENDATORI add constraint arendatori_nn_nume check (nume is not null);
alter table ARENDATORI add constraint arendatori_nn_prenume check (prenume is not null);
alter table ARENDATORI add constraint arendatori_nn_cnp check (cnp is not null);
alter table ARENDATORI add constraint arendatori_uq_cnp unique(cnp);
alter table ARENDATORI add constraint arendatori_nn_telefon check (telefon is not null);

select * from user_constraints where table_name = 'ARENDATORI';

alter table CULTURI add constraint culturi_pk_id primary key(id_cultura);

select * from user_constraints where table_name = 'CULTURI';

--GHITA VALENTIN 1053 D

alter table TERENURI_AGRICOLE add constraint terenuri_agricole_pk_id primary key (id_teren);
alter table TERENURI_AGRICOLE add constraint ter_ag_fk_id_ar foreign key (id_arendator) references ARENDATORI (id_arendator);
alter table TERENURI_AGRICOLE add constraint ter_ag_fk_id_cult foreign key (id_cultura) references CULTURI (id_cultura);

select * from user_constraints where table_name = 'TERENURI_AGRICOLE';

alter table PLANIFICARE_ACTIVITATI add constraint plan_act_pk_id primary key (id_muncitor, id_teren);
alter table PLANIFICARE_ACTIVITATI add constraint plan_act_fk_id_munc foreign key (id_muncitor) references MUNCITORI (id_muncitor);
alter table PLANIFICARE_ACTIVITATI add constraint plan_act_fk_id_ter foreign key (id_teren) references TERENURI_AGRICOLE (id_teren);

select * from user_constraints where table_name = 'PLANIFICARE_ACTIVITATI';

--GHITA VALENTIN 1053D

alter table CLIENTI_AG add constraint clienti_ag_pk_id primary key (id_client);

select * from user_constraints where table_name = 'CLIENTI_AG';

--4. b) modificarea restrictiilor de integritate GHITA VALENTIN 1053 D

alter table CONTRACTE_AG add constraint contr_ag_pk_id primary key (id_client, id_cultura);
alter table CONTRACTE_AG add constraint contr_ag_fk_id_cli foreign key (id_client) references CLIENTI_AG (id_client);
alter table CONTRACTE_AG add constraint contr_ag_fk_id_cult foreign key (id_cultura) references CULTURI (id_cultura);
alter table CONTRACTE_AG add constraint contr_ag_nn_data check (data_contract is not null);
alter table CONTRACTE_AG add constraint contr_ag_nn_contr check (nr_contract is not null);

select * from user_constraints where table_name = 'CONTRACTE_AG';


-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (1, 'Anghelescu', 'Mihai', '5011821786333', to_date('17-06-2021','dd-mm-yyyy'), 3400, '0764374331', 'mih_ang@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (2, 'Popescu', 'Constantin', '5163914001742', to_date('01-08-2017','dd-mm-yyyy'), 3000, '0742763172', 'pop_ctt@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (3, 'Madescu', 'Marian', '5026862457810', to_date('26-11-2013','dd-mm-yyyy'),5600, '0772162354', 'mari_mad@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (4, 'Ghinea', 'Cristina', '2178956121500', to_date('07-02-2015','dd-mm-yyyy'), 4200, '0782555348', 'ghi.cris@gmail.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (5, 'Dinu', 'Valentin', '5167536001526', to_date('20-09-2020','dd-mm-yyyy'), 2500, '0771900235', 'vali.din@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (6, 'Popescu', 'Mihaela', '2163967129302', to_date('17-03-2016','dd-mm-yyyy'), 3100, '0733462117', 'pope_miha@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (7, 'Barbu', 'Bogdan', '5219263299103', to_date('25-04-2012','dd-mm-yyyy'),5000, '0722175344', 'bar.bog@gmail.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (8, 'Lungu', 'Raluca', '2111046119352', to_date('30-08-2010','dd-mm-yyyy'), 6000, '0762911571', 'ral.lu@gmail.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (9, 'Iordache', 'Elena', '2143913021782', to_date('29-11-2012','dd-mm-yyyy'), 2600, '0798352187', 'eli_io@yahoo.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (10, 'Ciotoianu', 'Catalin', '512395620163', to_date('14-08-2018','dd-mm-yyyy'), 3400, '0736724391', 'cata.ci@gmail.com');
insert into muncitori (id_muncitor, nume, prenume, cnp, data_angajare, salariu, telefon, email) values (11, 'Paun', 'Viorel', '5173544076742', to_date('01-08-2019','dd-mm-yyyy'), 3000, '0746529632', 'vio.p@yahoo.com');

select * from muncitori;


-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D

insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (1, 'Mitru', 'Stefan', '5912821385321', 400, '0723553123', 'mitru_s@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (2, 'Necsu', 'Adrian', '5313825678912', 4000, '0755666777', 'necsu_a@yahoo.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (3, 'Mihai', 'Micu', '575201837266', 900, '0775413893', 'mihai.m@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (4, 'Dumitru', 'Aida', '2649246734183', 1000, '0754321895', 'aida.d@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (5, 'Brancoveanu', 'Gheorghe', '57643295583164',1600, '0765432893', 'ghe.brv@yahoo.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (6, 'Marton', 'Ofelia', '2648245699431', 300, '0765321899', 'm.ofe@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (7, 'Conea', 'George', '5763017342995', 1400, '0726743297', 'ge_con@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (8, 'Manea', 'Adrian', '5835126730264', 200, '0785643211', 'manea.ad@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (9, 'Zimbru', 'Simona', '2854304417389', 700, '0787329410', 'zimb.simo@yahoo.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (10, 'Negoiu', 'Costin', '5432895641994', 500, '0764321977', 'cos_neg@gmail.com');
insert into arendatori (id_arendator, nume, prenume, cnp, val_arenda, telefon, email) values (11, 'Damian', 'Alexandru', '5452871443822', 1900, '0754345211', 'dam.alex@gmail.com');

select * from arendatori;


-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into culturi (id_cultura, nume, pret) values (1, 'Porumb PJ4563K', 743);
insert into culturi (id_cultura, nume, pret) values (2, 'Orz PF4282F', 500);
insert into culturi (id_cultura, nume, pret) values (3, 'Fl-Soarelui FS345HH', 1100);
insert into culturi (id_cultura, nume, pret) values (4, 'Porumb KGY345U', 384);
insert into culturi (id_cultura, nume, pret) values (5, 'Grau HS851EC', 920);
insert into culturi (id_cultura, nume, pret) values (6, 'Fl-Soarelui FD234KI', 625);
insert into culturi (id_cultura, nume, pret) values (7, 'Porumb PI6213RR', 819);
insert into culturi (id_cultura, nume, pret) values (8, 'Grau GR3417YY', 723);
insert into culturi (id_cultura, nume, pret) values (9, 'Porumb GFG364RO',444);
insert into culturi (id_cultura, nume, pret) values (10, 'Orz Ph47563L', 856);
insert into culturi (id_cultura, nume, pret) values (11, 'Grau GR438VB', 473);

select * from culturi;



-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (1, 11, 2, '44.780426, 26.732352', 0.6);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (2, 2, 2, '44.123456, 26.654321', 9);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (3, 2, 1, '44.145256, 26.432334', 5);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (4, 3, 7, '44.653982, 26.209745', 7);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (5, 5, 3, '44.376457, 26.953640', 5);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (6, 8, 9, '44.643987, 26.093276', 0.3);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (7, 1, 4, '44.574276, 26.093254',0.7);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (8, 6, 6, '44.653952, 26.726121', 6);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (9, 9, 11, '44.529465, 26.980021', 2);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (10, 4, 8, '44.2176546, 26.209854', 1);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (11, 7, 10, '44.654354, 26.345217', 0.9);
insert into terenuri_agricole (id_teren, id_arendator, id_cultura, coordonate_gps, suprafata) values (12, 10, 5, '44.987678, 26.212365',4);

select * from terenuri_agricole;



-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (3, 2, to_date('12-03-2023','dd-mm-yyyy'), 'discuit');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (1, 2, to_date('12-03-2023','dd-mm-yyyy'), 'arat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (2, 2, to_date('24-03-2023','dd-mm-yyyy'), 'semanat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (4, 2, to_date('24-03-2023','dd-mm-yyyy'), 'azotat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (5, 2, to_date('04-05-2023','dd-mm-yyyy'), 'erbicidat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (11, 1, to_date('26-06-2023','dd-mm-yyyy'), 'recoltat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (7, 1, to_date('26-06-2023','dd-mm-yyyy'), 'transport');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (9, 1, to_date('26-06-2023','dd-mm-yyyy'), 'recoltat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (4, 1, to_date('26-06-2023','dd-mm-yyyy'), 'transport');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (10, 1, to_date('27-06-2023','dd-mm-yyyy'), 'arat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (6, 9, to_date('10-07-2023','dd-mm-yyyy'), 'ierbicidat');
insert into planificare_activitati (id_muncitor, id_teren, data_activitate, tip_activitate) values (7, 5, to_date('15-07-2023','dd-mm-yyyy'), 'ierbicidat');

select * from planificare_activitati;



-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (1, 'pj', 15846735, null, 'SC GRANE SRL', null, '0722654790', 'grane@yahoo.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (2, 'pj', 54357653, null, 'SC HEALTHYEAT SRL', null, '0711111111', 'healthyeat@yahoo.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (3, 'pf', null, '5478656512134', 'Sitighiu', 'Miron', '0748574286', null);
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (4, 'pf', null, '2857387920672', 'Aeron', 'Zenobia', '0748672123', null);
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (5, 'pj', 65398712, null, 'SC CORN SRL', null, '0765473411', 'cornsrl@gmail.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (6, 'pj', 98716430, null, 'SC HAPPYFOOD SRL', null, '0765432987', 'happy.food@yahoo.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (7, 'pj', 54298712, null, 'SC GOODFOOD SRL', null, '0723541849', 'good.food@gmail.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (8, 'pj', 26354939, null, 'SC GRAU SRL', null, '0755231900', 'grau@yahoo.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (9, 'pj', 34290298, null, 'SC FOODY SRL', null, '0755432776', 'foody@gmail.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (10, 'pj', 13167820, null, 'SC MIX SRL', null, '0722654790', 'mix_food@yahoo.com');
insert into clienti_ag (id_client, tip, cui, cnp, nume, prenume, telefon, email) values (11, 'pf', null, '5573419362435', 'Bodirlau', 'Marian', '0755432123', null);

select * from clienti_ag;



-- 5.	Ad?ugarea (min 10, max 15) de înregistr?ri în fiecare tabel? (1p)   GHITA VALENTIN  1053 D
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (1, 3, to_date('07-08-2022','dd-mm-yyyy'), 26, 3000, 5);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (2, 7, to_date('17-08-2022','dd-mm-yyyy'), 27, 3900, 6);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (3, 11, to_date('27-08-2022','dd-mm-yyyy'), 28, 600, 0.5);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (4, 10, to_date('02-09-2022','dd-mm-yyyy'), 29, 900, 0.8);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (5,7, to_date('18-09-2022','dd-mm-yyyy'), 30, 8000, 10);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (6, 4, to_date('30-09-2022','dd-mm-yyyy'), 31, 10000, 12);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (7, 9, to_date('10-10-2022','dd-mm-yyyy'), 32, 4000, 6);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (8, 3, to_date('28-10-2022','dd-mm-yyyy'), 33, 20000, 22);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (9, 2, to_date('05-11-2022','dd-mm-yyyy'), 34, 5000, 7);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (10, 11, to_date('07-12-2022','dd-mm-yyyy'), 35, 9000, 11);
insert into contracte_ag (id_client, id_cultura, data_contract, nr_contract, valoare, cantitate_vanduta ) values (11, 6, to_date('03-01-2023','dd-mm-yyyy'), 36,32000, 34);

select * from contracte_ag;


commit;




--6.	Actualizarea inregistrarilor (1p)   GHITA VALENTIN  1053 D
--marim salariul tuturor angajatilor cu 5%
update Muncitori
set salariu = salariu * 1.05;

select salariu from muncitori;

--actualizam mailul clientului cu id-ul = 3
update Clienti_Ag
set email = 'stg_mir@yahoo.com'
where id_client = 3;

select email from clienti_ag
where id_client = 3;

commit;
--6.	Actualizarea inregistrarilor (1p)   GHITA VALENTIN  1053 D

--stergem inregistrarea cu id_cultura = 50 (pe care mai intai o cream) din tabela Culturi
insert into CULTURI (id_cultura) values (50);

delete from Culturi
where id_cultura = 50;

select * from culturi;


--6.	Actualizarea inregistrarilor (1p)   GHITA VALENTIN  1053 D
--crestem val_arenda persoanei cu numele Brancoveanu Gheorghe cu 5% din val_arenda a celei mai mari (max) valori din tabela
update Arendatori
set val_arenda = val_arenda + (select MAX(val_arenda) * 0.05 from Arendatori)
where nume = 'Brancoveanu' and prenume = 'Gheorghe';

select * from arendatori;
rollback; --pt a anula o tranzactie


--7.	Stergerea si recuperarea unei tabele (1p)   GHITA VALENTIN  1053 D

drop table muncitori cascade constraints; --asa stergem o tabela in ciuda restrictiilor de care depinde baza de date

flashback table muncitori to before drop; --asa recuperam tabela stearsa

select * from muncitori;


/*8.	Exemple de interog?ri variate (min 20) – inclunzând ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, 
cereri imbricate, diverse func?ii single-row, functii de grup, structuri ierarhice, jonctiuni. (1,5p)
                                GHITA VALENTIN                  1053 D*/
--8.1 jonctiune
SELECT muncitori.nume, muncitori.prenume, terenuri_agricole.id_teren, terenuri_agricole.suprafata, planificare_activitati.tip_activitate
FROM muncitori
JOIN planificare_activitati
ON muncitori.id_muncitor = planificare_activitati.id_muncitor
JOIN terenuri_agricole
ON planificare_activitati.id_teren = terenuri_agricole.id_teren;


/*8.	Exemple de interog?ri variate (min 20) – inclunzând ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, 
cereri imbricate, diverse func?ii single-row, functii de grup, structuri ierarhice, jonctiuni. (1,5p)
                                GHITA VALENTIN                  1053 D*/
--8.2 jonctiune + functie de grup       --de ex, in cazul lui Necsu, cele 2 suprafete ii sunt adaugate sub una singura
SELECT arendatori.nume, SUM(terenuri_agricole.suprafata) as "Total Area"
FROM arendatori
JOIN terenuri_agricole
ON arendatori.id_arendator = terenuri_agricole.id_arendator
GROUP BY arendatori.nume;

/*8.	Exemple de interog?ri variate (min 20) – inclunzând ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, 
cereri imbricate, diverse func?ii single-row, functii de grup, structuri ierarhice, jonctiuni. (1,5p)
                                GHITA VALENTIN                  1053 D*/
--8.3 --utilizam UNION =>ontinem lista de nume prenume si email a tuturor muncitorilor si arendatorilor
(SELECT nume, prenume, email FROM muncitori)
UNION
(SELECT nume, prenume, email FROM arendatori);

--8.4 --INTERSECT => obtienm mincitorii care au lucrat si pe teren 1 si pe teren 2
(SELECT id_muncitor FROM planificare_activitati WHERE id_teren = 1)
INTERSECT
(SELECT id_muncitor FROM planificare_activitati WHERE id_teren = 2);

--8.5 --MINUS -> pt a afla cine a lucrat pe terenul 1 dar nu a lucrat pe terenul 2 
(SELECT id_muncitor FROM planificare_activitati WHERE id_teren = 1)
MINUS
(SELECT id_muncitor FROM planificare_activitati WHERE id_teren = 2);

/*8.	Exemple de interog?ri variate (min 20) – inclunzând ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, 
cereri imbricate, diverse func?ii single-row, functii de grup, structuri ierarhice, jonctiuni. (1,5p)
                                GHITA VALENTIN                  1053 D*/
--8.6 ->CASE ->incadram salariile muncitorilor in functie de valoarea acestora
SELECT nume, prenume,
CASE
  WHEN salariu < 2800 THEN 'Mic'
  WHEN salariu BETWEEN 2000 and 6000 THEN 'Mediu'
  WHEN salariu > 6000 THEN 'Mare'
END AS "Categorie salariu"
FROM muncitori;

--8.7 --single row functions -> LOWER si UPPER
SELECT UPPER(nume) from ARENDATORI where LOWER(nume) in ('dumitru','necsu');

--8.8
SELECT nume, val_arenda, 
       CASE 
         WHEN val_arenda < 1000 THEN 'putin'
         WHEN val_arenda >= 1000 THEN 'mult'
       END AS "Suprafata_Pamant"
FROM arendatori;

/*8.	Exemple de interog?ri variate (min 20) – inclunzând ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, 
cereri imbricate, diverse func?ii single-row, functii de grup, structuri ierarhice, jonctiuni. (1,5p)
                                GHITA VALENTIN                  1053 D*/
--8.9 --DECODE
SELECT nume, prenume, 
       DECODE(tip_activitate,
              'arat','Ingrijit pamantul',
              'discuit','Ingrijit pamantul',
              'transport','Profit',
              'recoltat', 'Profit',
              'ierbicidat', 'Ingrijit cultura') AS "Tip Activitate"
FROM muncitori m, planificare_activitati pa
WHERE m.id_muncitor = pa.id_muncitor;
--GHITA VALENTIN                  1053 D*/
--8.10 --ce cultura se afla pe terenul/terenurile arendatorului cu id 2
SELECT c.nume as Cultura
FROM culturi c 
JOIN terenuri_agricole ta ON c.id_cultura = ta.id_cultura 
JOIN arendatori a ON ta.id_arendator = a.id_arendator
WHERE a.id_arendator = 2;

--8.11 --valoare totala pt contractele cu persoane fizice
SELECT SUM(c.valoare) as Total_valoare
FROM contracte_ag c
JOIN clienti_ag ca ON c.id_client = ca.id_client
WHERE ca.tip = 'pf'
GROUP BY ca.tip;

--8.12 GHITA VALENTIN 1053D
SELECT nume, pret,
CASE
  WHEN pret < 400 THEN 'Mic'
  WHEN pret BETWEEN 400 and 800 THEN 'Mediu'
  WHEN pret > 800 THEN 'Mare'
END AS "Categorie pret seminte"
FROM Culturi;

--8.13 --valoare totala pt contractele cu persoane juridice GHITA VALENTIN 1053D
SELECT SUM(c.valoare) as Total_valoare
FROM contracte_ag c
JOIN clienti_ag ca ON c.id_client = ca.id_client
WHERE ca.tip = 'pj'
GROUP BY ca.tip;

--8.14 GHITA VALENTIN 1053D
SELECT c.nume as Cultura
FROM culturi c 
JOIN terenuri_agricole ta ON c.id_cultura = ta.id_cultura 
JOIN arendatori a ON ta.id_arendator = a.id_arendator
WHERE a.id_arendator = 6;











--9.	Gestiunea altor obiecte ale bazei de date: vederi, indecsi, sinonime, secvente. (1p)
--  GHITA VALENTIN  1053 D

--cream o vedere pentru arendatorii carora le datoram multi bani
create or replace view v_arendatori as select * from arendatori where val_arenda >= 1000
with read only; --nu dorim sa facem update-uri din greseala

select * from v_arendatori;
select COUNT(val_arenda) from v_arendatori; --va afisa 5, adica numarul total de val_arenda care trebuie platite de catre firma

--stergem vederea
drop view v_arendatori;

--9.	Gestiunea altor obiecte ale bazei de date: vederi, indecsi, sinonime, secvente. (1p)
--  GHITA VALENTIN  1053 D

--create index
create index contracte_valoare on Contracte_Ag(valoare);

select * from user_indexes where table_name = 'CONTRACTE_AG';
--stergere index
drop index contracte_valoare;

--creare sinonim
create synonym ar for arendatori;

select min(val_arenda) from ar; --va afisa 200
select * from ar;

--stergere sinonim
drop synonym ar;

--9.	Gestiunea altor obiecte ale bazei de date: vederi, indecsi, sinonime, secvente. (1p)
--  GHITA VALENTIN  1053 D

--cream secventa
create sequence seq_clienti_ag start with 15 increment by 5 maxvalue 100;

select * from clienti_ag;

insert into clienti_ag values(seq_clienti_ag.nextval, null, null, null, null, null, null, null); --generam id-uri

alter sequence seq_clienti_ag maxvalue 100000;
alter sequence seq_clienti_ag increment by 100;

select seq_clienti_ag.currval from dual; --val curenta unde a ajuns secventa;


--stergem secventa
drop sequence seq_clienti_ag;


delete from clienti_ag where id_client>11;
select * from clienti_ag;


