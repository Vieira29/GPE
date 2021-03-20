unit uFrmCadRemedio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, uFrmBaseCadastro, ACBrEnterTab,
  ZDataset, db;

type

  { TFrmCadRemedio }

  TFrmCadRemedio = class(TFrmBaseCadastro)
    DBEditCodigoRemedio: TDBEdit;
    DBEditNomeRemedio: TDBEdit;
    LabelCodigo: TLabel;
    LabelNomeRemedio: TLabel;
    ZQObjetosID_REMEDIO: TLongintField;
    ZQObjetosNOME_REMEDIO: TStringField;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure CarregarRemedio();

  public

  end;

var
  FrmCadRemedio: TFrmCadRemedio;

implementation

uses udm;

{$R *.lfm}

{ TFrmCadRemedio }

procedure TFrmCadRemedio.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmCadRemedio := nil;
end;

procedure TFrmCadRemedio.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBEditCodigoRemedio.SetFocus;
end;

procedure TFrmCadRemedio.ActionExcluirExecute(Sender: TObject);
begin
  inherited;
    try
    if MessageDlg('Atenção', 'Deseja Realmente Excluir?', mtWarning,  [mbYes, mbNo],0) = mrYes then
    begin
      DM.IniciaTransacao;
      with ZQComandos do
      begin
        CLOSE;
        SQL.Clear;
        SQL.Add('delete from TREMEDIO where (ID_REMEDIO = :ID_REMEDIO)');
        ParamByName('ID_REMEDIO').AsInteger := ZQObjetos.FieldByName('ID_REMEDIO').AsInteger;
        ExecSQL;
      end;
      DM.ConfirmaTransacao
    end;
  except
    on e: Exception do
    begin
      if Pos(e.Message, 'Operation aborted') > 0 then
      begin
        DM.ConfirmaTransacao;
        exit;
      end;
      MessageDlg('Atenção', PCHAR('Não será possível excluir porque já está sendo utilizado em outra tabela. ' + e.Message),  mtWarning, [mbOK],0);
      DM.CancelaTransacao;
      abort;
    end;
  end;
  CarregarRemedio();
end;

procedure TFrmCadRemedio.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;
  DBEditCodigoRemedio.SetFocus;

  //NOME_REMEDIO
  if ZQObjetos.FieldByName('NOME_REMEDIO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o nome do Remeédio!', mtWarning, [mbOK],0 );
    DBEditNomeRemedio.SetFocus;
    abort;
  END;


  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT] then
          VCodigo := ZQObjetos.FieldByName('ID_REMEDIO').AsInteger // ZQObjetosCODIGO.AsString
        ELSE
          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TREMEDIO_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TREMEDIO 															');
          sql.add('(ID_REMEDIO, NOME_REMEDIO)');
          sql.add('VALUES                                                                                     ');
          sql.add('(:ID_REMEDIO, :NOME_REMEDIO)');
          sql.add('MATCHING (ID_REMEDIO)                                                                     ');
          ParamByName('ID_REMEDIO').AsInteger   := VCodigo;
          ParamByName('NOME_REMEDIO').AsString  := ZQObjetos.FieldByName('NOME_REMEDIO').AsString;
          ExecSQL;
          DM.ConfirmaTransacao;

          if ZQObjetos.State in [DSINSERT] then
            MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else
            MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );
        end;

          ZQObjetos.FieldByName('ID_REMEDIO').AsInteger := VCodigo;

      end;

    except
      on e: Exception do
      begin
        DM.CancelaTransacao;
        MessageDlg('Erro', PCHAR('Ocorreu um erro!' + e.Message), mtError, [mbOK],0 );
        abort;
      end;
    end;
  finally
    ZQObjetos.Post;
  end;
  CarregarRemedio();

end;

procedure TFrmCadRemedio.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadRemedio.FormShow(Sender: TObject);
begin
  CarregarRemedio();
  inherited;
end;

procedure TFrmCadRemedio.CarregarRemedio();
begin
  with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT				');
    sql.add('REM.*              ');
    sql.add('FROM tremedio REM  ');
    open;
    last;
    first;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;
end;

initialization
RegisterClass(TFrmCadRemedio);

finalization
UnRegisterClass(TFrmCadRemedio);
end.

