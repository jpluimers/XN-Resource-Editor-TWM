        ??  ??                  T  ,   ??
 S N I P E T S       0           ;========================================================================
-------:MMCProjectSource
library %ProjectName%;

uses
  ComServ;

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.RES}

end.
--------
;========================================================================
--------:MMCSnapinDataFormSource
object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 100
  Width = 100
  object SnapinData1: TSnapinData
    ScopeItem.Columns = <>
    ScopeItem.ScopeItems = <>
    ScopeItem.ResultItems = <>
    ScopeItem.Text = %ScopeItemText%
    Left = 32
    Top = 16
  end
end
--------
;========================================================================
--------:MMCSnapinDataImplSource
unit %FileName%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SnapinData;

type
  TDataModule1 = class(TDataModule)
    SnapinData1: TSnapinData;
  private
    { Private declarations }

    procedure Initialize;
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.DFM}

uses ComServ, ComObj, MMCFactory, Snapins;

{ TDataModule1 }

procedure TDataModule1.Initialize;
begin
end;

{$region 'Snapin System Code'}

const
  Class_SimpleSnapin : TGuid = '%CreateGUID%';
  Class_SimpleSnapinAbout : TGuid = '%CreateGUID%';

type
  TSimpleComponentData = class (TSnapinComponentData)
  private
    fDataModule : TDataModule1;
  protected
    function GetSnapinData : TSnapinData; override;
  public
    destructor Destroy; override;
  end;

  TSimpleSnapinAbout = class (TSnapinAbout)
  private
    fDataModule : TDataModule1;
  protected
    function GetSnapinData : TSnapinData; override;
  public
    destructor Destroy; override;
  end;

{ TSimpleComponentData }

destructor TSimpleComponentData.Destroy;
begin
  fDataModule.Free;
  inherited
end;

function TSimpleComponentData.GetSnapinData: TSnapinData;
begin
  fDataModule := TDataModule1.Create (Nil);
  result := fDataModule.SnapinData1;
  fDataModule.Initialize;
end;

{ TTestSnapinAbout }

destructor TSimpleSnapinAbout.Destroy;
begin
  fDataModule.Free;
  inherited;
end;

function TSimpleSnapinAbout.GetSnapinData: TSnapinData;
begin
  fDataModule := TDataModule1.Create (nil);
  result := fDataModule.SnapinData1;
end;

var
  snapinName, snapinDescription, snapinProvider : string;

{$endregion}

initialization
{$region 'Snapin System Initialization'}
  DataModule1 := TDataModule1.Create (nil);
  try
    snapinDescription := DataModule1.SnapinData1.FileDescription;
    snapinName := DataModule1.SnapinData1.ProductName;
    snapinProvider := DataModule1.SnapinData1.Provider;
  finally
    DataModule1.Free
  end;
  if snapinDescription = '' then snapinDescription := snapinName;
  TMMCObjectFactory.Create (ComServer, TSimpleComponentData, Class_SimpleSnapin, TSimpleSnapinAbout, Class_SimpleSnapinAbout,
    snapinName, snapinDescription, snapinProvider);
{$endregion}
end.
----------
