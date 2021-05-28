---LĄCZENIA

--5. Jaka jest najwyższa pensja w lokalizacji 1700?

select max(salary) 
from employees e
join departments d on e.department_id = d.department_id
where location_id = 1700;

--6. Pokaż pracowników i ich grupy zaszeregowania.

select e.last_name, e.salary, jg.grade_level
from employees e 
join job_grades jg on e.salary between jg.lowest_sal and jg.highest_sal;

---PODZAPYTANIA

--1.Pokaż nazwiska, daty zatrudnienia pracowników, którzy pracują w tym samym departamentcie co Zlotkey.

select last_name, hire_date
from employees
where department_id = (select department_id from employees where last_name = 'Zlotkey');

--2. Kto z ww pracuje dłużej od Zlotkey, ale mniej zarabia?

select last_name, hire_date, salary
from employees
where hire_date < (select hire_date from employees where last_name = 'Zlotkey') 
and salary < (select salary from employees where last_name = 'Zlotkey');

--3. Którzy pracownicy zarabiają powyżej średniej?

select last_name, salary
from employees
where salary > (SELECT avg(salary) FROM employees);

--4. Kto pracuje w jednym departamencie z prezesem (PRES w kodzie stanowiska)?

select last_name
from employees
where DEPARTMENT_ID = (select DEPARTMENT_ID
from employees
where JOB_ID like '%PRES');

--5. Kto pracuje w lokalizacji 1700 - 2 sposoby rozwiązania

select last_name 
from employees e
join departments d on e.department_id = d.department_id
where location_id = 1700;

--6. Kto raportuje do Kinga?

select last_name
from employees
where manager_id = (select employee_id from employees where last_name = 'King');

--8. Czy menedżerowie (MAN na końcu kodu stanowiska) to najlepiej opłacane stanowisko? 
--Czy ktoś zarabia więcej od któregokolwiek menedżera?

select LAST_NAME, SALARY, JOB_ID, rank() over (order by salary desc) as ranking
from employees;

select LAST_NAME
from employees
where salary > (select max(salary) from employees where JOB_ID like '%MAN');

--9. Kto z departamentu 90 był zatrudniony przed osobami pracującymi obecnie w departmencie 80?

select last_name
from employees
where hire_date < (select min(hire_date) from employees where department_id = 80) and department_id = 90