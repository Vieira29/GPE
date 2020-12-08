unit uFrmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ActnList,
  Menus, ExtCtrls, Buttons, uCarregaINI;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    BitBtnTelaRemedio: TBitBtn;
    BitBtnTelaPacientes: TBitBtn;
    BitBtnTelaCidades: TBitBtn;
    BitBtnTelaProcedimento: TBitBtn;
    ImageFundo: TImage;
    PageControlOpcoes: TPageControl;
    Panel1: TPanel;
    StatusBarWelcome: TStatusBar;
    TabSheetPrincipal: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    procedure BitBtnTelaCidadesClick(Sender: TObject);
    procedure BitBtnTelaPacientesClick(Sender: TObject);
    procedure BitBtnTelaProcedimentoClick(Sender: TObject);
    procedure BitBtnTelaRemedioClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControlPrincipalChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  FrmMain: TFrmMain;
  CarregarINI: CarregaINI;
  Path_Banco: String;

implementation

uses udm, uFrmCadPacientes, uFrmCadCidade, uFrmCadRemedio, uFrmCadProcedimento;

{$R *.lfm}

{ TFrmMain }

procedure TFrmMain.TabControlPrincipalChange(Sender: TObject);
begin

end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
    StatusBarWelcome.Panels[1].text :=
    formatdatetime('dddd","dd" de "mmmm" de "yyyy', now) + ' - ' +
    formatdatetime('hh:mm:ss', now);
end;

procedure TFrmMain.BitBtnTelaPacientesClick(Sender: TObject);
begin
   if not Assigned(FrmCadPacientes) then
  begin
    FrmCadPacientes := TFrmCadPacientes.Create(self);
    FrmCadPacientes.Show;
  end
  else
  begin
    FrmCadPacientes.Show;
  end;
end;

procedure TFrmMain.BitBtnTelaProcedimentoClick(Sender: TObject);
begin
    if not Assigned(FrmCadProcedimento) then
  begin
    FrmCadProcedimento := TFrmCadProcedimento.Create(self);
    FrmCadProcedimento.Show;
  end
  else
  begin
    FrmCadProcedimento.Show;
  end;
end;

procedure TFrmMain.BitBtnTelaRemedioClick(Sender: TObject);
begin
    if not Assigned(FrmCadRemedio) then
  begin
    FrmCadRemedio := TFrmCadRemedio.Create(self);
    FrmCadRemedio.Show;
  end
  else
  begin
    FrmCadRemedio.Show;
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeAndNil(CarregarINI);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  CarregarINI := CarregaINI.Create();

  Path_Banco := CarregarINI.LeIni('Config.ini', 'Geral', 'Caminho do Banco',
    Path_Banco, 'S');
  DM.ConectaBanco(Path_Banco);

end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  Top := 0;
  Left := 0;
  Width := Screen.Width;
  Height := Screen.Height;
  self.WindowState:= wsMaximized;
end;

procedure TFrmMain.BitBtnTelaCidadesClick(Sender: TObject);
begin
    if not Assigned(FrmCadCidade) then
  begin
    FrmCadCidade := TFrmCadCidade.Create(self);
    FrmCadCidade.Show;
  end
  else
  begin
    FrmCadCidade.Show;
  end;

end;

end.

