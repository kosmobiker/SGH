--From SQL-wstep.txt   
--1. Pokaż nazwiska i stanowiska pracowników

SELECT LAST_NAME, JOB_ID
FROM employees;

--2. Pokaż nazwy departamentów i numery ich kierowników

SELECT DEPARTMENT_NAME, MANAGER_ID
FROM departments;

/*3.Pokaż nazwiska i numery pracowników oraz
 ich zarobki kwartalne (pensja i prowizja). Zadbaj o 
 nazwy alias dla kolumn*/

SELECT LAST_NAME, EMPLOYEE_ID, 3*(SALARY+ NVL(COMMISSION_PCT*SALARY, 0)) AS planned_salary
FROM employees;

/*4 Pokaż nazwiska i stanowiska pracowników oraz obecne 
  i przyszłe pensje po planowanej podwyżce o 10%.*/

SELECT LAST_NAME, JOB_ID, SALARY as current_salary, 1.1*SALARY  AS planned_salary
FROM employees;

--From SQL-where.txt 
--1. Podaj nazwiska i stanowiska osób z departamentu 50, które zarabiaja więcej niż 3000

SELECT LAST_NAME, JOB_ID
FROM employees
WHERE DEPARTMENT_ID = 50 AND SALARY >= 3000;


/*3. Kto nie jest urzędnikiem (urzędnik ma w id stanowiska słowo 
   CLERK w dowolnym miejscu)*/

SELECT *
FROM employees
WHERE HIRE_DATE NOT LIKE '%clerk%';

--4. Kto był zatrudniony w 1993 roku

SELECT *
FROM employees
WHERE EXTRACT(YEAR FROM HIRE_DATE)  = 1993;

--5. Kto był zatrudniony po 1 stycznia 1993

SELECT *
FROM employees
WHERE HIRE_DATE > '1-Jan-1993';

--6. Pokaż dane pracowników z departamentu 10 i 90

SELECT *
FROM employees
WHERE DEPARTMENT_ID IN (10, 90);

--7. Pokaż osoby znajdujące się na liście alfabetycznej przed Kingiem

SELECT *
FROM employees
WHERE REGEXP_LIKE(LAST_NAME, '[A-J].+')
ORDER BY LAST_NAME;

--8. Kto nie pobiera prowizji?

SELECT *
FROM employees
WHERE BONUS IS NULL;

--9. kto pobiera prowizję?

SELECT *
FROM employees
WHERE COMMISSION_PCT IS NULL;

--10. Kto ma nazwisko 4-literowe zaczynające się na "K"

SELECT *
FROM employees
WHERE LAST_NAME LIKE 'K___';

--11. Kto zarabia więcej niż 5000 i mniej niż 10000

SELECT *
FROM employees
WHERE SALARY BETWEEN 5000 AND 10000;