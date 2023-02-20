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
