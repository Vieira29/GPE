program GPE;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uFrmBaseForm, uFrmMain, uFrmCadPacientes, uDM, zcomponent,
  uFrmCadCidade, uFrmCadRemedio, uFrmCadProcedimento, uFrmRelatoInstrTrat,
  uCarregaINI, ufrmrelreceita, uFrmRelProcPorData, tachartlazaruspkg,
  ufrmcadgrupofamiliar, uFrmCadEvento, uFrmbaseTexto
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmCadPacientes, FrmCadPacientes);
  Application.CreateForm(TFrmCadCidade, FrmCadCidade);
  Application.CreateForm(TFrmCadRemedio, FrmCadRemedio);
  Application.CreateForm(TFrmCadProcedimento, FrmCadProcedimento);
  Application.CreateForm(TFrmRelatoInstrTrat, FrmRelatoInstrTrat);
  Application.CreateForm(TFrmRelReceita, FrmRelReceita);
  Application.CreateForm(TFrmRelProcPorData, FrmRelProcPorData);
  Application.CreateForm(TFrmCadGrupoFamiliar, FrmCadGrupoFamiliar);
  Application.CreateForm(TFrmCadEvento, FrmCadEvento);
  Application.CreateForm(TFrmBaseTexto, FrmBaseTexto);
  Application.Run;
end.

