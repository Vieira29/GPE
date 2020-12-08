unit uFrmBaseForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLType;

type

  { TFrmBaseForm }

  TFrmBaseForm = class(TForm)
    FadeIn: TTimer;
    FadeOut: TTimer;
    procedure FadeInTimer(Sender: TObject);
    procedure FadeOutTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);

  private

  public

  end;

var
  FrmBaseForm: TFrmBaseForm;

implementation

{$R *.lfm}

{ TFrmBaseForm }

procedure TFrmBaseForm.FadeInTimer(Sender: TObject);
begin
    AlphaBlendValue := AlphaBlendValue + 15;
    FadeIn.Enabled := not (AlphaBlendValue = 255);
end;

procedure TFrmBaseForm.FadeOutTimer(Sender: TObject);
begin
   AlphaBlendValue := AlphaBlendValue - 15;
  if AlphaBlendValue = 0 then
    Close;
end;

procedure TFrmBaseForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case Key of
        VK_ESCAPE: FadeOut.Enabled := true;
        VK_RETURN: PerformTab(true);
  end;
end;

procedure TFrmBaseForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13
  then  begin
            SelectNext(ActiveControl as TWinControl,True,True);
            key:=#0;
        end;
end;


end.

