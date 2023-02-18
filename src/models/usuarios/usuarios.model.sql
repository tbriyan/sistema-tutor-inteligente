--====================================================================================--
-- Funcion obtener profesores por pagina -- modified
--====================================================================================--
create or replace function getPrfsByPage(id_usr_adm int, desde int, limite int) returns
	table(
	id_usuario int,
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	begin
		return query
		select pf.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        u.username, u.fecha_cre, u.path_foto
        from usuario as u, administrador as a, profesor as pf, persona as p 
        where id_usr_adm = a.id_usuario and a.id_adm = pf.id_adm and pf.id_usuario = u.id_usuario
       	and pf.disabled = false and u.id_persona = p.id_persona LIMIT limite OFFSET desde;
	end;
$$
language plpgsql;
--====================================================================================--
-- Funcion guardar profesor - modified
--====================================================================================--
create or replace function savePrf(
	id_usr int,
	nom varchar,
	ap varchar,
	am varchar,
	tel varchar,
	sex varchar, 
	username varchar,
	pass varchar) returns varchar
as $$
	declare
		--id_p := (select id_persona from usuario where id_usuario = id_usr);
		id_a numeric := (select id_adm from administrador where id_usuario = id_usr);
		id_p numeric; --id_persona nueva
		id_u numeric; --id_usuario nuevo
	begin
		--crear persona
		insert into persona(nombre, apellido1, apellido2, telefono, sexo)
			values(nom, ap, am, tel, sex) returning id_persona into id_p;
		--crear usuario
		insert into usuario(id_persona, id_rol, username, pass, fecha_cre)
			values(id_p, 2, username, pass, (select current_timestamp)) returning id_usuario into id_u;
		--crear profesor
		insert into profesor(id_usuario, id_adm, disabled) values(id_u, id_a, false);
		
		return 'Profesor creado con exito!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion actualizar profesor - modified
--====================================================================================--

create or replace function updatePrf(
	id_usr int,
	id_usr_prf int,
	nom varchar,
	ap varchar,
	am varchar,
	tel varchar,
	sex varchar) returns varchar
as $$
	declare
		id_a numeric := (select id_adm from administrador where id_usuario = id_usr);
		id_p numeric := (select id_persona from usuario where id_usuario = id_usr_prf);
	begin
		if ((select count(*) from profesor where id_adm = id_a)>0)then
			--actualizar persona
			update persona
			set nombre=nom,
				apellido1=ap,
				apellido2=am,
				telefono=tel,
				sexo=sex
				where id_persona = id_p;
			return 'Profesor actualizado con exito!';
		end if;
		return 'Profesor no actualizado, ocurrio un error!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion obtener prfs por el nombre - modified
--====================================================================================--

create or replace function getPrfsByName(id_usr_adm int, args varchar) returns
	table(
		id_usuario int,
		nombre varchar,
		apellido1 varchar,
		apellido2 varchar,
		telefono varchar,
		sexo varchar,
		fecha_nac date,
		username varchar,
		fecha_cre date,
		path_photo varchar)
as $$
	declare
		id_a numeric := (select id_adm from administrador as a where a.id_usuario = id_usr_adm); 
	begin
			return query
			select pf.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
	        u.username, u.fecha_cre, u.path_foto
	        from usuario as u, profesor as pf, persona as p
	        where p.nombre like '%'||args||'%' and p.id_persona = u.id_persona 
				and u.id_usuario = pf.id_usuario and pf.disabled = false and id_a = pf.id_adm;
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion obtener profesor por username -modified
--====================================================================================--
create or replace function getPrfByUsername(id_usr_adm int, usernamex varchar) returns
table(
		id_usuario int,
		nombre varchar,
		apellido1 varchar,
		apellido2 varchar,
		telefono varchar,
		sexo varchar,
		fecha_nac date,
		username varchar,
		fecha_cre date,
		path_photo varchar)
as $$
	declare
		id_a numeric := (select id_adm from administrador as a where a.id_usuario = id_usr_adm); 
	begin
		return query
		select pf.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        u.username, u.fecha_cre, u.path_foto
        from usuario as u, administrador as a, profesor as pf, persona as p 
        where pf.id_adm = id_a and u.username like usernamex and pf.id_adm = a.id_adm
       		and pf.id_usuario = u.id_usuario and pf.disabled = false and u.id_persona = p.id_persona;
	end
	
$$
language plpgsql;
--select * from getprfByUsername(1, 'bmendozaa');
--select * from getprfByUsername(1, 'stintaa');

--====================================================================================--
-- Funcion obtener profesor por id
--====================================================================================--
create or replace function getPrfById(id_usr_adm int, id_usr_prf int) returns
table(
		id_usuario int,
		nombre varchar,
		apellido1 varchar,
		apellido2 varchar,
		telefono varchar,
		sexo varchar,
		fecha_nac date,
		username varchar,
		fecha_cre date,
		path_photo varchar)
as $$
	declare
		id_a numeric := (select id_adm from administrador as a where a.id_usuario = id_usr_adm); 
	begin
		return query
		select pf.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        u.username, u.fecha_cre, u.path_foto
        from usuario as u, administrador as a, profesor as pf, persona as p 
        where pf.id_adm = id_a and u.id_usuario = id_usr_prf and pf.id_adm = a.id_adm
       		and pf.id_usuario = u.id_usuario and u.id_persona = p.id_persona;
	end
	
$$
language plpgsql;
--select * from getprfbyid(1, 3);
--====================================================================================--
-- Funcion resetear contraseña de profesor
--====================================================================================--

create or replace function resetPassPrf(id_usr_adm int, id_usr_prf int, pass_prf varchar) returns varchar
as $$
	declare
		id_a numeric := (select id_adm from administrador where id_usuario = id_usr_adm);
	begin
		if((select count(*) from profesor p where p.id_adm = id_a)>0)then
			update usuario 
			set pass=pass_prf 
			where id_usuario = id_usr_prf;
			return 'Contraseña reestablecida con exito!';
		end if; 
		return 'No se reestablecio, ocurrio un error!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion obtener el numero de paginas del total de profesores - modified
--====================================================================================--

create or replace function totalPrfs(id_usr_adm int) returns int
as $$
	declare
		num_pages numeric;
	begin
		num_pages := (select count(*)
        from usuario as u, administrador as a, profesor as pf, persona as p 
        where id_usr_adm = a.id_usuario and a.id_adm = pf.id_adm 
			and pf.id_usuario = u.id_usuario and pf.disabled = false and u.id_persona = p.id_persona);
    	return num_pages;
	end
$$
language plpgsql;

--select totalPrfs(2);

--====================================================================================--
-- 								Funcion eliminar profesor
--====================================================================================--
create or replace function eliminarPrf(id_usr_adm int, id_usr_prf int) returns varchar
as $$
	declare 
		id_p numeric := (select id_prof from profesor p where p.id_usuario = id_usr_prf);
		id_a numeric := (select id_adm from administrador where id_usuario = id_usr_adm);
	begin 
		if (select count(*) from administrador a where a.id_adm = id_a)>0 then
			update profesor set disabled = true where id_prof = id_p;
			return 'Profesor eliminado con exito!';
		end if;
		return 'Profesor no encontrado!';
	end
$$
language plpgsql;




--------------------------------------ESTUDIANTES--------------------------------------------





--====================================================================================--
-- Funcion crear estudiante - modified
--====================================================================================--
create or replace function saveEst(
	id_usr_pf int,
	id_cur int,
	nom varchar,
	ap varchar,
	am varchar,
	tel varchar,
	sex varchar, 
	username varchar,
	pass varchar) returns varchar
as $$
	declare
		id_pf numeric := (select id_prof from profesor p where p.id_usuario = id_usr_pf);
		id_p numeric;
		id_u numeric;
		id_e numeric;
	begin
		--create persona
		insert into persona(nombre, apellido1, apellido2, telefono, sexo)
			values(nom, ap, am, tel, sex) returning id_persona into id_p;
		--create usuario
		insert into usuario(id_persona, id_rol, username, pass, fecha_cre)
			values(id_p, 3, username, pass, (select current_timestamp)) returning id_usuario into id_u;
		--create estudiante
		insert into estudiante(id_usuario, id_prof, id_curso, disabled) 
			values(id_u, id_pf, id_cur, false) returning id_estudiante into id_e;
		--Cambiar a Whiles o Fors cuando se pueda
		--=========MODULO ESTUDIANTE - TUTOR=========
		--====================Asignar Lecciones al Estudiante==================
		insert into estudiante_leccion(id_estudiante, id_leccion) values (id_e, 1);
		insert into estudiante_leccion(id_estudiante, id_leccion) values (id_e, 2);
		
		--====================Asignar Temas al Estudiante==================
		
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 1);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 2);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 3);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 4);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 5);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 6);
		insert into estudiante_tema(id_estudiante, id_tema) values (id_e, 7);
	
		--====================Asignar Ejercicios al Estudiante==================
		insert into estudiante_ejercicio(id_estudiante, id_ejercicio) values (id_e, 1);
		insert into estudiante_ejercicio(id_estudiante, id_ejercicio) values (id_e, 2);
		
		return 'Estudiante creado con exito!';
	end
$$
language plpgsql;


--====================================================================================--
-- Funcion obtener estudiantes por pagina de un curso especifico - modified
--====================================================================================--

create or replace function getEstsByPage(id_usr_prf int, desde int, limite int, input_curso int)
returns table(
	id_usuario int,
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	declare
		id_p numeric := (select id_prof from profesor p where p.id_usuario = id_usr_prf);
	begin
		return query
		select ue.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        	u.username, u.fecha_cre, u.path_foto
			from persona p, usuario u , profesor pf, (select e.id_usuario from estudiante e, curso c
			where input_curso = c.id_curso and c.id_curso = e.id_curso and e.disabled = false) ue
		where pf.id_usuario = id_usr_prf and u.id_usuario = ue.id_usuario and u.id_persona = p.id_persona
		order by ue.id_usuario asc
		limit limite offset desde;
	end;
	$$
language plpgsql;

--select * from getestsbypage(2, 0, 5, 10) 


--====================================================================================--
-- Funcion obtener el numero de paginas del total de estudiantes de un curso especifico - modified
--====================================================================================--

create or replace function totalEsts(id_usr_prf int, input_curso int) returns int
as $$
	declare
		total numeric;
	begin
    	total := (select count(*)
		from persona p, usuario u , profesor pf, (select e.id_usuario from estudiante e, curso c
													where input_curso = c.id_curso and c.id_curso = e.id_curso and e.disabled = false) ue
		where pf.id_usuario = id_usr_prf and u.id_usuario = ue.id_usuario and u.id_persona = p.id_persona);
 		return total;
	end
$$
language plpgsql;

--select totalEsts(2, 10);


--====================================================================================--
-- Funcion obtener estudiante por id de un curso determinado - modified
--====================================================================================--
--select * from getestbyid(2, 64, 9);

create or replace function getEstById(id_usr_pf int, id_usr_est int, id_curso_in int)
returns table(
	id_usuario int,
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	declare
		id_pf numeric := (select id_prof from profesor p where p.id_usuario = id_usr_pf);
		id_es numeric := (select id_estudiante from estudiante e where e.id_usuario = id_usr_est);
	begin
		return query
		(select e.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
			u.username , u.fecha_cre, u.path_foto 
			from estudiante e, usuario u, persona p
			where e.id_prof = id_pf and e.id_curso = id_curso_in and e.id_estudiante = id_es
				and e.disabled = false and e.id_usuario = u.id_usuario and u.id_persona = p.id_persona);
	end
$$
language plpgsql;


--====================================================================================--
-- Funcion actualizar estudiante de un curso determinado 
--====================================================================================--

create or replace function updateEst(
	id_usr_prf int,
	id_usr_est int,
	id_cur int,
	nom varchar,
	ap varchar,
	am varchar,
	tel varchar,
	sex varchar) returns varchar
as $$
	declare 
		id_prf numeric := (select id_prof from profesor pf where pf.id_usuario = id_usr_prf);
		id_est numeric := (select id_estudiante from estudiante e where e.id_usuario = id_usr_est);
	begin 
		update persona p
			set 
			nombre=nom,
			apellido1=ap,
			apellido2=am,
			telefono=tel,
			sexo=sex
		where p.id_persona = 
				(select pe.id_persona from persona pe, usuario u, estudiante e
					where e.id_estudiante = id_est and e.id_prof = id_prf
						and e.id_curso = id_cur and e.id_usuario = u.id_usuario and u.id_persona = pe.id_persona);
		return 'Estudiante actualizado con exito!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion buscar estudiante por nombre de determinado curso - modified
--====================================================================================--
--select * from getestsbyname(2, 9, 'e');

create or replace function getEstsByName(id_usr_prf int, id_curso_in int, args varchar) returns
table(
	id_usuario int,
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	declare
		id_pf numeric := (select id_prof from profesor pf where pf.id_usuario = id_usr_prf);
	begin
		return query
		select e.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
	        u.username, u.fecha_cre, u.path_foto
	    from persona p, usuario u, estudiante e
	    where e.id_prof = id_pf and e.id_curso = id_curso_in and e.disabled = false and e.id_usuario = u.id_usuario 
	   		and u.id_persona = p.id_persona and p.nombre like '%'||args||'%'
	   	order by e.id_usuario asc;
	end
$$
language plpgsql;


--====================================================================================--
-- Funcion obtener estudiante por username - modified
--====================================================================================--
--select * from getestbyusername(2, 'eperezs');
create or replace function getEstByUsername(id_usr_prf int, usernamex varchar) returns
table(
	id_usuario int,
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	declare
		id_pf numeric := (select id_prof from profesor pf where pf.id_usuario = id_usr_prf);
	begin
		return query
		select e.id_usuario, p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        u.username, u.fecha_cre, u.path_foto
        from usuario as u,  estudiante as e, persona as p 
        where e.id_prof = id_pf and e.id_usuario = u.id_usuario and e.disabled = false and u.id_persona = p.id_persona
        	and u.username like usernamex;
	end
	
$$
language plpgsql;

--====================================================================================--
-- Funcion resetear contraseña estudiante - modified
--====================================================================================--

create or replace function resetPassEst(id_usr_prf int, id_usr_est int, pass_est varchar) returns varchar
as $$
	declare
		id_pf numeric := (select id_prof from profesor pf where pf.id_usuario = id_usr_prf);
	begin
		if((select count(*) from estudiante e where e.id_prof = id_pf)>0)then
			update usuario 
			set pass=pass_est 
			where id_usuario = id_usr_est;
			return 'Contraseña reestablecida con exito!';
		end if; 
		return 'No se reestablecio, ocurrio un error!';
	end
$$
language plpgsql;

--====================================================================================--
					-- Eliminar estudiante - modified
--====================================================================================--

create or replace function eliminarEst(id_usr_prf int, id_usr_est int) returns varchar
as $$
	declare 
	id_p numeric := (select id_prof from profesor where id_usuario = id_usr_prf);
	id_e numeric := (select id_estudiante from estudiante where id_usuario = id_usr_est);
	begin 
		if (select count(*) from profesor p where p.id_prof = id_p)>0 then
			update estudiante set disabled = true where id_estudiante = id_e;
			return 'Estudiante eliminado con exito!';
		end if;
		return 'Estudiante no encontrado!';	
	end
	
$$
language plpgsql;

----------------------------------------PERFIL DE USUARIO------------------------


--====================================================================================--
-- Funcion obtener datos de usuario
--====================================================================================--

create or replace function getSelf(id_usr int) returns
table(
	nombre varchar,
	apellido1 varchar,
	apellido2 varchar,
	telefono varchar,
	sexo varchar,
	fecha_nac date,
	username varchar,
	fecha_cre date,
	path_photo varchar)
as $$
	begin
		return query
		select p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac,
        u.username, u.fecha_cre, u.path_foto
        from usuario u, persona p
        where id_usr = u.id_usuario and u.id_persona = p.id_persona;
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion guardar foto de perfil
--====================================================================================--

create or replace function saveProfilePhoto(id_usr int, pathname varchar) returns void
as $$
	begin
		update usuario set path_foto = pathname where id_usuario = id_usr;
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion Guardar Nombre del perfil de usuario
--====================================================================================--

create or replace function saveName(id_usr int, i_name varchar, i_ap varchar, i_am varchar)
returns varchar
as $$
	declare
		id_p numeric := (select id_persona from usuario where id_usuario = id_usr);
	begin 
		update persona 
		set nombre = i_name, apellido1 = i_ap, apellido2 = i_am
		where id_persona = id_p;
	
		return 'Nombre actualizado correctamente!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion guardar fecha de nacimiento del perfil de usuario
--====================================================================================--

	create or replace function saveFechaNac(id_usr int, fecha date) returns varchar
	as $$
		declare 
			id_p numeric := (select id_persona from usuario where id_usuario = id_usr);
		begin 
			update persona 
			set fecha_nac = fecha
			where id_persona = id_p;
			
			return 'Fecha actualizada correctamente!';
		end
		
	$$
	language plpgsql;

--====================================================================================--
-- Funcion guardar sexo del perfil de usuario
--====================================================================================--

create or replace function saveSex(id_usr int, sex varchar) returns varchar
as $$
	declare
		id_p numeric := (select id_persona from usuario where id_usuario = id_usr);
	begin
		update persona
		set sexo = sex
		where id_persona = id_p;
	
		return 'Genero actualizado correctamente!';
	end
$$
language plpgsql;

--====================================================================================--
-- Funcion guardar telefono del perfil de usuario
--===================================================================================

create or replace function saveTel(id_usr int, tel varchar) returns varchar
as $$
	declare
		id_p numeric := (select id_persona from usuario where id_usuario = id_usr);
	begin 
		update persona
		set telefono = tel
		where id_persona = id_p;
	
		return 'Telefono actualizado correctamente!';
	end
	
$$
language plpgsql;

--====================================================================================--
-- Funcion guardar contraseña del perfil de usuario
--===================================================================================

create or replace function savePassword(id_usr int, passw varchar) returns varchar
as $$
	begin 
		update usuario
		set pass = passw
		where id_usuario = id_usr;
	
		return 'Contraseña actualizada correctamente!';
	end
$$
language plpgsql;