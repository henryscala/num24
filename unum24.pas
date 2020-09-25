unit unum24;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, urational,uexpr;
const
  NUMS_COUNT = 4;
type

  { TfrmNum24 }




  TfrmNum24 = class(TForm)
    btnCalculate: TButton;
    edtNum1: TEdit;
    edtNum2: TEdit;
    edtNum3: TEdit;
    edtNum4: TEdit;
    mmResult: TMemo;
    procedure btnCalculateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fOps: array[1..NUMS_COUNT] of char;
    fNums: array[1..NUMS_COUNT] of integer;
    fRationals: array[1..NUMS_COUNT] of TRational;
    fExprs:array[1..NUMS_COUNT] of TExpr;
    procedure log(s:String );
    procedure intArrayCallback(context:pointer;ary:array of integer);
  public

  end;

var
  frmNum24: TfrmNum24;

implementation

{$R *.lfm}

{ TfrmNum24 }

procedure TfrmNum24.log( s:String);
begin
  mmResult.lines.add(s);
end;
procedure TfrmNum24.FormCreate(Sender: TObject);

begin
  fOps[1] := '+';
  fOps[2] := '-';
  fOps[3] := '*';
  fOps[4] := '/';
end;

procedure TfrmNum24.intArrayCallback(context:pointer;ary:array of integer);
var
  s:string = '';
  i:integer;
begin
  for i:=low(ary) to high(ary) do begin
      s := s + ' ' +intToStr(ary[i]);
  end;
  log(s);
end;

procedure TfrmNum24.btnCalculateClick(Sender: TObject);
var
  i:integer;
  exprList:TList;
  expr:PExpr;
begin
  fNums[1] := StrToInt(edtNum1.Text);
  fNums[2] := StrToInt(edtNum2.Text);
  fNums[3] := StrToInt(edtNum3.Text);
  fNums[4] := StrToInt(edtNum4.Text);
  log(format('4 nums: %d,%d,%d,%d', [fNums[1],fNums[2],fNums[3],fNums[4]] ));

  for i:=1 to NUMS_COUNT do begin
    fRationals[i] := intToRational(fNums[i]);
    fExprs[i] := rationalToExpr(fRationals[i]);
    log(rationalToStr( fRationals[i] ) );
    log(exprToStr(@fExprs[i]));
  end;
  exprList := enumerateExpr2(@fExprs[1],@fExprs[2],fOps);
  for i:= 0 to exprList.Count-1 do begin
    expr := exprList.Items[i];
    log(exprToStr(expr));
  end;

  combination(4,2,nil,@intArrayCallback);
end;

end.

