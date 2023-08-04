unit About;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TfraAbout = class(TFrame)
    Label2: TLabel;
    Label3: TLabel;
    imgBackground: TImage;
    pnlBack: TPanel;
    pnlID: TPanel;
    Memo1: TMemo;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
