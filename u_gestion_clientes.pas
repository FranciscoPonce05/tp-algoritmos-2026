UNIT U_GESTION_CLIENTES;

{$CODEPAGE UTF8}

INTERFACE

USES
  ARCHIVO_CLIENTES, ARBOLES, CRT, VALIDACION;

PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_ARBOL);

IMPLEMENTATION

PROCEDURE LEE_REGISTRO(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; I: LONGINT; VAR REG: T_REG_CLIENTES);
BEGIN
  SEEK(ARCH_CLIENTES, I);
  READ(ARCH_CLIENTES, REG);
END;

// ALTA DE NUEVO CLIENTE CON VALIDACIONES
PROCEDURE DAR_ALTA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_ARBOL; DNI_INGRESADO: STRING);
VAR
  REG: T_REG_CLIENTES;
  CONFIRMA: BOOLEAN;
  POS_RELATIVA: LONGINT;
BEGIN
  CLRSCR;
  WRITELN('========================================');
  WRITELN('         ALTA DE NUEVO CLIENTE          ');
  WRITELN('========================================');
  WRITELN('DNI: ', DNI_INGRESADO);
  REG.DNI := DNI_INGRESADO;

  {Ingreso de cada dato utilizando las funciones de la unit VALIDACION para garantizar formatos correctos}
  REG.APEYNOM := LEERCADENANOVACIA('Ingrese Apellido y Nombres');
  REG.DIREC   := LEERDIRECCION('Ingrese Direccion');
  REG.FNAC    := LEERFECHANAC('Ingrese Fecha de Nacimiento');
  REG.CEL     := LEERCELULAR('Ingrese Celular');
  REG.MAIL    := LEEREMAIL('Ingrese E-mail');
  REG.ESTADO  := TRUE; {Activo por defecto}

  WRITELN;
  CONFIRMA := LEERCONFIRMACION('¿Desea registrar al cliente?');
  IF CONFIRMA THEN
  BEGIN
    {SEEK a FILESIZE ubica el puntero al final del archivo para anexar el nuevo registro}
    SEEK(ARCH_CLIENTES, FILESIZE(ARCH_CLIENTES));
    WRITE(ARCH_CLIENTES, REG);

    {Tras el WRITE el archivo crecio en 1, por lo que el nuevo registro quedo en FILESIZE - 1}
    POS_RELATIVA := FILESIZE(ARCH_CLIENTES) - 1;

    {Se inserta simultaneamente en ambos arboles con la misma posicion relativa}
    ARBOL_INSERTAR(ARBOL_DNI, REG.DNI, POS_RELATIVA);
    ARBOL_INSERTAR(ARBOL_NOM, REG.APEYNOM, POS_RELATIVA);

    WRITELN;
    WRITELN('>> ¡Cliente registrado con exito! <<');
  END
  ELSE
  BEGIN
    WRITELN;
    WRITELN('>> Alta cancelada. No se guardaron los datos. <<');
  END;

  WRITELN;
  WRITE('Presione una tecla para continuar...');
  READKEY;
END;

{Modificacion de los datos del cliente activo excepto su identificador unico (DNI), segun requerimiento A.3}
PROCEDURE MODIFICAR_DATOS(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_NOM: T_ARBOL; POS: LONGINT; VAR REG: T_REG_CLIENTES);
VAR
  OP: CHAR;
  CONFIRMA: BOOLEAN;
  NOMBRE_EN_ARBOL: STRING; {Apellido y nombre con el que el cliente figura actualmente en ARBOL_NOM}
BEGIN
  NOMBRE_EN_ARBOL := REG.APEYNOM;

  REPEAT
    CLRSCR;
    WRITELN('========================================');
    WRITELN('      MODIFICACION DE DATOS CLIENTE     ');
    WRITELN('========================================');
    WRITELN('DNI (no modificable): ', REG.DNI);
    WRITELN('1 - Apellido y Nombres: ', REG.APEYNOM);
    WRITELN('2 - Direccion:          ', REG.DIREC);
    WRITELN('3 - Fecha Nacimiento:   ', REG.FNAC);
    WRITELN('4 - Celular:            ', REG.CEL);
    WRITELN('5 - E-mail:             ', REG.MAIL);
    WRITELN('6 - Modificar TODOS los campos');
    WRITELN('0 - Volver al menu del cliente');
    WRITELN('========================================');
    WRITE('Seleccione que desea modificar: ');
    READLN(OP);

    CASE OP OF
      '1': REG.APEYNOM := LEERCADENANOVACIA('Nuevo Apellido y Nombres');
      '2': REG.DIREC   := LEERDIRECCION('Nueva Direccion');
      '3': REG.FNAC    := LEERFECHANAC('Nueva Fecha de Nacimiento');
      '4': REG.CEL     := LEERCELULAR('Nuevo Celular');
      '5': REG.MAIL    := LEEREMAIL('Nuevo E-mail');
      '6': BEGIN
             REG.APEYNOM := LEERCADENANOVACIA('Nuevo Apellido y Nombres');
             REG.DIREC   := LEERDIRECCION('Nueva Direccion');
             REG.FNAC    := LEERFECHANAC('Nueva Fecha de Nacimiento');
             REG.CEL     := LEERCELULAR('Nuevo Celular');
             REG.MAIL    := LEEREMAIL('Nuevo E-mail');
           END;
    END;

    IF OP IN ['1'..'6'] THEN
    BEGIN
      CONFIRMA := LEERCONFIRMACION('¿Desea guardar los cambios?');
      IF CONFIRMA THEN
      BEGIN
        SEEK(ARCH_CLIENTES, POS);
        WRITE(ARCH_CLIENTES, REG);

        {Si cambio el APEYNOM, el nodo de ARBOL_NOM se reubica: se elimina la clave vieja y se inserta la nueva con la misma POS}
        IF REG.APEYNOM <> NOMBRE_EN_ARBOL THEN
        BEGIN
          ARBOL_ELIMINAR(ARBOL_NOM, NOMBRE_EN_ARBOL, POS);
          ARBOL_INSERTAR(ARBOL_NOM, REG.APEYNOM, POS);
          NOMBRE_EN_ARBOL := REG.APEYNOM;
        END;

        WRITELN('>> Modificacion guardada con exito. <<');
      END
      ELSE
      BEGIN
        // Restaurar registro leyendo lo que habia en el archivo
        SEEK(ARCH_CLIENTES, POS);
        READ(ARCH_CLIENTES, REG);
        WRITELN('>> Modificacion cancelada. <<');
      END;
      WRITE('Presione una tecla para continuar...');
      READKEY;
    END;
  UNTIL OP = '0';
END;

// CONSULTA, BAJA LOGICA O MODIFICACION
PROCEDURE MODIFICAR_O_BAJA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_NOM: T_ARBOL; POS: LONGINT);
VAR
  REG: T_REG_CLIENTES;
  OP: CHAR;
  CONFIRMA: BOOLEAN;
BEGIN
  REPEAT
    LEE_REGISTRO(ARCH_CLIENTES, POS, REG);

    CLRSCR;
    WRITELN('========================================');
    WRITELN('           DATOS DEL CLIENTE            ');
    WRITELN('========================================');
    WRITELN('DNI:                 ', REG.DNI);
    WRITELN('Apellido y Nombres:  ', REG.APEYNOM);
    WRITELN('Direccion:           ', REG.DIREC);
    WRITELN('Fecha de Nacimiento: ', REG.FNAC);
    WRITELN('Celular:             ', REG.CEL);
    WRITELN('E-mail:              ', REG.MAIL);
    IF REG.ESTADO THEN
      WRITELN('Estado:              ACTIVO')
    ELSE
      WRITELN('Estado:              NO ACTIVO (Baja logica)');
    WRITELN('========================================');

    IF REG.ESTADO THEN
    BEGIN
      // Cliente ACTIVO
      WRITELN('1 - Modificar datos');
      WRITELN('2 - Dar de Baja Logica');
      WRITELN('0 - Volver al menu principal');
      WRITELN('========================================');
      WRITE('Seleccione una opcion: ');
      READLN(OP);

      CASE OP OF
        '1': MODIFICAR_DATOS(ARCH_CLIENTES, ARBOL_NOM, POS, REG);
        '2': BEGIN
               WRITELN;
               {Baja logica: cambia el campo ESTADO a FALSE sin borrar fisicamente el registro}
               CONFIRMA := LEERCONFIRMACION('¿Confirma dar de BAJA LOGICA al cliente?');
               IF CONFIRMA THEN
               BEGIN
                 REG.ESTADO := FALSE;
                 SEEK(ARCH_CLIENTES, POS);
                 WRITE(ARCH_CLIENTES, REG);
                 WRITELN('>> Baja logica aplicada correctamente. <<');
                 WRITE('Presione una tecla para continuar...');
                 READKEY;
               END;
             END;
      END;
    END
    ELSE
    BEGIN
      // Cliente INACTIVO
      WRITELN('El cliente se encuentra dado de BAJA LOGICA.');
      WRITELN('1 - Reactivar cliente (Alta logica)');
      WRITELN('0 - Volver al menu principal');
      WRITELN('========================================');
      WRITE('Seleccione una opcion: ');
      READLN(OP);

      CASE OP OF
        '1': BEGIN
               CONFIRMA := LEERCONFIRMACION('¿Desea reactivar a este cliente?');
               IF CONFIRMA THEN
               BEGIN
                 REG.ESTADO := TRUE;
                 SEEK(ARCH_CLIENTES, POS);
                 WRITE(ARCH_CLIENTES, REG);
                 WRITELN('>> Cliente reactivado con exito. <<');
                 WRITE('Presione una tecla para continuar...');
                 READKEY;
               END;
             END;
      END;
    END;
  UNTIL OP = '0';
END;

// PROCEDIMIENTO PRINCIPAL DE GESTION DE CLIENTES
PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_ARBOL);
VAR
  DNI: STRING;
  POS: LONGINT;
  OPC: CHAR;
BEGIN
  CLRSCR;
  WRITELN('========================================');
  WRITELN('          GESTION DE CLIENTES           ');
  WRITELN('========================================');
  DNI := LEERDNI('Ingrese DNI del cliente');

  {Busqueda en ARBOL_DNI en lugar del recorrido secuencial. Devuelve -1 si el DNI no existe}
  ARBOL_BUSCAR(ARBOL_DNI, DNI, POS);

  {Si el DNI no existe (POS = -1), deriva al submenú para dar de Alta o Volver (Requerimiento A.2)}
  IF POS = -1 THEN
  BEGIN
    REPEAT
      CLRSCR;
      WRITELN('========================================');
      WRITELN('          GESTION DE CLIENTES           ');
      WRITELN('========================================');
      WRITELN('El DNI "', DNI, '" no se encuentra registrado.');
      WRITELN;
      WRITELN('1 - Alta de Cliente');
      WRITELN('0 - Volver al menu anterior');
      WRITELN('========================================');
      WRITE('Seleccione una opcion: ');
      READLN(OPC);

      CASE OPC OF
        '1': BEGIN
               DAR_ALTA(ARCH_CLIENTES, ARBOL_DNI, ARBOL_NOM, DNI);
               OPC := '0'; {Luego del alta regresa al menu anterior}
             END;
      END;
    UNTIL OPC = '0';
  END
  ELSE
  BEGIN
    {Si el cliente existe (POS <> -1), muestra la ficha y ofrece Modificacion o Baja (Requerimiento A.3)}
    MODIFICAR_O_BAJA(ARCH_CLIENTES, ARBOL_NOM, POS);
  END;
END;

END.

