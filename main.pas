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

PROCEDURE mostrarMenu;
BEGIN
	writeln('------------------------------------------------------------------------');
	writeln('A) Dar de alta un componente.');
	writeln('B) Configurar un ordenador.');
	writeln('C) Modificar un componente.');
	writeln('D) Vender un componente');
	writeln('E) Vender un ordenador');
	writeln('F) Mostrar las ventas actuales');
	writeln('G) Mostrar todos los ordenadores ordenados por precio de menor a mayor');
	writeln('H) Mostrar todos los componentes sueltos');
	writeln('I) Guardar datos en ficheros binarios');
	writeln('J) Guardar datos en ficheros de texto');
	writeln('K) Cargar datos de ficheros binarios');
	writeln('L) Cargar datos de ficheros de texto');
	writeln('M) Finalizar');
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
{----------------------Aqui estan las VAR----------------------}
VAR
	opcion,subopcion:char;
	tienda:tTienda;
	compBin:tFicheroComponentes;
	ordBin:tFicheroPcs;
	compText,ordText:text;
	
{----------------------Aqui empieza el programa principal----------------------}
BEGIN
	REPEAT
		mostrarMenu;
		readln(opcion);
		CASE opcion OF
		{	'A','a':
			'B','b':
			'C','c':
			'D','d':
			'E','e':
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
					cargarBin(tienda,compBin,ordBin);
    		END;
			'L','l':
			BEGIN
				writeln('Al cargar los datos desde el fichero, se sobreescribiran los datos cargados en el sistema.');
				REPEAT
					writeln('¿Desea continuar? (S/N)');
					readln(subopcion)
				UNTIL ((subopcion='S') OR (subopcion='N'));
				IF (subopcion='S') THEN
					cargarText(tienda,compText,ordText);
			END;
			'M','m': writeln('Fin del programa.');
			ELSE
				writeln('Opción incorrecta.');
		END;
		readln;
	UNTIL ((opcion='M') OR (opcion='m'));
END.
