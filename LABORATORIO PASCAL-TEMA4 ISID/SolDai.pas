{$CODEPAGE UTF8}

program Materiales;
uses
  SysUtils;

type
  RegSal = record
    Tecnologia: char;
    Nombre: string[30];
    Cantidad: string[3];
    Estado: string[100];
    Codigo: string[5];
  end;

const
  Tec = ['L', 'P', 'B'];

var
  ArchivoMateriales: text;
  Sal: text;
  ArchSal: file of RegSal;
  v: char;
  CdUs: string;
  ContL, ContP, ContB: integer;
  Arch: RegSal;

procedure InitializeVariables;
begin
  ContL := 0;
  ContP := 0;
  ContB := 0;
end;

procedure WriteMaterial(Arch: RegSal);
begin
  writeln(Sal, 'Tecnologia ', Arch.Tecnologia, ':');
  writeln(Sal, 'Nombre: ', Arch.Nombre);
  writeln(Sal, 'Cantidad: ', Arch.Cantidad);
  writeln(Sal, 'Estado: ', Arch.Estado);
  writeln(Sal, 'Codigo: ', Arch.Codigo);
  writeln(Sal); // Agregar una línea en blanco para separar los registros
end;

procedure ProcessMaterial;
var
  IsLB: boolean;
begin
  IsLB := False;

  if v in Tec then
  begin
    if v = 'B' then
    begin
      IsLB := True;
      Arch.Tecnologia := v;
      writeln('Tecnologia B:');
      readln(ArchivoMateriales, Arch.Nombre);
      readln(ArchivoMateriales, Arch.Cantidad);
      readln(ArchivoMateriales, Arch.Estado);
      readln(ArchivoMateriales, Arch.Codigo);

      writeln(Sal, 'Tecnologia B:');
      writeln(Sal, 'Nombre: ', Arch.Nombre);
      writeln(Sal, 'Cantidad: ', Arch.Cantidad);
      writeln(Sal, 'Estado: ', Arch.Estado);
      writeln(Sal, 'Codigo: ', Arch.Codigo);
      writeln;
      ContB := ContB + 1;
    end
    else
    begin
      if (v = 'L') or (v = 'P') then
      begin
        Arch.Tecnologia := v;
        write(Sal, 'Tecnologia ', v, ': ');
        readln(ArchivoMateriales, Arch.Nombre);
        readln(ArchivoMateriales, Arch.Cantidad);
        readln(ArchivoMateriales, Arch.Estado);
        readln(ArchivoMateriales, Arch.Codigo);

        writeln(Sal, 'Nombre: ', Arch.Nombre);
        writeln(Sal, 'Cantidad: ', Arch.Cantidad);
        writeln(Sal, 'Estado: ', Arch.Estado);
        writeln(Sal, 'Codigo: ', Arch.Codigo);
        writeln;
        
        if v = 'L' then
          ContL := ContL + 1
        else if v = 'P' then
        begin
          ContP := ContP + 1;
          WriteMaterial(Arch); // Mostrar los materiales de tecnología 'P' en el archivo de salida y en pantalla
        end;
      end;
    end;
  end;

  if not IsLB then
    readln(ArchivoMateriales); // Leer el resto de la línea para descartar el estado
end;

procedure GenerateSpecificFile(Code: string);
var
  FoundMaterial: boolean;
begin
  reset(ArchivoMateriales); // Abrir el archivo de materiales para leer desde el principio
  assign(ArchSal, 'ArchivoSalida.dat');
  rewrite(ArchSal);
  FoundMaterial := False;

  while not EOF(ArchivoMateriales) do
  begin
    read(ArchivoMateriales, v); // Leer la primera línea con "Tecnologia L/P/B"
    readln(ArchivoMateriales, Arch.Nombre);
    readln(ArchivoMateriales, Arch.Cantidad);
    readln(ArchivoMateriales, Arch.Estado);
    readln(ArchivoMateriales, Arch.Codigo);

    if (Arch.Tecnologia = 'L') and (Arch.Codigo = Code) then
    begin
      FoundMaterial := True;
      write(ArchSal, Arch);
    end;
  end;

  Close(ArchSal);
  Close(ArchivoMateriales); // Cerrar el archivo de materiales

  if not FoundMaterial then
    writeln('No se encontraron materiales de tecnología L con el código específico.')
  else
    writeln('Archivo de salida específico generado.');
end;

procedure DisplayResults;
begin
  writeln('La cantidad de materiales de cada tecnologia son los siguientes:');
  writeln('TECNOLOGIA L: ', ContL);
  writeln('TECNOLOGIA P: ', ContP);
  writeln('TECNOLOGIA B: ', ContB);
end;

procedure ShowOutputFile;
var
  Line: string;
begin
  reset(Sal);
  writeln('Contenido del archivo de salida:');
  writeln('--------------------------------');
  writeln;

  while not EOF(Sal) do
  begin
    readln(Sal, Line);
    writeln(Line);
  end;

  Close(Sal);
  writeln;
  writeln('--------------------------------');
  writeln('||Proceso completado||');
end;

begin
  assign(ArchivoMateriales, 'materiales.txt');
  {$I-} reset(ArchivoMateriales); {$I+}
  if ioresult <> 0 then
  begin
    writeln('El archivo "materiales.txt" no existe.');
    ExitCode := 1; // Set ExitCode to indicate an error
    Halt; // Terminate the program
  end;

  assign(Sal, 'SecuenciaSalida.txt');
  rewrite(Sal);

  writeln('Ingrese el código del material para generar el archivo: ');
  readln(CdUs);

  InitializeVariables;

  while not EOF(ArchivoMateriales) do
  begin
    read(ArchivoMateriales, v);
    ProcessMaterial;
  end;

  DisplayResults;

  writeln('Generando archivo de salida específico...');
  GenerateSpecificFile(CdUs);

  writeln; // Añadir una línea en blanco para separar la interacción anterior del resultado
  ShowOutputFile; // Mostrar el contenido del archivo de salida
end.