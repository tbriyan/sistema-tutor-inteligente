--=======================================================================================
--	     					TRIGGER TABLA - PROFESOR
--=======================================================================================

create table profesor_trigger(
	id_adm int,
	fecha_accion date,
	accion varchar(25),
	id_prof int,
	id_usuario_prof int
);
--TR Eliminar profesor
create function tr_profesor_delete() returns trigger
as $$
	begin
		insert into profesor_trigger
		values (old.id_adm, (select current_timestamp), 'eliminado', old.id_prof, old.id_usuario);
		return new;
	end
$$
language plpgsql;

create trigger trr_profesor_delete before update on profesor
for each row
execute procedure tr_profesor_delete();

--TR Crear profesor
create function tr_profesor_insert() returns trigger
as $$	
	begin
		insert into profesor_trigger
		values (new.id_adm, (select current_timestamp), 'insertado', new.id_prof, new.id_usuario);
		return new;
	end
$$
language plpgsql;
create trigger trr_profesor_insert after insert on profesor
for each row
execute procedure tr_profesor_insert();

--=======================================================================================
--	     					TRIGGER TABLA - ESTUDIANTE
--=======================================================================================

create table estudiante_trigger(
	id_prof int,
	fecha_accion date,
	accion varchar(25),
	id_estudiante int,
	id_usuario int,
	id_curso int
);
--agregar estudiante
create or replace function tr_estudiante_insert() returns trigger
as $$
	begin
		insert into estudiante_trigger
		values (new.id_prof, (select current_timestamp), 'insertado', new.id_estudiante, new.id_usuario, new.id_curso);
		return new;
	end	
$$
language plpgsql;
create trigger trr_estudiante_insert after insert on estudiante
for each row
execute procedure tr_estudiante_insert(); 
--eliminar estudiante
create or replace function tr_estudiante_delete() returns trigger
as $$
	begin
		if old.disabled != new.disabled then 
			insert into estudiante_trigger
			values (old.id_prof, (select current_timestamp), 'eliminado', old.id_estudiante, old.id_usuario, old.id_curso);
		end if;
		return new;
	end	
$$
language plpgsql;
create trigger trr_estudiante_delete before update on estudiante
for each row
execute procedure tr_estudiante_delete();