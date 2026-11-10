UNIT U_GESTION_CLIENTES;

{$CODEPAGE UTF8}

INTERFACE

uses
   ARCHIVO_CLIENTES, CRT;

PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES);

IMPLEMENTATION

PROCEDURE LEE_REGISTRO(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; I: LONGINT; VAR REG: T_REG_CLIENTES);
BEGIN
   SEEK(ARCH_CLIENTES, I);
   READ(ARCH_CLIENTES, REG);
END;

PROCEDURE BUSCAR(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; BUSCADO: STRING; VAR POS: LONGINT);
VAR
   I: LONGINT;
   REG: T_REG_CLIENTES;
BEGIN
   POS := -1;
   RESET(ARCH_CLIENTES);
   I := 0;
   WHILE (I < FILESIZE(ARCH_CLIENTES)) AND (POS = -1) DO
   BEGIN
      LEE_REGISTRO(ARCH_CLIENTES, I, REG);
      IF REG.DNI = BUSCADO THEN
         POS := I
      ELSE
         I := I + 1;
   END;
END;

// ALTA DE CLIENTE
PROCEDURE DAR_ALTA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; DNI_INGRESADO: STRING);
VAR
   REG: T_REG_CLIENTES;
BEGIN
   CLRSCR;
   WRITELN('--- ALTA DE NUEVO CLIENTE ---');
   REG.DNI := DNI_INGRESADO;
   
   WRITE('Ingrese Apellido y Nombre: '); READLN(REG.APEYNOM);
   WRITE('Ingrese Direccion: '); READLN(REG.DIREC);
   WRITE('Ingrese Fecha de Nacimiento (AAAAMMDD): '); READLN(REG.FNAC);
   WRITE('Ingrese Celular: '); READLN(REG.CEL);
   WRITE('Ingrese Mail: '); READLN(REG.MAIL);
   REG.ESTADO := TRUE; // Activo por defecto
   
   SEEK(ARCH_CLIENTES, FILESIZE(ARCH_CLIENTES));
   WRITE(ARCH_CLIENTES, REG);
   WRITELN;
   WRITELN('¡Cliente registrado con exito!');
   READKEY;
END;

PROCEDURE MODIFICAR_O_BAJA(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES; POS: LONGINT);
VAR
   REG: T_REG_CLIENTES;
   OP: CHAR;
BEGIN
   LEE_REGISTRO(ARCH_CLIENTES, POS, REG);
   
   REPEAT
      CLRSCR;
      WRITELN('--- DATOS DEL CLIENTE ---');
      WRITELN('DNI: ', REG.DNI);
      WRITELN('Apellido y Nombre: ', REG.APEYNOM);
      WRITELN('Direccion: ', REG.DIREC);
      WRITELN('Celular: ', REG.CEL);
      WRITELN('Mail: ', REG.MAIL);
      IF REG.ESTADO THEN 
         WRITELN('Estado: ACTIVO') 
      ELSE 
         WRITELN('Estado: NO ACTIVO (Baja logica)');
      
      WRITELN;
      WRITELN('1 - Modificar datos');
      WRITELN('2 - Dar de Baja Logica');
      WRITELN('0 - Volver');
      WRITE('Elija una opcion: ');
      READLN(OP);
      
      CASE OP OF
         '1': BEGIN
                 IF REG.ESTADO THEN
                 BEGIN
                    WRITELN('Modificando datos (El DNI no se modifica):');
                    WRITE('Nuevo Apellido y Nombre: '); READLN(REG.APEYNOM);
                    WRITE('Nueva Direccion: '); READLN(REG.DIREC);
                    WRITE('Nuevo Celular: '); READLN(REG.CEL);
                    WRITE('Nuevo Mail: '); READLN(REG.MAIL);
                    
                    SEEK(ARCH_CLIENTES, POS);
                    WRITE(ARCH_CLIENTES, REG);
                    WRITELN('Modificacion guardada');
                 END
                 ELSE
                    WRITELN('Error: El cliente esta inactivo, no se puede modificar.');
                 READKEY;
              end;
         '2': BEGIN
                 REG.ESTADO := FALSE;
                 SEEK(ARCH_CLIENTES, POS);
                 WRITE(ARCH_CLIENTES, REG);
                 WRITELN('Baja logica aplicada correctamente');
                 READKEY;
              end;
      END;
   UNTIL OP = '0';
END;

// PROCEDIMIENTO PRINCIPAL DE GESTION
PROCEDURE CLIENTES(VAR ARCH_CLIENTES: T_ARCHIVO_CLIENTES);
VAR 
   DNI: STRING[8];
   POS: LONGINT;
BEGIN
   CLRSCR;
   WRITE('INGRESE DNI DEL CLIENTE: ');
   READLN(DNI);
   
   IF FILESIZE(ARCH_CLIENTES) > 0 THEN
      BUSCAR(ARCH_CLIENTES, DNI, POS)
   ELSE
      POS := -1;
      
   IF POS = -1 THEN
   BEGIN
      WRITELN('El DNI ingresado no se encuentra en el sistema.');
      WRITELN('Se procedera al Alta del cliente.');
      READKEY;
      DAR_ALTA(ARCH_CLIENTES, DNI);
   END
   ELSE
   BEGIN
      MODIFICAR_O_BAJA(ARCH_CLIENTES, POS);
   END;
END;

END.