
--Se crea la tabla municipios con los campos acorde con la hoja de excel Municipios.xlsx
    create table municipios (
        departamento text,
        dep text,
        municipio text,
        depnum text,
        superficie real,
        poblacion integer,
        irural integer,
        region text
    );

--Se crea la tabla prestadores con los campos acorde con la hoja de excel Prestadores.xls
    create table prestadores (
        depa_nombre text,
        muni_nombre text,
        codigo_habilitacion integer,
        nombre_prestador text,
        tido_codigo text,
        nits_nit text,
        razon_social text,
        clpr_codigo integer,
        clpr_nombre text,
        ese text,
        direccion text,
        telefono text,
        fax text,
        email text,
        gerente text,
        nivel text,
        caracter text,
        habilitado text,
        fecha_radicacion  text,
        fecha_vencimiento text,
        fecha_cierre text,
        dv integer,
        clase_persona,
        naju_codigo integer,
        naju_nombre text,
        numero_sede_principal integer,
        fecha_corte_REPS text, 
        telefono_adicional text, 
        email_adicional text, 
        rep_legal text    
    );

-- Lo siguientes comandos fueron ejecutados en la linea de comandos de SQLite
-- Previamente se han guardado los archivos Prestadores.xls y Municipios.xlsx como CSV para permitir su importacion a SQLite

    /**
        Se crea la base de datos en SQLite
        .open datos.db
        Se activa  el modo CSV para importar los datos
        .mode csv
        Se utiliza el simbolo ';' como separador de las columnas
        .separator ";"
        Se importan los datos Municipios.csv a la tabla municipios 
        .import --skip 1 Municipios.csv municipios
        Se importan los datos Prestadores.csv a la tabla prestadores
        .import --skip 1 Prestadores.csv prestadores
    **/

-- Se verifica la correcta importación de los datos
    select * from municipios;
    select * from prestadores;

/*Los datos de las columnas (municipio y departamento) de la tabla municipios, ademas de (depa_nombre, muni_nombre) de la tabla prestadores contituyen las llaves primarias y secundarias 
  respectivamente por lo que es necesario eliminar caracteres que introducen ruido a la informacion e impiden su relacionamiento
*/
-- las columnas (municipio, departamento) de municipios y (depa_nombre, muni_nombre) de la tablas prestadores deben ser limpiados, para realizarlo se realizan la siguiente acciones

-- 1. Se eliminan los espacios en blanco de los campos descritos, se mantienen los espacios estrictamente necesarios

    UPDATE municipios set departamento=upper(departamento);
    UPDATE municipios set departamento=ltrim(departamento);
    UPDATE municipios set departamento=rtrim(departamento);
    UPDATE municipios set departamento=trim(departamento);
    UPDATE municipios set municipio=upper(municipio);
    UPDATE municipios set municipio=ltrim(municipio);
    UPDATE municipios set municipio=rtrim(municipio);
    UPDATE municipios set municipio=trim(municipio);
    UPDATE prestadores set depa_nombre=upper(depa_nombre);
    UPDATE prestadores set depa_nombre=ltrim(depa_nombre);
    UPDATE prestadores set depa_nombre=rtrim(depa_nombre);
    UPDATE prestadores set depa_nombre=trim(depa_nombre);
    UPDATE prestadores set muni_nombre=upper(muni_nombre);
    UPDATE prestadores set muni_nombre=ltrim(muni_nombre);
    UPDATE prestadores set muni_nombre=rtrim(muni_nombre);
    UPDATE prestadores set muni_nombre=trim(muni_nombre);
    UPDATE municipios set municipio = replace(municipio,"  "," ");
    UPDATE prestadores set depa_nombre = replace(depa_nombre,"  "," ");
    UPDATE prestadores set muni_nombre = replace(muni_nombre,"  "," ");

--2. Se eliminan caracteres especiales

    update municipios set departamento = replace(departamento,"%","");
    update municipios set departamento = replace(departamento,"&","");
    update municipios set departamento = replace(departamento,"#","");
    update municipios set departamento = replace(departamento,">","");
    update municipios set municipio = replace(municipio,"%","");
    update municipios set municipio = replace(municipio,"&","");
    update municipios set municipio = replace(municipio,"#","");
    update municipios set municipio = replace(municipio,">","");
    update municipios set municipio = replace(municipio,"*","");
    update municipios set municipio = replace(municipio,"?","");
    update municipios set municipio = replace(municipio,"!","");
    update municipios set municipio = replace(municipio,"'","");

--3 Para estandarizar los datos se usará mayusculas en los campos (municipio y departamento) y (depa_nombre, muni_nombre) por lo que se transforman los datos

    UPDATE municipios set municipio=upper(municipio);
    UPDATE municipios set departamento=upper(departamento);
    UPDATE municipios set region=upper(region);
    UPDATE prestadores set depa_nombre=upper(depa_nombre);
    UPDATE prestadores set muni_nombre=upper(muni_nombre);
    
--4 Algunos caracteres hay que reemplazarlos por su equivalente a mayuscula
    
    update municipios set departamento = replace(departamento,"á","Á");
    update municipios set departamento = replace(departamento,"é","É");
    update municipios set departamento = replace(departamento,"í","Í");
    update municipios set departamento = replace(departamento,"ó","Ó");
    update municipios set departamento = replace(departamento,"ú","Ú");
    update municipios set departamento = replace(departamento,"ñ","Ñ");
    
    update municipios set municipio = replace(municipio,"á","Á");
    update municipios set municipio = replace(municipio,"é","É");
    update municipios set municipio = replace(municipio,"í","Í");
    update municipios set municipio = replace(municipio,"ó","Ó");
    update municipios set municipio = replace(municipio,"ú","Ú");
    update municipios set municipio = replace(municipio,"ñ","Ñ");
    
    update prestadores set depa_nombre = replace(depa_nombre,"á","Á");
    update prestadores set depa_nombre = replace(depa_nombre,"é","É");
    update prestadores set depa_nombre = replace(depa_nombre,"í","Í");
    update prestadores set depa_nombre = replace(depa_nombre,"ó","Ó");
    update prestadores set depa_nombre = replace(depa_nombre,"ú","Ú");
    update prestadores set depa_nombre = replace(depa_nombre,"ñ","Ñ");
    
    update prestadores set muni_nombre = replace(muni_nombre,"á","Á");
    update prestadores set muni_nombre = replace(muni_nombre,"é","É");
    update prestadores set muni_nombre = replace(muni_nombre,"í","Í");
    update prestadores set muni_nombre = replace(muni_nombre,"ó","Ó");
    update prestadores set muni_nombre = replace(muni_nombre,"ú","Ú");
    update prestadores set muni_nombre = replace(muni_nombre,"ñ","Ñ");

--Se revisa cuantos registros hay en la tabla prestadores encontrando 60946 coherente con las filas de la fuente original

    select count(*) 
        from prestadores; --60946 registros

--Se revisa cuantos registros de prestadores hacen cruce adecuado con la tabla municipios es decir 

    select count(*) 
        from prestadores 
        inner join municipios 
        on municipios.municipio = prestadores.muni_nombre;--49721 registros cruzan con uno o mas filas en municipios

    select count(*) 
        from prestadores 
        inner join municipios 
        on (
            municipios.municipio = prestadores.muni_nombre and municipios.departamento = prestadores.depa_nombre
            ) ;--37732 registros cruzan por departamento y municipio

-- Es necesario identificar los registros que no cruzan, por lo que se hace la siguiente consulta

    select distinct prestadores.muni_nombre,prestadores.depa_nombre, count(*) 
        from prestadores 
        left join municipios 
        on (municipios.municipio = prestadores.muni_nombre) 
        where municipios.municipio is null
        group by prestadores.muni_nombre,prestadores.depa_nombre; -- se obtienen 24 municipios en prestadores que no cruzan con municipio
        
    select distinct prestadores.muni_nombre,prestadores.depa_nombre, count(*) 
        from prestadores 
        left join municipios 
        on (municipios.municipio = prestadores.muni_nombre and municipios.departamento = prestadores.depa_nombre ) 
        where municipios.municipio is null
        group by prestadores.muni_nombre,prestadores.depa_nombre; -- algunos distritos especiales tienen datos errados de sus departamentos
    

-- 5. Se uniformalizan los casos particulares de la siguiente forma

--**ACACÍAS** 
    select * from municipios where municipio like "%ACACIAS%"; --1 registro sin tilde, es necesario agregarla
    select * from prestadores where muni_nombre like "%ACACÍAS%"; -- 63 registros con tilde
    BEGIN TRANSACTION;
        update municipios set municipio='ACACÍAS' where municipio = 'ACACIAS'; -- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
--**BOGOTÁ**
    select * from municipios where municipio like 'BOGOTÁ%'; --1 registro con tilde pero ademas finaliza en 'D C'
    select * from prestadores where muni_nombre like '%BOGOTÁ%'; -- 14728 registros con tilde y finalizan en 'D. C'
    --primero normalizar nombre del municipio
    BEGIN TRANSACTION;
        update municipios set municipio='BOGOTÁ D.C.' where municipio like '%BOGOTÁ%';-- se resuelve conflicto
        update prestadores set muni_nombre='BOGOTÁ D.C.' where muni_nombre like '%BOGOTÁ%';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    --segundo normalizar nombre del departamento
    BEGIN TRANSACTION;
        update municipios set departamento='BOGOTÁ D.C.' where departamento like 'BOGOTÁ%';-- se resuelve conflicto
        update prestadores set depa_nombre='BOGOTÁ D.C.' where depa_nombre like 'BOGOTÁ%';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**CALARCÁ**
    select * from municipios where municipio like "%CALARCÁ%"; --1 registro con tilde, es necesario normalizar
    select * from prestadores where muni_nombre like "%CALARCA%"; -- 32 registros sin tilde
    
    BEGIN TRANSACTION;
        update prestadores set muni_nombre='CALARCÁ' where muni_nombre like 'CALARCA';-- se resuelve normalizar
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**CARMEN DE APICALÁ**
    select * from municipios where municipio like "CARMEN DE APICALA%"; --1 registro sin tilde, es necesario normalizar
    select * from prestadores where muni_nombre like "CARMEN DE APICALÁ%"; -- 32 registros sin tilde
    
    BEGIN TRANSACTION;
        update municipios set municipio='CARMEN DE APICALÁ' where municipio ='CARMEN DE APICALA';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**CHACHAGÜÍ**
    select * from municipios where municipio like "CHACHAG%"; --1 registro con dieresis en minuscula
    select * from prestadores where muni_nombre like "CHACHAGÜÍ%"; -- 32 registros sin tilde
    
    BEGIN TRANSACTION;
        update municipios set municipio='CHACHAGÜÍ' where municipio ='CHACHAGüÍ';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**CHIBOLO**
    select * from municipios where municipio like "CHIVOLO%"; --1 registro con V, segun wikipedia 'CHIBOLO' es el correcto
    select * from prestadores where muni_nombre like "CHIBOLO%"; -- 32 registros sin tilde
    
    BEGIN TRANSACTION;
        update municipios set municipio='CHIBOLO' where municipio ='CHIVOLO';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**CHIMA**
    select * from municipios where municipio like "CHIMÁ%"; --2 registros ambos con tilde
    select * from prestadores where muni_nombre like "CHIMA%"; -- 1 registros sin tilde
    
    BEGIN TRANSACTION;
        update prestadores set muni_nombre='CHIMÁ' where muni_nombre ='CHIMA';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**DIBULLA**
    select * from municipios where municipio like "DIBULA%"; --1 registro erroneo, le falta una L
    select * from prestadores where muni_nombre like "DIBULLA%"; -- 3 registros correctos
    
    BEGIN TRANSACTION;
        update municipios set municipio='DIBULLA' where municipio ='DIBULA';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
 --**GUACHENÉ**
    select * from municipios where municipio like "GUACHENÉ%"; --CIUDAD INEXISTENTE EN BD, es necesario crear registro
    select * from prestadores where muni_nombre like "GUACHENÉ%"; -- 7 registros correctos
    
    BEGIN TRANSACTION;
        -- se verifica dentro de los municipios de cauca que no exista
        select * from municipios where departamento='CAUCA' order by municipio;
        insert into municipios values ('CAUCA','19','GUACHENÉ','19300',392,19815,0,'REGIóN PACíFICO');-- se crea registro, se toman datos del DANE      
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
 --**GUATAPÉ**
    select * from municipios where municipio like "GUATAPÉ%"; --1 registro erroneo, le falta una L
    select * from prestadores where muni_nombre like "GUATAPE%"; -- 3 registros correctos
    
    BEGIN TRANSACTION;
        update prestadores set muni_nombre='GUATAPÉ' where muni_nombre ='GUATAPE';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
 --**GÜEPSA**
    select * from municipios where municipio like "GüEPSA%"; -- REgistro con 'ü' es necesario modificarlo manualmente
    select * from prestadores where muni_nombre like "GÜEPSA%"; -- 1 registro correctos
    
    BEGIN TRANSACTION;        
        update municipios set municipio='GÜEPSA' where municipio ='GüEPSA';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
 --**GÜICÁN**
    select * from municipios where municipio like "GüICÁN"; -- REgistro con 'ü' es necesario modificarlo manualmente
    select * from prestadores where muni_nombre like "GÜICÁN%"; -- 1 registro correctos
    
    BEGIN TRANSACTION;        
        update municipios set municipio='GÜICÁN' where municipio ='GüICÁN';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**MAGÜI**
    select * from municipios where municipio like "MAGüÍ%"; -- Registro con 'ü' es necesario modificarlo manualmente
    select * from prestadores where muni_nombre like "MAGÜI%"; -- 1 mal nombrado
    
    BEGIN TRANSACTION;        
        update municipios set municipio='MAGÜÍ' where municipio ='MAGüÍ';-- se resuelve conflicto
        update prestadores set muni_nombre='MAGÜÍ' where muni_nombre ='MAGÜI';--se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**PÁEZ**
    select * from municipios where municipio like "PÁEZ%"; --2 registros correspondiente de dos departamentos diferentes, correctamente nombrados
    select * from prestadores where muni_nombre like "PAEZ%"; -- 4 registros mal nombrados
    
    BEGIN TRANSACTION;          
        update prestadores set muni_nombre='PÁEZ' where muni_nombre ='PAEZ';-- se resuelve conflicto        
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION
    
 --**PUEBLOVIEJO**
    select * from municipios where municipio like "PUEBLO VIEJO%"; --1 registro mal nombrado
    select * from prestadores where muni_nombre like "PUEBLOVIEJO%"; -- 2 registros correctos
    
    BEGIN TRANSACTION;  
        update municipios set municipio='PUEBLOVIEJO' where municipio ='PUEBLO VIEJO';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**RIOBLANCO**
    select * from municipios where municipio like "RIO BLANCO%"; --1 registro mal nombrado
    select * from prestadores where muni_nombre like "RIOBLANCO%"; -- 5 registros bien nombrados
    
    BEGIN TRANSACTION;
        update municipios set municipio='RIOBLANCO' where municipio ='RIO BLANCO';-- se resuelve conflicto
    COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**SAN LUIS DE PALENQUE**
     select * from municipios where municipio like "%SAN LUIS DE GACENO%" and depnum='85325';  --1 registro mal nombrado, el nombre correcto es 'SAN LUIS DE PALENQUE' se comprueba al verificar en DANE el codigo de municipio y al verificar que no existe un municipio 'SAN LUIS DE GACENO' en Casanare
     select * from prestadores where muni_nombre like "SAN LUIS DE PALENQUE%"; -- 1 registro encontrado

     BEGIN TRANSACTION;
		update municipios set municipio='SAN LUIS DE PALENQUE' where municipio ='SAN LUIS DE GACENO' and depnum='85325';-- se resuelve conflicto		    
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
      

 --**SINCÉ???**
     select * from municipios where municipio like "SINCE%" ;  -- Solo existe un municipio que inicia con estos 4 caracteres y es 'SINCELEJO'
     select * from prestadores where muni_nombre like "SINCÉ%"; -- 13 registros mal nombrados

     BEGIN TRANSACTION;
         update prestadores set muni_nombre='SINCELEJO' where muni_nombre ='SINCÉ';-- se resuelve conflicto        	    
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**SONSÓN**
     select * from municipios where municipio like "SONSÓN%"; --1 registro correcto
     select * from prestadores where muni_nombre like "SONSON%"; -- 24 registros mal nombrados

     BEGIN TRANSACTION;
         update prestadores set muni_nombre='SONSÓN' where muni_nombre ='SONSON';-- se resuelve conflicto     
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**TOGÜÍ**
     select * from municipios where municipio like "TOGüÍ%"; --1 registro mal nombrado
     select * from prestadores where muni_nombre like "TOGÜÍ%"; -- 1 registro correcto

     BEGIN TRANSACTION;
         update municipios set municipio='TOGÜÍ' where municipio ='TOGüÍ';-- se resuelve conflicto
		
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**TUMACO**
     select * from municipios where municipio like "SAN ANDRÉS DE TUMACO"; --1 registro con nombre completo de la ciudad
     select * from prestadores where muni_nombre like "TUMACO%"; -- 101 registros con nombre acortado

     BEGIN TRANSACTION;
         update municipios set municipio='TUMACO' where municipio ='SAN ANDRÉS DE TUMACO';-- se resuelve conflicto		
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**TURBANA**
     select * from municipios where municipio like "TURBANÁ%"; --1 registro bien nombrado
     select * from prestadores where muni_nombre like "TURBANA%"; -- 6 registros sin tilde

     BEGIN TRANSACTION;		
         update prestadores set muni_nombre='TURBANÁ' where muni_nombre ='TURBANA';-- se resuelve conflicto     
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
 
 --**VALLE DEL GUAMUEZ**
     select * from municipios where municipio like "VALLE DE GUAMEZ%"; --1 registro mal nombrado
     select * from prestadores where muni_nombre like "VALLE DEL GUAMUEZ%"; -- 27 registros bien nombrados

     BEGIN TRANSACTION;
         update municipios set municipio='VALLE DEL GUAMUEZ' where municipio ='VALLE DE GUAMEZ';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**VISTAHERMOSA**
     select * from municipios where municipio like "VISTA HERMOSA%"; --1 registro bien nombrado
     select * from prestadores where muni_nombre like "VISTAHERMOSA%"; -- 3 bien nombrados

     BEGIN TRANSACTION;
          update prestadores set muni_nombre='VISTA HERMOSA' where muni_nombre ='VISTAHERMOSA';-- se resuelve conflicto     
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**BUENAVISTA**
     select * from municipios where municipio like "BUENA VISTA%"; --1 registro mal nombrado
     select * from prestadores where muni_nombre like "BUENAVISTA%"; -- 13 mal nombrados

     BEGIN TRANSACTION;
             update municipios set municipio='BUENAVISTA' where municipio ='BUENA VISTA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**BARRANQUILLA**
     select * from prestadores where depa_nombre like "BARRANQUILLA%"; -- 1885 registros en los que se encuentra mal refenciado el departamento, en este caso corresponde a 'ATLÁNTICO'

     BEGIN TRANSACTION;
             update prestadores set depa_nombre='ATLÁNTICO' where depa_nombre ='BARRANQUILLA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
     
 --**BUENAVENTURA**
     select * from prestadores where depa_nombre like "BUENAVENTURA%"; -- 152 registros en los que se encuentra mal refenciado el departamento, en este caso corresponde a 'VALLE DEL CAUCA'

     BEGIN TRANSACTION;
             update prestadores set depa_nombre='VALLE DEL CAUCA' where depa_nombre ='BUENAVENTURA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**CALI**
     select * from prestadores where depa_nombre like "CALI"; -- 4014 registros en los que se encuentra mal refenciado el departamento, en este caso corresponde a 'VALLE DEL CAUCA'

     BEGIN TRANSACTION;
             update prestadores set depa_nombre='VALLE DEL CAUCA' where depa_nombre ='CALI';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**CARTAGENA**
     select * from prestadores where depa_nombre like "CARTAGENA"; -- 1327 registros en los que se encuentra mal refenciado el departamento, en este caso corresponde a 'BOLÍVAR'

     BEGIN TRANSACTION;
             update prestadores set depa_nombre='BOLÍVAR' where depa_nombre ='CARTAGENA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

--**SAN ANDRÉS Y PROVIDENCIA**
     select * from municipios where departamento like "SAN ANDRÉS"; --1 registro mal nombrado, se prefiere 'SAN ANDRÉS Y PROVIDENCIA'
     select * from prestadores where depa_nombre like "SAN ANDRÉS Y PROVIDENCIA%"; -- 98 registros bien nombrados

     BEGIN TRANSACTION;
             update municipios set departamento='SAN ANDRÉS Y PROVIDENCIA' where departamento ='SAN ANDRÉS';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
 
 --**SANTA MARTA**
     select * from prestadores where depa_nombre like "SANTA MARTA"; -- 665 registros en los que se encuentra mal refenciado el departamento, en este caso corresponde a 'MAGDALENA'

     BEGIN TRANSACTION;
             update prestadores set depa_nombre='MAGDALENA' where depa_nombre ='SANTA MARTA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION
 

 --**SAN ANDRÉS DE CUERQUÍA**
     select * from municipios where municipio like "SAN ANDRÉS DE CUERQUÍA"; --1 registro mal nombra
      select * from prestadores where muni_nombre = "SAN ANDRÉS" and depa_nombre='ANTIOQUIA'; --3 registros mal nombrados, corresponde a 'SAN ANDRÉS DE CUERQUÍA'

     BEGIN TRANSACTION;
             update prestadores set muni_nombre='SAN ANDRÉS DE CUERQUÍA' where muni_nombre = "SAN ANDRÉS" and depa_nombre='ANTIOQUIA';-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

 --**SAN PABLO/BOLÍVAR**
     select * from municipios where municipio = "SAN PABLO DE BORBUR" and departamento="BOLÍVAR"; --1 registro mal nombrado, no existe 
      select * from prestadores where muni_nombre = "SAN PABLO" and depa_nombre='BOLÍVAR'; --13 registros bien nombrados

     BEGIN TRANSACTION;
             update municipios set municipio='SAN PABLO' where municipio = "SAN PABLO DE BORBUR" and departamento="BOLÍVAR";-- se resuelve conflicto 
     COMMIT TRANSACTION;--ROLLBACK TRANSACTION

-- VERIRICANDO YA SE LOGRARON CUZAR EL 100% DE LOS DATOS EN LA TABLA PRESTADORES hacia ta tabla MUNICIPIOS
        select count(*) 
            from prestadores 
            left join municipios 
            on (
                municipios.municipio = prestadores.muni_nombre and municipios.departamento = prestadores.depa_nombre
                )
            where municipios.municipio is null; -- se retornan 0 registros sin cruzar
    

        select count(*) 
            from prestadores 
            inner join municipios 
            on (
                municipios.municipio = prestadores.muni_nombre and municipios.departamento = prestadores.depa_nombre
                );-- de igual forma al hacer el cruce nos retorna 60946 registros, exactamente el mismo número de filas de la hoja de Prestadores original
                
-- Finalmente es necesario normalizar algunas columnas de la tabla prestadores y municipios

    select * from prestadores;
    -- columna clpr_nombre
    select distinct (clpr_nombre) from prestadores; 
    update prestadores set clpr_nombre= upper(clpr_nombre); -- paso a mayusculas
    update prestadores set clpr_nombre='OBJETO SOCIAL DIFERENTE A LA PRESTACIÓN DE SERVICIOS DE SALUD' where clpr_nombre='OBJETO SOCIAL DIFERENTE A LA PRESTACIóN DE SERVICIOS DE SALUD';
        
    --columna clase_persona
    select distinct (clase_persona) from prestadores; --correctamente agrupada, no es necesario conciliar datos

    --columna habilitado
    select distinct (habilitado) from prestadores; -- valor unico en todos los registros
    
     --columna naju_nombre
    select distinct (naju_nombre) from prestadores; --correctamente agrupada, no es necesario conciliar datos
    
    --columna naju_nombre
    select distinct (ese) from prestadores; --correctamente agrupada, no es necesario conciliar datos, demasiados datos nulos
    
     --columna nombre_prestador
     update prestadores set nombre_prestador= upper(nombre_prestador); -- se prefiere el uso general de mayusculas
     
    --columna razon_social
     update prestadores set razon_social= upper(razon_social); -- se prefiere el uso general de mayusculas
     
    
    select * from municipios;
    --columna superficie
    select * from municipios where superficie=null; -- en superficie no hay valores nulos que permite realizar analisis basados en este campo
    --columna población
    select * from municipios where poblacion=null or poblacion=0; -- no existen valores de 0 o nulos lo que permite usar esta columna para analisis relacionados con esta
    --región
    select distinct(region) from municipios; -- datos correctamente agrupados, unicamente se reemplazan la í por I y la ó por Ó
    update municipios set region=replace(region,'í','Í');
    update municipios set region=replace(region,'ó','Ó');
    
-- EN ESTE PUNTO LA BASE DE DATOS SE HA NORMALIZADO COMPLETAMENTE Y ESTA LISTA PARA SER ANALIZADA, DICHO ANALÍSIS SE REALIZARÁ EN R

-- *** LAS SIGUIENTES CONSULTAS HAN SIDO REALIZADAS DESDE EL SOFTWARE DE R***



-- 1. CONSULTA REGIONES
select 
    region,
    departamento,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter,
    ese
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where clpr_codigo=1;

select 
    region,
    departamento,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter,
    ese
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where ese='SI';
   
-- 1.1 

--1.2

-- 2.1 CONSULTA DE DISTRICUBION DE LOS SERVICIOS DE SALUD POR DEPARTAMENTO, SE INCLUYEN UNICAMENTE IPSs
select 
    departamento,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where clpr_codigo=1;

-- 2.2 CONSULTA DE DISTRICUBION DE LOS SERVICIOS DE SALUD POR DEPARTAMENTO, SE INCLUYEN UNICAMENTE INDEPENDIENTES
select 
    departamento,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where clpr_codigo=2;
    
select * from prestadores;
    
-- 2.3 Resumen IPS x cada 10.000Hab 
    select 
        departamento, 
        count(distinct(municipio)) as numMunicipios,
        count(*)*10000.0 /(select sum(poblacion) from municipios where departamento==MM.departamento) as Prestadores,
        count( case when naju_nombre='Privada' then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresPrivados,
        count( case when naju_nombre='Pública' then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresPublicos,
        count( case when naju_nombre='Mixta' then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresMixtos
    from municipios MM
    inner join prestadores 
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre
    where clpr_codigo=1
    group by departamento
    order by Prestadores desc;
-- 2.4 Resumen IPS x cada 1000 Km2

   select 
        departamento, 
        count(distinct(municipio)) as numMunicipios,
        count(*) as prestadpres,
        (select sum(superficie) from municipios where departamento==MM.departamento) as superficie,
        count(*)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as TotalPrestadoresx1000,
        count( case when naju_nombre="Privada" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresPrivadax1000,
        count( case when naju_nombre="Pública" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresPublicasx1000,
        count( case when naju_nombre="Mixta" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresMixtox1000
    from municipios MM
    inner join prestadores 
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre
    where clpr_codigo=1
    group by departamento
    order by TotalPrestadoresx1000;
    
-- 2.5 Resumen ESES

select 
    departamento,
    municipio,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where  ese="SI" ;

-- 2.6 ResumeN entidades publicas

select 
    departamento,
    municipio,
    naju_nombre,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where naju_codigo=4 and clpr_codigo=1;

-- 2.7 Resumen IPS privadas

select 
    departamento,
    municipio,
    naju_codigo,
    naju_nombre,
    clpr_codigo,
    clpr_nombre,
    municipio,
    nombre_prestador,
    caracter
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre 
    where naju_codigo=1 and clpr_codigo=1;
    
-- 2.8 Resumen IPS vs Profesionales Independientes
select     
    departamento,
    municipio,
    count(case when clpr_codigo=1 then 1 end) as IPSs,
    count(case when clpr_codigo=2 then 1 end) as Independientes
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre  
    group by departamento,municipio;
    
-- 2.8 Resumen IPS vs Profesionales Independientes
select     
    departamento,
    municipio,
    count(case when clpr_codigo=1 then 1 end) as IPSs,
    count(case when clpr_codigo=2 then 1 end) as Independientes
    from municipios MM 
    inner join prestadores
    on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre  
    group by departamento,municipio;
