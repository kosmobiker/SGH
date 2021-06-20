create table ecopy 
as select *
from employees;

create table dcopy
as select *
from departments;


/*1. Wprowadź dane nowego pracownika:
     1111, Brown, zatrudniony od jutra, pensja 3500, departament 10, mail brown@onet.pl,
     stanowisko SA_REP*/

insert into ecopy
values (1111, NULL, 'Brown', 'brown@onet.pl', NULL, sysdate+1, 'SA_REP', 3500, NULL, NULL, 10, NULL);

/*2. Wprowadź dane nowego departamentu:
     numer: 30, nazwa: HR, lokalizacja: 2500*/

insert into dcopy
values (30, 'HR', NULL, 2500);

/*3. Brown będzie raportował do kierownika o numerze 200*/

update ecopy
set manager_id=200
where employee_id=1111

/*4. Pracownicy z departamentu 50 dostali podwyżkę o 100 zł*/

update ecopy
set salary = salary + 100
where department_id = 50;

/*5. Wszyscy pracownicy z lokalizacji 1800 dostali podwyżkę o 10%*/

update ecopy
set salary = salary * 1.1
where department_id in (select department_id from dcopy where location_id = 1800);

/*6. Usuń dane pracowników z departamentu 80.*/

delete from ecopy
where department_id = 80;

/*7. Wprowadż dane osób z departamentu 80 korzystając z tabeli employees*/

insert into ecopy
select *
from employees
where department_id = 80;

/*8. Usuń dane pracowników departamentu Shipping.*/

delete from ecopy
where  ecopy.department_id = (select distinct dcopy.department_id  from ecopy, dcopy
where dcopy.department_id = ecopy.department_id and dcopy.department_name like '%Shipping%');

/*1. Utwórz tabelę ZNAJOMI z kolumnami:
imie              tekst, max. 20 znaków
nazwisko          tekst, max. 40 znaków
data_ur           data
liczba_rowerow    liczba, do 99 rowerów
i wprowadź jeden wiersz*/



/*2. Utwórz tabelę SALES oraz wprowadź do niej dane sprzedawców (SA na początku kodu stanowiska)
   korzystając z tabeli employees.*/

create table SALES
(first_name varchar2(20), last_name varchar2(40), salary varchar(10));

insert into SALES
value select first_name, last_name, salary from employees where job_id like 'SA%'

/*3. Utwórz tabelę CLERKS (z kolumnami nazwisko i pensja) oraz wprowadź do niej 
   dane urzędników korzystając z tabeli employees.*/

create table clerks (nazwisko, pensja) as 
select last_name, salary from employees where job_id = 'ST_CLERK'

/*4. Wprowadź do tabeli CLERKS swoje nazwisko i pensję 7000*/

create table CLERKS
(last_name varchar2(40), salary varchar(10));

insert into CLERKS
values ('Darhevich', 7000)

/*5. Usuń tabele SALES.*/

delete sales

/*7. Utwórz pustą tabelę emp1 zgodną co do struktury z employees.*/

create table emp1
as select *
from employees