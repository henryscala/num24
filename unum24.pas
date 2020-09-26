unit unum24;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, urational,uexpr;
const
  NUMS_COUNT = 4;
type

  { TfrmNum24 }

  { TInputOutputList }

  TInputOutputList = class
    public

    inputList:TList;
    outputList:TList;
    outputList1:TList;
    outputList2:TList;
    constructor create;
    destructor destroy;override;
  end;

  PIntArray4 = ^TIntArray4;
  TIntArray4 = array[0..3] of integer;



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
    procedure intArrayCallback1(context:pointer;ary:array of integer);
    procedure intArrayCallback2(context:pointer;ary:array of integer);
    procedure complementArray(ary:array of integer;var outAry:TIntArray4);
  public

  end;

var
  frmNum24: TfrmNum24;
  intArrayInitializer:TIntArray4 = (0,0,0,0);
implementation

{$R *.lfm}

{ TInputOutputList }

constructor TInputOutputList.create;
begin
  inputList := TList.Create;
  outputList := TList.Create;
  outputList1 := TList.Create;
  outputList2 := TList.Create;
end;

destructor TInputOutputList.destroy;
begin
  inputList.Free;
  outputList.Free;
  outputList1.Free;
  outputList2.Free;
end;

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

procedure TfrmNum24.intArrayCallback1(context:pointer;ary:array of integer);
var
  s:string = '';
  i:integer;
  ioList: TInputOutputList;
  exprList: TList;
  expr1,expr2:PExpr;
  pcomplement:PIntArray4;
  complement:TIntArray4;
begin
  for i:=low(ary) to high(ary) do begin
      s := s + intToStr(ary[i]);
  end;
  log(s);
  ioList := TInputOutputList( context );
  complement := intArrayInitializer;
  complementArray(ary,complement);
  expr1 := PExpr(ioList.inputList.Items[ary[0]]);
  expr2 := PExpr(ioList.inputList.Items[ary[1]]);
  log('expr1:'+exprToStr(expr1));
  log('expr2:'+exprToStr(expr2));
  exprList := enumerateExpr2(expr1,expr2,fOps);
  for i:=0 to exprList.Count-1 do begin
    log('combined expr:'+exprToStr(PExpr(exprList.Items[i])));
  end;

  for i:=0 to exprList.Count-1 do begin
    new(pcomplement);
    pcomplement^ := complement;
    ioList.outputList.Add(exprList.Items[i]);
    ioList.outputList1.Add(pcomplement);
  end;
end;

procedure TfrmNum24.intArrayCallback2(context:pointer;ary:array of integer);
var
  s:string = '';
  i:integer;
  ioList: TInputOutputList;
  exprList: TList;
  expr1,expr2:PExpr;
  pcomplement:PIntArray4;
  complement:TIntArray4;
begin
  for i:=low(ary) to high(ary) do begin
      s := s + intToStr(ary[i]);
  end;
  log(s);
  ioList := TInputOutputList( context );

  if ary[0] <> 0 then begin
    expr1 := ioList  //TODO
    enumerateExpr2(expr1,expr2,fOps);
  end else begin
    //TODO
  end;
  complement := intArrayInitializer;
  complementArray(ary,complement);
  expr1 := PExpr(ioList.inputList.Items[ary[0]]);
  expr2 := PExpr(ioList.inputList.Items[ary[1]]);
  log('expr1:'+exprToStr(expr1));
  log('expr2:'+exprToStr(expr2));
  exprList := enumerateExpr2(expr1,expr2,fOps);
  for i:=0 to exprList.Count-1 do begin
    log('combined expr:'+exprToStr(PExpr(exprList.Items[i])));
  end;

  for i:=0 to exprList.Count-1 do begin
    new(pcomplement);
    pcomplement^ := complement;
    ioList.outputList.Add(exprList.Items[i]);
    ioList.outputList1.Add(pcomplement);
  end;
end;

procedure TfrmNum24.complementArray(ary: array of integer; var outAry:TIntArray4);
var
  i,j:integer;
  all:set of 0..3 = [];
begin
  for i:=low(ary) to high(ary) do begin
    all := all + [ary[i]];
  end;
  j := 0;
  for i:=0 to 3 do begin
    if not (i in all) then begin
      outAry[j] := i;
      inc(j);
    end;
  end;
end;

procedure TfrmNum24.btnCalculateClick(Sender: TObject);
var
  i:integer;
  exprList:TList;
  expr:PExpr;
  ioList1:TInputOutputList;
  ioList2:TInputOutputList;
  ioList3:TInputOutputList;
begin
  fNums[1] := StrToInt(edtNum1.Text);
  fNums[2] := StrToInt(edtNum2.Text);
  fNums[3] := StrToInt(edtNum3.Text);
  fNums[4] := StrToInt(edtNum4.Text);
  log(format('4 nums: %d,%d,%d,%d', [fNums[1],fNums[2],fNums[3],fNums[4]] ));

  for i:=1 to NUMS_COUNT do begin
    fRationals[i] := intToRational(fNums[i]);
    fExprs[i] := rationalToExpr(fRationals[i]);
  end;

  ioList1:=TInputOutputList.create;
  for i:=1 to NUMS_COUNT do begin
    ioList1.inputList.Add(@fExprs[i]);
  end;
  combination(4,2,ioList1,@intArrayCallback1);
  for i:=0 to ioList1.outputList.Count-1 do begin
    expr :=ioList1.outputList.Items[i];
    log(exprToStr(expr));
  end;

  combination(3,2,ioList1,@intArrayCallback2);

end;

end.

