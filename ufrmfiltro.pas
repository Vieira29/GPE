unit ufrmfiltro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  ComCtrls,
  LCLType, StdCtrls, ZAbstractRODataset, DBCtrls, Buttons, ZDataset,
  uDM, uFrmBaseForm, uValidacaoGeral, Grids;

type

  { TFrmFiltro }

  TFrmFiltro = class(TFrmBaseForm)
    BitBtnCancelar: TBitBtn;
    BitBtnSelecionar: TBitBtn;
    BitBtnCadastrar: TBitBtn;
    chxDecrescente: TCheckBox;
    ComboBoxColuna: TComboBox;
    DBGrid1: TDBGrid;
    DBNavigatorCad: TDBNavigator;
    DSObjetos: TDataSource;
    EditPesquisa: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelGrid: TPanel;
    PanelBottom: TPanel;
    PanelControl: TPanel;
    PanelContent: TPanel;
    StatusBar1: TStatusBar;
    ZQObjetos: TZQuery;
    procedure BitBtnCadastrarClick(Sender: TObject);
    procedure BitBtnCancelarClick(Sender: TObject);
    procedure BitBtnSelecionarClick(Sender: TObject);
    procedure Busca(TipoPesquisa: string);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure EditPesquisaChange(Sender: TObject);
    procedure EditPesquisaExit(Sender: TObject);
    procedure EditPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure ProcurarCampo(valor: string);
    procedure ProcurarCampoLOCATE(valor: string);
    procedure GridSort(GridName : TDBGrid; Column: TColumn; QueryName : TZQUERY);
  private

  public
    idxColunaProcura: Integer;

  end;

var
  FrmFiltro: TFrmFiltro;
    ValidaGeral : ValidacaoGeral;
    VTabela: string;
    Vfiltro: string;
    VarColuna: Integer;
    VarCampo: string; // nome do campo para filtragem
    VarTipoCampo: Integer; // tipo do campo para filtragem
    VarPesquisa: string;
    VarNomeForm: string;

implementation

uses
  uFrmCadCidade;

{$R *.lfm}

{ TFrmFiltro }

procedure TFrmFiltro.Busca(TipoPesquisa: string);
begin
  //VarNomeForm := '';

//  MARCAS
  if TipoPesquisa = 'TMARCAS' then
  begin
    ZQObjetos.Close;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[0].FieldName := 'CODIGO';
    DBGrid1.Columns[0].Title.Caption := 'Código';
    DBGrid1.Columns[0].Width := 80;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[1].FieldName := 'NOMEMARCA';
    DBGrid1.Columns[1].Title.Caption := 'Nome da Marca';
    DBGrid1.Columns[1].Width := 350;

    with ZQObjetos do
    begin
      Close;
      sql.Clear;
      sql.Add('SELECT * FROM TMARCAS A');
      Open;
      Last;
      First;
    end;
    ZQObjetos.Open;
    //VarNomeForm := 'TMARCAS';
  end;

  //  CIDADE
  if TipoPesquisa = 'TCIDADE' then
  begin
    ZQObjetos.Close;
    DBGrid1.Clear;
    DBGrid1.Columns.Clear;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[0].FieldName := 'ID_CIDADE';
    DBGrid1.Columns[0].Title.Caption := 'Código';
    DBGrid1.Columns[0].Width := 80;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[1].FieldName := 'NOME_CIDADE';
    DBGrid1.Columns[1].Title.Caption := 'Nome da Cidade';
    DBGrid1.Columns[1].Width := 350;

   DBGrid1.Columns.Add;
    DBGrid1.Columns[2].FieldName := 'UF_CIDADE';
    DBGrid1.Columns[2].Title.Caption := 'UF';
    DBGrid1.Columns[2].Width := 80;

    with ZQObjetos do
    begin
      Close;
      sql.Clear;
      sql.Add('SELECT * FROM TCIDADE');
      Open;
      Last;
      First;
    end;
    ZQObjetos.Open;

    BitBtnCadastrar.Visible := true;


    VarPesquisa := 'TCIDADE';
  end;

  // PACIENTE
  if TipoPesquisa = 'TPACIENTE' then
  begin
    ZQObjetos.Close;
    DBGrid1.Clear;
    DBGrid1.Columns.Clear;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[0].FieldName := 'ID_PACIENTE';
    DBGrid1.Columns[0].Title.Caption := 'Código';
    DBGrid1.Columns[0].Width := 80;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[1].FieldName := 'NOME';
    DBGrid1.Columns[1].Title.Caption := 'Nome do Paciente';
    DBGrid1.Columns[1].Width := 350;

    with ZQObjetos do
    begin
      Close;
      sql.Clear;
      sql.Add('SELECT * FROM TPACIENTE');
      Open;
      Last;
      First;
    end;
    ZQObjetos.Open;

    VarPesquisa := 'TPACIENTE';
  end;

  // REMEDIO
  if TipoPesquisa = 'TREMEDIO' then
  begin
    ZQObjetos.Close;
    DBGrid1.Clear;
    DBGrid1.Columns.Clear;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[0].FieldName := 'ID_REMEDIO';
    DBGrid1.Columns[0].Title.Caption := 'Código';
    DBGrid1.Columns[0].Width := 80;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[1].FieldName := 'NOME_REMEDIO';
    DBGrid1.Columns[1].Title.Caption := 'Nome do Remédio';
    DBGrid1.Columns[1].Width := 350;

    with ZQObjetos do
    begin
      Close;
      sql.Clear;
      sql.Add('SELECT * FROM TREMEDIO');
      Open;
      Last;
      First;
    end;
    ZQObjetos.Open;

    VarPesquisa := 'TREMEDIO';
  end;


end;

procedure TFrmFiltro.DBGrid1DblClick(Sender: TObject);
begin
  BitBtnSelecionar.Click;
end;

procedure TFrmFiltro.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  
  if ZQObjetos.RecNo mod 2 = 0 then
  begin
    // DBGrid1.Canvas.Brush.Color := $00CCFFFF;
    DBGrid1.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    DBGrid1.Canvas.Brush.Color := clBtnFace;
  end;

  TDBGrid(Sender).Canvas.font.Color := clBlack;
  // aqui é definida a cor da fonte
  if gdSelected in State then
    with (Sender as TDBGrid).Canvas do
    begin

      TDBGrid(Sender).Canvas.font.Style := [fsbold];
      TDBGrid(Sender).Canvas.font.Size := 8;
      TDBGrid(Sender).Canvas.font.Color := clWhite;

      // Brush.Color := clGrayText; // aqui é definida a cor do fundo
      Brush.Color := $00996600; // aqui é definida a cor do fundo
      FillRect(Rect);
    end;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmFiltro.DBGrid1TitleClick(Column: TColumn);
begin
   GridSort(DBGrid1,Column,ZQObjetos);
   EditPesquisa.SetFocus;
end;

procedure TFrmFiltro.EditPesquisaChange(Sender: TObject);
begin
  if (DBGrid1.Columns[idxColunaProcura].Field) = nil then
    EXIT;

  try
    with DBGrid1.Columns[idxColunaProcura].Field do
    begin
      if DataType in [ftDate, ftDateTime] then
      begin
        if ValidaGeral.ValidaData(EditPesquisa.Text) then
          ProcurarCampoLOCATE(EditPesquisa.Text);
      end;

      if DataType in [ftInteger] then
      begin

        if ValidaGeral.ValidaInteiro(EditPesquisa.Text) then
          ProcurarCampoLOCATE(EditPesquisa.Text);
      end;

      if DataType in [ftFloat] then
      begin
        if ValidaGeral.ValidaDouble(EditPesquisa.Text) then
          ProcurarCampoLOCATE(EditPesquisa.Text);
      end;

      if DataType in [ftWideString] then
      begin
        if ValidaGeral.ValidaString(EditPesquisa.Text) then
          ProcurarCampoLOCATE(EditPesquisa.Text);
      end;

      if DataType in [ftString] then
      begin
        if ValidaGeral.ValidaString(EditPesquisa.Text) then
          ProcurarCampoLOCATE(EditPesquisa.Text);
      end;


    end;

  finally
    if Trim(EditPesquisa.Text) = '' then
      ProcurarCampoLOCATE(EditPesquisa.Text);

  end;
end;

procedure TFrmFiltro.BitBtnSelecionarClick(Sender: TObject);
begin
    BitBtnSelecionar.ModalResult := mrOk;
end;

procedure TFrmFiltro.BitBtnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmFiltro.BitBtnCadastrarClick(Sender: TObject);
begin
  //  CIDADE
  if VarPesquisa = 'TCIDADE' then
  begin
     if not Assigned(FrmCadCidade) then
     begin
       FrmCadCidade := TFrmCadCidade.Create(self);
       FrmCadCidade.ShowModal;
     end
     else
     begin
       FrmCadCidade.ShowModal;
     end;
     FreeAndNil(FrmCadCidade);
     Busca('TCIDADE');

  end;
end;

procedure TFrmFiltro.EditPesquisaExit(Sender: TObject);
begin
    EditPesquisa.Color := clWindow;
end;

procedure TFrmFiltro.EditPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  
 if ZQObjetos.Active then
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

procedure TFrmFiltro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   FreeAndNil(ValidaGeral);
   CloseAction := caFree;
end;

procedure TFrmFiltro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_ESCAPE) then
  begin
    Close;
  end;
end;

procedure TFrmFiltro.FormKeyPress(Sender: TObject; var Key: char);
begin
    if Key = #13 then
    BitBtnSelecionar.Click;
end;

procedure TFrmFiltro.FormShow(Sender: TObject);
var
a: array of string;
i, J: Integer;
begin
  ValidaGeral :=  ValidacaoGeral.Create();
  idxColunaProcura := 1;
  Busca(VTabela);

  if ZQObjetos.RecordCount > 0 then
    ZQObjetos.First;
  DBGrid1.SetFocus;

  EditPesquisa.SetFocus;


  if DBGrid1.Columns.Count > 0 then
  begin
    for i := 0 to DBGrid1.Columns.Count - 1 do
      if (DBGrid1.Columns[i].Field = nil) then
        ComboBoxColuna.Items.Add('Não definido')
      else
        ComboBoxColuna.Items.Add(DBGrid1.Columns[i].Field.DisplayName);

  end;

end;

procedure TFrmFiltro.ProcurarCampo(valor: string);
begin

  if ZQObjetos.State in [dsInsert, dsEdit] then
    Exit
  else
  begin
    if EditPesquisa.Text = '' then
    begin

      ZQObjetos.First;
    end
    else
    begin

      ZQObjetos.Filtered := false;
      ZQObjetos.Filter := 'UPPER(' + VarCampo + ')' + ' like ' + UpperCase(QuotedStr('%' + EditPesquisa.Text + '%'));
      ZQObjetos.Filtered := true;
      ZQObjetos.Locate(VarCampo, EditPesquisa.Text, [loPartialKey]);

    end;
  end;

end;

procedure TFrmFiltro.ProcurarCampoLOCATE(valor: string);
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

procedure TFrmFiltro.GridSort(GridName : TDBGrid; Column: TColumn; QueryName : TZQUERY);
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
RegisterClass(TFrmFiltro);

finalization
UnRegisterClass(TFrmFiltro);


end.

