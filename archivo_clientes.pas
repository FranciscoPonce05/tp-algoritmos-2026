UNIT ARCHIVO_CLIENTES;

 {$CODEPAGE UTF8}

 INTERFACE
CONST
  RUTA = 'Arch_clientes.dat';

  TYPE
    T_REG_CLIENTES = RECORD
      DNI: STRING[8];
      APEYNOM: STRING[100];
      DIREC: STRING[60];
      FNAC: STRING[8];
      CEL: STRING[15];
      MAIL: STRING[50];
      ESTADO: BOOLEAN;
    END;

    T_ARCHIVO_CLIENTES = FILE OF T_REG_CLIENTES;

  PROCEDURE CREAR_ABRIR(VAR ARCH_CLI: T_ARCHIVO_CLIENTES);
  PROCEDURE CERRAR(VAR ARCH_CLI: T_ARCHIVO_CLIENTES);

  IMPLEMENTATION

  USES
    SYSUTILS;

  PROCEDURE CREAR_ABRIR(VAR ARCH_CLI: T_ARCHIVO_CLIENTES);
  VAR
    RUTA_COMPLETA: STRING;
  BEGIN
    {ParamStr(0) obtiene la ruta del ejecutable y ExtractFilePath extrae su directorio.
     De esta forma el archivo .dat se guarda siempre en la carpeta del proyecto,
     evitando que Lazarus busque en otra ruta y reporte archivo vacio.}
    RUTA_COMPLETA := EXTRACTFILEPATH(PARAMSTR(0)) + RUTA;
    ASSIGN(ARCH_CLI, RUTA_COMPLETA);
    {$I-}
    RESET(ARCH_CLI);
    {$I+}
    IF IORESULT <> 0 THEN
      REWRITE(ARCH_CLI);
  END;

  PROCEDURE CERRAR(VAR ARCH_CLI: T_ARCHIVO_CLIENTES);
  BEGIN
    CLOSE(ARCH_CLI);
  END;

  END.
