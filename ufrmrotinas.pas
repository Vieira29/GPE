unit uFrmRotinas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TFrmRotinas }

  TFrmRotinas = class(TForm)
  private

  public
    function LeIni(NomeIni, Secao, Campo: string; valor: Variant; Tipo: Char): string;
  end;

var
  FrmRotinas: TFrmRotinas;

implementation


USES INIFILES;

{$R *.lfm}

{ TFrmRotinas }

function TFrmRotinas.LeIni(NomeIni, Secao, Campo: string; valor: Variant;
  Tipo: Char): string;
var
  ArqIni: TIniFile;
  resposta: string;
begin
  resposta := '';
  ArqIni := TIniFile.create(ExtractFilePath(Application.ExeName) + NomeIni);

  if Tipo = 'S' then
    resposta := ArqIni.readstring(Secao, Campo, valor);

  Result := resposta;

end;

end.

