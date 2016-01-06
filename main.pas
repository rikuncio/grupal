PROGRAM tienda;
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
{----------------------Aqui estan las VAR----------------------}
VAR
	opcion:char;

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
PROCEDURE guardarBin (almComp:tAlmacenComponentes; almPcs:tAlmacenPcs; VAR fichComp:tFicheroComponentes; VAR fichPcs:tFicheroPcs);
VAR
	i:integer;
BEGIN
	ASSIGN(fichComp,'componentes.dat');
	REWRITE(fichComp);
	WITH almComp DO
		FOR i:=1 TO tope DO
			WRITE(fichComp,listaComponentes[i]);
	CLOSE(fichComp);
	ASSIGN(fichPcs,'ordenadores.dat');
	REWRITE(fichPcs);
	WITH almPcs DO
		FOR i:=1 TO tope DO
			WRITE(fichPcs,listaPcs[i]);
	CLOSE(fichPcs);
END;

PROCEDURE cargarBin(VAR almComp:tAlmacenComponentes;VAR almPcs:tAlmacenPcs; VAR fichComp:tFicheroComponentes; VAR fichPcs:tFicheroPcs);
VAR
	i:integer;
	comp:tComponente;
	pc:tPc;
	listaC:tListaComponentes;
	listaP:tListaPcs;
BEGIN
	i:=1;
	ASSIGN(fichComp,'componentes.dat');
	RESET(fichComp);
	WHILE NOT EOF(fichComp) DO
	BEGIN
		read(fichComp,comp);
		listaC[i]:=comp;
		i:=i+1;
	END;
	WITH almComp DO
	BEGIN
		almComp.tope:=i-1;
		almComp.listaComponentes:=listaC;
	END;
	i:=1;
	ASSIGN(fichPcs,'ordenadores.dat');
	RESET(fichPcs);
	WHILE NOT EOF(fichPcs) DO
	BEGIN
		read(fichPcs,pc);
		listaP[i]:=pc;
		i:=i+1;
	END;
	WITH almPcs DO
	BEGIN
		almPcs.tope:=i-1;
		almPcs.listaPcs:=listaP;
	END;
END;

PROCEDURE guardarText (almComp:tAlmacenComponentes; almPcs:tAlmacenPcs; VAR fichComp:text; VAR fichPcs:text);
VAR
	i:integer;
BEGIN
	ASSIGN(fichComp,'componentes.txt');
	REWRITE(fichComp);
	WITH almComp DO
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
	WITH almPcs DO
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

PROCEDURE cargarText(VAR almComp:tAlmacenComponentes;VAR almPcs:tAlmacenPcs; VAR fichComp:text; VAR fichPcs:text);
VAR
	i:integer;
	listaC:tListaComponentes;
	listaP:tListaPcs;
BEGIN
	i:=1;
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
	WITH almComp DO
	BEGIN
		almComp.tope:=i-1;
		almComp.listaComponentes:=listaC;
	END;
	i:=1;
	ASSIGN(fichPcs,'ordenadores.txt');
	RESET(fichPcs);
	WHILE NOT EOF(fichPcs) DO
	BEGIN
		WITH listaP[i] DO
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
		i:=i+1;
	END;
	WITH almPcs DO
	BEGIN
		almPcs.tope:=i-1;
		almPcs.listaPcs:=listaP;
	END;
END;
{----------------------Aqui empieza el programa principal----------------------}
BEGIN
    
END.
