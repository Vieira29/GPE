unit uFrmCadEvento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, DBExtCtrls, uFrmBaseCadastro,
  ACBrEnterTab, ZDataset, db, uDM, ufrmfiltro, uFrmbaseTexto;

type

  { TFrmCadEvento }

  TFrmCadEvento = class(TFrmBaseCadastro)
    BtnPesqPaciente: TSpeedButton;
    DBDateEditDataLanEvento: TDBDateEdit;
    DBDateEditDataUltTratEsp: TDBDateEdit;
    DBDateEditDataUltCirEsp: TDBDateEdit;
    DBEditCodigoProcedimento: TDBEdit;
    DBEditCodPaciente: TDBEdit;
    DBEditNomePaciente: TDBEdit;
    DBMemoProblema: TDBMemo;
    DBMemoDescTratOutros: TDBMemo;
    DBRadioGroupTipoEvento: TDBRadioGroup;
    DBRadioGroupFlagTratOutros: TDBRadioGroup;
    DBRadioGroupFlagCirEsp: TDBRadioGroup;
    LabelCodigo: TLabel;
    LabelCodigo14: TLabel;
    LabelCodigo15: TLabel;
    LabelCodigo4: TLabel;
    LabelCodigo5: TLabel;
    LabelCodigo6: TLabel;
    LabelPaciente: TLabel;
    PageControlTipoEvento: TPageControl;
    PanelTituloTipoSol: TPanel;
    PanelTituloTipoRet: TPanel;
    spbExibirEvento: TSpeedButton;
    spbExibirEventoFamiliar: TSpeedButton;
    TabRetorno: TTabSheet;
    TabSolicitacao: TTabSheet;
    ZQObjetosDATA_EVENTO: TDateField;
    ZQObjetosDESCRICAO_EVENTO: TStringField;
    ZQObjetosDESC_CIR_ESP: TStringField;
    ZQObjetosDESC_TRAT_OUTROS: TStringField;
    ZQObjetosFLAG_CIR_ESP: TStringField;
    ZQObjetosFLAG_TRAT_OUTROS: TStringField;
    ZQObjetosGRUPO_FAMILIAR: TLongintField;
    ZQObjetosID_EVENTO: TLongintField;
    ZQObjetosNOME_PACIENTE: TStringField;
    ZQObjetosPACIENTE: TLongintField;
    ZQObjetosPROBLEMA: TStringField;
    ZQObjetosSELECIONADO: TStringField;
    ZQObjetosTIPO_EVENTO: TStringField;
    ZQObjetosULT_CIR_ESP: TDateField;
    ZQObjetosULT_TRAT_ESP: TDateField;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure BtnPesqPacienteClick(Sender: TObject);
    procedure DBEditCodPacienteExit(Sender: TObject);
    procedure DBRadioGroupTipoEventoChangeBounds(Sender: TObject);
    procedure DBRadioGroupTipoEventoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure CarregarEvento();
    procedure FormShow(Sender: TObject);
    procedure spbExibirEventoClick(Sender: TObject);
    procedure SelecionarPagina(PageControl: TPageControl; Pagina: TTabSheet);
    procedure spbExibirEventoFamiliarClick(Sender: TObject);
  private

  public

  end;

var
  FrmCadEvento: TFrmCadEvento;
  ValorTotalRegistros : integer;

implementation

{$R *.lfm}


{ TFrmCadEvento }

procedure TFrmCadEvento.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmCadEvento := nil;
end;

procedure TFrmCadEvento.ActionExcluirExecute(Sender: TObject);
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
        SQL.Add('delete from TEVENTO where (ID_EVENTO = :ID_EVENTO)');
        ParamByName('ID_EVENTO').AsInteger := ZQObjetos.FieldByName('ID_EVENTO').AsInteger;
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
  CarregarEvento();
end;

procedure TFrmCadEvento.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;

  DBDateEditDataLanEvento.SetFocus;

  //PACIENTE
  if ZQObjetos.FieldByName('PACIENTE').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Selecione um paciente para o evento!', mtWarning, [mbOK],0 );
    DBEditCodPaciente.SetFocus;
    abort;
  END;



  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT]
        then VCodigo := ZQObjetos.FieldByName('id_evento').AsInteger // ZQObjetosCODIGO.AsString
        ELSE VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TEVENTO_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TEVENTO   ');
          sql.add('(ID_EVENTO, PACIENTE, TIPO_EVENTO, DATA_EVENTO, PROBLEMA, FLAG_TRAT_OUTROS, DESC_TRAT_OUTROS, ULT_TRAT_ESP, FLAG_CIR_ESP, DESC_CIR_ESP, ULT_CIR_ESP) ');
          sql.add('VALUES                                  ');
          sql.add('(:ID_EVENTO, :PACIENTE, :TIPO_EVENTO, :DATA_EVENTO, :PROBLEMA, :FLAG_TRAT_OUTROS, :DESC_TRAT_OUTROS, :ULT_TRAT_ESP, :FLAG_CIR_ESP, :DESC_CIR_ESP, :ULT_CIR_ESP) ');
          sql.add('MATCHING (ID_EVENTO)            ');
          ParamByName('ID_EVENTO').AsInteger        := VCodigo;
          ParamByName('PACIENTE').AsInteger         := ZQObjetos.FieldByName('PACIENTE').AsInteger;
          ParamByName('TIPO_EVENTO').AsString       := ZQObjetos.FieldByName('TIPO_EVENTO').AsString;
          ParamByName('DATA_EVENTO').AsDateTime     := ZQObjetos.FieldByName('DATA_EVENTO').AsDateTime;
          ParamByName('PROBLEMA').AsString          := ZQObjetos.FieldByName('PROBLEMA').AsString;
          ParamByName('FLAG_TRAT_OUTROS').AsString  := ZQObjetos.FieldByName('FLAG_TRAT_OUTROS').AsString;
          ParamByName('DESC_TRAT_OUTROS').AsString  := ZQObjetos.FieldByName('DESC_TRAT_OUTROS').AsString;
          ParamByName('DATA_EVENTO').AsDateTime     := ZQObjetos.FieldByName('DATA_EVENTO').AsDateTime;
          ParamByName('ULT_TRAT_ESP').AsDateTime    := ZQObjetos.FieldByName('ULT_TRAT_ESP').AsDateTime;
          ParamByName('FLAG_CIR_ESP').AsString      := ZQObjetos.FieldByName('FLAG_CIR_ESP').AsString;
          ParamByName('DESC_CIR_ESP').AsString      := ZQObjetos.FieldByName('DESC_CIR_ESP').AsString;
          ParamByName('ULT_CIR_ESP').AsDateTime     := ZQObjetos.FieldByName('ULT_CIR_ESP').AsDateTime;

          ExecSQL;
          DM.ConfirmaTransacao;

          if ZQObjetos.State in [DSINSERT]
          then MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );
        end;

          ZQObjetos.FieldByName('ID_EVENTO').AsInteger := VCodigo;

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
  CarregarEvento();

end;

procedure TFrmCadEvento.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  CarregarEvento();
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadEvento.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBDateEditDataLanEvento.setfocus;
  ZQObjetosDATA_EVENTO.AsDateTime := now();
  DBRadioGroupTipoEvento.ItemIndex:= 0;
end;

procedure TFrmCadEvento.BtnPesqPacienteClick(Sender: TObject);
begin
     try
     if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Edit;

    FrmFiltro := TFrmFiltro.Create(self);
    VTabela := 'TPACIENTE';
    FrmFiltro.ShowModal;

    if FrmFiltro.BitBtnSelecionar.ModalResult = mrok then
    begin
      ZQObjetos.FieldByName('PACIENTE').AsString         := FrmFiltro.ZQObjetos.FIELDBYNAME('ID_PACIENTE').AsString;
      ZQObjetos.FieldByName('NOME_PACIENTE').AsString     := FrmFiltro.ZQObjetos.FIELDBYNAME('NOME').AsString;
    end;

  finally
    FreeAndNil(FrmFiltro);
  end;
end;

procedure TFrmCadEvento.DBEditCodPacienteExit(Sender: TObject);
begin
if not (ZQObjetos.state in [DSEDIT, DSINSERT])
 then Exit;

 if ZQObjetos.FieldByName('PACIENTE').AsString = ''
 then Exit;


 with ZQComandos do
 begin
   close;
   sql.Clear;
   sql.add('SELECT							');
   sql.add('PACIENTE.id_paciente,          ');
   sql.add('PACIENTE.nome AS NOME_PACIENTE ');
   sql.add('FROM TPACIENTE PACIENTE        ');
   sql.add('where                              ');
   sql.add('    PACIENTE.id_paciente = :PACIENTE     ');
   ParamByName('PACIENTE').AsString := ZQObjetos.FieldByName('PACIENTE').AsString;
   open;
   last;
   first;

   if (RecordCount = 0)
   then begin
         MessageDlg('Paciente inválido!', mtWarning, [mbOk], 0);
         DBEditCodPaciente.setfocus;
         abort;
         end
   else begin

     if not (ZQObjetos.State in [DSEDIT, DSINSERT]) then
       ZQObjetos.Edit;

     ZQObjetos.FieldByName('NOME_PACIENTE').AsString := FIELDBYNAME('NOME_PACIENTE').AsString;


         end;

 end;

end;

procedure TFrmCadEvento.DBRadioGroupTipoEventoChangeBounds(Sender: TObject);
begin

end;

procedure TFrmCadEvento.DBRadioGroupTipoEventoClick(Sender: TObject);
begin
 if DBRadioGroupTipoEvento.ItemIndex = 0
 then SelecionarPagina(PageControlTipoEvento, TabSolicitacao)
 else SelecionarPagina(PageControlTipoEvento, TabRetorno)
end;


procedure TFrmCadEvento.CarregarEvento();
begin
  with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT                                                                 ');
    sql.add(''' '' as selecionado,                                                  ');
    sql.add('EVENTO.*,                                                              ');
    sql.add('CASE EVENTO.tipo_evento                                                ');
    sql.add('WHEN ''S'' then ''Solicitacao''                                        ');
    sql.add('WHEN ''R'' then ''Retorno''                                            ');
    sql.add('end as DESCRICAO_EVENTO,                                               ');
    sql.add('PACIENTE.nome AS NOME_PACIENTE,                                         ');
    sql.add('PACIENTE.GRUPO_FAMILIAR                                               ');
    sql.add('FROM TEVENTO EVENTO                                                    ');
    sql.add('LEFT JOIN tpaciente PACIENTE ON EVENTO.paciente = PACIENTE.id_paciente ');
    open;
    last;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadEvento.FormShow(Sender: TObject);
begin
   CarregarEvento();
   inherited;
   ComboBoxColuna.ItemIndex := 2;
   idxColunaProcura := 2;
end;

procedure TFrmCadEvento.spbExibirEventoClick(Sender: TObject);
var
  vtemptexto : string;
  vflag, vcomplemento   : string;
begin
 try

   with ZQComandos do
   begin
     close;
     sql.Clear;
     sql.add('select PACIENTE.*,                                                                                      ');
     sql.add('       cidade.nome_cidade,                                                                              ');
     sql.add('       CIDADE.uf_cidade,                                                                                ');
     sql.add('       GRUPO_FAMILIAR.DESCRICAO                                                                         ');
     sql.add('from tpaciente PACIENTE                                                                                 ');
     sql.add('LEFT join tcidade cidade on PACIENTE.cidade = cidade.id_cidade                                         ');
     sql.add('LEFT join tgrupo_familiar grupo_familiar on PACIENTE.grupo_familiar = grupo_familiar.id_grupo_familiar ');
     sql.add('WHERE PACIENTE.ID_PACIENTE = :ID_PACIENTE                                                               ');
     ParamByName('ID_PACIENTE').AsInteger := ZQObjetosPACIENTE.AsInteger;
     open;
     last;
     first;
   end;

   if ZQObjetosTIPO_EVENTO.AsString = 'S'
   then begin
        if ZQObjetosFLAG_TRAT_OUTROS.AsString = 'S'
        then begin
             vflag := 'Sim';
             vcomplemento := #13 + 'Se sim, qual?' + #13 + ZQObjetosDESC_TRAT_OUTROS.AsString + #13;
        end
        else begin
             vflag := 'Não';
             vcomplemento := #13 + ' ';
             end;

         vtemptexto :=
         'Ficha de *Solicitação*'
        + #13 + 'Data: ' + ZQObjetosDATA_EVENTO.AsString
        + #13 + '*Paciente*: ' + ZQObjetosNOME_PACIENTE.AsString
        + #13 + 'Data de Nascimento: ' + ZQComandos.FieldByName('NASCIMENTO').AsString
        + #13 + 'Idade: ' + ZQComandos.FieldByName('IDADE').AsString + #13
        + #13 + 'CEP: ' + ZQComandos.FieldByName('CEP').AsString
        + #13 + 'Endereço: ' + ZQComandos.FieldByName('LOGRADOURO').AsString
                + ' ' + ZQComandos.FieldByName('ENDERECO').AsString
                + ' ' + ZQComandos.FieldByName('COMPLEMENTO').AsString
        + #13 + 'Nro: ' +  ZQComandos.FieldByName('NRO').AsString
        + #13 + 'Bairro: ' + ZQComandos.FieldByName('BAIRRO').AsString
        + #13 + 'Cidade: ' + ZQComandos.FieldByName('NOME_CIDADE').AsString
        + #13 + 'Estado: ' + ZQComandos.FieldByName('UF_CIDADE').AsString + #13
        + #13 + '_Problema_: ' + #13 + ZQObjetosPROBLEMA.AsString + #13
        + #13 + 'Já está em algum tratamento?' + #13 + vflag + #13
        + vcomplemento;
        end
   else begin

       if ZQObjetosFLAG_CIR_ESP.AsString = 'S'
       then begin
       vflag := 'Sim';
       vcomplemento := #13 + 'Se sim, quando foi a última?' + #13 + ZQObjetosULT_CIR_ESP.AsString + #13;
       end
       else begin
       vflag := 'Não';
       vcomplemento := #13 + '';
       end;

         vtemptexto :=
         'Ficha de *Retorno*'
        + #13 + 'Data: ' + ZQObjetosDATA_EVENTO.AsString
        + #13 + '*Paciente*: ' + ZQObjetosNOME_PACIENTE.AsString
        + #13 + 'Data de Nascimento: ' + ZQComandos.FieldByName('NASCIMENTO').AsString
        + #13 + 'Idade: ' + ZQComandos.FieldByName('IDADE').AsString + #13
        + #13 + 'CEP: ' + ZQComandos.FieldByName('CEP').AsString
        + #13 + 'Endereço: ' + ZQComandos.FieldByName('LOGRADOURO').AsString
              + ' ' + ZQComandos.FieldByName('ENDERECO').AsString
              + ' ' + ZQComandos.FieldByName('COMPLEMENTO').AsString
        + #13 + 'Nro: ' +  ZQComandos.FieldByName('NRO').AsString
        + #13 + 'Bairro: ' + ZQComandos.FieldByName('BAIRRO').AsString
        + #13 + 'Cidade: ' + ZQComandos.FieldByName('NOME_CIDADE').AsString
        + #13 + 'Estado: ' + ZQComandos.FieldByName('UF_CIDADE').AsString + #13
        + #13 + '_Problema_: ' + #13 + ZQObjetosPROBLEMA.AsString + #13
        + #13 + 'Quando foi o último tratamento espiritual com Dr. Hansen?' + #13 + ZQObjetosULT_TRAT_ESP.AsString + #13
        + #13 + 'Já fez cirurgia espiritual com Dr. Hansen?' + #13 + vflag + #13
        + vcomplemento;
   end;

    FrmBaseTexto := TFrmBaseTexto.Create(self);
    FrmBaseTexto.TextoExibido := vtemptexto;
    FrmBaseTexto.ShowModal;


  finally
    FreeAndNil(FrmBaseTexto);
  end;
end;

procedure TFrmCadEvento.SelecionarPagina(PageControl: TPageControl;
  Pagina: TTabSheet);
begin



  if   PageControl.Name = 'PageControlTipoEvento'
  then begin

       TabRetorno.TabVisible              := False;
       TabSolicitacao.TabVisible          := False;
       PageControlTipoEvento.ActivePage   := nil;
       //PageControlTipoEvento.Style        := tsFlatButtons;

       if   Pagina.Name = 'TabRetorno'
       then begin
            PageControlTipoEvento.ActivePage := TabRetorno;
            end;

       if   Pagina.Name = 'TabSolicitacao'
       then begin
            PageControlTipoEvento.ActivePage := TabSolicitacao;
            end;


       end;


end;

procedure TFrmCadEvento.spbExibirEventoFamiliarClick(Sender: TObject);
var
  vcabecalho, vpacientes, vtemptexto : string;
  vflag, vcomplemento   : string;
  IndicePaciente : integer;
begin
 try

   with ZQComandos do
   begin
     close;
     sql.Clear;
     sql.add('select PACIENTE.id_paciente,													  ');
     sql.add('       PACIENTE.nome,                                                            ');
     sql.add('       PACIENTE.nascimento,                                                      ');
     sql.add('       PACIENTE.idade,                                                           ');
     sql.add('       GF.*,                                                                     ');
     sql.add('       cidade.nome_cidade,                                                       ');
     sql.add('       CIDADE.uf_cidade,                                                         ');
     sql.add('       EVENTO.*                                                                  ');
     sql.add('from tpaciente PACIENTE                                                          ');
     sql.add('INNER join tgrupo_familiar GF on PACIENTE.grupo_familiar = GF.id_grupo_familiar  ');
     sql.add('INNER join tcidade cidade on GF.cidade = cidade.id_cidade                        ');
     sql.add('INNER JOIN tevento EVENTO ON PACIENTE.id_paciente = EVENTO.paciente              ');
     sql.add('WHERE                                                                            ');
     sql.add('GF.id_grupo_familiar             = :ID_GRUPO_FAMILIAR                            ');
     sql.add('AND EVENTO.data_evento           = :DATA_EVENTO                                  ');
     sql.add('AND EVENTO.tipo_evento           = :TIPO_EVENTO                                  ');
     ParamByName('ID_GRUPO_FAMILIAR').AsInteger := ZQObjetosGRUPO_FAMILIAR.AsInteger;
     ParamByName('DATA_EVENTO').AsDateTime := ZQObjetosDATA_EVENTO.AsDateTime;
     ParamByName('TIPO_EVENTO').AsString := ZQObjetosTIPO_EVENTO.AsString;
     open;
     last;
     first;
   end;

   //SOLICITAÇAO
   if ZQObjetosTIPO_EVENTO.AsString = 'S'
   then begin
        vcabecalho :=
         'Ficha de *Solicitação*'
        + #13 + 'Familiar: *' +  ZQComandos.RecordCount.ToString() + '* _pacientes_'
        + #13 + 'CEP: ' + ZQComandos.FieldByName('CEP').AsString
        + #13 + 'Endereço: ' + ZQComandos.FieldByName('LOGRADOURO').AsString
                + ' ' + ZQComandos.FieldByName('ENDERECO').AsString
                + ' ' + ZQComandos.FieldByName('COMPLEMENTO').AsString
        + #13 + 'Nro: ' +  ZQComandos.FieldByName('NRO').AsString
        + #13 + 'Bairro: ' + ZQComandos.FieldByName('BAIRRO').AsString
        + #13 + 'Cidade: ' + ZQComandos.FieldByName('NOME_CIDADE').AsString
        + #13 + 'Estado: ' + ZQComandos.FieldByName('UF_CIDADE').AsString + #13;

        IndicePaciente := 0;
       vpacientes     := '';

        ZQComandos.First;
        while not(ZQComandos.eof)
        do begin

           if  ZQComandos.FieldByName('FLAG_TRAT_OUTROS').AsString = 'S'
           then begin
                vflag := 'Sim';
                vcomplemento := #13 + 'Se sim, qual?' + #13 + ZQComandos.FieldByName('DESC_TRAT_OUTROS').AsString + #13;
                end
           else begin
                vflag := 'Não';
                vcomplemento := #13 + ' ';
                end;


           Inc(IndicePaciente);
           vpacientes := vpacientes +
            #13 + '*Paciente ' + IndicePaciente.ToString() + '*: ' + ZQComandos.FieldByName('NOME').AsString
          + #13 + 'Data de Nascimento: ' + ZQComandos.FieldByName('NASCIMENTO').AsString
          + #13 + 'Idade: ' + ZQComandos.FieldByName('IDADE').AsString + #13
          + #13 + '_Problema_: ' + #13 + ZQComandos.FieldByName('PROBLEMA').AsString + #13
          + #13 + 'Já está em algum tratamento?' + #13 + vflag + #13
          + vcomplemento;


           ZQComandos.next;
           end;


        end
   //RETORNO
   else begin

       vcabecalho :=
         'Ficha de *Retorno*'
        + #13 + 'Familiar: *' +  ZQComandos.RecordCount.ToString() + '* _pacientes_'
        + #13 + 'CEP: ' + ZQComandos.FieldByName('CEP').AsString
        + #13 + 'Endereço: ' + ZQComandos.FieldByName('LOGRADOURO').AsString
                + ' ' + ZQComandos.FieldByName('ENDERECO').AsString
                + ' ' + ZQComandos.FieldByName('COMPLEMENTO').AsString
        + #13 + 'Nro: ' +  ZQComandos.FieldByName('NRO').AsString
        + #13 + 'Bairro: ' + ZQComandos.FieldByName('BAIRRO').AsString
        + #13 + 'Cidade: ' + ZQComandos.FieldByName('NOME_CIDADE').AsString
        + #13 + 'Estado: ' + ZQComandos.FieldByName('UF_CIDADE').AsString + #13;

        IndicePaciente := 0;
        vpacientes     := '';
        ZQComandos.First;
        while not(ZQComandos.eof)
        do begin

           if ZQComandos.FieldByName('FLAG_CIR_ESP').AsString = 'S'
           then begin
           vflag := 'Sim';
           vcomplemento := #13 + 'Se sim, quando foi a última?' + #13 + ZQComandos.FieldByName('ULT_CIR_ESP').AsString + #13;
           end
           else begin
           vflag := 'Não';
           vcomplemento := #13 + '';
           end;


           Inc(IndicePaciente);
           vpacientes := vpacientes +
            #13 + '*Paciente ' + IndicePaciente.ToString() + '*: ' + ZQComandos.FieldByName('NOME').AsString
          + #13 + 'Data de Nascimento: ' + ZQComandos.FieldByName('NASCIMENTO').AsString
          + #13 + 'Idade: ' + ZQComandos.FieldByName('IDADE').AsString + #13
          + #13 + '_Problema_: ' + #13 + ZQComandos.FieldByName('PROBLEMA').AsString + #13
          + #13 + 'Quando foi o último tratamento espiritual com Dr. Hansen?' + #13 + ZQComandos.FieldByName('ULT_TRAT_ESP').AsString + #13
          + #13 + 'Já fez cirurgia espiritual com Dr. Hansen?' + #13 + vflag + #13
          + vcomplemento;


           ZQComandos.next;
           end;



      end;

   vtemptexto := vcabecalho + vpacientes;




    FrmBaseTexto := TFrmBaseTexto.Create(self);
    FrmBaseTexto.TextoExibido := vtemptexto;
    FrmBaseTexto.ShowModal;


  finally
    FreeAndNil(FrmBaseTexto);
  end;
end;

initialization
RegisterClass(TFrmCadEvento);

finalization
UnRegisterClass(TFrmCadEvento);

end.

