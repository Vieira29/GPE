unit uFrmRelProcPorData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, EditBtn, uFrmBaseRelatorio, ZDataset, db, RLReport, RLDraftFilter,
  RLHTMLFilter, RLPDFFilter, RLXLSFilter;

type

  { TFrmRelProcPorData }

  TFrmRelProcPorData = class(TFrmBaseRelatorio)
    DateEditDataInicial: TDateEdit;
    DateEditDataFim: TDateEdit;
    GroupBoxPeriodo: TGroupBox;
    LabelAte: TLabel;
    RadioGroupTipoDia: TRadioGroup;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLDBResult1: TRLDBResult;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw10: TRLDraw;
    RLDraw11: TRLDraw;
    RLDraw12: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw7: TRLDraw;
    RLDraw8: TRLDraw;
    RLDraw9: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabelTituloProc: TRLLabel;
    RLLabelRelFiltro: TRLLabel;
    RLReportRelProcPorData: TRLReport;
    ZQComandosDATA_PROCEDIMENTO: TDateField;
    ZQComandosDESCRICAO_DIA: TStringField;
    ZQComandosID_PROCEDIMENTO: TLongintField;
    ZQComandosNOME_PACIENTE: TStringField;
    ZQComandosPACIENTE: TLongintField;
    ZQComandosTIPO_DIA: TStringField;
    procedure BitBtnImprimirClick(Sender: TObject);
    procedure BitBtnVisualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupTipoDiaClick(Sender: TObject);
  private

  public
    TipoDia : string;
    function Gerar_Relatorio(ImpV:smallint):boolean;

  end;

var
  FrmRelProcPorData: TFrmRelProcPorData;

implementation

{$R *.lfm}

{ TFrmRelProcPorData }

procedure TFrmRelProcPorData.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmRelProcPorData := nil;
end;

procedure TFrmRelProcPorData.FormShow(Sender: TObject);
begin
  DateEditDataInicial.Date:= now;
  DateEditDataFim.Date:= now;
end;

procedure TFrmRelProcPorData.BitBtnVisualizarClick(Sender: TObject);
begin
  Gerar_Relatorio(2);
end;

procedure TFrmRelProcPorData.BitBtnImprimirClick(Sender: TObject);
begin
  Gerar_Relatorio(1);
end;

procedure TFrmRelProcPorData.RadioGroupTipoDiaClick(Sender: TObject);
begin
  CASE RadioGroupTipoDia.ItemIndex
  of
    0 : TipoDia := 'TE';
    1 : TipoDia := 'CE';
    2 : TipoDia := 'RA';
    3 : TipoDia := 'RR';
    4 : TipoDia := 'RP';
  end;
end;

function TFrmRelProcPorData.Gerar_Relatorio(ImpV: smallint): boolean;
begin

  RLLabelRelFiltro.Caption := FormatDateTime('DD\MM\YYYY', DateEditDataInicial.Date) + ' até ' + FormatDateTime('DD\MM\YYYY', DateEditDataFim.Date)  + ' | ';



  CASE RadioGroupTipoDia.ItemIndex
  of
    0 : RLLabelRelFiltro.Caption  := RLLabelRelFiltro.Caption + 'Tratamento Espiritual';
    1 : RLLabelRelFiltro.Caption  := RLLabelRelFiltro.Caption + 'Cirurgia Espiritual';
    2 : RLLabelRelFiltro.Caption  := RLLabelRelFiltro.Caption + 'Repouso Absoluto';
    3 : RLLabelRelFiltro.Caption  := RLLabelRelFiltro.Caption + 'Repouso Relativo';
    4 : RLLabelRelFiltro.Caption  := RLLabelRelFiltro.Caption + 'Retirar Pontos';
  end;


  with ZQComandos do
  begin
    close;
    sql.clear;
    sql.add('select																				');
    sql.add('PROC.id_procedimento,                                                              ');
    sql.add('PROC.paciente,                                                                     ');
    sql.add('PAC.nome AS NOME_PACIENTE,                                                         ');
    sql.add('DPROC.data_procedimento,                                                           ');
    sql.add('DPROC.tipo_dia,                                                                    ');
    sql.add('CASE DPROC.tipo_dia                                                                ');
    sql.add('WHEN ''TE'' then ''Tratamento Espiritual''                                         ');
    sql.add('WHEN ''CE'' then ''Cirurgia Espiritual''                                           ');
    sql.add('WHEN ''RA'' then ''Repouso Absoluto''                                              ');
    sql.add('WHEN ''RR'' then ''Repouso Relativo''                                              ');
    sql.add('WHEN ''RP'' then ''Retirada dos Pontos''                                           ');
    sql.add('end as DESCRICAO_DIA                                                               ');
    sql.add('FROM TPROCEDIMENTO PROC                                                            ');
    sql.add('INNER JOIN TPACIENTE PAC ON PROC.paciente = PAC.id_paciente                        ');
    sql.add('INNER JOIN tdias_procedimento DPROC ON PROC.id_procedimento = DPROC.procedimento   ');
    sql.add('WHERE                                                                              ');
    sql.add('DPROC.data_procedimento BETWEEN :DATA_INI AND :DATA_FIM                            ');
    sql.add('AND DPROC.tipo_dia = :TIPO_DIA                                                     ');
    sql.add('ORDER BY DPROC.data_procedimento');
    ParamByName('DATA_INI').AsDateTime  := DateEditDataInicial.Date;
    ParamByName('DATA_FIM').AsDateTime  := DateEditDataFim.Date;
    ParamByName('TIPO_DIA').AsString    := TipoDia;
    open;
    last;
    first;



    if (recordcount = 0) then
    begin
      MessageDlg('Não há registros para impressão', mtWarning, [mbOk], 0 );
      abort;
    end;
  end;



  if (ImpV = 1) then
  begin
    RLReportRelProcPorData.Prepare;
    RLReportRelProcPorData.Print;
  end;

  if (ImpV = 2) then
  begin
    RLReportRelProcPorData.Preview;
  end;
end;

initialization
RegisterClass(TFrmRelProcPorData);

finalization
UnRegisterClass(TFrmRelProcPorData);

end.

