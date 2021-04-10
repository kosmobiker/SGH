/*1. Pokaż dane pracowników zaczynając od tego, który ma 
   najmniejszą pensję*/
SELECT * FROM Employees
ORDER BY salary;

/*2. Pokaż dane pracowników z departamentu 50, zaczynając od 
osoby najdłużej pracującej*/
SELECT * FROM Employees
WHERE DEPARTMENT_ID = 50
ORDER BY HIRE_DATE;

/*4. Pokaż stanowiska pracowników na 3 sposoby: tak jak są 
   przechowywane w bazie, małymi literami i wielkim literami*/
SELECT JOB_TITLE, lower(JOB_TITLE), upper(JOB_TITLE) 
FROM Jobs;

/*5. Zbuduj kod dla każdego pracownika złożony z dwóch pierwszych
   liter nazwiska, numeru departamentu i pierwszej litery 
   stanowiska*/
SELECT SUBSTR(LAST_NAME, 1, 2)||DEPARTMENT_ID||SUBSTR(JOB_TITLE, 1, 1)
FROM Employees
JOIN Jobs ON Jobs.JOB_ID = Employees.JOB_ID;

/*6. Kto ma w nazwisku litery le jako czwartą i piątą?*/
SELECT *
FROM Employees
WHERE SUBSTR(LAST_NAME, 4, 2) = 'le';

/*7. Pokaż dane osób, których nazwisko jest więcej niż 4-ro 
   literowe*/
SELECT *
FROM Employees
WHERE LENGTH(LAST_NAME) > 4;

/*8.Pokaż nazwiska,pensje pracowników z departamentu 50 oraz policz
   dla nich premie jako 7,5% pensji. Premię nalezy zaokrąglić do pełnych
   dziesiątek groszy.*/
SELECT LAST_NAME, SALARY, TO_CHAR(ROUND(SALARY*0.075, 2), '999999.99') AS BONUS
FROM Employees
WHERE LENGTH(LAST_NAME) > 4;

/*9. Ile dni przepracowali sprzedawcy (SA na poczatku kodu stanowiska)? 
    Wynik pokaż jako liczbę całkowitą (wykonaj zaokrąglenie).*/
SELECT LAST_NAME, ROUND((CURRENT_DATE - HIRE_DATE),0)
FROM Employees
WHERE JOB_ID LIKE 'SA_%';

/*10. Ile miesięcy (w zaokrągleniu do liczby całkowitej) przepracowali programiści (IT na poczatku)? */
SELECT LAST_NAME, ROUND((CURRENT_DATE - HIRE_DATE),0)
FROM Employees
WHERE JOB_ID LIKE 'IT_%';

/*11. Ile lat ((w zaokrągleniu do części dziesiętnej) przepracowały osoby z pensją wyższą niż 8000?*/
SELECT LAST_NAME, ROUND(MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE)/12, 1)
FROM Employees
WHERE SALARY > 8000;

/*12. Jakiego dnia tygodnia zatrudniono Matosa?*/
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DAY')
FROM Employees
WHERE LAST_NAME = 'Matos';

/*13. Pokaż nazwiska pracowników i numery ich szefów. Dla pracowników, 
    którzy nie mają szefa wyświetl '***'*/
SELECT LAST_NAME, NVL(TO_CHAR(MANAGER_ID), '***')
FROM Employees;

