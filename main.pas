PROGRAM grupal;
CONST
  NCTIPO = 15; {nË™mero caracteres tipo}
  NCIDENTIFICADOR = 4; {nË™mero caracteres del identificador del componente}
  MAXPC = 25; {nË™mero de ordenadores (PC) mÂ·ximos en la tienda}
  MAXCOMPONENTES = 100; {nË™mero de componentes sueltos mÂ·ximo}
  MIN = 1;
TYPE
  tTipo = string[NCTIPO]; {Tipo para almacenar el tipo del componente}

  tIdentificador = string[NCIDENTIFICADOR]; {Para almacenar el identificador}

  tNumComponentes = MIN..MAXCOMPONENTES; {Para almacenar el ÃŒndice de componentes}

  tNumPc = MIN..MAXPC; {Tipo para almacenar el ÃŒndice de ordenadores}

  tComponente = RECORD {Tipo para almacenar un producto}
  	tipo: tTipo;
  	id: tIdentificador;
  	descripcion: String;
  	precio : real;
  END;

  tPc = RECORD {Tipo para almacenar un ordenador}
   datos, memoria, procesador, discoDuro: tComponente;
  END;

  tListaComponentes= ARRAY [tNumComponentes] OF tComponente;

  tListaPcs = ARRAY [tNumPc] OF tPc;

  tAlmacenComponentes = RECORD {AlmacÃˆn de componentes}
  	listaComponentes : tListaComponentes;
  	tope: integer;
  END;

  tAlmacenPcs = RECORD {AlmacÃˆn de Pcs}
  	listaPcs : tListaPcs;
  	tope: integer;
  END;

  tTienda = RECORD {Tienda}
  	almacenPcs : tAlmacenPcs;
  	almacenComponentes: tAlmacenComponentes;
  	ventasTotales: real; {Almacena el total de la ventas}
  END;
  tFicheroPcs = FILE OF tPc;

  tFicheroComponentes = FILE OF tComponente;



 VAR
 	componente,comp,componenteMod:tComponente;
 	opcion,opcion2:char;
 	almaComp:tAlmacenComponentes;
 	pc:tPc;
 	almaPc:tAlmacenPcs;
 	modComp,ide,venta:tIdentificador;
 	aux:integer;
 	tienda:tTienda;

 PROCEDURE inicio(VAR almacenComp:tAlmacenComponentes);
 BEGIN{inicio}
	almacenComp.tope:=0;
 END;{inicio}

 PROCEDURE inicioPc(VAR almacenPc:tAlmacenPcs);
 BEGIN{inicioPc}
 	almacenPc.tope:=0;
 END;{inicioPc}


PROCEDURE mostrarMenu;
BEGIN{mostrarMenu}
	writeln;
	writeln('######### MENU #########');
	writeln('a.-Dar de alta un componente');
	writeln('b.-Configurar un ordenador');
	writeln('c.-Modificar un componente');
	writeln('d.-Vender un componente');
END;{MostrarMenu}

FUNCTION comprobAlmacen (almacenComp:tAlmacenComponentes):boolean;
BEGIN{comprobAlmacen}
	IF almacenComp.tope = MAXCOMPONENTES THEN
		comprobAlmacen:= TRUE
	ELSE
		comprobAlmacen:= FALSE
END;{comprobAlmacen}

PROCEDURE leerComponente( VAR comp:tComponente);
BEGIN{leerComp}
	WITH comp DO
		BEGIN
			writeln('Introduzca el tipo:');
			readln(tipo);
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


FUNCTION buscar (iden:tIdentificador;almacen:tAlmacenComponentes):tComponente;
VAR
	i:integer;
BEGIN{proce}
    i:=0;
	REPEAT
		i:=i+1;
	UNTIL(i=(almacen.tope)) OR ((almacen.listaComponentes[i].id)=(iden));
	IF ((almacen.listaComponentes[i].id)=(iden)) THEN BEGIN
		buscar:=almacen.listaComponentes[i];
		END
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
		ELSE	IF almacen.tope=MAXPC THEN
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
		writeln(precio);
	END;
END;{mostrar}

PROCEDURE menuComp;
BEGIN{menu}
	writeln('MENU DE MODIFICACION');
	writeln('1.- Modificar el tipo');
	writeln('2.- Modificar la descripcion');
	writeln('3.- Modificar el precio')
END;{menu}

BEGIN
	inicio(almaComp);
	inicioPc(almaPc);
	REPEAT
		mostrarMenu;
		readln(opcion);
		CASE opcion OF
			'a','A':BEGIN
						writeln('Dar de alta un componente');
						IF comprobAlmacen(almaComp) = TRUE THEN
							writeln('El almacen esta lleno')
						ELSE
							BEGIN
								leerComponente(componente);
								altaComponente(componente,almaComp);

							END;
					END;

			'B','b':BEGIN
			            WITH pc DO BEGIN
					    	REPEAT
			            	aux:=0;
			            	writeln('Introduzca un identificador');
			            	readln(ide);
			            	comp:=buscar(ide,almaComp);
					    	writeln('Configurar un ordenador');
					    	IF (comp.tipo = 'procesador') AND ( aux = 0)THEN
					    		BEGIN
					    			procesador:=comp;
					    			aux:=aux+1;
					    		END
					    		ELSE IF (comp.tipo = 'memoria') AND (aux=1) THEN
					    				BEGIN
					    					memoria:=comp;
					    					aux:=aux+1;
					    				END
					    			ELSE IF (comp.tipo = 'discoDuro') AND (aux=2) THEN
					    				BEGIN
					    					discoDuro:=comp;
					    					aux:=aux+1;
					    				END;
					    	UNTIL (aux = 3);
						   { procesador:=buscarProce(almaComp);
						    discoDuro:=buscarDisco(almaComp);
						    memoria:=buscarMemoria(almaComp);}
					        writeln('Introduzca un identificador');
					        readln(datos.id);
					        writeln('Introudzca una descripcion');
					        readln(datos.descripcion);
					        datos.precio:= procesador.precio+discoDuro.precio+memoria.precio+10;
					       END;{WITH}
					   altaPc(pc,almaPc);
					   eliminar(almaComp,pc.procesador.id);
					   eliminar(almaComp,pc.discoDuro.id);
					   eliminar(almaComp,pc.memoria.id);
					END;
			'c','C':BEGIN
						writeln('Modificar un componente');
						writeln('Introduzca el identificador del componente');
						readln(modComp);
						IF (posicion(almaComp,modComp)=0) THEN
							writeln('El componente no esta en el almacen')
						ELSE BEGIN
								mostrarComp(almaComp.listaComponentes[posicion(almaComp,modComp)]);
								REPEAT
									menuComp;
									readln(opcion2);
									CASE opcion OF
										'1':BEGIN
												writeln('Modificar el tipo');
												writeln(almaComp.listaComponentes[posicion(almaComp,modComp)].tipo);
											END;
										'2':BEGIN
												writeln('Modificar la descripcion');
												writeln(almaComp.listaComponentes[posicion(almaComp,modComp)].descripcion);
											END;
										'3':BEGIN
												writeln('Modificar el precio');
												writeln(almaComp.listaComponentes[posicion(almaComp,modComp)].precio);
											END;
										END;{CASE}
									UNTIL (opcion2='f') OR (opcion2='F');
								END;{BEGIN IF}
							END;
			'd','D':BEGIN
						writeln('Vender componente');
						writeln('Introduzca el identificador del componente');
						readln(venta);
						IF (posicion(almaComp,venta)=0) THEN
							writeln('El componente no existe')
						ELSE BEGIN
							mostrarComp(almaComp.listaComponentes[posicion(almaComp,venta)]);
							readln;
							tienda.ventasTotales:= (tienda.ventasTotales +  almaComp.listaComponentes[posicion(almaComp,venta)].precio);
							eliminar(almaComp,almaComp.listaComponentes[posicion(almaComp,venta)].id)

						END;

					END;

		END;{case}
	UNTIL (opcion='f') OR (opcion='F');
END.
