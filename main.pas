PROGRAM tiendaURJC;
CONST
	NCTIPO = 15; 
	NCIDENTIFICADOR = 4; 
	MAXPC = 25; 
	MAXCOMPONENTES = 100; 
	MIN = 1;
TYPE
	tTipo = string[NCTIPO]; 
	tIdentificador = string[NCIDENTIFICADOR]; 
	tNumComponentes = MIN..MAXCOMPONENTES; 
	tNumPc = MIN..MAXPC; 
	tComponente = RECORD 
		tipo: tTipo;
		id: tIdentificador;
		descripcion: string;
		precio : real;
	END;
	tPc = RECORD
		datos, memoria, procesador, discoDuro: tComponente;
	END;
	tListaComponentes= ARRAY [tNumComponentes] OF tComponente;
	tListaPcs = ARRAY [tNumPc] OF tPc;
	tAlmacenComponentes = RECORD
		listaComponentes : tListaComponentes;
		tope: integer;
	END;
	tAlmacenPcs = RECORD 
		listaPcs : tListaPcs;
		tope: integer;
	END;
	tTienda = RECORD
		almacenPcs : tAlmacenPcs;
		almacenComponentes: tAlmacenComponentes;
		ventasTotales: real; 
	END;
	tFicheroPcs = FILE OF tPc;
	tFicheroComponentes = FILE OF tComponente;
{-----------------------------------------Aqui empiezan los subprogramas de Raul---------------------------}
PROCEDURE inicio(VAR tien:tTienda);
BEGIN{inicio}
	WITH tien DO
	BEGIN
		almacenComponentes.tope:=0;
		almacenPcs.tope:=0;
		ventasTotales:=0;
	END;
END;{inicio}

FUNCTION comprobAlmacen (almacenComp:tAlmacenComponentes):boolean;
BEGIN{comprobAlmacen}
	IF almacenComp.tope = MAXCOMPONENTES THEN
		comprobAlmacen:= TRUE
	ELSE
		comprobAlmacen:= FALSE
END;{comprobAlmacen}

PROCEDURE leerComponente( VAR comp:tComponente);
VAR
	opc:integer;
BEGIN{leerComp}
	WITH comp DO
	BEGIN
		REPEAT
			writeln('Seleccione el tipo de componente:');
			writeln('1) Procesador.');
			writeln('2) Disco duro.');
			writeln('3) Memoria.');
			readln(opc);
			CASE opc OF
				1:tipo:='procesador';
				2:tipo:='disco duro';
				3:tipo:='memoria';
			END;
		UNTIL ((opc=1) OR (opc=2) OR (opc=3));
		writeln('Introduzca el identificador:');
		readln(id);
		writeln('Introduzca la descripcion:');
		readln(descripcion);
		writeln('Introduzca el precio');
		readln(precio);
	END;
END;{leerComp}

PROCEDURE altaComponente (comp:tComponente; VAR almacenComp:tAlmacenComponentes);
VAR
	i:integer;
BEGIN{alta}
	FOR i:=0 to almacenComp.tope DO
		IF comp.id=almacenComp.listaComponentes[i].id THEN
			writeln('El identificador ya corresponde a otro componente')
		ELSE
		BEGIN
			almacenComp.tope:=almacenComp.tope + 1;
			almacenComp.listaComponentes[almacenComp.tope]:=comp;
		END;
END;{alta}


PROCEDURE buscar (iden:tIdentificador;almacen:tAlmacenComponentes;VAR compo:tComponente; tip:string;VAR auxi:integer);
VAR
	i:integer;
BEGIN{proce}
	i:=0;
	REPEAT
		i:=i+1;
	UNTIL(i=(almacen.tope)) OR ((almacen.listaComponentes[i].id)=(iden));
	IF ((almacen.listaComponentes[i].id)=(iden)) THEN
		IF almacen.listaComponentes[i].tipo=tip THEN
		BEGIN
			compo:=almacen.listaComponentes[i];
			auxi:=1;
		END
		ELSE
			writeln('El componente elegido no es un ',tip)
	ELSE
		writeln('El identificador no corresponde a un componente');
END;{proce}



PROCEDURE altaPc (ordenador:tPc; VAR almacen:tAlmacenPcs);
VAR
	i:integer;
BEGIN{alta}
	FOR i:=0 to almacen.tope DO
		IF ordenador.datos.id=almacen.listaPcs[i].datos.id THEN
			writeln('El identificador ya corresponde a otro ordenador')
		ELSE IF almacen.tope=MAXPC THEN
			writeln('El almacen de ordenadores está lleno')
		ELSE
		BEGIN
			almacen.tope:=almacen.tope + 1;
			almacen.listaPcs[almacen.tope]:=ordenador;
		END;
END;{alta}

FUNCTION posicion(almacen:tAlmacenComponentes;comp:tIdentificador):integer;
VAR
	i:integer;
BEGIN{posicion}
	i:=0;
	REPEAT
		i:=i+1;
	UNTIL (i=(almacen.tope)) OR ((almacen.listaComponentes[i].id)=(comp));
	IF ((almacen.listaComponentes[i].id)=(comp))THEN
		posicion:=i
	ELSE
		posicion:=0;
END;{posicion}


PROCEDURE eliminar(VAR almacen:tAlmacenComponentes;componente:tIdentificador);
VAR
	posi:integer;

BEGIN{eliminar}
	posi:=posicion(almacen,componente);
	WITH almacen DO BEGIN
		listaComponentes[posi]:=listaComponentes[tope];
		tope:=tope-1;
	END;
END;{eliminar}

PROCEDURE mostrarComp (componenteMod:tComponente);
BEGIN{mostrar}
	WITH componenteMod DO BEGIN
		writeln('Tipo del componente:');
		writeln(tipo);
		writeln('Descripcion del componente:');
		writeln(descripcion);
		writeln('Precio del componente');
		writeln(precio:0:2);
	END;
END;{mostrar}

PROCEDURE menuComp;
BEGIN{menu}
	writeln('MENU DE MODIFICACION');
	writeln('1.- Modificar el tipo');
	writeln('2.- Modificar la descripcion');
	writeln('3.- Modificar el precio');
	writeln('f.-Finalizar modificacion');
END;{menu}
{---------------------------------Aqui acaban los subprogramas de Raul y empiezan los de Aitor-----------------------}
PROCEDURE mostrarMenu;
BEGIN
	writeln('------------------------------------------------------------------------');
	writeln('A) Dar de alta un componente.');
	writeln('B) Configurar un ordenador.');
	writeln('C) Modificar un componente.');
	writeln('D) Vender un componente.');
	writeln('E) Vender un ordenador.');
	writeln('F) Mostrar las ventas actuales.');
	writeln('G) Mostrar todos los ordenadores ordenados por precio de menor a mayor.');
	writeln('H) Mostrar todos los componentes sueltos.');
	writeln('I) Guardar datos en ficheros binarios.');
	writeln('J) Guardar datos en ficheros de texto.');
	writeln('K) Cargar datos de ficheros binarios.');
	writeln('L) Cargar datos de ficheros de texto.');
	writeln('M) Finalizar.');
	writeln('Introduzca una opcion:');
END;
PROCEDURE guardarBin (tien:tTienda; VAR fichComp:tFicheroComponentes; VAR fichPcs:tFicheroPcs);
VAR
	i:integer;
BEGIN
	ASSIGN(fichComp,'componentes.dat');
	REWRITE(fichComp);
	WITH tien DO
		WITH almacenComponentes DO
			FOR i:=1 TO tope DO
				WRITE(fichComp,listaComponentes[i]);
	CLOSE(fichComp);
	ASSIGN(fichPcs,'ordenadores.dat');
	REWRITE(fichPcs);
	WITH tien DO
		WITH almacenPcs DO
			FOR i:=1 TO tope DO
				WRITE(fichPcs,listaPcs[i]);
	CLOSE(fichPcs);
END;

PROCEDURE cargarBin(VAR tien:tTienda; VAR fichComp:tFicheroComponentes; VAR fichPcs:tFicheroPcs);
VAR
	i,j:integer;
	listaC:tListaComponentes;
	listaP:tListaPcs;
BEGIN
	i:=1;
	j:=1;
	ASSIGN(fichComp,'componentes.dat');
	RESET(fichComp);
	WHILE NOT EOF(fichComp) DO
	BEGIN
		read(fichComp,listaC[i]);
		i:=i+1;
	END;
	ASSIGN(fichPcs,'ordenadores.dat');
	RESET(fichPcs);
	WHILE NOT EOF(fichPcs) DO
	BEGIN
		read(fichPcs,listaP[j]);
		j:=j+1;
	END;
	WITH tien DO
	BEGIN
		WITH almacenPcs DO
		BEGIN
			tope:=j-1;
			listaPcs:=listaP;
		END;
		WITH almacenComponentes DO
		BEGIN
			tope:=i-1;
			listaComponentes:=listaC;
		END;
		ventasTotales:=0;
	END;
END;

PROCEDURE guardarText (tien:tTienda; VAR fichComp:text; VAR fichPcs:text);
VAR
	i:integer;
BEGIN
	ASSIGN(fichComp,'componentes.txt');
	REWRITE(fichComp);
	WITH tien DO
		WITH almacenComponentes DO
			FOR i:=1 TO tope DO
				WITH listacomponentes[i] DO
    				BEGIN
	    				writeln(fichComp,tipo);
	    				writeln(fichComp,id);
	    				writeln(fichComp,descripcion);
	    				writeln(fichComp,precio);
				END;
	CLOSE(fichComp);
	ASSIGN(fichPcs,'ordenadores.txt');
	REWRITE(fichPcs);
	WITH tien DO
		WITH almacenPcs DO
			FOR i:=1 TO tope DO
				WITH listaPcs[i] DO
				BEGIN
					WITH datos DO
					BEGIN
						writeln(fichPcs,tipo);
						writeln(fichPcs,id);
						writeln(fichPcs,descripcion);
						writeln(fichPcs,precio);
					END;
					WITH memoria DO
					BEGIN
						writeln(fichPcs,tipo);
						writeln(fichPcs,id);
						writeln(fichPcs,descripcion);
						writeln(fichPcs,precio);
					END;
					WITH procesador DO
					BEGIN
						writeln(fichPcs,tipo);
						writeln(fichPcs,id);
						writeln(fichPcs,descripcion);
						writeln(fichPcs,precio);
					END;
					WITH discoDuro DO
					BEGIN
						writeln(fichPcs,tipo);
						writeln(fichPcs,id);
						writeln(fichPcs,descripcion);
						writeln(fichPcs,precio);
					END;
				END;
	CLOSE(fichPcs);
END;

PROCEDURE cargarText(VAR tien:tTienda; VAR fichComp:text; VAR fichPcs:text);
VAR
	i,j:integer;
	listaC:tListaComponentes;
	listaP:tListaPcs;
BEGIN
	i:=1;
	j:=1;
	ASSIGN(fichComp,'componentes.txt');
	RESET(fichComp);
	WHILE NOT EOF(fichComp) DO
	BEGIN
		WITH listaC[i] DO
		BEGIN
			readln(fichComp,tipo);
			readln(fichComp,id);
			readln(fichComp,descripcion);
			readln(fichComp,precio);
		END;
		i:=i+1;
	END;
	ASSIGN(fichPcs,'ordenadores.txt');
	RESET(fichPcs);
	WHILE NOT EOF(fichPcs) DO
	BEGIN
		WITH listaP[j] DO
		BEGIN
			WITH datos DO
			BEGIN
				readln(fichPcs,tipo);
				readln(fichPcs,id);
				readln(fichPcs,descripcion);
				readln(fichPcs,precio);
			END;
			WITH memoria DO
			BEGIN
				readln(fichPcs,tipo);
				readln(fichPcs,id);
				readln(fichPcs,descripcion);
				readln(fichPcs,precio);
			END;
			WITH procesador DO
			BEGIN
				readln(fichPcs,tipo);
				readln(fichPcs,id);
				readln(fichPcs,descripcion);
				readln(fichPcs,precio);
			END;
			WITH discoDuro DO
			BEGIN
				readln(fichPcs,tipo);
				readln(fichPcs,id);
				readln(fichPcs,descripcion);
				readln(fichPcs,precio);
			END;
		END;
		j:=j+1;
	END;
	WITH tien DO
	BEGIN
		WITH almacenPcs DO
		BEGIN
			listaPcs:=listaP;
			tope:=j-1;
		END;
		WITH almacenComponentes DO
		BEGIN
			listaComponentes:=listaC;
			tope:=i-1;
		END;
		ventasTotales:=0;
	END;
END;
FUNCTION comprobarFicheros(tipo:string):boolean;
VAR
	fich:text;
BEGIN
	ASSIGN (fich,'componentes.'+tipo);
	{$i-}
	RESET (fich);
	{$i+}
	IF (IOResult<>0) THEN
		comprobarFicheros:=FALSE
	ELSE
	BEGIN
		ASSIGN (fich,'ordenadores.'+tipo);
		{$i-}
		RESET (fich);
		{$i+}
		IF (IOResult<>0) THEN
			comprobarFicheros:=FALSE
		ELSE
			comprobarFicheros:=TRUE;
	END;
END;
{----------------------Aqui estan las VAR----------------------}
VAR
	opcion,subopcion:char;
	tienda:tTienda;
	compBin:tFicheroComponentes;
	ordBin:tFicheroPcs;
	compText,ordText:text;
	existe:boolean;
	componente,comp:tComponente;
	pc:tPc;
	modComp,ide,venta:tIdentificador;
	aux:integer;
{----------------------Aqui empieza el programa principal----------------------}
BEGIN
	inicio(tienda);
	REPEAT
		mostrarMenu;
		readln(opcion);
		CASE opcion OF
			'A','a':
			BEGIN
				writeln('Dar de alta un componente');
				IF comprobAlmacen(tienda.almacenComponentes) = TRUE THEN
					writeln('El almacen esta lleno')
				ELSE
				BEGIN
					leerComponente(componente);
					altaComponente(componente,tienda.almacenComponentes);
				END;
			END;
			'B','b':
			BEGIN
				WITH pc DO BEGIN
					writeln('Configurar un ordenador:');
					aux:=0;
					REPEAT
						writeln('Introduzca un identificador de procesador');
						readln(ide);
						buscar(ide,tienda.almacenComponentes,comp,'procesador',aux);
					UNTIL (aux=1);
					procesador:=comp;
					aux:=0;
					REPEAT
						writeln('Introduzca un identificador de disco duro');
						readln(ide);
						buscar(ide,tienda.almacenComponentes,comp,'disco duro',aux);
					UNTIL (aux=1);
					discoDuro:=comp;
					aux:=0;
					REPEAT
						writeln('Introduzca un identificador de memoria');
						readln(ide);
						buscar(ide,tienda.almacenComponentes,comp,'memoria',aux);
					UNTIL (aux=1);
					memoria:=comp;
					writeln('Introduzca un identificador para el ordenador');
					readln(datos.id);
					writeln('Introduzca una descripcion del ordenador');
					readln(datos.descripcion);
					datos.precio:= procesador.precio+discoDuro.precio+memoria.precio+10;
					datos.tipo:='Ordenador';
				END;{WITH}
				altaPc(pc,tienda.almacenPcs);
				eliminar(tienda.almacenComponentes,pc.procesador.id);
				eliminar(tienda.almacenComponentes,pc.discoDuro.id);
				eliminar(tienda.almacenComponentes,pc.memoria.id);
			END;
			'C','c':
			BEGIN
				writeln('Modificar un componente');
				writeln('Introduzca el identificador del componente');
				readln(modComp);
				IF (posicion(tienda.almacenComponentes,modComp)=0) THEN
					writeln('El componente no esta en el almacen')
				ELSE BEGIN
					mostrarComp(tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,modComp)]);
					REPEAT
						menuComp;
						readln(subopcion);
						CASE subopcion OF
						'1':BEGIN
							writeln('Modificar el tipo');
							readln(tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,modComp)].tipo);
						END;
						'2':BEGIN
							writeln('Modificar la descripcion');
							readln(tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,modComp)].descripcion);
						END;
						'3':BEGIN
							writeln('Modificar el precio');
							readln(tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,modComp)].precio);
						END;
						END;{CASE}
					UNTIL (subopcion='f') OR (subopcion='F');
				END;{BEGIN IF}
			END;
			'D','d':
			BEGIN
				writeln('Vender componente');
				writeln('Introduzca el identificador del componente');
				readln(venta);
				IF (posicion(tienda.almacenComponentes,venta)=0) THEN
					writeln('El componente no existe')
				ELSE BEGIN
					mostrarComp(tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,venta)]);
					readln;
					tienda.ventasTotales:= (tienda.ventasTotales +  tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,venta)].precio);
					eliminar(tienda.almacenComponentes,tienda.almacenComponentes.listaComponentes[posicion(tienda.almacenComponentes,venta)].id)
				END;
			END;
			{'E','e':
			'F','f':
			'G','g':
			'H','h':}
			'I','i':
			BEGIN
				writeln('Al guardar los datos, se sobreescribiran los datos anteriormente guardados.');
				REPEAT
					writeln('¿Desea continuar? (S/N)');
					readln(subopcion)
				UNTIL ((subopcion='S') OR (subopcion='N'));
				IF (subopcion='S') THEN
					guardarBin(tienda,compBin,ordBin);
			END;
			'J','j':
			BEGIN
				writeln('Al guardar los datos, se sobreescribiran los datos anteriormente guardados.');
				REPEAT
					writeln('¿Desea continuar? (S/N)');
					readln(subopcion)
				UNTIL ((subopcion='S') OR (subopcion='N'));
				IF (subopcion='S') THEN
					guardarText(tienda,compText,ordText);
				END;
			'K','k':
			BEGIN
				writeln('Al cargar los datos desde el fichero, se sobreescribiran los datos cargados en el sistema.');
				REPEAT
					writeln('¿Desea continuar? (S/N)');
					readln(subopcion)
				UNTIL ((subopcion='S') OR (subopcion='N'));
				IF (subopcion='S') THEN
				BEGIN
					existe:=comprobarFicheros('dat');
					IF existe THEN
						cargarBin(tienda,compBin,ordBin)
					ELSE
						writeln('El fichero no existe');
				END;
			END;
			'L','l':
			BEGIN
				writeln('Al cargar los datos desde el fichero, se sobreescribiran los datos cargados en el sistema.');
				REPEAT
					writeln('¿Desea continuar? (S/N)');
					readln(subopcion)
				UNTIL ((subopcion='S') OR (subopcion='N'));
				IF (subopcion='S') THEN
				BEGIN
					existe:=comprobarFicheros('txt');
					IF existe THEN
						cargarText(tienda,compText,ordText)
					ELSE
						writeln('El fichero no existe');
				END;
			END;
			'M','m': writeln('Fin del programa.');
			ELSE
				writeln('Opción incorrecta.');
		END;
		readln;
	UNTIL ((opcion='M') OR (opcion='m'));
END.
