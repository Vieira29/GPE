unit ufrmrelreceita;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, uFrmBaseRelatorio, ZDataset, db, RLReport, RLDraftFilter,
  RLHTMLFilter, RLPDFFilter, RLXLSFilter, RLXLSXFilter;

type

  { TFrmRelReceita }

  TFrmRelReceita = class(TFrmBaseRelatorio)
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand5: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLDBText13: TRLDBText;
    RLDBText14: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText9: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw10: TRLDraw;
    RLDraw11: TRLDraw;
    RLDraw12: TRLDraw;
    RLDraw13: TRLDraw;
    RLDraw14: TRLDraw;
    RLDraw15: TRLDraw;
    RLDraw16: TRLDraw;
    RLDraw17: TRLDraw;
    RLDraw18: TRLDraw;
    RLDraw19: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw7: TRLDraw;
    RLDraw9: TRLDraw;
    RLGroupMestre: TRLGroup;
    RLLabel1: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel18: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel20: TRLLabel;
    RLLabel21: TRLLabel;
    RLLabel22: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabelTituloProc: TRLLabel;
    RLReportRelReceita: TRLReport;
    ZQComandosBAIRRO: TStringField;
    ZQComandosCELULAR: TStringField;
    ZQComandosCIDADE_UF: TStringField;
    ZQComandosENDERECO: TStringField;
    ZQComandosID_PROCEDIMENTO: TLongintField;
    ZQComandosLOGRADOURO: TStringField;
    ZQComandosNOME_PACIENTE: TStringField;
    ZQComandosNOME_REMEDIO: TStringField;
    ZQComandosNRO: TLongintField;
    ZQComandosPACIENTE: TLongintField;
    ZQComandosPOSOLOGIA: TStringField;
    ZQComandosQTD_FRASCOS: TSmallintField;
    ZQComandosREMEDIO: TLongintField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public
    Filtro   : String;
    TipoProc : String;
    function GerarRelatorio(ImpV:smallint):boolean;

  end;

var
  FrmRelReceita: TFrmRelReceita;

implementation

{$R *.lfm}

{ TFrmRelReceita }

procedure TFrmRelReceita.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmRelReceita := nil;
end;

function TFrmRelReceita.GerarRelatorio(ImpV: smallint): boolean;
begin

  with ZQComandos do
  begin
    close;
    sql.clear;
    sql.add('SELECT																							');
    sql.add('proc.id_procedimento,                                                                          ');
    sql.add('proc.paciente,                                                                                 ');
    sql.add('pac.nome as nome_paciente,                                                                     ');
    sql.add('cid.nome_cidade || ''-'' ||cid.uf_cidade as CIDADE_UF,                                         ');
    sql.add('PAC.celular,                                                                                  ');
    sql.add('PAC.logradouro,                                                                                ');
    sql.add('PAC.endereco,                                                                                  ');
    sql.add('PAC.nro,                                                                                       ');
    sql.add('PAC.bairro,                                                                                    ');
    sql.add('REC.remedio,                                                                                   ');
    sql.add('REM.nome_remedio,                                                                              ');
    sql.add('REC.qtd_frascos,                                                                               ');
    sql.add('REC.qtd_posologia || '' gotas entre '' || rec.intervalo_posologia || '' horas '' as POSOLOGIA  ');
    sql.add('FROM TRECEITA REC                                                                              ');
    sql.add('INNER JOIN tprocedimento PROC ON PROC.id_procedimento = REC.procedimento                       ');
    sql.add('INNER JOIN TPACIENTE PAC ON PROC.paciente = PAC.id_paciente                                    ');
    sql.add('inner join tcidade cid on pac.cidade = cid.id_cidade                           ');
    sql.add('INNER JOIN TREMEDIO REM ON REC.remedio = REM.id_remedio                                        ');
    sql.add(' WHERE 1=1 ');

    if not(Filtro = '')
    then begin
         sql.add('AND PROC.ID_PROCEDIMENTO IN ( ' + Filtro + ' )');
         end;
    sql.add('ORDER BY REC.REMEDIO');
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
    RLReportRelReceita.Prepare;
    RLReportRelReceita.Print;
  end;

  if (ImpV = 2) then
  begin
    RLReportRelReceita.Preview;
  end;
end;

initialization
RegisterClass(TFrmRelReceita);

finalization
UnRegisterClass(TFrmRelReceita);

end.

