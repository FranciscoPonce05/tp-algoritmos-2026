UNIT MENU;

{$CODEPAGE UTF8}

INTERFACE

USES
  ARCHIVO_CLIENTES, ARBOLES, CRT, SYSUTILS, U_GESTION_CLIENTES, VALIDACION;

PROCEDURE MENU_PRINCIPAL;

IMPLEMENTATION

{Recorre el archivo de clientes y arma los dos arboles en memoria (clave + posicion relativa)}
PROCEDURE CARGAR_ARBOLES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_ARBOL);
VAR
  I: LONGINT;
  REG: T_REG_CLIENTES;
BEGIN
  FOR I := 0 TO FILESIZE(ARCH_CLIENTES) - 1 DO
  BEGIN
    SEEK(ARCH_CLIENTES, I);
    READ(ARCH_CLIENTES, REG);
    ARBOL_INSERTAR(ARBOL_DNI, REG.DNI, I);
    ARBOL_INSERTAR(ARBOL_NOM, REG.APEYNOM, I);
  END;
END;

PROCEDURE MENU_PRINCIPAL;
VAR
  ARCH_CLIENTES: T_ARCHIVO_CLIENTES;
  ARBOL_DNI, ARBOL_NOM: T_ARBOL;
  OPCION: INTEGER;
  ENTRADA: STRING;
  CODIGO: INTEGER;
  OPCION_VALIDA: BOOLEAN;
BEGIN
  // CREAR Y ABRIR ARCHIVO DE CLIENTES
  CREAR_ABRIR(ARCH_CLIENTES);

  // INICIALIZAR ARBOLES Y CARGARLOS CON LOS CLIENTES YA GUARDADOS EN EL ARCHIVO
  ARBOL_DNI := NIL;
  ARBOL_NOM := NIL;
  CARGAR_ARBOLES(ARCH_CLIENTES, ARBOL_DNI, ARBOL_NOM);

  REPEAT
    REPEAT
      CLRSCR;
      GOTOXY(30, 12);
      WRITE('1 - GESTION DE CLIENTES');
      GOTOXY(30, 14);
      WRITE('2 - GESTION DE POLIZAS');
      GOTOXY(30, 16);
      WRITE('3 - LISTADOS');
      GOTOXY(30, 18);
      WRITE('4 - ESTADISTICAS');
      GOTOXY(30, 20);
      WRITE('0 - FINALIZAR');
      GOTOXY(28, 22);
      WRITE('---------------------------------');
      GOTOXY(28, 23);
      WRITE('INGRESE OPCION [0..4]: ');
      {Se lee como cadena de texto para evitar que el programa aborte con Runtime Error 106 si el usuario ingresa letras}
      READLN(ENTRADA);
      ENTRADA := TRIM(ENTRADA);

      {VAL intenta convertir el texto a numero. Si hay letras o caracteres invalidos, CODIGO es distinto de 0}
      VAL(ENTRADA, OPCION, CODIGO);
      OPCION_VALIDA := (CODIGO = 0) AND (LENGTH(ENTRADA) > 0) AND (OPCION >= 0) AND (OPCION <= 4);

      IF NOT OPCION_VALIDA THEN
      BEGIN
        {Muestra el mensaje de error y espera una tecla; el bucle limpia la pantalla con CLRSCR para redibujar el menu alineado}
        GOTOXY(20, 25);
        WRITE('>> ERROR: Debe ingresar un numero entre 0 y 4. <<');
        GOTOXY(20, 26);
        WRITE('Presione una tecla para reintentar...');
        READKEY;
      END;
    UNTIL OPCION_VALIDA;

    CASE OPCION OF
      1: BEGIN
           CLIENTES(ARCH_CLIENTES, ARBOL_DNI, ARBOL_NOM);
         END;
      // 2: POLIZAS(ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_DNI);
      // 3: LISTADOS(ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_NOM);
      // 4: ESTADISTICAS(ARCH_CLIENTES, ARCH_POLIZAS);
    END;
  UNTIL OPCION = 0;

  CERRAR(ARCH_CLIENTES);
END;

END.


