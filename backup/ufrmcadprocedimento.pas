unit uFrmCadProcedimento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, DBGrids, ActnList, DBExtCtrls, EditBtn, Spin,
  uFrmBaseCadastro, ACBrEnterTab, ZDataset, db, BufDataset, DateUtils, Grids;

type

  { TFrmCadProcedimento }

  TFrmCadProcedimento = class(TFrmBaseCadastro)
    BDDataProcDATA_PROCEDIMENTO: TDateTimeField;
    BDDataProcDESCRICAO_DIA: TStringField;
    BDDataProcID_DIAS_PROCEDIMENTO: TLongintField;
    BDDataProcTIPO_DIA: TStringField;
    BDReceitaNOME_REMEDIO: TStringField;
    BDReceitaPOSOLOGIA: TStringField;
    BDReceitaREMEDIO: TLongintField;
    BtnPesqPaciente: TSpeedButton;
    BtnPesqRemedio: TSpeedButton;
    BDReceita: TBufDataset;
    BDDataProc: TBufDataset;
    DateEditDataInicial: TDateEdit;
    DBEditQtdDias: TDBEdit;
    DBEditPosologia: TDBEdit;
    DBEditCodPaciente: TDBEdit;
    DBEditCodigoProcedimento: TDBEdit;
    DBEditCodRemedio: TDBEdit;
    DBEditNomePaciente: TDBEdit;
    DBEditNomeRemedio: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigatorReceita: TDBNavigator;
    DBRadioGroupTipoProcedimento: TDBRadioGroup;
    DSDataProc: TDataSource;
    DSReceita: TDataSource;
    Image1: TImage;
    Image2: TImage;
    LabelCodigo: TLabel;
    LabelCodigo1: TLabel;
    LabelDataInicial: TLabel;
    LabelRemedio: TLabel;
    LabelQtdDias: TLabel;
    LabelPaciente: TLabel;
    PageControlnfoProc: TPageControl;
    PanelControle1: TPanel;
    NovaReceita: TSpeedButton;
    GravarReceita: TSpeedButton;
    ExcluirReceita: TSpeedButton;
    CancelarReceita: TSpeedButton;
    SpeedButtonInstrucoes: TSpeedButton;
    TabSheetDatasProc: TTabSheet;
    TabSheetReceita: TTabSheet;
    ZQDataProc: TZQuery;
    ZQDataProcDATA_PROCEDIMENTO: TDateField;
    ZQDataProcDESCRICAO_DIA: TStringField;
    ZQDataProcID_DIAS_PROCEDIMENTO: TLongintField;
    ZQDataProcTIPO_DIA: TStringField;
    ZQReceita: TZQuery;
    ZQObjetosID_PROCEDIMENTO: TLongintField;
    ZQObjetosNOME_PACIENTE: TStringField;
    ZQObjetosNOME_PROCEDIMENTO: TStringField;
    ZQObjetosPACIENTE: TLongintField;
    ZQObjetosQTD_DIAS: TSmallintField;
    ZQObjetosSELECIONADO: TStringField;
    ZQObjetosTIPO_PROCEDIMENTO: TStringField;
    ZQReceitaNOME_REMEDIO: TStringField;
    ZQReceitaPOSOLOGIA: TSmallintField;
    ZQReceitaREMEDIO: TLongintField;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure BtnPesqPacienteClick(Sender: TObject);
    procedure BtnPesqRemedioClick(Sender: TObject);
    procedure DateEditDataInicialEditingDone(Sender: TObject);
    procedure DBEditCodPacienteExit(Sender: TObject);
    procedure DBEditCodRemedioExit(Sender: TObject);
    procedure DBGridCadCellClick(Column: TColumn);
    procedure DBGridCadDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure DBRadioGroupTipoProcedimentoChange(Sender: TObject);
    procedure DSDataProcDataChange(Sender: TObject; Field: TField);
    procedure DSDataProcStateChange(Sender: TObject);
    procedure DSReceitaStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure CarregarProcedimento;
    procedure CarregarDiasProcedimento(pProcedimento:integer);
    procedure CarregarReceita(pProcedimento:integer);
    procedure FormShow(Sender: TObject);
    procedure GravarReceitaClick(Sender: TObject);
    procedure NovaReceitaClick(Sender: TObject);
    procedure ExcluirReceitaClick(Sender: TObject);
    procedure CancelarReceitaClick(Sender: TObject);
    procedure spbGerarDiasClick(Sender: TObject);
    procedure SpeedButtonInstrucoesClick(Sender: TObject);
    procedure ZQObjetosAfterScroll(DataSet: TDataSet);
    function SetarProximaSegunda(pData:TDate):TDate;
    function Gravar_Receita(pProcedimento:integer):boolean;
    function Excluir_Receitas(pProcedimento:integer):boolean;
    procedure Config_Controles_Remedio();
    procedure ZQReceitaAfterScroll(DataSet: TDataSet);
    function Gravar_Datas_Proc(pProcedimento:integer):boolean;
    function Excluir_datas_Proc(pProcedimento:integer):boolean;
    procedure ResetarBufDataSet(pBufDataSet:TBufDataSet);
    procedure Distribuir_Dias_Proc(pDataInicial:TDateTime; pTipoProc:string; pQtdDias:Smallint);

  private
    type
    TLastDataProc = record
       DataProcedimento : TDateTime;
       TipoDia          : String;
       DescricaoDia     : String;
    end;


  public
      LastDataProc : TLastDataProc;

  end;

var
  FrmCadProcedimento: TFrmCadProcedimento;

implementation

uses
  udm, uFrmFiltro, uFrmRelatoInstrTrat;

{$R *.lfm}

{ TFrmCadProcedimento }

procedure TFrmCadProcedimento.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmCadProcedimento := nil;
end;

procedure TFrmCadProcedimento.DBEditCodPacienteExit(Sender: TObject);
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

procedure TFrmCadProcedimento.DBEditCodRemedioExit(Sender: TObject);
begin
  if not (BDReceita.state in [DSEDIT, DSINSERT])
  then Exit;

  if BDReceita.FieldByName('REMEDIO').AsString = ''
  then Exit;


  with ZQComandos do
  begin
    close;
    sql.Clear;
    sql.add('SELECT							');
    sql.add('REM.id_remedio,                ');
    sql.add('REM.nome_remedio               ');
    sql.add('FROM TREMEDIO REM              ');
    sql.add('WHERE                          ');
    sql.add('REM.id_remedio = :ID_REMEDIO   ');
    ParamByName('ID_REMEDIO').AsString := BDReceita.FieldByName('REMEDIO').AsString;
    open;
    last;
    first;

    if (RecordCount = 0)
    then begin
          MessageDlg('Remédio inválido!', mtWarning, [mbOk], 0);
          DBEditCodRemedio.setfocus;
          abort;
          end
    else begin

      if not (BDReceita.State in [DSEDIT, DSINSERT]) then
        BDReceita.Edit;

      BDReceita.FieldByName('NOME_REMEDIO').AsString := FIELDBYNAME('NOME_REMEDIO').AsString;


          end;

  end;
end;

procedure TFrmCadProcedimento.DBGridCadCellClick(Column: TColumn);
begin
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

procedure TFrmCadProcedimento.DBGridCadDrawColumnCell(Sender: TObject;
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

procedure TFrmCadProcedimento.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin

  if Button = nbInsert
  then begin

        if not(ZQObjetos.State in [dsInsert, dsEdit])
        then ZQObjetos.Edit;

        ZQObjetos.FieldByName('QTD_DIAS').AsInteger := ZQObjetos.FieldByName('QTD_DIAS').AsInteger + 1;

        if   not BDDataProc.Active
        then BDDataProc.Open;

        BDDataProc.Append;

        if BDDataProc.RecordCount = 0
        then begin
             LastDataProc.DataProcedimento := SetarProximaSegunda(DateEditDataInicial.Date);
             BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
             BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
             BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
             BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
             end
        else begin
             LastDataProc.DataProcedimento := SetarProximaSegunda(LastDataProc.DataProcedimento);
             BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
             BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
             BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
             BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
             end;

         BDDataProc.Post;

        end;



  if Button = nbDelete
  then begin

        {if BDDataProc.FieldByName('TIPO_DIA').AsString <> 'TE'
        then begin
             MessageDlg('Atenção', 'Você não pode excluir dias que não são Tratamentos Espirituais, para redefinir as datas estipule uma nova Data Inicial!', mtWarning, [mbOK],0 );
             DBEditNomeRemedio.SetFocus;
             abort;
             end;}

        if not(ZQObjetos.State in [dsInsert, dsEdit])
        then ZQObjetos.Edit;

       if ZQObjetos.FieldByName('QTD_DIAS').AsInteger > 0 then
       ZQObjetos.FieldByName('QTD_DIAS').AsInteger := ZQObjetos.FieldByName('QTD_DIAS').AsInteger - 1;



        end;





end;

procedure TFrmCadProcedimento.DBRadioGroupTipoProcedimentoChange(Sender: TObject
  );
begin

   if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       exit;

    if DBRadioGroupTipoProcedimento.ItemIndex = 0
    then Distribuir_Dias_Proc(DateEditDataInicial.Date, 'T', 4)
    else Distribuir_Dias_Proc(DateEditDataInicial.Date, 'C', 4);

end;
procedure TFrmCadProcedimento.DSDataProcDataChange(Sender: TObject;
  Field: TField);
begin

end;

procedure TFrmCadProcedimento.DSDataProcStateChange(Sender: TObject);
begin
  if BDDataProc.State in [dsInsert, dsEdit] then
      if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Edit;

end;
procedure TFrmCadProcedimento.DSReceitaStateChange(Sender: TObject);
begin
  Config_Controles_Remedio();
end;

procedure TFrmCadProcedimento.BtnPesqPacienteClick(Sender: TObject);
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

procedure TFrmCadProcedimento.BtnPesqRemedioClick(Sender: TObject);
begin
   try
     if not (BDReceita.State in [dsInsert, dsEdit]) then
       BDReceita.Edit;

    FrmFiltro := TFrmFiltro.Create(self);
    VTabela := 'TREMEDIO';
    FrmFiltro.ShowModal;

    if FrmFiltro.BitBtnSelecionar.ModalResult = mrok then
    begin
      BDReceita.FieldByName('REMEDIO').AsString          := FrmFiltro.ZQObjetos.FIELDBYNAME('ID_REMEDIO').AsString;
      BDReceita.FieldByName('NOME_REMEDIO').AsString     := FrmFiltro.ZQObjetos.FIELDBYNAME('NOME_REMEDIO').AsString;
    end;

  finally
    FreeAndNil(FrmFiltro);
  end;
end;
procedure TFrmCadProcedimento.DateEditDataInicialEditingDone(Sender: TObject);
begin
   if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Edit;

  if   DBRadioGroupTipoProcedimento.ItemIndex = 0
  then Distribuir_Dias_Proc(DateEditDataInicial.Date, 'T', 4)
  else Distribuir_Dias_Proc(DateEditDataInicial.Date, 'C', 4);
end;

procedure TFrmCadProcedimento.ActionNovoExecute(Sender: TObject);
begin
  inherited;
  DBEditCodigoProcedimento.SetFocus;

  DateEditDataInicial.Date := now;
  LastDataProc.DataProcedimento:= NOW;

end;



procedure TFrmCadProcedimento.ActionGravarExecute(Sender: TObject);
var
  VCodigo: integer;
begin
  inherited;
  DBEditCodigoProcedimento.SetFocus;

  //NOME_REMEDIO
  if ZQObjetos.FieldByName('PACIENTE').AsString = '' then
  BEGIN
    MessageDlg('Atenção', 'Digite um paciente válido!', mtWarning, [mbOK],0 );
    DBEditNomeRemedio.SetFocus;
    abort;
  END;


  try
    try
      if ZQObjetos.State in [DSINSERT, DSEDIT] then
      begin


        VCodigo := 0;
        if ZQObjetos.State IN [DSEDIT] then
          VCodigo := ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger // ZQObjetosCODIGO.AsString
        ELSE
          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TPROCEDIMENTO_ID'));

        dm.IniciaTransacao();

        with ZQComandos do
        begin
          CLOSE;
          SQL.Clear;
          sql.add('UPDATE OR INSERT INTO TPROCEDIMENTO  							');
          sql.add('(ID_PROCEDIMENTO, PACIENTE, TIPO_PROCEDIMENTO, QTD_DIAS)');
          sql.add('VALUES                                                                                     ');
          sql.add('(:ID_PROCEDIMENTO, :PACIENTE, :TIPO_PROCEDIMENTO, :QTD_DIAS)');
          sql.add('MATCHING (ID_PROCEDIMENTO)                                                                     ');
          ParamByName('ID_PROCEDIMENTO').AsInteger   := VCodigo;
          ParamByName('PACIENTE').AsInteger          := ZQObjetos.FieldByName('PACIENTE').AsInteger;
          ParamByName('TIPO_PROCEDIMENTO').AsString  := ZQObjetos.FieldByName('TIPO_PROCEDIMENTO').AsString;
          ParamByName('QTD_DIAS').AsInteger          := ZQObjetos.FieldByName('QTD_DIAS').AsInteger;;

          ExecSQL;
          DM.ConfirmaTransacao;
        end;

          ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger := VCodigo;

        if   ZQObjetos.State IN [dsInsert]
        then begin
             Gravar_Datas_Proc(VCodigo);

             Gravar_Receita(VCodigo);

             end
        ELSE begin

            IF ZQDataProc.RecordCount > 0
            THEN Excluir_datas_Proc(VCodigo);
            Gravar_Datas_Proc(VCodigo);

            IF ZQReceita.RecordCount > 0
            THEN Excluir_Receitas(VCodigo);
            Gravar_Receita(VCodigo);

             end;

          if ZQObjetos.State in [DSINSERT] then
            MessageDlg( 'Informação', 'Cadastro realizado com sucesso!', mtConfirmation, [mbOK],0 )
          else
            MessageDlg( 'Informação', 'Alteração realizada com sucesso!', mtConfirmation, [mbOK],0 );


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
  CarregarProcedimento();

end;

procedure TFrmCadProcedimento.ActionExcluirExecute(Sender: TObject);
begin
  inherited;
    try
    if MessageDlg('Atenção', 'Deseja Realmente Excluir?', mtWarning,  [mbYes, mbNo],0) = mrYes then
    begin

      Excluir_Receitas(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);

      Excluir_datas_Proc(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);

      DM.IniciaTransacao;
      with ZQComandos do
      begin
        CLOSE;
        SQL.Clear;
        SQL.Add('delete from TPROCEDIMENTO where (ID_PROCEDIMENTO = :ID_PROCEDIMENTO)');
        ParamByName('ID_PROCEDIMENTO').AsInteger := ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger;
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
  CarregarProcedimento();
end;

procedure TFrmCadProcedimento.ActionCancelarExecute(Sender: TObject);
begin
  inherited;
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadProcedimento.CarregarProcedimento;
begin
    with ZQObjetos do
  begin
    close;
    sql.Clear;
    sql.add('select                                                     ');
    sql.add(''' '' as SELECIONADO,                                      ');
    sql.add('PROC.id_procedimento,                                      ');
    sql.add('PROC.paciente,                                             ');
    sql.add('PAC.nome AS NOME_PACIENTE,                                 ');
    sql.add('PROC.tipo_procedimento,                                    ');
    sql.add('CASE PROC.tipo_procedimento                                ');
    sql.add('WHEN ''C'' then ''Cirurgia''                               ');
    sql.add('WHEN ''T'' then ''Tratamento''                             ');
    sql.add('end as NOME_PROCEDIMENTO,                                  ');
    sql.add('proc.qtd_dias                                              ');
    sql.add('FROM TPROCEDIMENTO PROC                                    ');
    sql.add('INNER JOIN TPACIENTE PAC ON PROC.paciente = PAC.id_paciente');
    open;
    last;
    first;
  end;

  ValorTotalRegistros := ZQObjetos.RecordCount;
  StatusBarCad.Panels[0].Text := 'Total de Registros: ' + IntToStr(ValorTotalRegistros);
  PageControlCad.ActivePage := TabConsulta;
end;

procedure TFrmCadProcedimento.CarregarDiasProcedimento(pProcedimento:integer);
begin
   with ZQDataProc do
  begin
    close;
    sql.Clear;
    sql.add('select					   ');
    sql.add('DPROC.id_dias_procedimento,                   ');
    sql.add('DPROC.data_procedimento,                   ');
    sql.add('DPROC.tipo_dia,                            ');
    sql.add('CASE DPROC.tipo_dia                        ');
    sql.add('WHEN ''TE'' then ''Tratamento Espiritual'' ');
    sql.add('WHEN ''CE'' then ''Cirurgia Espiritual''   ');
    sql.add('WHEN ''RA'' then ''Repouso Absoluto''      ');
    sql.add('WHEN ''RR'' then ''Repouso Relativo''      ');
    sql.add('WHEN ''RP'' then ''Retirada dos Pontos''   ');
    sql.add('end as DESCRICAO_DIA                       ');
    sql.add('from tdias_procedimento DPROC              ');
    sql.add('WHERE                                      ');
    sql.add('DPROC.procedimento = :ID_PROCEDIMENTO      ');
    ParamByName('ID_PROCEDIMENTO').AsInteger := pProcedimento;
    open;
    last;
    first;
  end;
   BDDataProc.CopyFromDataset(ZQDataProc, true);

   BDDataProc.Last;
   LastDataProc.DataProcedimento := BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime;
   BDDataProc.First;
   DateEditDataInicial.Date      := BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime;
end;

procedure TFrmCadProcedimento.CarregarReceita(pProcedimento:integer);
begin
  with ZQReceita do
  begin
    close;
    sql.Clear;
    sql.add('SELECT													');
    sql.add('REC.remedio,                                           ');
    sql.add('REM.nome_remedio,                                      ');
    sql.add('REC.posologia                                          ');
    sql.add('FROM TRECEITA REC                                      ');
    sql.add('INNER JOIN TREMEDIO REM ON REC.remedio = REM.id_remedio');
    sql.add('WHERE                                                  ');
    sql.add('REC.procedimento = :ID_PROCEDIMENTO                    ');
    ParamByName('ID_PROCEDIMENTO').AsInteger := pProcedimento;
    open;
    last;
    first;
  end;

 BDReceita.CopyFromDataset(ZQReceita, true);

end;

procedure TFrmCadProcedimento.FormShow(Sender: TObject);
begin
  inherited;
  BDReceita.CreateDataset;
  BDDataProc.CreateDataset;

  DateEditDataInicial.Date := now;

  CarregarProcedimento;
  CarregarDiasProcedimento(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);
  CarregarReceita(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);


end;

procedure TFrmCadProcedimento.GravarReceitaClick(Sender: TObject);
begin
  inherited;
    if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Edit;

    if not BDReceita.Active then
    BDReceita.Open;

    BDReceita.Post;

end;

procedure TFrmCadProcedimento.NovaReceitaClick(Sender: TObject);
begin

  if not (ZQObjetos.State in [dsInsert, dsEdit]) then
     ZQObjetos.Edit;

  if not BDReceita.Active then
    BDReceita.Open;

  BDReceita.Append;

  DBEditCodRemedio.SetFocus;
end;

procedure TFrmCadProcedimento.ExcluirReceitaClick(Sender: TObject);
begin

 if not (ZQObjetos.State in [dsInsert, dsEdit]) then
    ZQObjetos.Edit;

  if BDReceita.RecordCount = 0 then
  begin
    MessageDlg('Não há registros para excluir!', mtWarning, [mbOk], 0 );
    abort;
  end;

  BDReceita.Delete;

end;

procedure TFrmCadProcedimento.CancelarReceitaClick(Sender: TObject);
begin
  if (MessageDlg('Deseja Cancelar a operação?', mtconfirmation, [mbYes, mbNo],0 ) = mrYes)
  then begin
    ZQReceita.Cancel;
    if not (ZQObjetos.State in [dsInsert, dsEdit]) then
       ZQObjetos.Cancel;
  end;


end;

procedure TFrmCadProcedimento.spbGerarDiasClick(Sender: TObject);
var
  i:integer;
begin
  if   StrToInt(DBEditQtdDias.text) >= BDDataProc.RecordCount
  then begin

        if not(ZQObjetos.State in [dsInsert, dsEdit])
        then ZQObjetos.Edit;

        if BDDataProc.RecordCount > 0
        then  BDDataProc.clear;

        if   not BDDataProc.Active
        then BDDataProc.Open;


        for i := 0 to StrToInt(DBEditQtdDias.text)
        do begin
           BDDataProc.Append;

           if BDDataProc.RecordCount = 0
           then begin
                LastDataProc.DataProcedimento := SetarProximaSegunda(DateEditDataInicial.Date);
                BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
                BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                end
           else begin
                LastDataProc.DataProcedimento := SetarProximaSegunda(LastDataProc.DataProcedimento);
                BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
                BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                end;

                 BDDataProc.Post;

           end;



       end
  else begin
       if not(ZQObjetos.State in [dsInsert, dsEdit])
        then ZQObjetos.Edit;

       //if not (BDDataProc.State in [dsInsert, dsEdit])
       //then BDDataProc.Edit;

       BDDataProc.Delete;

       end;
end;

procedure TFrmCadProcedimento.SpeedButtonInstrucoesClick(Sender: TObject);
begin
  //if PageControlCad.ActivePage = TabCadastro
  //then begin
        if not Assigned(FrmRelatoInstrTrat) then
           begin
             FrmRelatoInstrTrat := TFrmRelatoInstrTrat.Create(self);
             FrmRelatoInstrTrat.Filtro   := ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsString;
             FrmRelatoInstrTrat.TipoProc := ZQObjetos.FieldByName('tipo_procedimento').AsString;
             FrmRelatoInstrTrat.Gerar_Relatorio(2);
           end
             else
           begin
             FrmRelatoInstrTrat.Filtro := ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsString;
             FrmRelatoInstrTrat.TipoProc := ZQObjetos.FieldByName('tipo_procedimento').AsString;
             FrmRelatoInstrTrat.Gerar_Relatorio(2);

           end;



       //end;
end;

procedure TFrmCadProcedimento.ZQObjetosAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if PageControlnfoProc.ActivePage = TabSheetDatasProc then
  begin
    CarregarDiasProcedimento(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);
  end
  else if PageControlnfoProc.ActivePage = TabSheetReceita then
  begin
    CarregarReceita(ZQObjetos.FieldByName('ID_PROCEDIMENTO').AsInteger);
  end
end;

function TFrmCadProcedimento.SetarProximaSegunda(pData: TDate): TDate;
var
  respDate:TDate;
  i, DiaSemana :smallint;
begin

  respDate := pData;

  for i := 0 to 7
  do begin
    respDate := IncDay(respDate, 1);
    DiaSemana := DayOfWeek(respDate);
    if DiaSemana = 2
    then begin
        break;
        end;
  end;

  result := respdate;



end;
function TFrmCadProcedimento.Gravar_Receita(pProcedimento: integer): boolean;
begin
  inherited;
    //DBEditCodRemedio.SetFocus;

    //NOME_REMEDIO
    {if ZQReceita.FieldByName('NOME_REMEDIO').AsString = '' then
    BEGIN
      MessageDlg('Atenção', 'Preencha o nome do Remeédio!', mtWarning, [mbOK],0 );
      DBEditNomeRemedio.SetFocus;
      abort;
    END;}

      try

          BDReceita.First;

          while not(BDReceita.EOF)
          do begin
            dm.IniciaTransacao();

          with ZQComandos do
          begin
            CLOSE;
            SQL.Clear;
            sql.add('UPDATE OR INSERT INTO TRECEITA 															');
            sql.add('(PROCEDIMENTO, REMEDIO, POSOLOGIA)');
            sql.add('VALUES                                                                                     ');
            sql.add('(:PROCEDIMENTO, :REMEDIO, :POSOLOGIA)');
            sql.add('MATCHING (PROCEDIMENTO, REMEDIO)                                                            ');
            ParamByName('PROCEDIMENTO').AsInteger   := pProcedimento;
            ParamByName('REMEDIO').AsString         := BDReceita.FieldByName('REMEDIO').AsString;
            ParamByName('POSOLOGIA').AsString       := BDReceita.FieldByName('POSOLOGIA').AsString;
            ExecSQL;
          end;

          DM.ConfirmaTransacao;

            BDReceita.Next;
          end;

      except
        on e: Exception do
        begin
          DM.CancelaTransacao;
          MessageDlg('Erro', PCHAR('Ocorreu um erro!' + e.Message), mtError, [mbOK],0 );
          abort;
        end;
      end;

    CarregarReceita(pProcedimento);
end;

function TFrmCadProcedimento.Excluir_Receitas(pProcedimento:integer): boolean;
begin

   try
      DM.IniciaTransacao;

      While not(ZQReceita.eof)
      do begin
         with ZQComandos do
         begin
           CLOSE;
           SQL.Clear;
           SQL.Add('delete from TRECEITA where (PROCEDIMENTO = :ID_PROCEDIMENTO AND REMEDIO = :ID_REMEDIO)');
           ParamByName('ID_PROCEDIMENTO').AsInteger := pProcedimento;
           ParamByName('ID_REMEDIO').AsInteger := ZQReceita.FieldByName('REMEDIO').AsInteger;
           ExecSQL;
         end;

       ZQReceita.Next;
       end;

      DM.ConfirmaTransacao

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


end;

procedure TFrmCadProcedimento.Config_Controles_Remedio();
begin
  DBNavigatorReceita.Enabled := (BDReceita.State in [dsBrowse]);
  NovaReceita.Enabled := (BDReceita.State in [dsBrowse, dsInactive]);
  GravarReceita.Enabled := (BDReceita.State in [DSINSERT, DSEDIT]);
  CancelarReceita.Enabled := (BDReceita.State in [DSINSERT, DSEDIT]);
  ExcluirReceita.Enabled := (BDReceita.State in [dsBrowse]);
end;

procedure TFrmCadProcedimento.ZQReceitaAfterScroll(DataSet: TDataSet);
begin
  Config_Controles_Remedio();
end;

function TFrmCadProcedimento.Gravar_Datas_Proc(pProcedimento: integer): boolean;
VAR
  VCodigo:integer;
begin
 inherited;
      try

          BDDataProc.First;

          while not(BDDataProc.EOF)
          do begin
            dm.IniciaTransacao();


          VCODIGO := StrToInt(dm.ObtemSequencia('GEN_TDIAS_PROCEDIMENTO_ID'));

          with ZQComandos do
          begin
            CLOSE;
            SQL.Clear;
            sql.add('UPDATE OR INSERT INTO TDIAS_PROCEDIMENTO 															');
            sql.add('(ID_DIAS_PROCEDIMENTO, PROCEDIMENTO, DATA_PROCEDIMENTO, TIPO_DIA)');
            sql.add('VALUES                                                                                     ');
            sql.add('(:ID_DIAS_PROCEDIMENTO, :PROCEDIMENTO, :DATA_PROCEDIMENTO, :TIPO_DIA)');
            sql.add('MATCHING (ID_DIAS_PROCEDIMENTO)                                                            ');
            ParamByName('PROCEDIMENTO').AsInteger         := pProcedimento;
            ParamByName('ID_DIAS_PROCEDIMENTO').AsInteger := VCodigo;
            ParamByName('DATA_PROCEDIMENTO').AsDateTime   := BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime;
            ParamByName('TIPO_DIA').AsString              := BDDataProc.FieldByName('TIPO_DIA').AsString;
            ExecSQL;
          end;

          DM.ConfirmaTransacao;

            BDDataProc.Next;
          end;

      except
        on e: Exception do
        begin
          DM.CancelaTransacao;
          MessageDlg('Erro', PCHAR('Ocorreu um erro!' + e.Message), mtError, [mbOK],0 );
          abort;
        end;
      end;

    CarregarDiasProcedimento(pProcedimento);
end;

function TFrmCadProcedimento.Excluir_datas_Proc(pProcedimento: integer
  ): boolean;
begin
   try
      DM.IniciaTransacao;

      While not(ZQDataProc.eof)
      do begin
         with ZQComandos do
         begin
           CLOSE;
           SQL.Clear;
           SQL.Add('delete from TDIAS_PROCEDIMENTO where (PROCEDIMENTO = :ID_PROCEDIMENTO AND ID_DIAS_PROCEDIMENTO = :ID_DIAS_PROCEDIMENTO)');
           ParamByName('ID_PROCEDIMENTO').AsInteger := pProcedimento;
           ParamByName('ID_DIAS_PROCEDIMENTO').AsInteger := ZQDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger;
           ExecSQL;
         end;

       ZQDataProc.Next;
       end;

      DM.ConfirmaTransacao

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
end;

procedure TFrmCadProcedimento.ResetarBufDataSet(pBufDataSet: TBufDataSet);
var
 OldFieldDefs : TFielddefs;
begin
   OldFieldDefs := TFielddefs.Create(nil);
   OldFieldDefs.Assign(pBufDataSet.FieldDefs);
   pBufDataSet.Clear;
   pBufDataSet.Close;
   pBufDataSet.FieldDefs.Assign(OldFieldDefs);
   pBufDataSet.CreateDataset;
   pBufDataSet.Open;
   OldFieldDefs.Free;
end;

procedure TFrmCadProcedimento.Distribuir_Dias_Proc(pDataInicial: TDateTime;
  pTipoProc: string; pQtdDias: Smallint);
var
 i:integer;
begin

  if pTipoProc = 'T'
  then begin
       ResetarBufDataSet(BDDataProc);

             for i := 0 to pQtdDias
             do begin

                   ZQObjetos.FieldByName('QTD_DIAS').AsInteger := pQtdDias;

                   if   not BDDataProc.Active
                   then BDDataProc.Open;

                   BDDataProc.Append;

                  if BDDataProc.RecordCount = 0
                  then begin
                       LastDataProc.DataProcedimento := SetarProximaSegunda(pDataInicial);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                       end
                  else begin
                       LastDataProc.DataProcedimento := SetarProximaSegunda(LastDataProc.DataProcedimento);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                       end;

                   BDDataProc.Post;

                  end;
       end;

  if pTipoProc = 'C'
  then begin
        ResetarBufDataSet(BDDataProc);


                if   not BDDataProc.Active
                then BDDataProc.Open;

                BDDataProc.Append;

                  if BDDataProc.RecordCount = 0
                  then begin
                       LastDataProc.DataProcedimento := SetarProximaSegunda(pDataInicial);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'CE';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Cirurgia Espiritual';
                       end;

                    for i := 0 to 2
                    do begin
                       BDDataProc.Append;
                       LastDataProc.DataProcedimento := IncDay(LastDataProc.DataProcedimento, 1);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'RA';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Repouso Absoluto';
                       end;

                    for i := 0 to 2
                    do begin
                       BDDataProc.Append;
                       LastDataProc.DataProcedimento := IncDay(LastDataProc.DataProcedimento, 1);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'RR';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Repouso Relativo';
                       end;

                    BDDataProc.Append;
                    LastDataProc.DataProcedimento := SetarProximaSegunda(SetarProximaSegunda(pDataInicial));
                    BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                    BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
                    BDDataProc.FieldByName('TIPO_DIA').AsString            := 'RP';
                    BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Retirada dos Pontos';


                     for i := 0 to pQtdDias
             do begin

                   if   not BDDataProc.Active
                   then BDDataProc.Open;

                   BDDataProc.Append;

                  if BDDataProc.RecordCount = 0
                  then begin
                       LastDataProc.DataProcedimento := SetarProximaSegunda(pDataInicial);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime := LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                       end
                  else begin
                       LastDataProc.DataProcedimento := SetarProximaSegunda(LastDataProc.DataProcedimento);
                       BDDataProc.FieldByName('ID_DIAS_PROCEDIMENTO').AsInteger := 0;
                       BDDataProc.FieldByName('DATA_PROCEDIMENTO').AsDateTime:= LastDataProc.DataProcedimento;
                       BDDataProc.FieldByName('TIPO_DIA').AsString            := 'TE';
                       BDDataProc.FieldByName('DESCRICAO_DIA').AsString       := 'Tratamento Espiritual';
                       end;

                   BDDataProc.Post;

                  end;

                  ZQObjetos.FieldByName('QTD_DIAS').AsInteger := BDDataProc.RecordCount;
       end;

end;

initialization
RegisterClass(TFrmCadProcedimento);

finalization
UnRegisterClass(TFrmCadProcedimento);

end.

