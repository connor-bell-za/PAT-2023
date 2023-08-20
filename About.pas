unit About;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Effects, ShellAPI;

type
  TfraAbout = class(TFrame)
    Label2: TLabel;
    Label3: TLabel;
    imgBackground: TImage;
    Memo1: TMemo;
    Image2: TImage;
    Panel1: TPanel;
    lblHeading: TLabel;
    Label1: TLabel;
    Panel2: TPanel;
    ShadowEffect1: TShadowEffect;
    Memo2: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    btnLink: TButton;
    procedure btnLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses Main;

procedure TfraAbout.btnLinkClick(Sender: TObject);
begin
  // Open the Github site for the application using the OpenLink procedure
  // in frmMain.
  frmMain.sLink := 'https://github.com/connor-bell-za/PAT-2023/';
  frmMain.OpenLink;
end;

end.
