libname music '/folders/myfolders/sasuser/Lab 6/sas_db' inencoding=any;

/*Zadanie 1*/
PROC SQL;
	create table album_list as 
	select a.name, b.title as album_name 
	from music.artist as a 
	inner join music.album as b	on a.artistID=b.artistid;
QUIT;

/*Zadanie 2*/
PROC SQL;
	create table rock_jazz  as
	select a.*, b.name as genre
	from music.track as a 
	left join music.genre as b on a.genreid=b.genreid
	where b.name in ('Rock', 'Jazz');
QUIT;

/*Zadanie 3*/
PROC SQL;
	create table artist_rj  as
	select distinct c.name, b.title, a.genre
	from rock_jazz as a 
	left join music.album as b on a.albumid=b.albumid
	left join music.artist as c	on b.artistid=c.artistid;
QUIT;

/*Zadanie 4*/

PROC SQL;
	create table managers as
	select a.EmployeeId, a.LastName, a.FirstName, a.ReportsTo, CAT(b.FirstName, b.LastName) as manager
	from music.employee as a inner join music.employee as b
	on a.ReportsTo=b.EmployeeId;
QUIT;

/*Zadanie 5*/

proc sort data=music.artist out=artists;
by artistID;
proc sort data=music.album out=albums;
by artistID;
data album_list_proc;
merge albums(in=al) artists(in=art);
by artistid;
if al and art;
run;

/*Zadanie 6*/

proc sort data=music.track out=tracks;
by genreid;
proc sort data=music.genre out=genres;
by genreid;
data rock_jazz_proc;
merge tracks (in=art) genres (in=al);
by genreid;
where name in ('Rock', 'Jazz');
if al;
run;