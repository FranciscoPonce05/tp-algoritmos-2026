UNIT MENU;

{$MODE OBJFPC}
{$CODEPAGE UTF8}

INTERFACE

USES
  ARCHIVO_CLIENTES, CRT, SYSUTILS, U_GESTION_CLIENTES, VALIDACION;

PROCEDURE MENU_PRINCIPAL;

IMPLEMENTATION

USES ARCHIVO_POLIZAS, U_GESTION_POLIZAS, ARBOLES;

PROCEDURE MENU_PRINCIPAL;
VAR
  ARCH_CLIENTES: T_ARCHIVO_CLIENTES;
  ARCH_POLIZAS: T_ARCHIVO_POLIZAS;
  ARBOL_DNI: T_ARBOL;
  REG: T_REG_CLIENTES;
  POS: LONGINT;
  OPCION: INTEGER;
  ENTRADA: STRING;
  CODIGO: INTEGER;
  OPCION_VALIDA: BOOLEAN;
BEGIN
  // CREAR Y ABRIR ARCHIVO DE CLIENTES
  ARCHIVO_CLIENTES.CREAR_ABRIR(ARCH_CLIENTES);

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
           CLIENTES(ARCH_CLIENTES);
         END;
      2: BEGIN
           ARCHIVO_POLIZAS.CREAR_ABRIR(ARCH_POLIZAS);
           TRY
             {La base recibida gestiona clientes sin indices. Se arma el ABB
              con los datos actuales al entrar. En el menu grupal se pasa
              directamente la raiz mantenida por Gestion de Clientes.}
             ARBOL_DNI := NIL;
             TRY
               SEEK(ARCH_CLIENTES, 0);
               WHILE NOT EOF(ARCH_CLIENTES) DO
               BEGIN
                 POS := FILEPOS(ARCH_CLIENTES);
                 READ(ARCH_CLIENTES, REG);
                 ARBOL_INSERTAR(ARBOL_DNI, REG.DNI, POS);
               END;
               POLIZAS(ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_DNI);
             FINALLY
               LIBERAR(ARBOL_DNI);
             END;
           FINALLY
             ARCHIVO_POLIZAS.CERRAR(ARCH_POLIZAS);
           END;
         END;
      // 3: LISTADOS(ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_NOM);
      // 4: ESTADISTICAS(ARCH_CLIENTES, ARCH_POLIZAS);
    END;
  UNTIL OPCION = 0;

  ARCHIVO_CLIENTES.CERRAR(ARCH_CLIENTES);
END;

END.