unit ufrmcadgrupofamiliar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, MaskUtils,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, uFrmBaseCadastro, ACBrEnterTab,
  ACBrCEP, ZDataset, db, uDM, ufrmfiltro;

type

  { TFrmCadGrupoFamiliar }

  TFrmCadGrupoFamiliar = class(TFrmBaseCadastro)
    ACBrCEP1: TACBrCEP;
    BtnBuscaCEP: TSpeedButton;
    BtnPesqCidade: TSpeedButton;
    DBEditBairro: TDBEdit;
    DBEditCEP: TDBEdit;
    DBEditCidade: TDBEdit;
    DBEditCodigoGrupoFamiliar: TDBEdit;
    DBEditComplemento: TDBEdit;
    DBEditDescGrupoFamiliar: TDBEdit;
    DBEditEndereco: TDBEdit;
    DBEditLogradouro: TDBEdit;
    DBEditNomeCidade: TDBEdit;
    DBEditNro: TDBEdit;
    DBEditUF: TDBEdit;
    GroupBoxLocalizacao: TGroupBox;
    LabelCodigo: TLabel;
    LabelCodigo1: TLabel;
    LabelCodigo10: TLabel;
    LabelCodigo11: TLabel;
    LabelCodigo4: TLabel;
    LabelCodigo5: TLabel;
    LabelCodigo6: TLabel;
    LabelCodigo7: TLabel;
    LabelCodigo8: TLabel;
    LabelCodigo9: TLabel;
    ZQObjetosBAIRRO: TStringField;
    ZQObjetosCEP: TStringField;
    ZQObjetosCIDADE: TLongintField;
    ZQObjetosCOMPLEMENTO: TStringField;
    ZQObjetosDESCRICAO: TStringField;
    ZQObjetosENDERECO: TStringField;
    ZQObjetosID_GRUPO_FAMILIAR: TLongintField;
    ZQObjetosLOGRADOURO: TStringField;
    ZQObjetosNOME_CIDADE: TStringField;
    ZQObjetosNRO: TLongintField;
    ZQObjetosUF_CIDADE: TStringField;
    procedure ACBrCEP1BuscaEfetuada(Sender: TObject);
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure BtnBuscaCEPClick(Sender: TObject);
    procedure BtnPesqCidadeClick(Sender: TObject);
    procedure DBEditCidadeExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure CarregarGrupoFamiliar();
    procedure FormShow(Sender: TObject);
    function  Procurar_Cidade(pNomeCidade, pUF:String):boolean;
    procedure Gravando_Nova_Cidade(pNomeCidade, pUF:String);
  private

  public

  end;

var
  FrmCadGrupoFamiliar: TFrmCadGrupoFamiliar;

implementation

{$R *.lfm}

{ TFrmCadGrupoFamiliar }

procedure TFrmCadGrupoFamiliar.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmCadGrupoFamiliar := nil;
end;

procedure TFrmCadGrupoFamiliar.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBEditCodigoGrupoFamiliar.setfocus;
end;

procedure TFrmCadGrupoFamiliar.BtnBuscaCEPClick(Sender: TObject);
begin
    if not (ZQObjetos.State in [dsInsert, dsEdit]) then
    ZQObjetos.Edit;


  if DBEditCEP.Text <> ''
  then begin
     ACBrCEP1.BuscarPorCEP(DBEditCEP.Text );
        end;
end;

procedure TFrmCadGrupoFamiliar.BtnPesqCidadeClick(Sender: TObject);
begin
      inherited;
    try
     if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Edit;

    FrmFiltro := TFrmFiltro.Create(self);
    VTabela := 'TCIDADE';
    FrmFiltro.ShowModal;

    if FrmFiltro.BitBtnSelecionar.ModalResult = mrok then
    begin
      ZQObjetos.FieldByName('CIDADE').AsString       := FrmFiltro.ZQObjetos.FIELDBYNAME('ID_CIDADE').AsString;
      ZQObjetos.FieldByName('NOME_CIDADE').AsString  := FrmFiltro.ZQObjetos.FIELDBYNAME('NOME_CIDADE').AsString;
      ZQObjetos.FieldByName('UF_CIDADE').AsString    := FrmFiltro.ZQObjetos.FIELDBYNAME('UF_CIDADE').AsString;
    end;

  finally
    FreeAndNil(FrmFiltro);
  end;
end;

procedure TFrmCadGrupoFamiliar.DBEditCidadeExit(Sender: TObject);
begin

  inherited;

  if not (ZQObjetos.state in [DSEDIT, DSINSERT])
  then Exit;

  if ZQObjetos.FieldByName('CIDADE').AsString = ''
  then Exit;


  with ZQComandos do
  begin
    close;
    sql.Clear;
    sql.add('select                             ');
    sql.add('    cidade.id_cidade,              ');
    sql.add('    cidade.nome_cidade,            ');
    sql.add('    cidade.UF_CIDADE               ');
    sql.add('from tcidade cidade                ');
    sql.add('where                              ');
    sql.add('    cidade.id_cidade = :cidade     ');
    ParamByName('cidade').AsString := ZQObjetos.FieldByName('CIDADE').AsString;
    open;
    last;
    first;

    if (RecordCount = 0)
    then begin
          MessageDlg('Cidade inválida!', mtWarning, [mbOk], 0);
          DBEditcidade.setfocus;
          abort;
          end
    else begin

      if not (ZQObjetos.State in [DSEDIT, DSINSERT]) then
        ZQObjetos.Edit;

      ZQObjetos.FieldByName('NOME_CIDADE').AsString := FIELDBYNAME('NOME_CIDADE').AsString;
      ZQObjetos.FieldByName('UF_CIDADE').AsString := FIELDBYNAME('UF_CIDADE').AsString;

          end;

  end;


end;

procedure TFrmCadGrupoFamiliar.ActionExcluirExecute(Sender: TObject);
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
        SQL.Add('delete from TGRUPO_FAMILIAR where (id_grupo_familiar = :id_grupo_familiar)');
        ParamByName('id_grupo_familiar').AsInteger := ZQObjetos.FieldByName('id_grupo_familiar').AsInteger;
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
  CarregarGrupoFamiliar();
end;

procedure TFrmCadGrupoFamiliar.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;

  DBEditCodigoGrupoFamiliar.SetFocus;

  //DESCRICAO
  if ZQObjetos.FieldByName('DESCRICAO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha a descrição do grupo familiar!', mtWarning, [mbOK],0 );
    DBEditDescGrupoFamiliar.SetFocus;
    abort;
  END;

  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT] then
          VCodigo := ZQObjetos.FieldByName('id_grupo_familiar').AsInteger // ZQObjetosCODIGO.AsString
        ELSE
          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TGRUPO_FAMILIAR_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TGRUPO_FAMILIAR   ');
          sql.add('(ID_GRUPO_FAMILIAR, DESCRICAO, CEP, LOGRADOURO, BAIRRO, ENDERECO, NRO, COMPLEMENTO, CIDADE)');
          sql.add('VALUES                                  ');
          sql.add('(:ID_GRUPO_FAMILIAR, :DESCRICAO, :CEP, :LOGRADOURO, :BAIRRO, :ENDERECO, :NRO, :COMPLEMENTO, :CIDADE)');
          sql.add('MATCHING (ID_GRUPO_FAMILIAR)            ');
          ParamByName('ID_GRUPO_FAMILIAR').AsInteger := VCodigo;
          ParamByName('DESCRICAO').AsString 	     := ZQObjetos.FieldByName('DESCRICAO').AsString;
          ParamByName('CEP').AsString 	             := ZQObjetos.FieldByName('CEP').AsString;
          ParamByName('LOGRADOURO').AsString         := ZQObjetos.FieldByName('LOGRADOURO').AsString;
          ParamByName('BAIRRO').AsString             := ZQObjetos.FieldByName('BAIRRO').AsString;
          ParamByName('ENDERECO').AsString           := ZQObjetos.FieldByName('ENDERECO').AsString;
          ParamByName('NRO').AsInteger 	             := ZQObjetos.FieldByName('NRO').AsInteger;
          ParamByName('COMPLEMENTO').AsString        := ZQObjetos.FieldByName('COMPLEMENTO').AsString;
          ParamByName('CIDADE').AsInteger            := ZQObjetos.FieldByName('CIDADE').AsInteger;
          ExecSQL;
          DM.ConfirmaTransacao;

          if ZQObjetos.State in [DSINSERT] then
            MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else
            MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );
        end;

          ZQObjetos.FieldByName('ID_GRUPO_FAMILIAR').AsInteger := VCodigo;

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
  CarregarGrupoFamiliar();


end;

procedure TFrmCadGrupoFamiliar.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  CarregarGrupoFamiliar();
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadGrupoFamiliar.ACBrCEP1BuscaEfetuada(Sender: TObject);
var
   i : integer;
begin
    for I := 0 to ACBrCEP1.Enderecos.Count -1 do
    begiN
         ZQObjetos.FieldByName('CEP').AsString          := FormatMaskText('00000\-000;0;', ACBrCEP1.Enderecos[i].CEP);
         ZQObjetos.FieldByName('ENDERECO').AsString     := ACBrCEP1.Enderecos[i].Logradouro;
         ZQObjetos.FieldByName('COMPLEMENTO').AsString  := ACBrCEP1.Enderecos[i].Complemento;

         if Procurar_Cidade(ACBrCEP1.Enderecos[i].Municipio, ACBrCEP1.Enderecos[i].UF)
         then begin
              ZQObjetos.FieldByName('CIDADE').AsInteger := ZQComandos.FieldByName('ID_CIDADE').AsInteger;
              ZQObjetos.FieldByName('NOME_CIDADE').AsString := ZQComandos.FieldByName('NOME_CIDADE').AsString;
              ZQObjetos.FieldByName('UF_CIDADE').AsString := ZQComandos.FieldByName('UF_CIDADE').AsString;
              end
         else begin
              Gravando_Nova_Cidade(ACBrCEP1.Enderecos[i].Municipio, ACBrCEP1.Enderecos[i].UF);
               end;

         ZQObjetos.FieldByName('BAIRRO').AsString       := ACBrCEP1.Enderecos[i].Bairro;
         ZQObjetos.FieldByName('LOGRADOURO').AsString   := ACBrCEP1.Enderecos[i].Tipo_Logradouro;
    end;
end;

procedure TFrmCadGrupoFamiliar.CarregarGrupoFamiliar();
begin
   with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT		     ');
    sql.add('GF.*,                   ');
    sql.add('cidade.nome_cidade,     ');
    sql.add('CIDADE.uf_cidade        ');
    sql.add('FROM tgrupo_familiar GF ');
    sql.add('left join tcidade cidade on GF.cidade = cidade.id_cidade');
    open;
    last;
    first;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadGrupoFamiliar.FormShow(Sender: TObject);
begin
   CarregarGrupoFamiliar();
   inherited;
   ComboBoxColuna.ItemIndex := 2;
   idxColunaProcura := 2;
end;

function TFrmCadGrupoFamiliar.Procurar_Cidade(pNomeCidade, pUF: String
  ): boolean;
var
resp : boolean;
begin

  resp := false;

  with ZQComandos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT					   ');
    sql.add('CID.*                     ');
    sql.add('FROM tcidade CID          ');
    sql.add('WHERE                     ');
    sql.add('CID.nome_cidade LIKE ''%' + pNomeCidade + '%'' ');
    sql.add('AND CID.uf_cidade = '''+ pUF +''' ');
    open;
    last;
    first;

    if RecordCount > 0
    then begin
         resp := true;
         end;

    Result := resp;

  end;

end;

procedure TFrmCadGrupoFamiliar.Gravando_Nova_Cidade(pNomeCidade, pUF: String);
var
VCodigoCidade:integer;
begin

    try

      VCodigoCidade := StrToInt(dm.OBTEMSEQUENCIA('GEN_TCIDADE_ID'));

        dm.IniciaTransacao;

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          SQL.ADD('UPDATE OR INSERT INTO TCIDADE (ID_CIDADE, NOME_CIDADE, UF_CIDADE) VALUES (:ID_CIDADE, :NOME_CIDADE, :UF_CIDADE) MATCHING (ID_CIDADE);');
          ParamByName('ID_CIDADE').AsInteger  := VCodigoCidade;
          ParamByName('NOME_CIDADE').AsString := pNomeCidade;
          ParamByName('UF_CIDADE').AsString   := pUF;
          ExecSQL;
          dm.ConfirmaTransacao;
         end;

         MessageDlg( 'Informação', 'A Cidade nao constava no banco de dados, logo, foi cadastrada com sucesso!', mtConfirmation, [mbOK],0 )

    except
      on e: Exception do
      begin
        DM.CancelaTransacao;
        MessageDlg('Erro', PCHAR('Ocorreu um erro!' + e.Message), mtError, [mbOK],0 );
        abort;
      end;



end;

end;

initialization
RegisterClass(TFrmCadGrupoFamiliar);

finalization
UnRegisterClass(TFrmCadGrupoFamiliar);

end.

