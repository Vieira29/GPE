unit uFrmRelatoInstrTrat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, uFrmBaseRelatorio, ZDataset, db, RLReport, RLDraftFilter,
  RLHTMLFilter, RLPDFFilter, RLXLSFilter, RLXLSXFilter;

type

  { TFrmRelatoInstrTrat }

  TFrmRelatoInstrTrat = class(TFrmBaseRelatorio)
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand5: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLDBText13: TRLDBText;
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
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw7: TRLDraw;
    RLDraw8: TRLDraw;
    RLDraw9: TRLDraw;
    RLGroupMestre: TRLGroup;
    RLLabel1: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel18: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel20: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabelTituloProc: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLMemo1: TRLMemo;
    RLReportGuiaInstrucoes: TRLReport;
    ZQComandosBAIRRO: TStringField;
    ZQComandosCELULAR: TStringField;
    ZQComandosCIDADE_UF: TStringField;
    ZQComandosDATA_PROCEDIMENTO: TDateField;
    ZQComandosDATA_PROC_LAN: TDateField;
    ZQComandosDESCRICAO_DIA: TStringField;
    ZQComandosENDERECO: TStringField;
    ZQComandosID_PROCEDIMENTO: TLongintField;
    ZQComandosLOGRADOURO: TStringField;
    ZQComandosNOME_PACIENTE: TStringField;
    ZQComandosNRO: TLongintField;
    ZQComandosPACIENTE: TLongintField;
    ZQComandosTIPO_DIA: TStringField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RLBand1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBand3BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLMemo1AfterPrint(Sender: TObject);
    procedure RLMemo1BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);


  private

  public
    Filtro   : String;
    TipoProc : String;
     function Gerar_Relatorio(ImpV:smallint):boolean;

  end;

var
  FrmRelatoInstrTrat: TFrmRelatoInstrTrat;

implementation

{$R *.lfm}

{ TFrmRelatoInstrTrat }

procedure TFrmRelatoInstrTrat.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  CloseAction := caFree;
  FrmRelatoInstrTrat := nil;
end;

procedure TFrmRelatoInstrTrat.RLBand1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
    if   TipoProc = 'T'
    then RLLabelTituloProc.Caption := 'RECOMENDAÇÕES PARA TRATAMENTO À DISTÂNCIA'
    else RLLabelTituloProc.Caption := 'RECOMENDAÇÕES PARA CIRURGIA À DISTÂNCIA';
end;

procedure TFrmRelatoInstrTrat.RLBand3BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
    if TipoProc = 'T'
  then begin
       RLMemo1.Lines.Clear;
       RLMemo1.Lines.Add('1) NA SEMANA QUE ANTECEDE O TRATAMENTO																										');
       RLMemo1.Lines.Add('A) Ler o evangelho todos os dias                                                                                                             ');
       RLMemo1.Lines.Add('B) Orai e vigiar pensamentos e atos                                                                                                          ');
       RLMemo1.Lines.Add('C) Evitar bebidas alcoólicas                                                                                                                 ');
       RLMemo1.Lines.Add('                                                                                                                                             ');
       RLMemo1.Lines.Add('2) NO DIA DO TRATAMENTO                                                                                                                      ');
       RLMemo1.Lines.Add('A) Manter conversações e vibrações positivas desde o amanhecer.                                                                              ');
       RLMemo1.Lines.Add('B) Não fumar e não beber bebidas alcoólicas                                                                                                  ');
       RLMemo1.Lines.Add('C) Fazer uma alimentação leve, sem carnes, gorduras, frituras e frutas ácidas                                                                ');
       RLMemo1.Lines.Add('D) A última refeição deverá ser (02) horas antes da tratamento.                                                                              ');
       RLMemo1.Lines.Add('                                                                                                                                             ');
       RLMemo1.Lines.Add('3) NO MOMENTO DO RECOLHIMENTO PARA O TRATAMENTO                                                                                              ');
       RLMemo1.Lines.Add('A) Recolher-se às 20h30 min, do dia marcado em seu leito, se possível, sobre um lençol branco e virol branco,                                ');
       RLMemo1.Lines.Add('em penumbra, com vestuário claro podendo ter 1 (um) ou mais acompanhantes para preces, leitura e meditações                                  ');
       RLMemo1.Lines.Add('sobre o evangelho até as 21h00                                                                                                               ');
       RLMemo1.Lines.Add('                                                                                                                                             ');
       RLMemo1.Lines.Add('B) Das 21h até as 21h30min, o paciente ficará em concentração, no mais absoluto silêncio. Se dormir o paciente não deverá ser acordado.      ');
       RLMemo1.Lines.Add('                                                                                                                                             ');
       RLMemo1.Lines.Add('B) Colocar uma garrafa com água ao lado da cama, para magnetização, iniciando bebê-la após 01 (uma) hora do tratamento, caso esteja acordada ');
       RLMemo1.Lines.Add('                                                                                                                                             ');
       RLMemo1.Lines.Add('C) Seguir bebendo a água de 02 em 02 horas.                                                                                                  ');
       end;

  if TipoProc = 'C'
  then begin
       RLMemo1.Lines.Clear;
       RLMemo1.Lines.Add('1) NA SEMANA QUE ANTECEDE A CIRURGIA																										 ');
       RLMemo1.Lines.Add('A) Ler o evangelho todos os dias                                                                                                          ');
       RLMemo1.Lines.Add('B) Orai e vigiar pensamentos e atos                                                                                                       ');
       RLMemo1.Lines.Add('C) Evitar bebidas alcoólicas                                                                                                              ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('2) NO DIA DA CIRURGIA                                                                                                                     ');
       RLMemo1.Lines.Add('A) Manter conversações e vibrações positivas desde o amanhecer.                                                                           ');
       RLMemo1.Lines.Add('B) Não fuma e não beber bebidas alcoólicas                                                                                                ');
       RLMemo1.Lines.Add('C) Fazer uma alimentação leve, sem carnes, gorduras, frituras e frutas ácidas                                                             ');
       RLMemo1.Lines.Add('D) A última refeição deverá ser (02) horas antes da cirurgia.                                                                             ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('3) NO MOMENTO DO RECOLHIMENTO PARA A CIRURGIA                                                                                             ');
       RLMemo1.Lines.Add('A) Recolher-se às 20h30 min, do dia marcado em seu leito, se possível, sobre um lençol branco e virol branco, em penumbra,                ');
       RLMemo1.Lines.Add('com vestuário claro podendo ter 1 (um) ou mais acompanhantes para preces, leitura e meditações sobre o evangelho até as 21h30             ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('B) Colocar uma garrafa com água ao lado da cama, para magnetização, iniciando bebê-la após 01 (uma) hora da cirurgia, caso esteja acordada');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('C) Seguir bebendo a água de 02 em 02 horas.                                                                                               ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('REPOUSO APÓS A CIRURGIA (IMPORTANTE)                                                                                                      ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('MUITO IMPORTANTE                                                                                                                          ');
       RLMemo1.Lines.Add('A) Repouso absoluto por três (3) dias                                                                                                     ');
       RLMemo1.Lines.Add('B) Repouso relativo por quatro (4) dias, podendo sentar e andar sem grandes movimentos e esforços.                                        ');
       RLMemo1.Lines.Add('C) Retirar os pontos da cirurgia em sua casa (no local onde foi realizada)                                                                ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('RETIRADA DE PONTOS SEGUE O MESMO PROCESSO DO DIA DA CIRURGIA                                                                              ');
       RLMemo1.Lines.Add('                                                                                                                                          ');
       RLMemo1.Lines.Add('DIETA APÓS A CIRURGIA                                                                                                                     ');
       RLMemo1.Lines.Add('A dieta alimentar ficará liberada a partir do 9º dia.                                                                                     ');
       end;
end;

procedure TFrmRelatoInstrTrat.RLMemo1AfterPrint(Sender: TObject);
begin

end;

procedure TFrmRelatoInstrTrat.RLMemo1BeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  if TipoProc = 'T'
  then begin
       RLMemo1.Lines.Clear;
       RLMemo1.Lines.Text := '1) NA SEMANA QUE ANTECEDE O TRATAMENTO													   ';
       RLMemo1.Lines.Text := 'A) Ler o evangelho todos os dias                                                                                                             ';
       RLMemo1.Lines.Text := 'B) Orai e vigiar pensamentos e atos                                                                                                          ';
       RLMemo1.Lines.Text := 'C) Evitar bebidas alcoólicas                                                                                                                 ';
       RLMemo1.Lines.Text := '                                                                                                                                             ';
       RLMemo1.Lines.Text := '2) NO DIA DO TRATAMENTO                                                                                                                      ';
       RLMemo1.Lines.Text := 'A) Manter conversações e vibrações positivas desde o amanhecer.                                                                              ';
       RLMemo1.Lines.Text := 'B) Não fumar e não beber bebidas alcoólicas                                                                                                  ';
       RLMemo1.Lines.Text := 'C) Fazer uma alimentação leve, sem carnes, gorduras, frituras e frutas ácidas                                                                ';
       RLMemo1.Lines.Text := 'D) A última refeição deverá ser (02) horas antes da tratamento.                                                                              ';
       RLMemo1.Lines.Text := '                                                                                                                                             ';
       RLMemo1.Lines.Text := '3) NO MOMENTO DO RECOLHIMENTO PARA O TRATAMENTO                                                                                              ';
       RLMemo1.Lines.Text := 'A) Recolher-se às 20h30 min, do dia marcado em seu leito, se possível, sobre um lençol branco e virol branco,                                ';
       RLMemo1.Lines.Text := 'em penumbra, com vestuário claro podendo ter 1 (um) ou mais acompanhantes para preces, leitura e meditações                                  ';
       RLMemo1.Lines.Text := 'sobre o evangelho até as 21h00                                                                                                               ';
       RLMemo1.Lines.Text := '                                                                                                                                             ';
       RLMemo1.Lines.Text := 'B) Das 21h até as 21h30min, o paciente ficará em concentração, no mais absoluto silêncio. Se dormir o paciente não deverá ser acordado.      ';
       RLMemo1.Lines.Text := '                                                                                                                                             ';
       RLMemo1.Lines.Text := 'B) Colocar uma garrafa com água ao lado da cama, para magnetização, iniciando bebê-la após 01 (uma) hora do tratamento, caso esteja acordada ';
       RLMemo1.Lines.Text := '                                                                                                                                             ';
       RLMemo1.Lines.Text := 'C) Seguir bebendo a água de 02 em 02 horas.                                                                                                  ';
       end;

  if TipoProc = 'C'
  then begin
       RLMemo1.Lines.Text := '1) NA SEMANA QUE ANTECEDE A CIRURGIA												        ';
       RLMemo1.Lines.Text := 'A) Ler o evangelho todos os dias                                                                                                          ';
       RLMemo1.Lines.Text := 'B) Orai e vigiar pensamentos e atos                                                                                                       ';
       RLMemo1.Lines.Text := 'C) Evitar bebidas alcoólicas                                                                                                              ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := '2) NO DIA DA CIRURGIA                                                                                                                     ';
       RLMemo1.Lines.Text := 'A) Manter conversações e vibrações positivas desde o amanhecer.                                                                           ';
       RLMemo1.Lines.Text := 'B) Não fuma e não beber bebidas alcoólicas                                                                                                ';
       RLMemo1.Lines.Text := 'C) Fazer uma alimentação leve, sem carnes, gorduras, frituras e frutas ácidas                                                             ';
       RLMemo1.Lines.Text := 'D) A última refeição deverá ser (02) horas antes da cirurgia.                                                                             ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := '3) NO MOMENTO DO RECOLHIMENTO PARA A CIRURGIA                                                                                             ';
       RLMemo1.Lines.Text := 'A) Recolher-se às 20h30 min, do dia marcado em seu leito, se possível, sobre um lençol branco e virol branco, em penumbra,                ';
       RLMemo1.Lines.Text := 'com vestuário claro podendo ter 1 (um) ou mais acompanhantes para preces, leitura e meditações sobre o evangelho até as 21h30             ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'B) Colocar uma garrafa com água ao lado da cama, para magnetização, iniciando bebê-la após 01 (uma) hora da cirurgia, caso esteja acordada';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'C) Seguir bebendo a água de 02 em 02 horas.                                                                                               ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'REPOUSO APÓS A CIRURGIA (IMPORTANTE)                                                                                                      ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'MUITO IMPORTANTE                                                                                                                          ';
       RLMemo1.Lines.Text := 'A) Repouso absoluto por três (3) dias                                                                                                     ';
       RLMemo1.Lines.Text := 'B) Repouso relativo por quatro (4) dias, podendo sentar e andar sem grandes movimentos e esforços.                                        ';
       RLMemo1.Lines.Text := 'C) Retirar os pontos da cirurgia em sua casa (no local onde foi realizada)                                                                ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'RETIRADA DE PONTOS SEGUE O MESMO PROCESSO DO DIA DA CIRURGIA                                                                              ';
       RLMemo1.Lines.Text := '                                                                                                                                          ';
       RLMemo1.Lines.Text := 'DIETA APÓS A CIRURGIA                                                                                                                     ';
       RLMemo1.Lines.Text := 'A dieta alimentar ficará liberada a partir do 9º dia.                                                                                     ';

       end;

end;


function TFrmRelatoInstrTrat.Gerar_Relatorio(ImpV: smallint): boolean;
begin


  
  with ZQComandos do
  begin
    close;
    sql.clear;
    sql.add('select																			');
    sql.add('proc.id_procedimento,                                                          ');
    sql.add('proc.paciente,                                                                 ');
    sql.add('proc.data_proc_lan,                                                            ');
    sql.add('pac.nome as nome_paciente,                                                     ');
    sql.add('cid.nome_cidade || ''-'' ||cid.uf_cidade as CIDADE_UF,                         ');
    sql.add('PAC.celular,                                                                  ');
    sql.add('PAC.logradouro,                                                                ');
    sql.add('PAC.endereco,                                                                  ');
    sql.add('PAC.nro,                                                                       ');
    sql.add('PAC.bairro,                                                                    ');
    sql.add('dias.data_procedimento,                                                        ');
    sql.add('dias.tipo_dia,                                                                 ');
    sql.add('CASE dias.tipo_dia                                                             ');
    sql.add('WHEN ''TE'' then ''Tratamento Espiritual''                                     ');
    sql.add('WHEN ''CE'' then ''Cirurgia Espiritual''                                       ');
    sql.add('WHEN ''RA'' then ''Repouso Absoluto''                                          ');
    sql.add('WHEN ''RR'' then ''Repouso Relativo''                                          ');
    sql.add('WHEN ''RP'' then ''Retirada dos Pontos''                                       ');
    sql.add('end as DESCRICAO_DIA                                                           ');
    sql.add('from tprocedimento proc                                                        ');
    sql.add('left join tpaciente pac on proc.paciente = pac.id_paciente                     ');
    sql.add('inner join tcidade cid on pac.cidade = cid.id_cidade                           ');
    sql.add('left join tdias_procedimento dias on proc.id_procedimento = dias.procedimento  ');
    sql.add(' WHERE 1=1 ');

    if not(Filtro = '')
    then begin
         sql.add('AND PROC.ID_PROCEDIMENTO IN ( ' + Filtro + ' )');
         end;
    sql.add('ORDER BY dias.data_procedimento           ');
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
    RLReportGuiaInstrucoes.Prepare;
    RLReportGuiaInstrucoes.Print;
  end;

  if (ImpV = 2) then
  begin
    RLReportGuiaInstrucoes.Preview;
  end;
end;

initialization
RegisterClass(TFrmRelatoInstrTrat);

finalization
UnRegisterClass(TFrmRelatoInstrTrat);

end.

