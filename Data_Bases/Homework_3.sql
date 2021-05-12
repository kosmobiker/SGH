/*SQL-where.txt

3. Kto nie jest urzędnikiem (urzędnik ma w id stanowiska słowo CLERK w dowolnym miejscu)*/
SELECT *
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE '%CLERK%';

/*9. kto pobiera prowizję?*/
SELECT *
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

-----------------------------------------------------------

/*SQL-fun-poj.txt

/*13. Pokaż nazwiska pracowników i numery ich szefów. Dla pracowników, 
    którzy nie mają szefa wyświetl '***'*/
SELECT LAST_NAME, NVL(TO_CHAR(MANAGER_ID), '***')
FROM EMPLOYEES;

-----------------------------------------------------------

/*Polimorf.txt

2. Pokaż nazwiska pracowników i informację o stażu pracy. Osoby zatrudnione: 
   w 1990 roku z komentarzem-długoletni pracownik
   w 2000 - nowy pracownik
   pozostali - '***'*/

SELECT LAST_NAME, HIRE_DATE, (CASE EXTRACT(YEAR FROM HIRE_DATE)
        WHEN 1990 THEN 'długoletni pracownik'
        WHEN 2000 THEN 'nowy pracownik'
        ELSE '***' END) AS KOMENTARZ
FROM EMPLOYEES;  

/*3. Wyświetl nazwiska pracowników z adnotacją SMT 
   (senior management team) dla osób bezpośrednio 
   podległych przezesowi (numer 100). Dla
   osób z niższych stanowisk wyświetl nazwy ich 
   stanowisk.*/

SELECT FIRST_NAME, LAST_NAME, (CASE MANAGER_ID 
        WHEN 100 THEN 'SMT'
        ELSE JOB_ID END) AS ADNOTACJA
FROM EMPLOYEES;

-----------------------------------------------------------

/*funkcje_grup.txt

1. Pokaż największą, najmniejszą i średnią pensję przypadającą 
na jednego pracownika*/

SELECT MIN(SALARY) as min_salary, MAX(SALARY) as max_salary, AVG(SALARY) as avg_salary
FROM EMPLOYEES;


/*2. Pokaż największą, najmniejszą i średnią pensję wypłacaną na  
poszczególnych stanowiskach pracy.*/

SELECT JOB_ID, MIN(SALARY) as min_salary, MAX(SALARY) as max_salary, AVG(SALARY) as avg_salary
FROM EMPLOYEES
GROUP BY JOB_ID;

/*3. Pokaż największą, najmniejszą i średnią pensję przypadającą 
na jednego pracownika w departamencie 50.*/

SELECT MIN(SALARY) as min_salary, MAX(SALARY) as max_salary, AVG(SALARY) as avg_salary
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 50;

/*4. Ile osób pracuje na poszczególnych stanowiskach?*/

SELECT JOB_ID, COUNT(EMPLOYEE_ID) as NUMBER_OF_EMPLOYEES
FROM EMPLOYEES
GROUP BY JOB_ID;

/*5. Ilu szefów pracuje w tej firmie, tzn. osób, które mają podwładnych. 
Analizuj kolumnę MANAGER_ID.*/

SELECT COUNT(*) AS Num_of_Bosses
FROM (SELECT COUNT(EMPLOYEE_ID)
FROM EMPLOYEES
GROUP BY MANAGER_ID);

/*6. Ile wynoszą pensje osób, które najgorzej  zarabiają u 
każdego z szefów?*/

SELECT MIN(SALARY)
FROM EMPLOYEES
GROUP BY MANAGER_ID;

/*7. Ile wynoszą pensje osób, które najgorzej  zarabiają u 
każdego z szefów? Nie pokazuj szefa z nieokreślonym numerem.*/

SELECT MANAGER_ID, MIN(SALARY)
FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID;

/*8. Ile wynoszą pensje osób, które najgorzej  zarabiają u 
każdego z szefów? Nie pokazuj szefa z nieokreślonym numerem. 
Szukam jedynie tych osób, których pensja nie przekracza 10000.*/

SELECT MANAGER_ID, MIN(SALARY)
FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL AND SALARY <= 10000
GROUP BY MANAGER_ID;

/*9. Jak jest różnica między największą i najmniejszą pensją?*/

SELECT MAX(SALARY) - MIN(SALARY)
FROM EMPLOYEES;

/*10. W których departamentach średnia pensja jest większa niż 10000?
 Pokaż tylko te departamenty, gdzie pracują więcej niż 2 osoby.*/

SELECT DEPARTMENT_ID 
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID) > 2 AND AVG(SALARY) > 10000;

/*11. Od kiedy pracują osoby z najdłuższym stażem w poszczególnych 
departamentach?*/

SELECT DEPARTMENT_ID, MIN(HIRE_DATE)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID

/*12. Pokaż najwyższe pensje menedżerów (końcówka MAN w job_id) w
 poszególnych departamentach. Wyniki posortuj zaczynając od najwyżsej pensji*/

SELECT DEPARTMENT_ID, MAX(SALARY)
FROM EMPLOYEES
WHERE JOB_ID LIKE '%MAN'
GROUP BY DEPARTMENT_ID
ORDER BY 1 DESC

/*13. Ile osób zatrudniono w poszczególnych latach: 1994, 1995, 1996*/

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS YEAR_OF_HIRING, COUNT(*) AS NUM_OF_EMP
FROM EMPLOYEES
WHERE EXTRACT(YEAR FROM HIRE_DATE) in (1994, 1995, 1996)
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)