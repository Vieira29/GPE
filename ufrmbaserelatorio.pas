unit uFrmBaseRelatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, uFrmBaseForm, ZDataset, db, RLReport, RLDraftFilter, RLHTMLFilter,
  RLPDFFilter, RLXLSFilter, RLXLSXFilter, udm;

type

  { TFrmBaseRelatorio }

  TFrmBaseRelatorio = class(TFrmBaseForm)
    BitBtnImprimir: TBitBtn;
    BitBtnVisualizar: TBitBtn;
    BitBtnSair: TBitBtn;
    DSRelatorio: TDataSource;
    Image1: TImage;
    LabelInfo: TLabel;
    PanelInfo: TPanel;
    PanelRelRodape: TPanel;
    RLDraftFilter1: TRLDraftFilter;
    RLHTMLFilter1: TRLHTMLFilter;
    RLPDFFilter1: TRLPDFFilter;
    RLReportRelatorio: TRLReport;
    RLXLSFilter1: TRLXLSFilter;
    RLXLSXFilter1: TRLXLSXFilter;
    ZQComandos: TZQuery;
    procedure BitBtnSairClick(Sender: TObject);
  private

  public

  end;

var
  FrmBaseRelatorio: TFrmBaseRelatorio;

implementation

{$R *.lfm}

{ TFrmBaseRelatorio }

procedure TFrmBaseRelatorio.BitBtnSairClick(Sender: TObject);
begin
  close;
end;

end.

