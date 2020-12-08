unit uValidacaoGeral;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { ValidacaoGeral }

  ValidacaoGeral = class
    function ValidaData(value: string): Boolean;
    function ValidaInteiro(value: String): Boolean;
    function ValidaDouble(value: String): Boolean;
    function ValidaString(value: String): Boolean;
end;

implementation

{ ValidacaoGeral }

function ValidacaoGeral.ValidaData(value: string): Boolean;
var
  Data: TDateTime;
begin
  Result := true;
  try
    Data := StrToDate(value);
  except
    Result := false;
  end;

end;

function ValidacaoGeral.ValidaInteiro(value: String): Boolean;
var
  Numero: Integer;
begin
  Result := true;
  try
    Numero := StrToInt(value);
  except
    Result := false;
  end;

end;

function ValidacaoGeral.ValidaDouble(value: String): Boolean;
var
  Numero: Double;
begin
  Result := true;
  try
    Numero := StrToFloat(value);
  except
    Result := false;
  end;

end;

function ValidacaoGeral.ValidaString(value: String): Boolean;
var
  VString: string;
begin
  Result := true;
  try
    VString := value;
  except
    Result := false;
  end;

end;

end.

