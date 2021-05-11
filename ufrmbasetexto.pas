unit uFrmbaseTexto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Clipbrd;

type

  { TFrmBaseTexto }

  TFrmBaseTexto = class(TForm)
    BitBtnSair: TBitBtn;
    BitBtnCopiar: TBitBtn;
    MemoTexto: TMemo;
    PanelFooter: TPanel;
    PanelContent: TPanel;
    procedure BitBtnCopiarClick(Sender: TObject);
    procedure BitBtnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    TextoExibido : string;

  end;

var
  FrmBaseTexto: TFrmBaseTexto;

implementation

{$R *.lfm}

{ TFrmBaseTexto }

procedure TFrmBaseTexto.BitBtnSairClick(Sender: TObject);
begin
  close;
end;

procedure TFrmBaseTexto.BitBtnCopiarClick(Sender: TObject);
begin
   Clipboard.AsText := MemoTexto.Text;
end;

procedure TFrmBaseTexto.FormShow(Sender: TObject);
begin
  MemoTexto.Clear;
  MemoTexto.Lines.add(TextoExibido);
end;

end.

