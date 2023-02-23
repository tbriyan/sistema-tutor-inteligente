--====================================================================================--
-- Funcion crear curso - Profesor - modified
--====================================================================================--

create or replace function saveCourse(id_usr_prf int, input_grado varchar, input_paralelo varchar) 
returns
	table(oestado int, omensaje varchar)
as $$
	declare
		id_p numeric := (select id_prof from profesor where id_usuario = id_usr_prf);
		oestado int;
		omensaje varchar;
	begin
		if exists(select 1 from curso c where c.grado = input_grado) then
			if exists(select 1 from curso c where c.grado = input_grado and c.paralelo = input_paralelo) then
				--verificamos si fue eliminado
				if(select 1 from curso c where c.grado = input_grado and c.paralelo = input_paralelo and c.disabled = true) then
					
					update curso
					set disabled = false
					where grado = input_grado
					and paralelo = input_paralelo;
					
					oestado := 1;
					omensaje := 'Curso creado con exito';
				else 
					oestado := 0;
					omensaje := 'El curso ya existe';
				end if;
			else
				insert into curso(id_prof, grado, paralelo, disabled) 
				values(id_p, input_grado, input_paralelo, false);
				
				oestado := 1;
				omensaje := 'Curso creado con exito';
				
			end if;
		else
			insert into curso(id_prof, grado, paralelo, disabled) 
			values(id_p, input_grado, input_paralelo, false);
			
			oestado := 1;
			omensaje := 'Curso creado con exito';
		end if;
		return query select oestado, omensaje;
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
		--Eliminamos estudiantes
		update estudiante
		set disabled = true
		where id_curso = id_curso_in;
		--Eliminamos el curso
		update curso set disabled = true where id_prof = id_p and id_curso = id_curso_in;
		return 'Curso eliminado con exito!';
	end
$$
language plpgsql;


--====================================================================================--
-- 							Funcion obtener curso y Progreso
--====================================================================================--

--=======================================================================================
--	     					TRIGGER TABLA - CURSO
--=======================================================================================
create table curso_trigger(
	id_prof int,
	fecha_accion date,
	accion varchar(25),
	id_curso int,
	grado varchar(25),
	paralelo varchar(25),
	color varchar(25)
);
--TRIGGER CREAR CURSO
create or replace function tr_insert_course() returns trigger
as $$
	begin
		insert into curso_trigger
		values (new.id_prof, (select current_timestamp), 'insertado', new.id_curso, new.grado, new.paralelo, new.color);
	return new;
	end
$$
language plpgsql;

create trigger trr_insert_course after insert on curso
for each row
execute procedure tr_insert_course();

--TRIGGER ELIMINAR CURSO
create or replace function tr_delete_course() returns trigger
as $$
	begin
		if old.disabled != new.disabled then
			insert into curso_trigger
			values (old.id_prof, (select current_timestamp), 'eliminado', old.id_curso, old.grado, old.paralelo, old.color);
		end if;
	return new;
	end
$$
language plpgsql;

create trigger trr_delete_course before update on curso
for each row
execute procedure tr_delete_course();




--################################ VIEW - pagina_principal #################################333


--=====================================================================
--						Obtener Lecciones
--=====================================================================
create or replace function get_lecciones_by_id_usr(id_usr int) returns
table (
	id_leccion int,
	titulo varchar,
	status boolean
)
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		return query
			select l.id_leccion, l.titulo, el.estado from leccion l, estudiante_leccion el
				where el.id_estudiante = id_e and el.id_leccion = l.id_leccion
				order by l.id_leccion ASC;
	end
$$
language plpgsql;
--select * from get_lecciones_by_id_usr(3);
--=====================================================================
--						Obtener Temas
--=====================================================================
create or replace function get_temas_by_leccion(id_usr int, id_l int) returns
table(
	id_tema int,
	titulo varchar,
	path_img varchar,
	status boolean
)
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		return query
		select t.id_tema, t.titulo, t.path_img, et.estado from tema t, estudiante_tema et
			where et.id_estudiante = id_e and et.id_tema = t.id_tema and t.id_leccion = id_l
			order by t.id_tema ASC;
	end
	
$$
language plpgsql;
--select * from get_temas_by_leccion(3, 3);
--=====================================================================
--						Obtener Ejercicios
--=====================================================================
create or replace function get_ejercicio_by_leccion(id_usr int, id_l int) returns
table(
	id_ejercicio int,
	descripcion varchar,
	status boolean
)
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		return query
			select e.id_ejercicio, e.descripcion, ee.estado from ejercicio e, estudiante_ejercicio ee
				where ee.id_estudiante = id_e and ee.id_ejercicio = e.id_ejercicio
					and e.id_leccion = id_l;
	end
	
$$
language plpgsql;

--select * from get_ejercicio_by_leccion(3, 1);

--=====================================================================
--						Obtener PathTema
--=====================================================================
create or replace function obtener_tema(id int) returns 
table(
	id_tema int,
	titulo varchar,
	id_leccion int,
	path_video text,
	contenido text
	)
as $$
	begin 
		return query
		select bt.id_tema, t.titulo, t.id_leccion, bt.path_video, bt.contenido from bc_tema bt, tema t 
			where bt.id_tema = t.id_tema and bt.id_tema = id;
	end
$$
language plpgsql;
--=====================================================================
--						Activar checking del tema por id
--=====================================================================
--drop function setStatusTema(id_usr int, id_tema int, status bool)
create or replace function setStatusTema(id_usr int, id_tem int, status bool)
returns varchar
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		update estudiante_tema et set estado = status where et.id_estudiante = id_e and et.id_tema = id_tem;
		return 'Se actualizo el estado correctamente!';
	end
$$
language plpgsql;

--=====================================================================
-- obtener estados de los temas de un estudiante en una leccion
--=====================================================================
--select * from getstatustemas(4, 1);
create or replace function getStatusTemas(id_usr int, id_l int) returns 
table(
	id_tema int,
	estado boolean
)
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		return query
		select et.id_tema, et.estado  from tema t, estudiante_tema et 
			where t.id_leccion = id_l and et.id_estudiante = id_e and t.id_tema = et.id_tema;
	end
		
$$
language plpgsql;

--=====================================================================
--						actualizar estado de la leccion
--=====================================================================
create or replace function updateStatusLeccion(id_usr int, id_l int, status boolean) returns varchar
as $$
	declare
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
	begin
		update estudiante_leccion set estado = status where id_estudiante = id_e and id_leccion = id_l;
		return 'Estado de la leccion actualizado con exito!';
	end
$$
language plpgsql;

--==========================================================================================
--								Guardar puntaje del ejercicio --REVISAR SI ES POR PRIMERA VEZ
--==========================================================================================

create or replace function savePuntaje(id_usr int, id_ejer int, point numeric)
returns varchar
as $$
	declare 
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
		puntaje numeric := (select ee.puntaje from estudiante_ejercicio ee where ee.id_estudiante = id_e and ee.id_ejercicio = id_ejer);
	begin 
		
		if puntaje is not null then
			if point>puntaje then
				update estudiante_ejercicio set estado = true, puntaje = point, fecha = (select current_timestamp)
					where id_estudiante = id_e and id_ejercicio = id_ejer;
				return 'Puntaje Guardado con exito';	
			else
				return 'El puntaje es menor, no se guardo!';
			end if;
		else
			update estudiante_ejercicio set estado = true, puntaje = point, fecha = (select current_timestamp)
				where id_estudiante = id_e and id_ejercicio = id_ejer;
			return 'Puntaje Guardado con exito';
		end if;
	end;
$$
language plpgsql;
--==========================================================================================
--								Obtener Puntaje de Lecciones
--==========================================================================================

create or replace function getPuntajeDeLecciones(id_usr int)
returns table(
	id_estudiante int,
	id_ejercicio int,
	id_leccion int,
	puntaje int,
	titulo varchar
)
as $$
	declare
		id_e numeric := (select est.id_estudiante from estudiante est where est.id_usuario = id_usr);
	begin
		return query
		select ee.id_estudiante, e.id_ejercicio, l.id_leccion, ee.puntaje, l.titulo  from estudiante_ejercicio ee, ejercicio e, leccion l
		where ee.id_estudiante = id_e and ee.id_ejercicio = e.id_ejercicio and e.id_leccion = l.id_leccion order by l.id_leccion asc;
	end
$$ 
language plpgsql;

--==========================================================================================
--								Otener avance de temas
--==========================================================================================

create or replace function getAvanceDeTemas(id_usr int)
returns table(
	id_estudiante int,
	id_tema int,
	id_leccion int,
	estado_tema boolean,
	titulo varchar
)
as $$
	declare
		id_e numeric := (select est.id_estudiante from estudiante est where est.id_usuario = id_usr);
	begin
		return query
		select et.id_estudiante, et.id_tema, t.id_leccion , et.estado, t.titulo from estudiante_tema et, tema t
		where et.id_estudiante = id_e and et.id_tema = t.id_tema order by et.id_tema asc;
	end
$$
language plpgsql;

--==========================================================================================
--								Salvar estilo de aprendizaje
--==========================================================================================

create or replace function guardarEstilo(id_usr int, iar varchar, isi varchar, ivv varchar, isg varchar) returns varchar
as $$
	declare 
		id_e numeric := (select e.id_estudiante from estudiante e where e.id_usuario = id_usr);
		estilo varchar := (select substring(ivv from char_length(ivv) for char_length(ivv)));
	begin
		insert into hoja_estilo(id_estudiante, ar, si, vv, sg)
		values(id_e, iar, isi, ivv, isg);
		if estilo like 'A'::varchar then
			--actualizar estudiante dandole el visual jaja
			update estudiante set id_estilo = 1 where id_estudiante = id_e;
		else
			update estudiante set id_estilo = 2 where id_estudiante = id_e;
			--acutaliar estudiante dandole el verbal jaja
		end if;
		return 'Hoja de estilo guardado exitosamente!';
	end
$$
language plpgsql;


alter table estudiante_tema add column puntaje numeric;
alter table estudiante_tema add column fec_puntaje date;

create or replace function guardar_puntaje_tema(id_usr int, in_id_tema int, in_puntaje numeric, fecha_cre date)
returns boolean
as $$
	declare
		id_e numeric := (select est.id_estudiante from estudiante est where est.id_usuario = id_usr);
	begin
		update estudiante_tema set puntaje = in_puntaje, fec_puntaje = fecha_cre where id_estudiante = id_e and id_tema = in_id_tema;
	return true;
	end
	
$$
language plpgsql;



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
		if exists(
			select 1 from persona
			where nombre = nom 
			and apellido1 = ap 
			and apellido2 = am
		) then
			return 'El Usuario ya existe!';
		else
		--crear persona
		insert into persona(nombre, apellido1, apellido2, telefono, sexo)
			values(nom, ap, am, tel, sex) returning id_persona into id_p;
		--crear usuario
		insert into usuario(id_persona, id_rol, username, pass, fecha_cre)
			values(id_p, 2, username, pass, (select current_timestamp)) returning id_usuario into id_u;
		--crear profesor
		insert into profesor(id_usuario, id_adm, disabled) values(id_u, id_a, false);
		
		return 'Profesor creado con exito!';
		end if;
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
		
		if exists(
			select 1 from persona
			where nombre = nom 
			and apellido1 = ap 
			and apellido2 = am
		) then
			return 'El estudiante ya Existe';
		else
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
		end if;
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


--Funciones nuevas

create or replace function fn_reporte_generar_usuarios_estudiantes(input_idUsuario int, input_idCurso int)
returns table(
	nombre varchar,
	usuario varchar,
	contrasenia varchar
)
as $$
	declare
		vid_prof int;
	begin 
		vid_prof := (select id_prof from profesor where id_usuario = input_idUsuario);
		return query	
			select (p.nombre||' '||p.apellido1||' '||p.apellido2)::varchar as nombre,
			uu.username as usuario, p.apellido1 as constrasenia
			from
			(select *
			from usuario u 
			inner join estudiante e 
			on u.id_usuario = e.id_usuario 
			where e.disabled = false
			and e.id_curso = input_idCurso
			and e.id_prof = vid_prof) as uu
			inner join persona p 
			on p.id_persona = uu.id_persona;
	end;
$$
language plpgsql;