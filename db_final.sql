CREATE TABLE persona(
    id_persona SERIAL,
    nombre VARCHAR(25),
    apellido1 VARCHAR(25),
    apellido2 VARCHAR(25),
    telefono VARCHAR(25),
    sexo VARCHAR(1),
    fecha_nac DATE,
    PRIMARY KEY(id_persona)
);
CREATE TABLE rol(
    id_rol SERIAL,
    tipo VARCHAR(25),
    PRIMARY KEY(id_rol)
);

INSERT INTO rol(tipo) VALUES('ADM');
INSERT INTO rol(tipo) VALUES('PRF');
INSERT INTO rol(tipo) VALUES('EST');

CREATE TABLE usuario(
    id_usuario SERIAL,
    id_persona INT REFERENCES persona(id_persona),
    id_rol INT REFERENCES rol(id_rol),
    username VARCHAR(25),
    pass VARCHAR(255),
    fecha_cre DATE,
    path_foto VARCHAR(200),
    PRIMARY KEY(id_usuario)
);
CREATE TABLE administrador(
    id_adm SERIAL,
    id_usuario INT REFERENCES usuario(id_usuario),
    PRIMARY KEY(id_adm)
);
CREATE TABLE profesor(
    id_prof SERIAL,
    id_usuario INT REFERENCES usuario(id_usuario),
    id_adm INT REFERENCES administrador(id_adm),
    disabled boolean,
    PRIMARY KEY(id_prof)
);
CREATE TABLE curso(
    id_curso SERIAL,
    id_prof INT REFERENCES profesor(id_prof),
    grado varchar(25),
    paralelo varchar(5),
    color varchar(25),
    disabled boolean,
    PRIMARY KEY(id_curso)
);
create table estilo_aprendizaje(
	id_estilo SERIAL,
	estilo varchar(25),
	primary key(id_estilo)
);

insert into estilo_aprendizaje(id_estilo, estilo) values(1, 'VA');
insert into estilo_aprendizaje(id_estilo, estilo) values(2, 'VB');

CREATE TABLE estudiante(
    id_estudiante SERIAL,
    id_usuario INT REFERENCES usuario(id_usuario),
    id_prof INT REFERENCES profesor(id_prof),
    id_curso INT REFERENCES curso(id_curso),
    id_estilo INT references estilo_aprendizaje(id_estilo),
    disabled boolean,
    PRIMARY KEY(id_estudiante)
);
--changes from here
create table leccion(
	id_leccion serial,
	titulo VARCHAR(255),
	primary key(id_leccion)
);
create table estudiante_leccion(
	id_estudiante int references estudiante(id_estudiante),
	id_leccion int references leccion(id_leccion),
	estado boolean
);
create table ejercicio(
	id_ejercicio serial,
	descripcion varchar(255),
	id_leccion int references leccion(id_leccion),
	primary key(id_ejercicio)
);
create table estudiante_ejercicio(
	id_estudiante int references estudiante(id_estudiante),
	id_ejercicio int references ejercicio(id_ejercicio),
	fecha date,
	estado boolean,
	puntaje int
);
create table tema(
	id_tema int,
	titulo varchar(255),
    path_img varchar(100),
    id_leccion int references leccion(id_leccion),
	primary key(id_tema)
);
create table estudiante_tema(
	id_estudiante int references estudiante(id_estudiante),
	id_tema int references tema(id_tema),
	estado boolean
);
create table pregunta(
	id_pregunta int,
	id_ejercicio int references ejercicio(id_ejercicio),
	pregunta json
);
CREATE TABLE bc_tema(
    id_tema int,
    path_video text,
    contenido text,
    primary key(id_tema)
);
create table ejercicio0(
	id_ejercicio0 serial,
	id_leccion int references leccion(id_leccion),
	preguntas json,
	primary key(id_ejercicio0)
);
--=========================ESTILO DE APRENDIZAJE TABLA DE PERFIL
create table hoja_estilo(
	id_hestilo serial,
	id_estudiante int references estudiante(id_estudiante),
	ar varchar(10),
	si varchar(10),
	vv varchar(10),
	sg varchar(10),
	primary key (id_hestilo)
);
--============================= DATOS PARA INGRESAR A LA COLUMNA LECCION ===========================
insert into leccion(id_leccion, titulo) values(1, 'Introducción a la Química');
insert into leccion(id_leccion, titulo) values(2, 'Función Óxidos');
--============================= FIN DE DATOS PARA INGRESAR A LA COLUMNA LECCION ===========================

--============================= DATOS PARA INGRESAR A COLUMNA "TEMA" ================================
insert into tema(id_tema, titulo, id_leccion, path_img) values(1, 'Introduccion a la Química', 1, '/img/img-temas/l1-t1.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(2, 'El Atomo', 1, '/img/img-temas/l1-t2.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(3, 'Nomenclatura Química', 1, '/img/img-temas/l1-t3.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(4, 'Oxidos Metálicos', 2, '/img/img-temas/l2-t1.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(5, 'Oxidos no Metálicos', 2, '/img/img-temas/l2-t2.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(6, 'Peróxidos', 2, '/img/img-temas/l2-t3.png');
insert into tema(id_tema, titulo, id_leccion, path_img) values(7, 'Superóxidos', 2, '/img/img-temas/l2-t4.png');
--============================= FIN DE DATOS PARA INGRESAR AL TEMA================================

--============================= DATOS PARA INGRESAR A LA COLUMNA EJERCICIO ==========================
insert into ejercicio(id_ejercicio, descripcion, id_leccion) 
values(1, 'Prueba tu habilidad introductoria, estudia los atomos y refuerza el concepto de nomenclatura', 1);

insert into ejercicio(id_ejercicio, descripcion, id_leccion) 
values(2, 'Estas listo?, Metal o No Metal, pon a prueba tu conocimiento en Oxidos y sienta las bases de tu futuro!', 2);
--============================= FIN DE DATOS PARA INGRESAR A LA COLUMNA EJERCICIO ==========================

--================================ INICIO DE BANCO DE CONTENIDO =============================
insert into bc_tema values(1,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/qYDtPeOOWl8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
'<div class="container">
        <h1 class="text-center mt-3"><strong>Introducción</strong></h1>
        <br>
        <h3 class="text-primary"><strong>¿Que es la Ciencia?</strong></h3>
        <p>La ciencia es un disciplina que se encarga de estudiar e investigar con rigor los fenómenos sociales, naturales y artificiales a través de la observación, experimentación y medición para dar respuesta a lo desconocido.</p>
        <p>La ciencia, tal y como se conoce, se originó en los siglos XVI y XVII. René Descartes, uno de los que más contribuyó de manera inicial, creó el método cartesiano en el que señalaba que «solo se puede decir que existe algo que haya sido probado». Fue una gran influencia en el mundo de las ciencias.</p>
        <h3 class="text-primary"><strong>¿Que es la Química?</strong></h3>
        <p>La quimica es una ciencia que estudia los cambios y transformaciones que sufre la materia. Es la ciencia que estudia las sustancias y las partículas que las componen, así como las distintas dinámicas que entre éstas pueden darse.</p>
        <h5 class="text-primary"><strong>Historia de la Química</strong></h5>
        <p>En un sentido estricto, la historia de la química comenzó en la prehistoria cuando el humano comenzó a interesarse por los materiales, por la fabricación, la cocción y el horneado. Su vínculo con el progreso tecnológico de la humanidad es incuestionable.</p>
        <p>La palabra química proviene del latín ars chimia (“arte alquímico”), a su vez derivado del término árabe alquimia, con el que se nombraba alrededor del año 330 a la práctica pseudocientífica de los buscadores de la piedra filosofal, con la cual podrían convertir el plomo y otros metales en oro, de otorgar la inmortalidad o la omnisciencia.</p>
        <p>Los primeros alquimistas eran científicos islámicos que, mientras Occidente se sumergía en el fanatismo religioso cristiano, cultivaron la sabiduría de los elementos y los materiales, comprendidos como un conjunto de cuerpos y espíritus que empleando las técnicas correctas podían ser manipulados o transformados.</p>
        <p>A estos misteriosos personajes se les solían llamar “químicos” (de alquímicos). Sin embargo, a partir de 1661, con la publicación de “El Químico Escéptico” del científico irlandés Robert Boyle (1627-1691), el término pasó a tener un significado menos esotérico (espiritual) y más vinculado con las ciencias.</p>
        <p>Alrededor de 1662, el científico suizo Christopher Glaser (1615-1670) definió a la química como el arte científico de disolver los cuerpos de distintos materiales, debido a que en 1730 el alemán Georg Stahl (1659-1734) la llamó el arte de entender las dinámicas de las mezclas.</p>
        <p>Recién en 1837 el químico francés Jean-Baptiste Dumas (1800-1884) la definió como la ciencia que se ocupa de las fuerzas intermoleculares. En cambio, hoy la comprendemos como el estudio de la materia y sus cambios, siguiendo la definición del célebre químico hongkonés Raymond Chang (1939-2017).</p>
        <p>Sin embargo, la química como ciencia empezó a existir en el siglo XVIII, cuando los primeros experimentos científicos comprobables con la materia tuvieron lugar en la Europa moderna, especialmente luego de la postulación en 1983 de la Teoría atómica por John Dalton.</p>
        <p>Desde entonces, la química ha provocado numerosos descubrimientos y revoluciones. Además, ha tenido un importante impacto en ciencias y disciplinas semejantes, como la biología, la física y la ingeniería.</p>
        <h3 class="text-primary mb-2"><strong>Ramas de la Química</strong></h3>
        <p>
            <img class="mb-5" src="/img/lecciones/rama_quimica.png" alt="" width="100%">
        </p>
    </div>');
insert into bc_tema values(2,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/FdRD23O_vyI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
'<div class="container">
        <h1 class="text-center mt-3"><strong>El Átomo</strong></h1>
        <br>
        <h3 class="text-primary"><strong>¿Que es el Átomo?</strong></h3>
        <p>El átomo es la unidad más básica de la materia con propiedades de un elemento químico. El átomo es el componente fundamental de toda la materia o sea, todo lo que existe en el universo físico conocido está hecho de átomos. Todo el universo, todas las estrellas, galaxias, planetas y demás cuerpos celestes también están hechos de átomos.</p>
        <h4 class="text-primary"><strong>Características del Átomo</strong></h4>
        <p>Aunque el átomo es una unidad básica, está compuesto de tres subestructuras:</p>
        <p>
            <ul>
                <li>Los protones.</li>
                <li>Los neutrones.</li>
                <li>Los electrones.</li>
            </ul>
        </p>
        <p>Estas partículas subatómicas tienen un orden en particular dentro del átomo. Los protones y los neutrones forman el núcleo atómico mientras que los electrones orbitan alrededor de éste. Adicionalmente, estas partículas están definidas por su carga eléctrica, donde los protones tienen una carga eléctrica positiva, los electrones negativa y los neutrones como su nombre lo indica, no tienen carga alguna, aunque aportan otras características al átomo.</p>
        <p class="text-center">
            <img src="/img/lecciones/atomo.gif" alt="" width="100%" style="max-width: 500px;">
        </p>
        <p>
            La mayor parte de la masa se encuentra en el núcleo, o sea, en los protones y los neutrones. Un protón tiene aproximadamente 1,800 veces la masa de un electrón. Los electrones orbitan alrededor del núcleo en una nube que tiene un radio de aproximadamente 10,000 veces el tamaño del núcleo.
        </p>
        <h5 class="text-primary"><strong>Protones</strong></h5>
        <p>Portadores de la carga positiva, los protones son parte del núcleo y aportan casi la mitad de la masa de un átomo. Con ligeramente menos masa que los neutrones, los protones tienen una masa de 1.67×10-27 Kilogramos o sea 1836 veces la masa de un electrón. La masa de un protón es 99.86% la masa de un neutrón.</p>
        <h5 class="text-primary"><strong>Quarks</strong></h5>
        <p>Los protones y los neutrones están compuestos de un par de partículas llamadas quarks y gluones. Los protones contienen dos quarks ascendentes de carga positiva (+2/3) y un quark descendente con carga negativa (-1/3), mientras que los neutrones contienen un quark ascendente y dos quarks descendentes. Los gluones son responsables de unir a los quarks entre sí.</p>
        <h5 class="text-primary"><strong>Neutrones</strong></h5>
        <p>El otro elemento del núcleo son los neutrones con una masa ligeramente superior a la de los protones o lo que es equivalente a 1.69x 10-27 Kilogramos o 1839 veces la masa de un electrón. Igual que los protones, los neutrones están hechos de quarks pero tienen uno ascendente con carga (+2/3) y dos descendentes con carga (-1/3) cada uno lo que da una carga neta de cero.</p>
        <h5 class="text-primary"><strong>Electrones</strong></h5>
        <p>La partícula más pequeña del átomo son los electrones que son más de 1800 veces más pequeños que los protones y los neutrones, ya que tienen una masa de 9.109×10-31 kilogramos lo que equivale a 0.054% de la masa del átomo.</p>
        <p>Los electrones orbitan el núcleo del átomo en una órbita con un radio de unas 10,000 veces el tamaño del núcleo formando lo que se conoce como la nube de electrones. Estos son atraídos a los protones del núcleo por la fuerza electromagnética que atrapa a los electrones en un “pozo de potencial” electrostático alrededor del núcleo.</p>
        <h3 class="text-primary"><strong>Núcleo del Atomo</strong></h3>
        <p>
            El núcleo atómico está formado de protones y neutrones que en conjunto se llaman nucleones y contienen casi la totalidad de la masa del átomo. Un 99.999% de la masa, se encuentra en estas dos estructuras, los protones y los neutrones, que según el modelo estándar se encuentran unidos por la “fuerza nuclear fuerte”.
        </p>
        <h3 class="text-primary"><strong>Los Átomos y la Tabla Periódica</strong></h3>
        <p>En la información de todas las tablas periódicas, está el número atómico y el peso atómica de cada elemento. El número atómico es el número que se encuentra en la esquina superior izquierda y el peso atómico es el número ubicado en la parte inferior, como en este ejemplo para uranio.</p>
        <p class="text-center mb-5">
            <img src="/img/lecciones/uranio.png" alt="">
        </p>
    </div>');
insert into bc_tema values(3,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/11X3EkS_Jqw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
'<div class="container">
        <h1 class="text-center mt-3"><strong>Nomenclatura Química</strong></h1>
        <br>
        <h3 class="text-primary"><strong>Funciones de Química Inorgánica</strong></h3>
        <p>La Nomenclatura es el conjunto de reglas del lenguaje que se utiliza en Química y que se aplican a la denominación de los compuestos.</p>
        <p>Existen tres nomenclaturas que son comúnmente utilizados para determinar los compuestos químicos que existen actualmente y son los siguientes:</p>
        <p>
            <ul>
                <li>Nomenclatura tradicional, clásica o común (N.T.)</li>
                <li>Nomenclatura STOCK (N.S.)</li>
                <li>Nomenclatura I.U.P.A.C (N.I.)</li>
            </ul>
        </p>
        <h3 class="text-primary"><strong>Nomenclatura Tradicional</strong></h3>
        <p>Esta nomenclatura emplea prefijos y terminaciones para cada función; cuando un elemento posee dos valencias es:</p>
        <p class="text-center">
            <img src="/img/lecciones/nomenclatura-tradicional.png" alt="">
        </p>
        <p>Las sustancias químicas se clasifican de acuerdo a las diferentes valencias que posean. Estas se representan verbalmente con el uso de prefijos y sufijos.</p>
        <p class="text-center">
            <img src="/img/lecciones/tradicional.png" alt="" width="100%" style="max-width: 400px;">
        </p>
        <h3 class="text-primary"><strong>Nomenclatura IUPAC</strong></h3>
        <p>Este es el más extendido en la actualidad y es reconocido por la IUPAC. Nombra las sustancias con prefijos numéricos griegos. Estos indican la atomicidad (número de átomos) presente en las moléculas. La fórmula para nombrar los compuestos puede resumirse de la siguiente manera: prefijo-nombre genérico + prefijo-nombre específico. Podemos ver la siguiente tabla para orientarnos.</p>
        <p class="text-center">
            <img src="/img/lecciones/iupac.png" alt="" width="100%" style="max-width: 400px;">
        </p>
        <h3 class="text-primary"><strong>Nomenclatura STOCK</strong></h3>
        <p>En la actualidad, la IUPAC está promoviendo la estandarización de este método en lugar de los que usan sufijos, debido a que los estos resultan difíciles en algunas lenguas. El sistema elegido es el llamado Stock. Recibe su nombre de su creador, el químico alemán Alfred Stock (1876-1946).</p>
        <p>El sistema Stock agrega al final del elemento números romanos que indican la valencia de los átomos. Es decir, los números romanos indican el estado de oxidación de alguno de los elementos que puedan estar presentes en la sustancia química. Se deben disponer al final del nombre de la sustancia y entre paréntesis.</p>
        <p class="text-center mb-5">
            <img src="/img/lecciones/stock.png" alt="" width="100%" style="max-width: 400px;">
        </p>
    </div>');

insert into bc_tema values(4,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/nN_Xoq-nN1I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
'
    <div class="container">
        <h2 class="text-center"><strong>Oxidos Metalicos</strong></h2>
        <p>
            Son aquellos óxidos que se producen entre un oxigeno y un metal, esto sucede cuando el oxigeno trabaja con numero de valencia -2. Siendo su formula general:
            <div class="text-center h4">
                <strong>Metal + O</strong>
            </div> 
        </p>
        <p>
            El procedimiento al momento de combinar los estados de oxidación se realiza de la forma:
            <br>
            Si tenemos un metal, es este caso Fe (Hierro) con valencias +2, +3 y Oxigeno con -2.
            <li>Si del hierro tomamos la valencia +2, tendríamos lo siguiente:</li>
            <div class="text-center h4">
                Fe<sup>+2</sup> O<sup>-2</sup>
            </div>
            El hierro como el oxigeno tienen algo en común y este es la valencia, ya que ambas se pueden dividir comúnmente divisibles es decir que podemos dividir por 2, por lo que tendríamos el resultado de las siguiente forma:
            <div class="text-center h4">
                Fe 0
            </div>
            Como podemos ver se simplifican las valencias, esto sucede cuando comparten el mismo numero de valencias.
            <li>Ahora veamos un ejemplo cuando el hierro trabaja con valencia +3:</li>
            <div class="text-center h4">
                Fe<sup>+3</sup> O<sup>-2</sup>
            </div>
            Podemos ver que ambos no tienen valencias en común por lo que no podemos simplificar, por ende el resultado sería el siguiente:
            <div class="text-center h4">
                Fe<sub>2</sub> O<sub>3</sub>
            </div>
            Podemos ver que ambas valencias se intercambian, es decir que el 2 del Oxigeno se fue para el Hierro y el 3 del Hierro se para el Oxigeno.
        </p>
        <h3 class="text-primary"><strong>Nomenclaturas aplicadas a oxidos</strong></h3>
        <p>
            <strong>En la nomenclatura Stock</strong> los compuestos se nombran con las reglas generales anteponiendo como nombre genérico la palabra <strong>oxido</strong> precedido por el <strong>nombre del metal</strong> y su numero de <strong>valencia</strong>.
            <br>
            Para los ejemplos que se presentan a continuación se utilizara: Hierro "Fe" con su valencia +3 <strong>(Fe<sup>+3</sup>)</strong> y el Oxigeno con valencia -2 <strong>(0<sup>-2</sup>)</strong>.
            <div class="text-center h4">
                Oxido de hierro (III)
                <br>
                Fe<sub>2</sub>O<sub>3</sub>
            </div>
            Recordemos que en la nomenclatura Stock se anota en números romanos la valencia que se utiliza del metal, en la mayoría de los casos donde la valencia es unicamente 1 no se anota es decir que queda implícito, es decir se sobreentiende.
        </p>
        <p>
            <strong>En la nomenclatura Tradicional </strong>  se nombran con el sufijo -oso e -ico dependiendo de la menor o mayor valencia del metal que acompaña al oxigeno.
            <br>
            <div class="text-center h4">
                Oxido de férrico
                <br>
                Fe<sub>2</sub>O<sub>3</sub>
            </div>
            Recordemos que <strong>Fe (Hierro)</strong> posee valencias +2,+3, por lo que en el ejemplo anterior se trabaja con su valencia mayor.
            <br>
            Si recordamos en las siguientes tablas, la notación en nomenclatura tradicional depende mucho de las valencias con las que se trabaja.
            <br>
            <br>
            <strong>Si el metal tiene unicamente 2 valencias</strong>
            <div class="text-center">
                <img src="val-2.png" alt="">
            </div>
            <br>
            <strong>Si el metal tiene 2 o mas valencias</strong>
            <div class="text-center">
                <img src="vmax.png" alt="">
            </div>
        </p>
        <p>
            Finalmente en la <strong>nomenclatura sistemática</strong> (IUPAC) se utilizan las reglas generales con la palabra oxido como nombre genérico.
            <br>
            <div class="text-center h4">
                Trioxido de hierro
                <br>
                Fe<sub>2</sub>O<sub>3</sub>
            </div>
            Podemos ver que el <strong>Tri</strong> de <strong>Tri</strong>oxido de hierro viene determinado del numero de valencia que posee al momento de combinar con el oxigeno.
            Para refrescar la memoria a continuación se presenta la tabla con los prefijos numericos:
            <div class="text-center">
                <img src="t-iupac.png" alt="">
            </div>
            <br>
        </p>
    </div>
');
insert into bc_tema values(5,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/lEUAs_uszx8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
'
    <div class="container">
        <h2 class="text-center">
            <strong>Oxidos No Metalicos</strong>
            <br>
            <small>Anhidridos</small>
        </h2>
        <p>
            Son aquellos formados por la combinación del oxigeno con un no metal. Su fórmula general es:
            <div class="text-center h4">
                <strong>No Metal + O</strong>
            </div> 
        </p>
        <p>
            Para esta combinación la forma de nombrar los compuestos difiere en gran medida según el tipo de nomenclatura que se utilice.
            Para la nomenclatura IUPAC y Nomenclatura STOCK, la forma de nombrar los compuestos sigue siendo la misma que en los óxidos, sin embargo, en la Nomenclatura Tradicional este ya toma el nombre de anhidrido.
        </p>
        <p>
            Para poder entender de mejor manera tomamos el siguiente ejemplo:
        </p>
        <p>
            Si tenemos cloro <strong>Cl</strong> que posee valencias <strong>-1, +1, +3 +5, +7</strong> y Oxigeno <strong>O</strong> con valencia <strong>-2</strong>. Y nos ponemos a formar el compuesto con <strong>Cl<sup>+1</sup></strong>:
            <br>
            Trabajando de la misma forma que en los óxidos tenemos los siguiente:
        </p>
        <p class="text-center h2">
            <strong>
                <span>Cl<sup>+1</sup> O<sup>-2</sup></span>
                <br>
                <span>Cl<sub>2</sub> O</span>
            </strong>
        </p>
        <p>
            Nombrando el compuesto en las tres nomenclaturas.
        </p>
        <p>
            <ul>
                <li>Oxido de dicloro (N.I)</li>
                <li>Oxido de cloro (I) (N.S)</li>
                <li>Anhidrido hipocloroso (N.T)</li>
            </ul>
        </p>
        <p>
            Debemos tener en cuenta que, el nombrar un compuesto no representa cambio de la forma como se trabajaba en óxidos, excepto como se dijo anteriormente, en nomenclatura tradicional se nombra como anhidrido seguido de el sufijo o prefijo según la valencia con la que se trabaja.
        </p>
    </div>
');
insert into bc_tema values(6,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/t_tSXV8E2ug" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
'
    <div class="container">
        <h2 class="text-center">
            <strong>Peroxidos</strong>
        </h2>
        <p>
            Son aquellos formados por la combinación del oxigeno con un no metal. Su fórmula general es:
            <div class="text-center h4">
                <strong>Metal + Grupo Peróxido = Peróxido</strong>
                <br>
                <span>Metal + (O<sub>2</sub>)<sup>-2</sup> = X(O<sub>2</sub>)<sub>n</sub></span>
            </div> 
        </p>
        <p>
            Para nombrar los compuestos, en nomenclatura tradicional se utiliza el nombre peróxido en lugar de oxido y se agrega el nombre del metal con las reglas generales para los óxidos. En las nomenclaturas restantes Stock, IUPAC o Sistemática se nombran los compuestos con las mismas reglas generales para los óxidos.
        </p>
        <p>
            Para identificar un peróxido y no confundirlo con algún oxido se dice que, es peróxido si:
        </p>
        <p>
            <ul>
                <li>Si no hay simplificación del <strong>0<sub>2</sub></strong></li>
                <p class="text-center">
                    <strong>
                        <span>Na<sub>2</sub> O<sub>2</sub></span>
                    </strong>
                </p>
                <p>
                    A simple vista parecería un oxido que no se encuentra simplificado, pero el hecho de que no se simplifique quiere decir que se esta trabajando con un grupo peróxido.
                </p>
                <li>
                    Si es de la forma <strong>X(O<sub>2</sub>)<sub>n</sub></strong>
                    <p class="text-center">
                        <strong>
                            <span>Fe<sub>2</sub> (O<sub>2</sub>)<sub>3</sub></span>
                        </strong>
                    </p>
                </li>
                <li>
                    Si es <strong>XO<sub>2</sub></strong> y <strong>X</strong> no tiene valencia 4
                    <p class="text-center">
                        <strong>
                            <span>Cu O<sub>2</sub></span>
                        </strong>
                    </p>
                    <p>
                        Este se resuelve comprobando las valencias con las que se trabaja, es decir que si nos fijamos que valencias posee Cu este tiene +1, +2 por lo que el compuesto que se presenta indica que se trabajo con su valencia 2 y este se simplifica con la del peróxido, quedando el compuesto presentado.
                    </p>
                </li>
            </ul>
        </p>
        <p>
            A continuación, se presentan algunos ejemplos:
        </p>
        <strong class="text-primary">EJEMPLO 1</strong>
        <p class="text-center">
            <strong>
                Hg O<sub>2</sub>
            </strong>
            ===>
            Peróxido de mercurio (II) (N.S)
        </p>
        <strong>PASO 1</strong>
        <p>
            Como primer paso verificamos si este tiene simplificación en <strong>O<sub>2</sub></strong>, en un vistazo rápido comprobamos que no.
        </p>
        <strong>PASO 2</strong>
        <p>
            Verificamos si tiene la forma <strong> X(O<sub>2</sub>)<sub>n</sub></strong>, y si efectivamente posee esa forma.
        </p>
        <strong>PASO 3</strong>
        <p>
            Finalmente nos fijamos en nuestra tabla de valencias cuantas posee el mercurio, del cual se identifica que tiene +1, +2.
            <br>
            <ul>
                <li>
                    Si Hg trabaja con su valencia 1, tenemos: 
                    <strong>
                        Hg<sup>+1</sup> (O<sub>2</sub>)<sup>-2</sup>
                        ===>
                        Hg<sub>2</sub> (O<sub>2</sub>)<sub>1</sub>
                        ===>
                        Hg<sub>2</sub> O<sub>2</sub>
                    </strong>  
                </li>
                <br>
                <li>
                    Si Hg trabaja con su valencia 2, tenemos: 
                    <strong>
                        Hg<sup>+2</sup> (O<sub>2</sub>)<sup>-2</sup>
                        ===>
                        Hg<sub>2</sub> (O<sub>2</sub>)<sub>2</sub>
                        ===>
                        Hg O<sub>2</sub>
                    </strong> 
                </li>
            </ul>
        </p>
        <br><br>
        <strong class="text-primary">EJEMPLO 2</strong>
        <p class="text-center">
            <strong>
                Ge O<sub>2</sub>
            </strong>
            ===>
            Oxido de germanio (IV) (N.S)
        </p>
        <strong>PASO 1</strong>
        <p>
            Como primer paso verificamos si este tiene simplificación en <strong>O<sub>2</sub></strong>, en un vistazo rápido comprobamos que no.
        </p>
        <strong>PASO 2</strong>
        <p>
            Verificamos si tiene la forma <strong> X(O<sub>2</sub>)<sub>n</sub></strong>, y si efectivamente posee esa forma.
        </p>
        <strong>PASO 3</strong>
        <p>
            Nos fijamos en nuestra tabla de valencias cuantas posee el germanio, del cual se identifica que tiene +2, +4.
            <br>
            <ul>
                <li>
                    Si Ge trabaja con su valencia 2, tenemos: 
                    <strong>
                        Ge<sup>+2</sup> (O<sub>2</sub>)<sup>-2</sup>
                        ===>
                        Ge<sub>2</sub> (O<sub>2</sub>)<sub>2</sub>
                        ===>
                        Ge O<sub>2</sub>
                    </strong>  
                </li>
                <br>
                <li>
                    Si Hg trabaja con su valencia 2, tenemos: 
                    <strong>
                        Ge<sup>+4</sup> (O<sub>2</sub>)<sup>-2</sup>
                        ===>
                        Ge<sub>2</sub> (O<sub>2</sub>)<sub>4</sub>
                        ===>
                        Ge (O<sub>2</sub>)<sub>2</sub>
                    </strong> 
                </li>
            </ul>
        </p>
    </div>
');
insert into bc_tema values(7,
'<iframe width="780" height="420" src="https://www.youtube.com/embed/XOUDBw4bmXI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
'
    <div class="container">
        <h2 class="text-center">
            <strong>Oxidos Salinos o Mixtos</strong>
        </h2>
        <p>
            Son compuestos binarios que resultan de la combinación de dos óxidos simples de un mismo metal. Cuya formula general es:
            <div class="text-center h4">
                <strong>Oxido + Oxido = Oxido salino</strong>
                <br>
                <span>M<sub>3</sub>O<sub>4</sub>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                <span>M<sub>3</sub>O<sub>8</sub>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                <span>M<sub>2</sub>O<sub>4</sub>
            </div> 
        </p>
        <h3 class="text-primary"><strong>Formulación</strong></h3>
        <p>
            Estos óxidos, que son casos especiales responden a la formula presentada con anterioridad, que significa:
            <ul>
                <li>
                    <strong>M<sub>3</sub>O<sub>4</sub></strong>: En una molécula del compuesto existen 3 átomos de metal y 4 átomos de oxígeno.
                </li>
                <li>
                    <strong>M<sub>3</sub>O<sub>8</sub></strong>: En una molécula del compuesto existen 3 átomos de metal y 8 átomos de oxígeno.
                </li>
                <li>
                    <strong>M<sub>3</sub>O<sub>4</sub></strong>: En una molécula del compuesto existen 2 átomos de metal y 4 átomos de oxígeno.
                </li>
            </ul>
        </p>
        <p>
            Para representar la formula del oxido mixto es necesario escribir los dos oxidos simples y realizar una suma aritmética.
            Para una mayor comprensión se pasará a realizar una seríe de ejemplos:
        </p>
        <p>
            <strong>EJEMPLO 1: </strong>Para la estructura M<sub>3</sub>O<sub>4</sub> 
        </p>
        <p class="text-center">
            <strong>Fe<sub>3</sub>O<sub>4</sub></strong>
        </p>
        <p class="text-center">
            Oxido Ferroso – Ferrico (N.T) <br>
            Óxido de Hierro (II-III) (N.S) <br>
            Tetraoxido de Trihierro (N.I)
        </p>
        <p>
            Bien tenemos a nuestro oxido salino, ahora pasamos a ver como se forma y por qué se le conoce como oxido doble, salino o mixto.
        </p>
        <h5><strong>Formación</strong></h5>
        <p>
            Sabemos que el metal Hierro Fe tiene valencias +2, +3. Lo que se hace a continuación es crear el compuesto oxido con ambas valencias y sumar, como se ve a continuación:
        </p>
        <p class="text-center">
            <strong>Fe<sup>+2</sup>O<sup>-2</sup></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>Fe<sub>2</sub>O<sub>2</sub></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>Fe O</strong>
        </p>
        <p class="text-center">
            <strong>Fe<sup>+3</sup>O<sup>-2</sup></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>Fe<sub>2</sub>O<sub>3</sub></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>Fe<sub>2</sub>O<sub>3</sub></strong>
        </p>
        <p>
            Sumando <strong>Fe O</strong> con <strong>Fe<sub>2</sub>O<sub>3</sub></strong>
        </p>
        <p>
            Tenemos :  <strong>Fe<sub>3</sub>O<sub>4</sub></strong>
        </p>
        <br>
        <p>
            <strong>EJEMPLO 2: </strong>Para la estructura M<sub>3</sub>O<sub>8</sub>
        </p>
        <p>
            (Caso especial - Se trabaja con elementos Anfoteros)
        </p>
        <p class="text-center">
            <strong>U<sub>3</sub>O<sub>8</sub></strong>
        </p>
        <p class="text-center">
            Oxido Salino de Uranio (N.T) <br>
            Óxido de Uranio (IV-VI) (N.S) <br>
            Octaoxido de Triuranio (N.I)
        </p>
        <p>
            Bien tenemos a nuestro oxido salino, ahora pasamos a ver como se forma y por qué se le conoce como oxido doble, salino o mixto.
        </p>
        <h5><strong>Formación</strong></h5>
        <p>
            En el caso de Uranio este al ser un elemento Anfotero posee valencias tanto metal y no metal, en este caso se trabaja con sus valencias +4, +6.
        </p>
        <p class="text-center">
            <strong>U<sup>+4</sup>O<sup>-2</sup></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>U<sub>2</sub>O<sub>4</sub></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>U O<sub>2</sub></strong>
        </p>
        <p class="text-center">
            <strong>U<sup>+6</sup>O<sup>-2</sup></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>U<sub>2</sub>O<sub>6</sub></strong>
            &nbsp;&nbsp;===>&nbsp;&nbsp;
            <strong>U O<sub>3</sub></strong>
        </p>
        <p>
            Sumando <strong>U O<sub>2</sub></strong> + <span class="text-danger">2</span><strong>U O<sub>3</sub></strong>
        </p>
        <p>
            Tenemos :  <strong>U<sub>3</sub>O<sub>8</sub></strong>
        </p>
        <p>
            <h5 class="text-primary"><strong>¿ Por que sumamos 2 al compuesto <strong>U O<sub>3</sub></strong> ?</strong></h5>
            Resulta que en quimica existen los Numeros estequiometricos, que son los números que aparecen delante de las fórmulas de los reactivos y productos después de igualar la ecuación química.
            <br>
            La igualación de una ecuación química se debe al hecho de que debe conservarse la masa en toda reacción química. <a href="https://www.uv.es/madomin/miweb/leydelavoisier.html" target="_blank">(Ley de Lavoisier)</a>

        </p>
    </div>
');
