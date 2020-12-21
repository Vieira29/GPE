unit uFrmBaseCadastro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBGrids, Buttons, DBCtrls, ActnList, ufrmBaseForm, LResources,
  ZDataset, ZSqlUpdate, ZAbstractRODataset, db, BufDataset, sqldb, dbf, memds, FileUtil, Udm,
  uValidacaoGeral, LCLType, Grids, ACBrEnterTab;

type

  { TFrmBaseCadastro }

  TFrmBaseCadastro = class(TFrmBaseForm)
    ACBrEnterTab1: TACBrEnterTab;
    ActionNovo: TAction;
    ActionGravar: TAction;
    ActionExcluir: TAction;
    ActionSair: TAction;
    ActionPesquisar: TAction;
    ActionCancelar: TAction;
    ActionList1: TActionList;
    ApplicationProperties1: TApplicationProperties;
    ComboBoxColuna: TComboBox;
    DSObjetos: TDataSource;
    DBGridCad: TDBGrid;
    DBNavigatorCad: TDBNavigator;
    EditPesquisa: TEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    LabelTitulo: TLabel;
    PageControlCad: TPageControl;
    PanelPesquisa: TPanel;
    PanelControle: TPanel;
    PanelHeader: TPanel;
    PanelContent: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StatusBarCad: TStatusBar;
    TabConsulta: TTabSheet;
    TabCadastro: TTabSheet;
    ZQObjetos: TZQuery;
    ZQComandos: TZQuery;
    procedure ActionGravarExecute(Sender: TObject);
    procedure ActionSairExecute(Sender: TObject);
    procedure ComboBoxColunaChange(Sender: TObject);
    procedure ComboBoxColunaClick(Sender: TObject);
    procedure ConfiguraControles;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure ActionExcluirExecute(Sender: TObject);
    procedure ActionNovoExecute(Sender: TObject);
    procedure DBGridCadDblClick(Sender: TObject);
    procedure DBGridCadDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCadDrawColumnTitle(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCadTitleClick(Column: TColumn);
    procedure DSObjetosStateChange(Sender: TObject);
    procedure EditPesquisaChange(Sender: TObject);
    procedure EditPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure PageControlCadChange(Sender: TObject);
    procedure PageControlCadChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TabConsultaShow(Sender: TObject);
    procedure ZQObjetosAfterScroll(DataSet: TDataSet);
    procedure ProcurarCampo(valor:String);
    procedure mudafoco(Sender : TObject);
    procedure mudancafocotela(Sender : TObject);
    procedure EnterEx(Sender : TObject);
    procedure ExitEx(Sender : TObject);
    procedure SetCtrlFocado(Focar: Boolean);
    //procedure LimpezaMemoria;
    procedure ChangeControl(Sender: TObject);
    procedure GridSort(GridName : TDBGrid; Column: TColumn; QueryName : TZQUERY);
  protected
    PegaPosicao: Boolean;
  private

  public
    idxColunaProcura: Integer;
    NomeCampoTotalizar: string;
    ValorTotalRegistros:integer;
    ValorSelecionadosRegistros:integer;

  end;

var
  FrmBaseCadastro: TFrmBaseCadastro;
  ValidaGeral : ValidacaoGeral;
  FCorFocado: TColor = $00FCC294;
  _FAlterado: Boolean = false;
  _FCorAntiga: TColor;
  _FControleAtivo: TWinControl = nil;


implementation

{$R *.lfm}

{ TFrmBaseCadastro }

procedure TFrmBaseCadastro.ActionNovoExecute(Sender: TObject);
begin
  PageControlCad.ActivePage := TabCadastro;
  /// ///////////////////////////////////////////////////////////////////////////
  /// CONTROLE DE PERMISSAO DO SISTEMA
  /// ///////////////////////////////////////////////////////////////////////////

  if not ZQObjetos.Active then
    ZQObjetos.Open;

  ZQObjetos.Append;
end;

procedure TFrmBaseCadastro.DBGridCadDblClick(Sender: TObject);
begin
  PageControlCad.ActivePage := TabCadastro;
end;

procedure TFrmBaseCadastro.DBGridCadDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  if ZQObjetos.RecNo mod 2 = 0 then
  begin
    DBGridCad.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    DBGridCad.Canvas.Brush.Color := clBtnFace;
  end;

  TDBGrid(Sender).Canvas.font.Color := clBlack;

  DBGridCad.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  if PegaPosicao then
  begin
    if Column.FieldName = NomeCampoTotalizar then
    begin
      PegaPosicao := false;
    end;
  end;

  if gdSelected in State then
    with (Sender as TDBGrid).Canvas do
    begin
      Brush.Color := clNavy; // aqui é definida a cor do fundo
      DBGridCad.Canvas.font.Color := clWhite;
      DBGridCad.Canvas.font.Style := [];
      DBGridCad.Canvas.FillRect(Rect);
      DBGridCad.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;


end;

procedure TFrmBaseCadastro.DBGridCadDrawColumnTitle(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TFrmBaseCadastro.DBGridCadTitleClick(Column: TColumn);
begin
  GridSort(DBGridCad,Column,ZQObjetos);

  if   PageControlCad.ActivePage = TabConsulta
  then EditPesquisa.SetFocus;
end;

procedure TFrmBaseCadastro.DSObjetosStateChange(Sender: TObject);
begin
  ConfiguraControles;
end;

procedure TFrmBaseCadastro.EditPesquisaChange(Sender: TObject);
begin
  if (DBGridCad.Columns[idxColunaProcura].Field) = nil then
    EXIT;

  try
    with DBGridCad.Columns[idxColunaProcura].Field do
    begin
      if DataType in [ftDate, ftDateTime] then
      begin
        if ValidaGeral.ValidaData(EditPesquisa.Text) then
          ProcurarCampo(EditPesquisa.Text);
      end;

      if DataType in [ftInteger] then
      begin

        if ValidaGeral.ValidaInteiro(EditPesquisa.Text) then
          ProcurarCampo(EditPesquisa.Text);
      end;

      if DataType in [ftFloat] then
      begin
        if ValidaGeral.ValidaDouble(EditPesquisa.Text) then
          ProcurarCampo(EditPesquisa.Text);
      end;

      if DataType in [ftWideString] then
      begin
        if ValidaGeral.ValidaString(EditPesquisa.Text) then
          ProcurarCampo(EditPesquisa.Text);
      end;

      if DataType in [ftString] then
      begin
        if ValidaGeral.ValidaString(EditPesquisa.Text) then
          ProcurarCampo(EditPesquisa.Text);
      end;


    end;

  finally
    if Trim(EditPesquisa.Text) = '' then
      ProcurarCampo(EditPesquisa.Text);

  end;
end;

procedure TFrmBaseCadastro.EditPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ZQObjetos.Active) and (ZQObjetos.State in [dsBrowse]) then
  begin
    if (Key = VK_DOWN) or (Key = VK_RIGHT) then
    begin
      ZQObjetos.Next;
      abort;
    end;

    if (Key = VK_UP) or (Key = VK_LEFT) then
    begin
      ZQObjetos.Prior;
      abort;
    end;
  end;
end;

procedure TFrmBaseCadastro.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
   FreeAndNil(ValidaGeral);
   CloseAction := caFree;
end;

procedure TFrmBaseCadastro.FormCreate(Sender: TObject);
var
  a: array of string;
  i, J: Integer;
begin

  {if DBGridCad.Columns.Count > 0 then
  begin
    for i := 0 to DBGridCad.Columns.Count - 1 do
      if (DBGridCad.Columns[i].Field = nil) then
        ComboBoxColuna.Items.Add('Não definido')
      else
        ComboBoxColuna.Items.Add(DBGridCad.Columns[i].Field.DisplayName);

  end;}

end;

procedure TFrmBaseCadastro.FormKeyPress(Sender: TObject; var Key: char);
var
  i: Integer;
begin


  {If Key = #13 then // Se o comando for igual a enter
    Begin
     selectnext(ActiveControl,true,true); // Para pular de campo em campo
     //SelectNext(ActiveControl as TWinControl,True,True);
     Key := #0;
    End;}

    if Key = chr(27) then
    begin
      if (ZQObjetos.State in [DSEDIT, DSINSERT]) then
      begin
        if (MessageDlg('Você está nomeio de uma Operação, deseja cancelar e sair?', mtconfirmation, [mbYes, mbNo],0) = mrYes) then
        begin
          ZQObjetos.Cancel;
          ActionSair.Execute;
        end;
      end
      else
        ActionSair.Execute;
  end;

  // MUDAFOCO;
end;

procedure TFrmBaseCadastro.FormShow(Sender: TObject);
var
a: array of string;
i, J: Integer;
begin
  ValidaGeral :=  ValidacaoGeral.Create();
  idxColunaProcura:=1;

  if DBGridCad.Columns.Count > 0 then
  begin
    for i := 0 to DBGridCad.Columns.Count - 1 do
      if (DBGridCad.Columns[i].Field = nil) then
        ComboBoxColuna.Items.Add('Não definido')
      else
        ComboBoxColuna.Items.Add(DBGridCad.Columns[i].Field.DisplayName);
end;

end;

procedure TFrmBaseCadastro.PageControlCadChange(Sender: TObject);
begin
  if PageControlCad.ActivePage = TabConsulta then
  begin
    EditPesquisa.SetFocus;
  end;
end;

procedure TFrmBaseCadastro.PageControlCadChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not(ZQObjetos.State in [DSEDIT, DSINSERT]);
end;

procedure TFrmBaseCadastro.TabConsultaShow(Sender: TObject);
begin
  
  if (ZQObjetos.State IN [DSEDIT, DSINSERT]) then
  BEGIN
    ZQObjetos.Cancel;
  end;
end;

procedure TFrmBaseCadastro.ZQObjetosAfterScroll(DataSet: TDataSet);
begin
  ConfiguraControles;
end;

procedure TFrmBaseCadastro.ProcurarCampo(valor: String);
begin
   if ZQObjetos.State in [DSINSERT, DSEDIT] then
    EXIT
  else
  begin
    if EditPesquisa.Text = '' then
      ZQObjetos.First
    else
      ZQObjetos.Locate(ComboBoxColuna.Items[ComboBoxColuna.itemindex],valor,[loPartialKey,loCaseInsensitive]);
  end;
end;
procedure TFrmBaseCadastro.mudafoco(Sender: TObject);
var
  i: Integer;
  edt: TEdit;

  edbt: TDBEdit;
begin
  { : muda a cor dos componentes }
  for i := 0 to componentCount - 1 do
  begin
    { : se for um Edit }
    if (Components[i] is TEdit) then
    begin
      edt := (Components[i] as TEdit);
      if edt.Tag = 0 then
      begin
        if edt.focused then
          (Sender as TEdit).Color := clYellow
        else
          (Sender as TEdit).Color := clWindow;
      end;

    end;
    {
      if (Components[i] is TMemo) then
      begin
      if (Components[i] as TMemo).Focused then
      (Components[i] as TMemo).Color := clYellow
      else

      (Components[i] as TMemo).Color := clWindow
      end;

    }

    { : se for um DBEdit }
    if (Components[i] is TDBEdit) then
    begin
      edbt := (Components[i] as TDBEdit);
      if edbt.Tag = 0 then
      begin

        if edbt.focused then

          edbt.Color := clYellow
        else
          edbt.Color := clWindow;

      end;
    end;
    { : se for um DBMemo }

    { if (Components[i] is TDBMemo) then
      begin
      if (Components[i] as TDBMemo).Focused then

      (Components[i] as TDBMemo).Color := clYellow
      else
      (Components[i] as TDBMemo).Color := clWindow;

      end;
    }
  end;

end;

procedure TFrmBaseCadastro.mudancafocotela(Sender: TObject);
var
  i: Integer;
  Ed: TDBEdit;
  EDIT: TEdit;

begin
  { Percorre a matriz de componentes do form }
  for i := 0 to componentCount - 1 do
    { Se o componente é do tipo TEdit... }
    if Components[i] is TDBEdit then
    begin
      { Faz um type-casting pata o tipo TEdit }
      Ed := Components[i] as TDBEdit;

      { Se o Edit está com o foco... }
      if Ed.focused then
        Ed.Color := clYellow { Amarelo }
      else
        Ed.Color := clWhite; { Branco }

    end;

  if Components[i] IS TEdit then
  BEGIN
    EDIT := Components[i] AS TEdit;

    if (EDIT.focused) then
      EDIT.Color := clYellow
    else
      EDIT.Color := clWhite;

  END;

end;

procedure TFrmBaseCadastro.EnterEx(Sender: TObject);
begin
  { : altera a cor do componente quando receber o foco }
   if (Sender is TEdit) then
      (Sender as TEdit).Color := clYellow;
    if (Sender is TMemo) then
      (Sender as TMemo).Color := clYellow;
    if (Sender is TDBEdit) then
      (Sender as TDBEdit).Color := clYellow;
    if (Sender is TdbMemo) then
      (Sender as TdbMemo).Color := clYellow;

end;

procedure TFrmBaseCadastro.ExitEx(Sender: TObject);
begin
   { : altera a cor do componente quando sair o foco }
  if (Sender is TEdit) then
    (Sender as TEdit).Color := clWindow;
  if (Sender is TMemo) then
    (Sender as TMemo).Color := clWindow;
  { : altera a cor do componente quando sair o foco }
  if (Sender is TDBEdit) then
    (Sender as TDBEdit).Color := clWindow;
  if (Sender is TdbMemo) then
    (Sender as TdbMemo).Color := clWindow;
end;

procedure TFrmBaseCadastro.SetCtrlFocado(Focar: Boolean);
begin
  if (_FControleAtivo <> nil) then
    try
      if (_FControleAtivo is TCustomEdit) or (_FControleAtivo is TCustomComboBox) then
      begin
        if Focar then
        begin
          _FCorAntiga := TEdit(_FControleAtivo).Color;
          _FAlterado := true;
          TEdit(_FControleAtivo).Color := FCorFocado;
        end
        else
        begin
          TEdit(_FControleAtivo).Color := _FCorAntiga;
          _FAlterado := false;
        end;
      end;
    except
      // vai q o individuo já foi destruido!!!
    end;
end;

{procedure TFrmBaseCadastro.LimpezaMemoria;
var
  MainHandle: THandle;
begin
  //
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessId);
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
    CloseHandle(MainHandle);
  except

  end;
  Application.ProcessMessages;

end;}

procedure TFrmBaseCadastro.ChangeControl(Sender: TObject);
begin
   if Application.Terminated then
    EXIT;
end;

procedure TFrmBaseCadastro.ConfiguraControles;
begin
  DBNavigatorCad.Enabled := (ZQObjetos.State in [dsBrowse]) and (PageControlCad.ActivePageIndex in [TabConsulta.TabIndex, TabCadastro.TabIndex]);
  ActionNovo.Enabled := (ZQObjetos.State in [dsBrowse, dsInactive]) and (PageControlCad.ActivePageIndex in [TabConsulta.TabIndex, TabCadastro.TabIndex]);
  ActionGravar.Enabled := (ZQObjetos.State in [DSINSERT, DSEDIT]) and (PageControlCad.ActivePageIndex in [TabConsulta.TabIndex, TabCadastro.TabIndex]);
  ActionCancelar.Enabled := (ZQObjetos.State in [DSINSERT, DSEDIT]) and (PageControlCad.ActivePageIndex in [TabConsulta.TabIndex, TabCadastro.TabIndex]);
  ActionExcluir.Enabled := (ZQObjetos.State in [dsBrowse]) and (PageControlCad.ActivePageIndex in [TabConsulta.TabIndex, TabCadastro.TabIndex]);
  ActionSair.Enabled := true;
end;

procedure TFrmBaseCadastro.ActionSairExecute(Sender: TObject);
begin
   if (ZQObjetos.State IN [DSEDIT, DSINSERT]) then
   BEGIN
    if (MessageDlg('Você está no meio de uma operação, se optar por continuar a operação será cancelada, deseja continuar?',
      mtconfirmation, [mbYes, mbNo],0) = mrYes) then
    begin
      ZQObjetos.Cancel;
    end
    else
      abort;
   END;

  Close;
end;

procedure TFrmBaseCadastro.ComboBoxColunaChange(Sender: TObject);
begin
  idxColunaProcura := ComboBoxColuna.ItemIndex;
end;

procedure TFrmBaseCadastro.ComboBoxColunaClick(Sender: TObject);
begin

end;

procedure TFrmBaseCadastro.ActionGravarExecute(Sender: TObject);
begin

end;

procedure TFrmBaseCadastro.ActionCancelarExecute(Sender: TObject);
begin
  if (MessageDlg('Deseja Cancelar a operação?', mtconfirmation, [mbYes, mbNo],0 ) = mrYes) then
    ZQObjetos.Cancel;
end;

procedure TFrmBaseCadastro.ActionExcluirExecute(Sender: TObject);
begin
  
  if ZQObjetos.RecordCount = 0 then
  begin
    MessageDlg('Não há registros para excluir!', mtWarning, [mbOk], 0 );
    abort;
  end;
end;

procedure TFrmBaseCadastro.GridSort(GridName : TDBGrid; Column: TColumn; QueryName : TZQUERY);
{$J+}
const PreviousColumnIndex : integer = 0;
const SortOrder : TSortType = stAscending;
{$J-}
begin
  try
    GridName.Columns[PreviousColumnIndex].title.Font.Style:=GridName.Columns[PreviousColumnIndex].title.Font.Style-[fsBold];
    GridName.Columns[PreviousColumnIndex].Title.Caption:=StringReplace(GridName.Columns[PreviousColumnIndex].Title.Caption, '▼', '',[rfReplaceAll, rfIgnoreCase]);
    GridName.Columns[PreviousColumnIndex].Title.Caption:=StringReplace(GridName.Columns[PreviousColumnIndex].Title.Caption, '▲', '',[rfReplaceAll, rfIgnoreCase]);
  except
  end;

  Column.title.Font.Style := Column.title.Font.Style + [fsBold];
  PreviousColumnIndex := Column.Index;



  QueryName.SortedFields:=Column.FieldName;

  GridName.Columns[Column.Index].Title.Caption:=StringReplace(GridName.Columns[Column.Index].Title.Caption, '▼', '',[rfReplaceAll, rfIgnoreCase]);
  GridName.Columns[Column.Index].Title.Caption:=StringReplace(GridName.Columns[Column.Index].Title.Caption, '▲', '',[rfReplaceAll, rfIgnoreCase]);

 if SortOrder = stAscending then
    begin
        SortOrder:=stDescending;
        QueryName.SortType:=stDescending;
        GridName.Columns[Column.Index].Title.Caption:=GridName.Columns[Column.Index].Title.Caption+'▼';
    end
  else
    begin
        SortOrder:=stAscending;
        QueryName.SortType:=stAscending;
        GridName.Columns[Column.Index].Title.Caption:=GridName.Columns[Column.Index].Title.Caption+'▲';
    end;
end;

initialization
RegisterClass(TFrmBaseCadastro);

finalization
UnRegisterClass(TFrmBaseCadastro);

end.

