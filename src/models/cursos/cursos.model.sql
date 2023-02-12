--====================================================================================--
-- Funcion crear curso - Profesor - modified
--====================================================================================--

create or replace function saveCourse(id_usr_prf int, input_grado varchar, input_paralelo varchar) returns
	varchar
as $$
	declare
		id_p numeric := (select id_prof from profesor where id_usuario = id_usr_prf);
	begin
		insert into curso(id_prof, grado, paralelo, disabled) 
			values(id_p, input_grado, input_paralelo, false);
		return 'Curso creado con exito!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion obtener cursos con id_usuario del profesor - modified
--====================================================================================--

create or replace function getCourses(id_usr_prf int) returns 
	table(
	id_curso int,
	id_prof int,
	grado varchar,
	paralelo varchar,
	color varchar
	)
as $$
	declare
		id_p numeric := (select p.id_prof from profesor p where p.id_usuario = id_usr_prf);
	begin
		return query
			(select c.id_curso, c.id_prof, c.grado, c.paralelo, c.color from curso c where c.id_prof = id_p and c.disabled = false order by id_curso asc);
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion cambiar color de dashboard curso - profesor
--====================================================================================--

create or replace function cambiarColor(id_cur int, input_color varchar) returns varchar
as $$
	begin 
		update curso set color = input_color where id_curso = id_cur;
		return 'Color cambiado exitosamente!';
	end
	
$$
language plpgsql;

--====================================================================================--
-- Funcion obtener curso por id_usr_prof -modified
--====================================================================================--
create or replace function getCourseById(id_usr_prf int, id_cur int) returns
table(
	id_curso int,
	id_prof int,
	grado varchar,
	paralelo varchar,
	color varchar
	)
as $$
	declare
		id_pf numeric := (select pf.id_prof from profesor pf where pf.id_usuario = id_usr_prf);
	begin
		return query
		select c.id_curso, c.id_prof, c.grado, c.paralelo, c.color from curso c where c.id_curso = id_cur and c.disabled = false and c.id_prof = id_pf;
	end
$$
language plpgsql;

--select * from getcoursebyid(2, 9)


--====================================================================================--
-- 							Funcion eliminar curso -modified
--====================================================================================--
create or replace function deleteCourse(id_usr_prf int, id_curso_in int) returns varchar
as $$
	declare
		id_p numeric := (select id_prof from profesor where id_usuario = id_usr_prf);
	begin 
		update curso set disabled = true where id_prof = id_p and id_curso = id_curso_in;
		return 'Curso eliminado con exito!';
	end
$$
language plpgsql;


--====================================================================================--
-- 							Funcion obtener curso y Progreso
--====================================================================================--

