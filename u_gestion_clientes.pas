UNIT U_GESTION_CLIENTES;

{$CODEPAGE UTF8}

INTERFACE

USES
  ARCHIVO_CLIENTES, CRT, VALIDACION, ARBOL;

PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_PUNT);

IMPLEMENTATION

CONST
  MARGEN = '                  '; // 18 espacios para centrar en terminal estandar de 80 columnas

PROCEDURE LEE_REGISTRO(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; I: LONGINT; VAR REG: T_REG_CLIENTES);
BEGIN
  SEEK(ARCH_CLIENTES, I);
  READ(ARCH_CLIENTES, REG);
END;

// ALTA DE NUEVO CLIENTE CON VALIDACIONES Y ACTUALIZACION DE ARBOLES
PROCEDURE DAR_ALTA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; DNI_INGRESADO: STRING; VAR ARBOL_DNI, ARBOL_NOM: T_PUNT);
VAR
  REG: T_REG_CLIENTES;
  CONFIRMA: BOOLEAN;
  NUEVA_POS: LONGINT;
BEGIN
  CLRSCR;
  WRITELN(MARGEN, '============================================');
  WRITELN(MARGEN, '           ALTA DE NUEVO CLIENTE            ');
  WRITELN(MARGEN, '============================================');
  WRITELN(MARGEN, 'DNI: ', DNI_INGRESADO);
  WRITELN;
  REG.DNI := DNI_INGRESADO;

  {Ingreso de cada dato utilizando las funciones de la unit VALIDACION para garantizar formatos correctos}
  REG.APEYNOM := LEERCADENANOVACIA(MARGEN + 'Ingrese Apellido y Nombres');
  REG.DIREC   := LEERDIRECCION(MARGEN + 'Ingrese Direccion');
  REG.FNAC    := LEERFECHANAC(MARGEN + 'Ingrese Fecha de Nacimiento');
  REG.CEL     := LEERCELULAR(MARGEN + 'Ingrese Celular');
  REG.MAIL    := LEEREMAIL(MARGEN + 'Ingrese E-mail');
  REG.ESTADO  := FALSE; {Por defecto el ingreso de un cliente esta INACTIVO}

  WRITELN;
  WRITELN(MARGEN, 'Estado asignado por defecto: INACTIVO');
  CONFIRMA := LEERCONFIRMACION(MARGEN + '¿Desea registrar al cliente?');
  IF CONFIRMA THEN
  BEGIN
    {SEEK a FILESIZE ubica el puntero al final del archivo para anexar el nuevo registro}
    NUEVA_POS := FILESIZE(ARCH_CLIENTES);
    SEEK(ARCH_CLIENTES, NUEVA_POS);
    WRITE(ARCH_CLIENTES, REG);

    {Actualiza los arboles binarios en memoria con el nuevo registro}
    INSERTAR_NODO(ARBOL_DNI, REG.DNI, NUEVA_POS);
    INSERTAR_NODO(ARBOL_NOM, REG.APEYNOM, NUEVA_POS);

    WRITELN;
    WRITELN(MARGEN, '>> ¡Cliente registrado con exito! <<');
  END
  ELSE
  BEGIN
    WRITELN;
    WRITELN(MARGEN, '>> Alta cancelada. No se guardaron los datos. <<');
  END;

  WRITELN;
  WRITE(MARGEN, 'Presione una tecla para continuar...');
  READKEY;
END;

{Modificacion de los datos del cliente activo excepto su identificador unico (DNI), segun requerimiento A.3}
PROCEDURE MODIFICAR_DATOS(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_NOM: T_PUNT; POS: LONGINT; VAR REG: T_REG_CLIENTES);
VAR
  OP: CHAR;
  CONFIRMA: BOOLEAN;
  NOMBRE_EN_ARBOL: STRING; {Apellido y nombre con el que el cliente figura actualmente en ARBOL_NOM}
BEGIN
  NOMBRE_EN_ARBOL := REG.APEYNOM;

  REPEAT
    CLRSCR;
    WRITELN(MARGEN, '============================================');
    WRITELN(MARGEN, '       MODIFICACION DE DATOS CLIENTE        ');
    WRITELN(MARGEN, '============================================');
    WRITELN(MARGEN, 'DNI (no modificable): ', REG.DNI);
    WRITELN(MARGEN, '1 - Apellido y Nombres: ', REG.APEYNOM);
    WRITELN(MARGEN, '2 - Direccion:          ', REG.DIREC);
    WRITELN(MARGEN, '3 - Fecha Nacimiento:   ', REG.FNAC);
    WRITELN(MARGEN, '4 - Celular:            ', REG.CEL);
    WRITELN(MARGEN, '5 - E-mail:             ', REG.MAIL);
    WRITELN(MARGEN, '6 - Modificar TODOS los campos');
    WRITELN(MARGEN, '0 - Volver al menu del cliente');
    WRITELN(MARGEN, '============================================');
    WRITE(MARGEN, 'Seleccione que desea modificar: ');
    READLN(OP);

    CASE OP OF
      '1': REG.APEYNOM := LEERCADENANOVACIA(MARGEN + 'Nuevo Apellido y Nombres');
      '2': REG.DIREC   := LEERDIRECCION(MARGEN + 'Nueva Direccion');
      '3': REG.FNAC    := LEERFECHANAC(MARGEN + 'Nueva Fecha de Nacimiento');
      '4': REG.CEL     := LEERCELULAR(MARGEN + 'Nuevo Celular');
      '5': REG.MAIL    := LEEREMAIL(MARGEN + 'Nuevo E-mail');
      '6': BEGIN
             REG.APEYNOM := LEERCADENANOVACIA(MARGEN + 'Nuevo Apellido y Nombres');
             REG.DIREC   := LEERDIRECCION(MARGEN + 'Nueva Direccion');
             REG.FNAC    := LEERFECHANAC(MARGEN + 'Nueva Fecha de Nacimiento');
             REG.CEL     := LEERCELULAR(MARGEN + 'Nuevo Celular');
             REG.MAIL    := LEEREMAIL(MARGEN + 'Nuevo E-mail');
           END;
    END;

    IF OP IN ['1'..'6'] THEN
    BEGIN
      CONFIRMA := LEERCONFIRMACION(MARGEN + '¿Desea guardar los cambios?');
      IF CONFIRMA THEN
      BEGIN
        SEEK(ARCH_CLIENTES, POS);
        WRITE(ARCH_CLIENTES, REG);

        {Si cambio el APEYNOM, el nodo de ARBOL_NOM se reubica: se elimina la clave vieja y se inserta la nueva con la misma POS}
        IF REG.APEYNOM <> NOMBRE_EN_ARBOL THEN
        BEGIN
          ELIMINAR_NODO(ARBOL_NOM, NOMBRE_EN_ARBOL, POS);
          INSERTAR_NODO(ARBOL_NOM, REG.APEYNOM, POS);
          NOMBRE_EN_ARBOL := REG.APEYNOM;
        END;

        WRITELN(MARGEN, '>> Modificacion guardada con exito. <<');
      END
      ELSE
      BEGIN
        // Restaurar registro leyendo lo que habia en el archivo
        SEEK(ARCH_CLIENTES, POS);
        READ(ARCH_CLIENTES, REG);
        WRITELN(MARGEN, '>> Modificacion cancelada. <<');
      END;
      WRITE(MARGEN, 'Presione una tecla para continuar...');
      READKEY;
    END;
  UNTIL OP = '0';
END;

// CONSULTA, BAJA LOGICA O MODIFICACION
PROCEDURE MODIFICAR_O_BAJA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_NOM: T_PUNT; POS: LONGINT);
VAR
  REG: T_REG_CLIENTES;
  OP: CHAR;
  CONFIRMA: BOOLEAN;
BEGIN
  REPEAT
    LEE_REGISTRO(ARCH_CLIENTES, POS, REG);

    CLRSCR;
    WRITELN(MARGEN, '============================================');
    WRITELN(MARGEN, '             DATOS DEL CLIENTE              ');
    WRITELN(MARGEN, '============================================');
    WRITELN(MARGEN, 'DNI:                 ', REG.DNI);
    WRITELN(MARGEN, 'Apellido y Nombres:  ', REG.APEYNOM);
    WRITELN(MARGEN, 'Direccion:           ', REG.DIREC);
    WRITELN(MARGEN, 'Fecha de Nacimiento: ', REG.FNAC);
    WRITELN(MARGEN, 'Celular:             ', REG.CEL);
    WRITELN(MARGEN, 'E-mail:              ', REG.MAIL);
    IF REG.ESTADO THEN
      WRITELN(MARGEN, 'Estado:              ACTIVO')
    ELSE
      WRITELN(MARGEN, 'Estado:              NO ACTIVO (Baja logica)');
    WRITELN(MARGEN, '============================================');

    IF REG.ESTADO THEN
    BEGIN
      // Cliente ACTIVO
      WRITELN(MARGEN, '1 - Modificar datos');
      WRITELN(MARGEN, '2 - Dar de Baja Logica');
      WRITELN(MARGEN, '0 - Volver al menu principal');
      WRITELN(MARGEN, '============================================');
      WRITE(MARGEN, 'Seleccione una opcion: ');
      READLN(OP);

      CASE OP OF
        '1': MODIFICAR_DATOS(ARCH_CLIENTES, ARBOL_NOM, POS, REG);
        '2': BEGIN
               WRITELN;
               {Baja logica: cambia el campo ESTADO a FALSE sin borrar fisicamente el registro}
               CONFIRMA := LEERCONFIRMACION(MARGEN + '¿Confirma dar de BAJA LOGICA al cliente?');
               IF CONFIRMA THEN
               BEGIN
                 REG.ESTADO := FALSE;
                 SEEK(ARCH_CLIENTES, POS);
                 WRITE(ARCH_CLIENTES, REG);
                 WRITELN(MARGEN, '>> Baja logica aplicada correctamente. <<');
                 WRITE(MARGEN, 'Presione una tecla para continuar...');
                 READKEY;
               END;
             END;
      END;
    END
    ELSE
    BEGIN
      // Cliente INACTIVO
      WRITELN(MARGEN, 'El cliente se encuentra dado de BAJA LOGICA.');
      WRITELN(MARGEN, '1 - Reactivar cliente (Alta logica)');
      WRITELN(MARGEN, '0 - Volver al menu principal');
      WRITELN(MARGEN, '============================================');
      WRITE(MARGEN, 'Seleccione una opcion: ');
      READLN(OP);

      CASE OP OF
        '1': BEGIN
               CONFIRMA := LEERCONFIRMACION(MARGEN + '¿Desea reactivar a este cliente?');
               IF CONFIRMA THEN
               BEGIN
                 REG.ESTADO := TRUE;
                 SEEK(ARCH_CLIENTES, POS);
                 WRITE(ARCH_CLIENTES, REG);
                 WRITELN(MARGEN, '>> Cliente reactivado con exito. <<');
                 WRITE(MARGEN, 'Presione una tecla para continuar...');
                 READKEY;
               END;
             END;
      END;
    END;
  UNTIL OP = '0';
END;

// PROCEDIMIENTO PRINCIPAL DE GESTION DE CLIENTES CON ABB
PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; VAR ARBOL_DNI, ARBOL_NOM: T_PUNT);
VAR
  DNI: STRING;
  POS: LONGINT;
  OPC: CHAR;
BEGIN
  CLRSCR;
  WRITELN(MARGEN, '============================================');
  WRITELN(MARGEN, '            GESTION DE CLIENTES             ');
  WRITELN(MARGEN, '============================================');
  WRITELN;
  DNI := LEERDNI(MARGEN + 'Ingrese DNI del cliente');

  {Busqueda eficiente en memoria utilizando el arbol binario por DNI}
  BUSCAR_NODO(ARBOL_DNI, DNI, POS);

  {Si el DNI no existe en el arbol (POS = -1), deriva al submenú para dar de Alta o Volver (Requerimiento A.2)}
  IF POS = -1 THEN
  BEGIN
    REPEAT
      CLRSCR;
      WRITELN(MARGEN, '============================================');
      WRITELN(MARGEN, '            GESTION DE CLIENTES             ');
      WRITELN(MARGEN, '============================================');
      WRITELN(MARGEN, 'El DNI "', DNI, '" no se encuentra registrado.');
      WRITELN;
      WRITELN(MARGEN, '1 - Alta de Cliente');
      WRITELN(MARGEN, '0 - Volver al menu anterior');
      WRITELN(MARGEN, '============================================');
      WRITE(MARGEN, 'Seleccione una opcion: ');
      READLN(OPC);

      CASE OPC OF
        '1': BEGIN
               DAR_ALTA(ARCH_CLIENTES, DNI, ARBOL_DNI, ARBOL_NOM);
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
