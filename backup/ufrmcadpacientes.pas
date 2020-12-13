unit uFrmCadPacientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, DBExtCtrls, ExtDlgs, MaskUtils,
  uFrmBaseCadastro, ZDataset, db, uDM, Grids, ACBrCEP, DateUtils;

type

  { TFrmCadPacientes }

  TFrmCadPacientes = class(TFrmBaseCadastro)
    ACBrCEP1: TACBrCEP;
    BtnAbrirImagem: TSpeedButton;
    BtnLimparImagem: TSpeedButton;
    BtnPesqCidade: TSpeedButton;
    BtnBuscaCEP: TSpeedButton;
    DBDateEditNacimento: TDBDateEdit;
    DBEditCodigo: TDBEdit;
    DBEditCidade: TDBEdit;
    DBEditNomeCidade: TDBEdit;
    DBEditUF: TDBEdit;
    DBEditCelular: TDBEdit;
    DBEditEmailConta: TDBEdit;
    DBEditNomePaciente: TDBEdit;
    DBEditIdade: TDBEdit;
    DBEditCEP: TDBEdit;
    DBEditLogradouro: TDBEdit;
    DBEditEndereco: TDBEdit;
    DBEditNro: TDBEdit;
    DBEditComplemento: TDBEdit;
    DBEditBairro: TDBEdit;
    DBImageImgPaciente: TDBImage;
    DBMemoProblema: TDBMemo;
    GroupBoxImagem: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    LabelCodigo: TLabel;
    LabelCodigo1: TLabel;
    LabelCodigo10: TLabel;
    LabelCodigo11: TLabel;
    LabelCodigo12: TLabel;
    LabelCodigo13: TLabel;
    LabelCodigo14: TLabel;
    LabelCodigo2: TLabel;
    LabelCodigo3: TLabel;
    LabelCodigo4: TLabel;
    LabelCodigo5: TLabel;
    LabelCodigo6: TLabel;
    LabelCodigo7: TLabel;
    LabelCodigo8: TLabel;
    LabelCodigo9: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    ZQObjetosBAIRRO: TStringField;
    ZQObjetosCELULAR: TStringField;
    ZQObjetosCEP: TStringField;
    ZQObjetosCIDADE: TLongintField;
    ZQObjetosCOMPLEMENTO: TStringField;
    ZQObjetosEMAIL_CONTA: TStringField;
    ZQObjetosENDERECO: TStringField;
    ZQObjetosIDADE: TSmallintField;
    ZQObjetosID_PACIENTE: TLongintField;
    ZQObjetosIMAGEM: TBlobField;
    ZQObjetosLOGRADOURO: TStringField;
    ZQObjetosNASCIMENTO: TDateField;
    ZQObjetosNOME: TStringField;
    ZQObjetosNOME_CIDADE: TStringField;
    ZQObjetosNRO: TLongintField;
    ZQObjetosPROBLEMA: TStringField;
    ZQObjetosSELECIONADO: TStringField;
    ZQObjetosTELEFONE: TStringField;
    ZQObjetosUF_CIDADE: TStringField;
    procedure ACBrCEP1BuscaEfetuada(Sender: TObject);
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure BtnAbrirImagemClick(Sender: TObject);
    procedure BtnBuscaCEPClick(Sender: TObject);
    procedure BtnLimparImagemClick(Sender: TObject);
    procedure BtnPesqCidadeClick(Sender: TObject);
    procedure DBDateEditNacimentoExit(Sender: TObject);
    procedure DBEditCidadeExit(Sender: TObject);
    procedure DBGridCadCellClick(Column: TColumn);
    procedure DBGridCadDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CarregarPacientes();
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    function  Procurar_Cidade(pNomeCidade, pUF:String):boolean;
    procedure Gravando_Nova_Cidade(pNomeCidade, pUF:String);
  private

  public

  end;

var
  FrmCadPacientes: TFrmCadPacientes;

implementation

uses
  ufrmfiltro;

{$R *.lfm}

{ TFrmCadPacientes }

procedure TFrmCadPacientes.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmCadPacientes := nil;
end;

procedure TFrmCadPacientes.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFrmCadPacientes.ActionExcluirExecute(Sender: TObject);
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
        SQL.Add('delete from TPACIENTE where (ID_PACIENTE = :ID_PACIENTE)');
        ParamByName('ID_PACIENTE').AsInteger := ZQObjetos.FieldByName('ID_PACIENTE').AsInteger;
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
  CarregarPacientes();
end;

procedure TFrmCadPacientes.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  CarregarPacientes();
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadPacientes.ACBrCEP1BuscaEfetuada(Sender: TObject);
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

procedure TFrmCadPacientes.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;
  DBEditCodigo.SetFocus;

  //nome
  if ZQObjetos.FieldByName('NOME').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o nome do paciente!', mtWarning, [mbOK],0 );
    DBEditNomePaciente.SetFocus;
    abort;
  END;

  //NASCIMENTO
 { if ZQObjetos.FieldByName('NASCIMENTO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha a Data de Nacimento do paciente!', mtWarning, [mbOK],0 );
    DBDateEditNacimento.SetFocus;
    abort;
  END;}

  //LOGRADOURO
  if ZQObjetos.FieldByName('LOGRADOURO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o Logradouro do Endereço do paciente!', mtWarning, [mbOK],0 );
    DBEditLogradouro.SetFocus;
    abort;
  END;

  //ENDEREÇO
  if ZQObjetos.FieldByName('ENDERECO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o Endereço do paciente!', mtWarning, [mbOK],0 );
    DBEditEndereco.SetFocus;
    abort;
  END;

  //NRO
  if ZQObjetos.FieldByName('NRO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o Número do Endereço do paciente!', mtWarning, [mbOK],0 );
    DBEditNro.SetFocus;
    abort;
  END;

  //BAIRRO
  if ZQObjetos.FieldByName('BAIRRO').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o Bairro do Endereço do paciente!', mtWarning, [mbOK],0 );
    DBEditBairro.SetFocus;
    abort;
  END;

  //CIDADE
  if ZQObjetos.FieldByName('CIDADE').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha a Cidade do Endereço do paciente!', mtWarning, [mbOK],0 );
    DBEditCidade.SetFocus;
    abort;
  END;

  //PROBLEMA
  {if ZQObjetos.FieldByName('PROBLEMA').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Preencha o Problema do paciente!', mtWarning, [mbOK],0 );
    DBMemoProblema.SetFocus;
    abort;
  END;}


  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT] then
          VCodigo := ZQObjetos.FieldByName('ID_PACIENTE').AsInteger // ZQObjetosCODIGO.AsString
        ELSE
          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TPACIENTE_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TPACIENTE 															');
          sql.add('(ID_PACIENTE, NOME, TELEFONE, CEP, LOGRADOURO, BAIRRO, ENDERECO, NRO, COMPLEMENTO, CIDADE, ');
          sql.add('CELULAR, NASCIMENTO ,EMAIL_CONTA, IMAGEM, IDADE, PROBLEMA)                     ');
          sql.add('VALUES                                                                                     ');
          sql.add('(:ID_PACIENTE, :NOME, :TELEFONE, :CEP, :LOGRADOURO, :BAIRRO, :ENDERECO, :NRO, :COMPLEMENTO, ');
          sql.add(':CIDADE, :CELULAR, :NASCIMENTO, :EMAIL_CONTA, :IMAGEM, :IDADE, :PROBLEMA)      ');
          sql.add('MATCHING (ID_PACIENTE)                                                                     ');
          ParamByName('ID_PACIENTE').AsInteger := VCodigo;
          ParamByName('NOME').AsString 	      := ZQObjetos.FieldByName('NOME').AsString;
          ParamByName('TELEFONE').AsString    := ZQObjetos.FieldByName('TELEFONE').AsString;
          ParamByName('CEP').AsString 	      := ZQObjetos.FieldByName('CEP').AsString;
          ParamByName('LOGRADOURO').AsString  := ZQObjetos.FieldByName('LOGRADOURO').AsString;
          ParamByName('BAIRRO').AsString      := ZQObjetos.FieldByName('BAIRRO').AsString;
          ParamByName('ENDERECO').AsString    := ZQObjetos.FieldByName('ENDERECO').AsString;
          ParamByName('NRO').AsInteger 	      := ZQObjetos.FieldByName('NRO').AsInteger;
          ParamByName('COMPLEMENTO').AsString := ZQObjetos.FieldByName('COMPLEMENTO').AsString;
          ParamByName('CIDADE').AsInteger      := ZQObjetos.FieldByName('CIDADE').AsInteger;
          ParamByName('CELULAR').AsString     := ZQObjetos.FieldByName('CELULAR').AsString;
          ParamByName('NASCIMENTO').AsDate    := ZQObjetos.FieldByName('NASCIMENTO').AsDateTime;
          ParamByName('EMAIL_CONTA').AsString := ZQObjetos.FieldByName('EMAIL_CONTA').AsString;

          if ZQObjetos.FieldByName('IMAGEM').IsNull then
          begin
             ParamByName('IMAGEM').Clear;
          end
          else
          begin
             ZQObjetos.FieldByName('IMAGEM').AsString;
          end;

          ParamByName('IDADE').AsInteger       := ZQObjetos.FieldByName('IDADE').AsInteger;
          ParamByName('ORIGEM_CAD').AsString  := ZQObjetos.FieldByName('ORIGEM_CAD').AsString;
          ParamByName('PROBLEMA').AsString    := ZQObjetos.FieldByName('PROBLEMA').AsString;
          ExecSQL;
          DM.ConfirmaTransacao;

          if ZQObjetos.State in [DSINSERT] then
            MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else
            MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );
        end;

          ZQObjetos.FieldByName('ID_PACIENTE').AsInteger := VCodigo;

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
  CarregarPacientes();

end;

procedure TFrmCadPacientes.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBEditCodigo.SetFocus;
end;

procedure TFrmCadPacientes.BtnAbrirImagemClick(Sender: TObject);
var
  BMP: TBitMap;
  JPG: TJpegImage;
  Ext: string;
  Img: TIMage;
begin
  if not (ZQObjetos.State in [dsInsert, dsEdit]) then
    ZQObjetos.Edit;

  if OpenPictureDialog1.Execute then
  begin
    try
      BMP := TBitMap.Create;
      Img := TImage.Create(Self);
      Ext := AnsiUpperCase(ExtractFileExt(OpenPictureDialog1.FileName));
      if (Ext = '.JPG') or (Ext = '.JPEG') then
      begin
        try
          JPG := TJpegImage.Create;
          JPG.LoadFromFile(OpenPictureDialog1.FileName);
          BMP.Assign(JPG);
        finally
          FreeAndNil(JPG);
        end;
      end else
        if (Ext = '.BMP') then
        begin
          BMP.LoadFromFile(OpenPictureDialog1.FileName);
        end;
      Img.Picture.Bitmap.Assign(BMP);
      if (Img.Picture.Width > 250) or (Img.Picture.Height > 250) then
        MessageDlg('Use apenas imagens com dimensões até 250x250 pixels. Tamanhos maiores não serão aceitos.', mtWarning, [mbOk], 0)
      else
      begin
        DBImageImgPaciente.Picture.Bitmap.Assign(BMP);
      end;
    finally
      FreeAndNil(BMP);
      FreeAndNil(Img);
    end;
  end;

end;

procedure TFrmCadPacientes.BtnBuscaCEPClick(Sender: TObject);
begin
  if not (ZQObjetos.State in [dsInsert, dsEdit]) then
    ZQObjetos.Edit;


  if DBEditCEP.Text <> ''
  then begin
     ACBrCEP1.BuscarPorCEP(DBEditCEP.Text );
        end;
end;

procedure TFrmCadPacientes.BtnLimparImagemClick(Sender: TObject);
begin
   inherited;
    if not (ZQObjetos.State in [dsInsert, dsEdit]) then
    ZQObjetos.Edit;

    ZQObjetos.FieldByName('IMAGEM').Clear;
end;

procedure TFrmCadPacientes.BtnPesqCidadeClick(Sender: TObject);
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

procedure TFrmCadPacientes.DBDateEditNacimentoExit(Sender: TObject);
var
  ano, ano_atual:integer;
begin
    if not (ZQObjetos.State in [dsInsert, dsEdit]) then
        ZQObjetos.Edit;

     Ano       := YearOf(DBDateEditNacimento.Date);
     ano_atual := YearOf(now);

    ZQObjetos.FieldByName('IDADE').AsInteger := ano_atual - ano;

end;

procedure TFrmCadPacientes.DBEditCidadeExit(Sender: TObject);
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

procedure TFrmCadPacientes.DBGridCadCellClick(Column: TColumn);
begin
  inherited;
   if DBGridCad.SelectedField.FieldName = 'SELECIONADO' then
  begin
    if ZQObjetos.RecordCount = 0 then
      exit;
    if not (ZQObjetos.State in [dsedit, dsinsert]) then
    begin
      ZQObjetos.Edit;
    end;

    if ZQObjetos.FieldByName('SELECIONADO').AsString = 'X' then
    begin
      ValorSelecionadosRegistros := ValorSelecionadosRegistros - 1;
      ZQObjetos.FieldByName('SELECIONADO').AsString := '';
    end
    else
    begin
     ZQObjetos.FieldByName('SELECIONADO').AsString := 'X';
      ValorSelecionadosRegistros := ValorSelecionadosRegistros + 1;
    end;
    ZQObjetos.Post;


    StatusBarCad.Panels[1].Text := IntToStr(ValorSelecionadosRegistros) + ' Selecionados';
  end;
end;

procedure TFrmCadPacientes.DBGridCadDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
bitmap: TBitmap;
begin
  inherited;
  // Seleção de linhas
  if Column.Index = 0 then
  begin
    DBGridCad.Canvas.FillRect(Rect);

    if Column.Field.AsString = 'X' then
      bitmap := Image2.Picture.bitmap
    else
      bitmap := Image1.Picture.bitmap;

    // desenha a imagem conforme a condição acima
    DBGridCad.Canvas.Draw((Rect.Right - Rect.Left - bitmap.Width) div 2 +
      Rect.Left, (Rect.Bottom - Rect.Top - bitmap.Height) div 2 +
      Rect.Top, bitmap);

  end;
end;


procedure TFrmCadPacientes.FormDestroy(Sender: TObject);
begin

end;

procedure TFrmCadPacientes.CarregarPacientes();
begin

  with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('select '' '' as selecionado, PACIENTE.*,                        ');
    sql.add('       cidade.nome_cidade,                                      ');
    sql.add('       CIDADE.uf_cidade                                         ');
    sql.add('from tpaciente PACIENTE                                         ');
    sql.add('inner join tcidade cidade on PACIENTE.cidade = cidade.id_cidade ');
    open;
    last;
    first;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;

end;

procedure TFrmCadPacientes.FormKeyPress(Sender: TObject; var Key: char);
begin
  inherited;

end;

procedure TFrmCadPacientes.FormShow(Sender: TObject);
begin
  CarregarPacientes();
  inherited;
end;

function TFrmCadPacientes.Procurar_Cidade(pNomeCidade, pUF: String): boolean;
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

procedure TFrmCadPacientes.Gravando_Nova_Cidade(pNomeCidade, pUF: String);
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
RegisterClass(TFrmCadPacientes);

finalization
UnRegisterClass(TFrmCadPacientes);

end.

