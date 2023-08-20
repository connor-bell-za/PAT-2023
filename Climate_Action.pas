unit Climate_Action;
{ Climate Action Frame }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMXTee.Engine, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.WebBrowser, Winapi.ShellAPI, FMX.TabControl, FMX.Layouts;

type
  TfraAction = class(TFrame)
    imgBackground: TImage;
    pnlBacking: TPanel;
    lblSaveHeading: TLabel;
    lblReduceCFHeading: TLabel;
    lblWhat: TLabel;
    mmWhatIsCF: TMemo;
    lblHowToReduce: TLabel;
    mmReduceCF: TMemo;
    imgGlobeTemp: TImage;
    lblCalculate: TLabel;
    pnlCalculate: TPanel;
    btnCalculateGo: TButton;
    lblCalculateCaption: TLabel;
    lblCalculateSubHeading: TLabel;
    lblNewsHeading: TLabel;
    pnlNews: TPanel;
    Panel1: TPanel;
    lblClimateNewsCaption: TLabel;
    TabControl1: TTabControl;
    tbDate1: TTabItem;
    tbDate2: TTabItem;
    tbDate3: TTabItem;
    tbDate4: TTabItem;
    tbDate5: TTabItem;
    mmArticle1: TMemo;
    img1: TImage;
    Layout1: TLayout;
    mmArticle2: TMemo;
    img2: TImage;
    GridLayout1: TGridLayout;
    lblHeading2: TLabel;
    mmArticle3: TMemo;
    mmArticle4: TMemo;
    mmArticle5: TMemo;
    img3: TImage;
    img4: TImage;
    img5: TImage;
    GridLayout2: TGridLayout;
    GridLayout3: TGridLayout;
    GridLayout4: TGridLayout;
    lblHeading3: TLabel;
    lblHeading4: TLabel;
    lblHeading5: TLabel;
    lblHeading1: TLabel;
    Line1: TLine;
    Line2: TLine;
    procedure btnCalculateGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses Main;

procedure TfraAction.btnCalculateGoClick(Sender: TObject);
begin
  // Calculate Carbon Footprint
  {Use ShellExecute to Open WWF Website in Browser}
  frmMain.sLink :=  'https://footprint.wwf.org.uk/';
  frmMain.OpenLink;
  { Shell Execute did not work in this frame, therefore a procedure called
    OpenLink was created in the MAIN FORM which allows the use of
    ShellExecute. Please find the code for this button in the MAIN FORM }
end;

end.

{ Last Modified: Connor Bell - 17 July 2023}
