unit uDM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, BufDataset, odbcconn, FileUtil, LResources, Forms,
  Controls, Graphics, Dialogs, ZConnection, ZDataset;

type

  { TDM }

  TDM = class(TDataModule)
    ZConexao: TZConnection;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZQuery2: TZQuery;
    function ConectaBanco(caminho: string): boolean;
    procedure IniciaTransacao();
    procedure ConfirmaTransacao();
    procedure CancelaTransacao();
    function CriarQuery():TZQuery;
    procedure CarregarDataSistema();
    function ObtemSequencia(Generator: String): String;
    procedure ZConexaoAfterConnect(Sender: TObject);
  private

  public
    DataSistema:TDateTime;
    caminho: String;

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

function TDM.ConectaBanco(caminho: string): boolean;
begin
  try

    //if ZConexao.Connected then
    //begin
      //ZConexao.Connected := false;
    //end;

    //ZConexao.LoginPrompt := false;
    //tem que colocar o caminho da dll
    ZConexao.Database:= caminho;
    ZConexao.Protocol:='firebird-2.5';
    ZConexao.User:= 'sysdba';
    ZConexao.Password:= 'masterkey';
    ZConexao.Connected := true;

    if ZConexao.Connected = true then
    begin
      Result := true;
    end;

  except
    on e: Exception do
    begin
      MessageDlg('Não foi possível conectar no banco de dados, Entre em contato com o suporte', mtError, [mbOK],0 );
      Abort;
      Result := false;
    end;
  end;
end;

procedure TDM.IniciaTransacao();
begin
  if zconexao.InTransaction then
   begin
     zconexao.Commit;
   end;
  ZConexao.StartTransaction;
end;

procedure TDM.ConfirmaTransacao();
begin
   if zconexao.InTransaction then
   begin
     zconexao.Commit;
   end;
end;

procedure TDM.CancelaTransacao();
begin
   ZConexao.Rollback;
end;

function TDM.CriarQuery(): TZQuery;
var
  VQuery: TZQuery;
begin
  // Prepara o componente TFDQuery pra receber uma query, com FConn já atribuído.
  VQuery := TZQuery.Create(nil);
  VQuery.Connection := ZConexao;
  Result := VQuery;
end;

procedure TDM.CarregarDataSistema();
var
  VQueryDataSistema: TZQuery;
begin
  VQueryDataSistema := DM.CriarQuery();
  try
    VQueryDataSistema.SQL.Add('select CURRENT_DATE AS DATA_ATUAL, current_timestamp AS DATA_TEMPO_ATUAL FROM RDB$DATABASE');
    VQueryDataSistema.ExecSQL;
    try
      DataSistema := VQueryDataSistema.Fields[0].AsDateTime;
    finally
      VQueryDataSistema.close;
    end;
  finally
    VQueryDataSistema.Free;
  end;
end;

function TDM.ObtemSequencia(Generator: String): String;
var
  Query: TZQuery;
begin
  Query := TZQuery.Create(self);
  with Query do
  begin
    Connection := ZConexao;
    SQL.Clear;
    SQL.add('Select gen_id(' + Generator + ',1) from  RDB$DATABASE');
    Open;
    Result := Fields[0].AsString;
    CLOSE;
  end;
  FreeAndNil(Query);
end;

procedure TDM.ZConexaoAfterConnect(Sender: TObject);
begin

end;

end.

