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
-------fin db_final
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







--PARA EL TEMA 1
insert into ejercicio0 values(1, 1, '{
	"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "En Química cualquier cosa que tenga masa y ocupe un lugar en el espacio es:",
			"descripcion" : "",
			"opciones" : ["objeto", "materia", "electron"],
			"respuesta" : "materia"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿Cuales son los 3 estados de la materia?",
			"descripcion" : "",
			"opciones" : ["solido, liquido, gaseoso", "solido, congelado, gaseoso", "ninguna de las anteriores"],
			"respuesta" : "solido, liquido, gaseoso"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "La combinación de dos o mas sustancias en la que estas conservan sus propiedades se denomina",
			"descripcion" : "",
			"opciones" : ["mezclas", "sustancias", "ninguno"],
			"respuesta" : "mezclas"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "En las mezclas homogeneas, la composición de la mezcla es:",
			"descripcion" : "",
			"opciones" : ["uniforme", "dispersa", "ninguno"],
			"respuesta" : "uniforme"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "En las mezclas heterogeneas, la composición de la mezcla es:",
			"descripcion" : "",
			"opciones" : ["dispersa", "no uniforme", "uniforme"],
			"respuesta" : "no uniforme"
		}
			]
}');

--PARA EL TEMA 2
insert into ejercicio0 values(2, 1, '{
	"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿De que está formado el Núcleo Atómico?",
			"opciones" : ["Protones y Electrones", "Electrones y Neutrones", "Protones y Neutrones"],
			"descripcion" : "",
			"respuesta" : "Protones y Neutrones"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "Es la unidad mas pequeña posible de un elemento Químico...",
			"descripcion" : "",
			"opciones" : ["El Neutrón", "El núcleo", "El Átomo"],
			"respuesta" : "El Átomo"
		},
        {
			"tipo" : "completar",
			"pregunta" : "¿En cuantas ramas se divide la Química?",
			"descripcion" : "Introduzca un numero entre: 1, 2, 7, 4",
			"respuesta" : "4"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿De que esta compuesto el núcleo de un átomo?",
			"descripcion" : "",
			"opciones" : ["electrones y neutrones", "protones y electrones", "electrones"],
			"respuesta" : "electrones"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "Los Electrones poseen carga...",
			"descripcion" : "",
			"opciones" : ["positiva", "negativa", "todos los anteriores"],
			"respuesta" : "negativa"
		}
			]
}');
--PARA EL TEMA 3
insert into ejercicio0 values(3, 1, '{
	"lista" : [
        {
			"tipo" : "completar",
			"pregunta" : "¿Cuantos tipos de nomenclatura son comunmente utilizados?",
			"descripcion" : "Introduzca un numero",
			"respuesta" : "3"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Las opciones que se presentan a continuación todas son nomenclaturas?. Determine la opcion correcta",
			"opciones" : ["Nomenclatura tradicinal (NT)", "Nomenclatura STOCK (NS)", "Nomenclatura IUPAC (NI)", "Todas las anteriores"],
			"respuesta" : "Todas las anteriores"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿En que nomenclatura, el numero de oxidación se indica con Numeros Romanos?",
			"opciones" : ["Nomenclatura tradicional (NT)", "Nomenclatura IUPAC (NI)", "Nomenclatura STOCK (NS)"],
			"respuesta" : "Nomenclatura STOCK (NS)"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿A que tipo de nomenclatura pertenece, la que utiliza prefijos (mono, di, tri,..)?",
			"opciones" : ["Nomenclatura tradicional (NT)", "Nomenclatura IUPAC (NI)", "Nomenclatura STOCK (NS)"],
			"respuesta" : "Nomenclatura IUPAC (NI)"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿A que tipo de nomenclatura pertenece, la que utiliza prefijos y sufijos (hipo, oso, ico,..)?",
			"opciones" : ["Nomenclatura tradicional (NT)", "Nomenclatura IUPAC (NI)", "Nomenclatura STOCK (NS)"],
			"respuesta" : "Nomenclatura tradicional (NT)"
		}
			]
}');
--4
--        <sub></sub>      <sup></sup>
insert into ejercicio0 values(4, 2, '{
	"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?",
			"descripcion" : "Pb O<sub>2</sub>",   
			"opciones" : ["Oxido Plumboso", "Oxido Plumbico", "Hidroxido de Plomo"],
			"respuesta" : "Oxido Plumboso"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Seleccione la formula quimica del siguiente compuesto",
			"descripcion" : "Oxido de Oro (I)",
			"opciones" : ["Au<sub>2</sub> O", "Au O", "Au<sub>2</sub> O<sub>3</sub>"],
			"respuesta" : "Au<sub>2</sub> O"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura Stock, cual es el nombre del siguiente compuesto?",
			"descripcion" : "Ra O",
			"opciones" : ["Oxido de radio", "Dioxido de radio", "Oxido de radio (II)", "Ninguna de las anteriores"],
			"respuesta" : "Oxido de radio (II)"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "Seleccione la formula quimica del siguiente compuesto",
			"descripcion" : "Oxido de radio (II)",
			"opciones" : ["Ra<sub>2</sub> O", "Ra O", "Ra<sub>2</sub> O<sub>4</sub>"],
			"respuesta" : "Ra O"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Seleccione la formula quimica del siguiente compuesto",
			"descripcion" : "Oxido de estaño (II)",
			"opciones" : ["Sn O", "Sn<sub>3</sub> O<sub>2</sub>", "Ra O<sub>3</sub>"],
			"respuesta" : "Sn O"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura IUPAC, cual es el nombre del siguiente compuesto?",
			"descripcion" : "Ra O",
			"opciones" : ["Oxido de radio", "Monoxido de radio", "Oxido de radio (II)"],
			"respuesta" : "Monoxido de radio"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura Stock, cual es el nombre del siguiente compuesto?",
			"descripcion" : "Ra O",
			"opciones" : ["Oxido de Radio", "Oxido de Radio (II)", "Monoxido de Radio"],
			"respuesta" : "Oxido de Radio (II)"
		},
		{
			"tipo" : "completar",
			"pregunta" : "¿Cual es el numero que deberia aparecer en la X del Oxido plumbico?",
			"descripcion" : "Pb O<sub>X</sub>",
			"respuesta" : "2"
		}
			]
}');
insert into ejercicio0 values(5, 2, '{
"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?",
			"descripcion" : "Cl<sub>2</sub> O",   
			"opciones" : ["Anhidrido percloroso", "Anhidrido hipocloroso", "Anhidrido perclorico"],
			"respuesta" : "Anhidrido hipocloroso"
		},
		{
			"tipo" : "completar",
			"pregunta" : "En el siguiente <strong>Anhidrido fosforoso</strong>, que numero deberia ir en la x",
			"descripcion" : "P<sub>X</sub> O<sub>3</sub>",
			"respuesta" : "2"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?",
			"descripcion" : "P<sub>2</sub> O<sub>5</sub>",
			"opciones" : ["Anhidrido polonico", "Oxido de calcio", "Oxido de Fosforo", "Anhidrido fosfórico"],
			"respuesta" : "Anhidrido fosfórico"
		},
		{
			"tipo" : "completar",
			"pregunta" : "Del siguiente <strong>Anhidrido Hipobromoso</strong>, que valor deberia ir en la x",
			"descripcion" : "Br<sub>2</sub> O<sub>X</sub>",
			"respuesta" : "1"
		},
		{
			"tipo" : "completar",
			"pregunta" : "Del siguiente <strong>Anhidrido Sulfurico</strong>, que valor deberia ir en la x",
			"descripcion" : "S<sub>2</sub> O<sub>X</sub>",
			"respuesta" : "6"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "En nomenclatura Stock, es correcto que la formula <strong>Cl<sub>2</sub> O</strong> se llame:",
			"descripcion" : "Oxido de cloro (I)",
			"opciones" : ["Si es correcto", "No es correcto"],
			"respuesta" : "Si es correcto"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?",
			"descripcion" : "N<sub>2</sub> O<sub>3</sub>",
			"opciones" : ["Anhidrido nitrico", "Anhidrido nitroso", "Anhidrido niquelico"],
			"respuesta" : "Anhidrido nitroso"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Seleccione la formula quimica del siguiente compuesto",
			"descripcion" : "Oxido de Nitrogeno (V)",
			"opciones" : ["N O", "N<sub>3</sub> O<sub>2</sub>", "N<sub>2</sub> O<sub>5</sub>"],
			"respuesta" : "Sn O"
		}
			]
}');

insert into ejercicio0 values(6, 2, '{
"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?",
			"descripcion" : "H<sub>2</sub> O<sub>2</sub>",   
			"opciones" : ["Agua", "Peroxido de zinc", "Peroxido de hidrogeno"],
			"respuesta" : "Peroxido de hidrogeno"
		},
		{
			"tipo" : "completar",
			"pregunta" : "En el siguiente compuesto <strong>Peroxido de mercurio (II)</strong>, que numero deberia ir en la x",
			"descripcion" : "Hg (O<sub>X</sub>)",
			"respuesta" : "2"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿El siguiente compuesto <strong>Ge O<sub>2</sub></strong>, es un peroxido?",
			"descripcion" : "",
			"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
			"respuesta" : "No, no es un peroxido"
		},
		{
			"tipo" : "completar",
			"pregunta" : "En el siguiente compuesto <strong>Peroxido de hidrogeno</strong>, que numero deberia ir en la x",
			"descripcion" : "H<sub>2</sub> O<sub>X</sub>",
			"respuesta" : "2"
		},
        {
			"tipo" : "seleccionar",
			"pregunta" : "¿El siguiente compuesto <strong>Sr O</strong>, es un peroxido?",
			"descripcion" : "",
			"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
			"respuesta" : "No, no es un peroxido"
		},
		 {
			"tipo" : "seleccionar",
			"pregunta" : "¿El siguiente compuesto <strong>Cr<sub>2</sub> (O<sub>2</sub>)<sub>3</sub></strong>, es un peroxido?",
			"descripcion" : "",
			"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
			"respuesta" : "Si, es un peroxido"
		},
        {
			"tipo" : "completar",
			"pregunta" : "En el siguiente compuesto <strong>Peroxido de cromo (III)</strong>, que numero deberia ir en la x",
			"descripcion" : "Cr<sub>X</sub> (O<sub>2</sub>)<sub>3</sub>",
			"respuesta" : "2"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿El siguiente compuesto <strong>Fe O<sub>2</sub></strong>, es un peroxido?",
			"descripcion" : "",
			"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
			"respuesta" : "Si, es un peroxido"
		}
			]
}');


insert into ejercicio0 values(7, 2, '{
"lista" : [
		{
			"tipo" : "seleccionar",
			"pregunta" : "Es correcto que el Oxido Mixto o Doble, <strong>Fe<sub>3</sub> O<sub>4</sub></strong> se nombre de la siguiente manera:",
			"descripcion" : "Oxido ferroso - ferrico",
			"opciones" : ["No es correcto", "Si es correcto", "No puede ser ambas"],
			"respuesta" : "Si es correcto"
		},
		{
			"tipo" : "completar",
			"pregunta" : "En el siguiente oxido doble <strong>Fe<sub>X</sub> O<sub>4</sub></strong>, que numero deberia ir en la x",
			"descripcion" : "Oxido ferroso - ferrico",
			"respuesta" : "2"
		},
		{
			"tipo" : "completar",
			"pregunta" : "En el siguiente compuesto <strong>Oxido de cobalto (II) Y (III)</strong>, que numero deberia ir en la x",
			"descripcion" : "Co<sub>3</sub> O<sub>X</sub>",
			"respuesta" : "4"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "¿El siguiente compuesto <strong>Pb<sub>3</sub> O<sub>4</sub></strong>, es un oxido doble?",
			"descripcion" : "",
			"opciones" : ["Si, si es", "No, no es"],
			"respuesta" : "Si, si es"
		},
		{
			"tipo" : "completar",
			"pregunta" : "Que valor deberia tener X para que la formula general de los oxidos dobles sea correcta",
			"descripcion" : "M<sub>3</sub> O<sub>4</sub> &nbsp;&nbsp; M<sub>3</sub> O<sub>X</sub> &nbsp;&nbsp; M<sub>2</sub> O<sub>4</sub>",
			"respuesta" : "8"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Los oxidos dobles, son compuestos binarios que resultan de la combinación de oxidos simples de un mismo metal",
			"descripcion" : "¿Es correcta la definición?",
			"opciones" : ["Si", "No"],
			"respuesta" : "Si"
		},
		{
			"tipo" : "seleccionar",
			"pregunta" : "Con que otro nombre se conoce a los Oxidos dobles",
			"descripcion" : "",
			"opciones" : ["Oxidos Salinos", "Oxidos Mixtos", "Oxidos Dobles", "Todas las anteriores"],
			"respuesta" : "Todas las anteriores"
		}
			]
}');



--============================= BANCO DE DATOS DE PREGUNTAS PARA CADA EJERCICIO ==========================
insert into pregunta(id_pregunta, id_ejercicio, pregunta)
	values
	(1, 1, '{
				"pregunta" : "¿Cuales son los 3 estados de la materia?",
        		"opciones" : ["solido, liquido, gaseoso", "solido, congelado, gaseoso", "ninguna de las anteriores"],
        		"respuesta" : "solido, liquido, gaseoso"
			}'
	),
	(2, 1, '{
				"pregunta" : "¿Cuales son los 3 estados de la materia?",
        		"opciones" : ["solido, liquido, gaseoso", "solido, congelado, gaseoso", "ninguna de las anteriores"],
        		"respuesta" : "solido, liquido, gaseoso"
			}'
	),

    (3, 1, '{"pregunta" : "La Química es la ciencia que estudia...",
            "opciones" : [" el origen, la evolución y las características de los seres vivos", "las propiedades de la materia y de la energía", "los cambios y transformaciones que sufre la materia", "ninguna de las anteriores"],
            "respuesta" : "los cambios y transformaciones que sufre la materia"}'),

    (4, 1, '{"pregunta" : "¿Quienes fueron los primeros Alquimistas?",
            "opciones" : ["Naturistas Rusos", "Científicos Ingleses", "Científicos Islámicos"],
            "respuesta" : "Científicos Islámicos"}'),

    (5, 1, '{"pregunta" : "¿Alguna vez la Química fue considerada esotérica (espiritual)?",
            "opciones" : ["No", "Si"],
            "respuesta" : "Si"}'),        

    (6, 1, '{"pregunta" : "En la antigüedad la Química era conocida como...",
            "opciones" : ["Magia", "Ocultismo", "Alquimia", "Nigromancia"],
            "respuesta" : "Alquimia"}'), 

    (7, 1, '{"pregunta" : "¿En cuantas ramas se divide la Química?",
            "opciones" : ["5", "2", "4" ,"3"],
            "respuesta" : "4"}'), 

    (8, 1, '{"pregunta" : "La Bioquímica pertenece a la rama de...",
            "opciones" : ["Química Aplicada", "Química Pura", "Química Descriptiva", "Química General"],
            "respuesta" : "Química Aplicada"}'), 

    (9, 1, '{"pregunta" : "Es la unidad mas pequeña posible de un elemento Químico...",
            "opciones" : ["El Neutrón", "El núcleo", "El Átomo"],
            "respuesta" : "El Átomo"}'), 

    (10, 1, '{"pregunta" : "¿De cuantas subestructuras esta compuesta el Átomo?",
            "opciones" : ["3", "6", "4"],
            "respuesta" : "3"}'), 

    (11, 1, '{"pregunta" : "¿De que está formado el Núcleo Atómico?",
            "opciones" : ["Protones y Electrones", "Electrones y Neutrones", "Protones y Neutrones"],
            "respuesta" : "Protones y Neutrones"}'), 

    (12, 1, '{"pregunta" : "¿Cuantas Nomenclaturas Químicas se utilizan comunmente?",
            "opciones" : ["2", "3", "4"],
            "respuesta" : "3"}'), 

    (13, 1, '{"pregunta" : "Óxido de Potasio, está en nomenclatura...",
            "opciones" : ["Tradicional", "Iupac", "Stock"],
            "respuesta" : "Tradicional"}'), 

    (14, 1, '{"pregunta" : "Monóxido de carbono, está en nomenclatura...",
            "opciones" : ["Tradicional", "Iupac", "Stock"],
            "respuesta" : "Iupac"}'), 

    (15, 1, '{"pregunta" : "Tetracloruro de Potasio, está en nomenclatura...",
            "opciones" : ["Tradicional", "Iupac", "Stock"],
            "respuesta" : "Iupac"}'), 

    (16, 1, '{"pregunta" : "Óxido de Hierro, está en nomenclatura...",
            "opciones" : ["Tradicional", "Iupac", "Stock"],
            "respuesta" : "Stock"}'
			),
	(17, 1, 
			'{
				"pregunta" : "La combinación de dos o mas sustancias en la que estas conservan sus propiedades se denomina",
            	"opciones" : ["mezclas", "sustancias", "ninguno"],
				"respuesta" : "mezclas"
			}'
	),
	--FIN DE LA LECCION 1
	--INICIO DE LA LECCION 2
	(18, 2, 
			'{
				"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?</br><strong>Pb O<sub>2</sub></strong>",
            	"opciones" : ["Oxido Plumboso", "Oxido Plumbico", "Hidroxido de Plomo"],
				"respuesta" : "Oxido Plumboso"
			}'
	),
	(19, 2, 
			'{
				"pregunta" : "Seleccione la formula quimica del siguiente compuesto, <strong>Oxido de Oro (I)</strong>",
            	"opciones" : ["Au<sub>2</sub> O", "Au O", "Au<sub>2</sub> O<sub>3</sub>"],
				"respuesta" : "Au<sub>2</sub> O"
			}'
	),
	(20, 2, 
			'{
				"pregunta" : "Seleccione la formula quimica del siguiente compuesto, <strong>Oxido de radio (II)</strong>",
            	"opciones" : ["Ra<sub>2</sub> O", "Ra O", "Ra<sub>2</sub> O<sub>4</sub>"],
				"respuesta" : "Ra O"
			}'
	),
	(21, 2, 
			'{
				"pregunta" : "Seleccione la formula quimica del siguiente compuesto, <strong>Oxido de estaño (II)</strong>",
            	"opciones" : ["Sn O", "Sn<sub>3</sub> O<sub>2</sub>", "Ra O<sub>3</sub>"],
				"respuesta" : "Sn O"
			}'
	),
	(22, 2, 
			'{
				"pregunta" : "¿En nomenclatura IUPAC, cual es el nombre del siguiente compuesto?, <strong>Ra O</strong>",
            	"opciones" : ["Oxido de radio", "Monoxido de radio", "Oxido de radio (II)"],
				"respuesta" : "Monoxido de radio"
			}'
	),
	(23, 2, 
			'{
				"pregunta" : "¿En nomenclatura Stock, cual es el nombre del siguiente compuesto?, <strong>Ra O</strong>",
            	"opciones" : ["Oxido de Radio", "Oxido de Radio (II)", "Monoxido de Radio"],
				"respuesta" : "Oxido de Radio (II)"
			}'
	),
	(24, 2, 
			'{
				"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente formula?, <strong>P<sub>2</sub> O<sub>5</sub></strong>",
            	"opciones" : ["Anhidrido polonico", "Oxido de calcio", "Oxido de Fosforo", "Anhidrido fosfórico"],
				"respuesta" : "Anhidrido fosfórico"
			}'
	),
	(25, 2, 
			'{
				"pregunta" : "En nomenclatura Stock, es correcto que la formula <strong>Cl<sub>2</sub> O</strong> se llame: <strong>Oxido de cloro (I)</strong>",
            	"opciones" : ["Si es correcto", "No es correcto"],
				"respuesta" : "Si es correcto"
			}'
	),
	(26, 2, 
			'{
				"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?, <strong>N<sub>2</sub> O<sub>3</sub></strong>",
            	"opciones" : ["Anhidrido nitrico", "Anhidrido nitroso", "Anhidrido niquelico"],
				"respuesta" : "Anhidrido nitroso"
			}'
	),
	(27, 2, 
			'{
				"pregunta" : "Seleccione la formula quimica del siguiente compuesto, <strong>Oxido de Nitrogeno (V)</strong>",
            	"opciones" : ["N O", "N<sub>3</sub> O<sub>2</sub>", "N<sub>2</sub> O<sub>5</sub>"],
				"respuesta" : "Sn O"
			}'
	),
	(28, 2, 
			'{
				"pregunta" : "¿En nomenclatura tradicional, cual es el nombre del siguiente compuesto?, <strong>H<sub>2</sub> O<sub>2</sub></strong>",
            	"opciones" : ["Agua", "Peroxido de zinc", "Peroxido de hidrogeno"],
				"respuesta" : "Peroxido de hidrogeno"
			}'
	),
	(29, 2, 
			'{
				"pregunta" : "¿El siguiente compuesto <strong>Ge O<sub>2</sub></strong>, es un peroxido?",
            	"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
				"respuesta" : "No, no es un peroxido"
			}'
	),
	(30, 2, 
			'{
				"pregunta" : "¿El siguiente compuesto <strong>Sr O</strong>, es un peroxido?",
            	"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
				"respuesta" : "No, no es un peroxido"
			}'
	),
	(31, 2, 
			'{
				"pregunta" : "¿El siguiente compuesto <strong>Cr<sub>2</sub> (O<sub>2</sub>)<sub>3</sub></strong>, es un peroxido?",
            	"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
				"respuesta" : "Si, es un peroxido"
			}'
	),
	(32, 2, 
			'{
				"pregunta" : "¿El siguiente compuesto <strong>Fe O<sub>2</sub></strong>, es un peroxido?",
            	"opciones" : ["Si, es un peroxido", "No, no es un peroxido", "Todas son correctas"],
				"respuesta" : "Si, es un peroxido"
			}'
	),
	(33, 2, 
			'{
				"pregunta" : "Es correcto que el Oxido Mixto o Doble, <strong>Fe<sub>3</sub> O<sub>4</sub></strong> se nombre de la siguiente manera: <strong>Oxido ferroso - ferrico</strong>",
            	"opciones" : ["No es correcto", "Si es correcto", "No puede ser ambas"],
				"respuesta" : "Si es correcto"
			}'
	),
	(34, 2, 
			'{
				"pregunta" : "¿El siguiente compuesto <strong>Pb<sub>3</sub> O<sub>4</sub></strong>, es un oxido doble?",
            	"opciones" : ["Si, si es", "No, no es"],
				"respuesta" : "Si, si es"
			}'
	),
	(35, 2, 
			'{
				"pregunta" : "Los oxidos dobles, son compuestos binarios que resultan de la combinación de oxidos simples de un mismo metal</br¿Es correcta la definición?",
            	"opciones" : ["Si", "No"],
				"respuesta" : "Si"
			}'
	),
	(36, 2, 
			'{
				"pregunta" : "Con que otro nombre se conoce a los Oxidos dobles",
            	"opciones" : ["Oxidos Salinos", "Oxidos Mixtos", "Oxidos Dobles", "Todas las anteriores"],
				"respuesta" : "Todas las anteriores"
			}'
	)
;
--============================= FIN DEL BANCO DE DATOS DE PREGUNTAS DE EJERCICIO ==========================
