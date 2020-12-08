unit uCarregaINI;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, IniFiles, StdCtrls;

type
  CarregaINI = class

  public
   ArqIni: TIniFile;
  { Public declarations }
  function LeIni(NomeIni, Secao, Campo: string; valor: Variant; Tipo: Char): string;
  constructor Create;
  destructor Destroy; override;
  end;

implementation

{ CarregaINI }

constructor CarregaINI.Create;
begin
//
end;

destructor CarregaINI.Destroy;
begin
  inherited;
  ArqIni.Free;
end;

function CarregaINI.LeIni(NomeIni, Secao, Campo: string; valor: Variant;
  Tipo: Char): string;
var
  resposta: string;
begin
  resposta := '';
  ArqIni := TIniFile.create(ExtractFilePath(Application.ExeName) + NomeIni);


  if Tipo = 'S' then
    resposta := ArqIni.readstring(Secao, Campo, valor);

  Result := resposta;


end;

end.

