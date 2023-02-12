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