unit uFrmCadCidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, uFrmBaseCadastro,
  ZDataset, db, uDM;

type

  { TFrmCadCidade }

  TFrmCadCidade = class(TFrmBaseCadastro)
    DBEditCodigoCidade: TDBEdit;
    DBEditNomeCidade: TDBEdit;
    DBEditUFCidade: TDBEdit;
    LabelCodigo: TLabel;
    LabelCodigo1: TLabel;
    LabelCodigo2: TLabel;
    ZQObjetosID_CIDADE: TLongintField;
    ZQObjetosNOME_CIDADE: TStringField;
    ZQObjetosUF_CIDADE: TStringField;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure CarregarCidades;

  public

  end;

var
  FrmCadCidade: TFrmCadCidade;

implementation

{$R *.lfm}

{ TFrmCadCidade }

procedure TFrmCadCidade.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   inherited;
  CloseAction := caFree;
  FrmCadCidade := nil;
end;

procedure TFrmCadCidade.ActionExcluirExecute(Sender: TObject);
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
        SQL.Add('delete from TCIDADE where (ID_CIDADE = :ID_CIDADE)');
        ParamByName('ID_CIDADE').AsInteger := ZQObjetos.FieldByName('ID_CIDADE').AsInteger;
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
  CarregarCidades();
end;

procedure TFrmCadCidade.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  CarregarCidades;
end;

procedure TFrmCadCidade.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;
  DBEditCodigoCidade.SetFocus;

  //NOME_CIDADE
  if ZQObjetos.FieldByName('NOME_CIDADE').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o nome da Cidade!', mtWarning, [mbOK],0 );
    DBEditNomeCidade.SetFocus;
    abort;
  END;

  //UF CIDADE
  if ZQObjetos.FieldByName('UF_CIDADE').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha a UF da Cidade!', mtWarning, [mbOK],0 );
    DBEditUFCidade.SetFocus;
    abort;
  END;



  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT] then
          VCodigo := ZQObjetos.FieldByName('ID_CIDADE').AsInteger // ZQObjetosCODIGO.AsString
        ELSE
          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TCIDADE_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TCIDADE 															');
          sql.add('(ID_CIDADE, NOME_CIDADE, UF_CIDADE)');
          sql.add('VALUES                                                                                     ');
          sql.add('(:ID_CIDADE, :NOME_CIDADE, :UF_CIDADE)');
          sql.add('MATCHING (ID_CIDADE)                                                                     ');
          ParamByName('ID_CIDADE').AsInteger   := VCodigo;
          ParamByName('NOME_CIDADE').AsString  := ZQObjetos.FieldByName('NOME_CIDADE').AsString;
          ParamByName('UF_CIDADE').AsString    := ZQObjetos.FieldByName('UF_CIDADE').AsString;
          ExecSQL;
          DM.ConfirmaTransacao;

          if ZQObjetos.State in [DSINSERT] then
            MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else
            MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );
        end;

          ZQObjetos.FieldByName('ID_CIDADE').AsInteger := VCodigo;

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
  CarregarCidades();

end;

procedure TFrmCadCidade.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBEditCodigoCidade.SetFocus;
end;

procedure TFrmCadCidade.FormShow(Sender: TObject);
begin
  CarregarCidades();
  inherited;
end;

procedure TFrmCadCidade.CarregarCidades;
begin

  with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT			  ');
    sql.add('CID.*            ');
    sql.add('FROM tcidade CID ');
    open;
    last;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;
end;

initialization
RegisterClass(TFrmCadCidade);

finalization
UnRegisterClass(TFrmCadCidade);

end.

