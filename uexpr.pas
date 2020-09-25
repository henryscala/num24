unit uexpr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, urational;
type

TExprType = (etTerminal,etNonTerminal);
PExpr = ^TExpr;
TExpr = record
  case exprType:TExprType of
  etTerminal:(rational:TRational);
  etNonTerminal:(op:char;expr1:^TExpr;expr2:^TExpr);
end;
TIntArrayCallBack = procedure(context:pointer;ary:array of integer) of object;
function calculateExpr(expr:PExpr):TRational;
function enumerateExpr2(r1,r2:PExpr;ops:array of char):TList;
function rationalToExpr(r:TRational):TExpr;
function exprToStr(expr:PExpr):String;
procedure combination(n,r:integer;context:pointer;call:TIntArrayCallBack );
implementation
function exprOfOp(r1,r2:PExpr;op:char): PExpr;
var
  expr:PExpr;
begin

  new(expr);
  expr^.exprType:=etNonTerminal;
  expr^.op:=op;
  expr^.expr1:=r1;
  expr^.expr2:=r2;
  result:=expr;
end;

function rationalToExpr(r:TRational):TExpr;
begin
  result.exprType:=etTerminal;
  result.rational:=r;
end;

function enumerateExpr2(r1,r2:PExpr;ops:array of char):TList;
var
  i:integer;
  expr:^TExpr;
  v1,v2:TRational;
begin
  result := TList.Create;

  for i := low(ops) to high(ops) do begin
    case ops[i] of
      '+','*': begin
        expr := exprOfOp(r1,r2,ops[i]);
        result.Add(expr);
      end;
      '-': begin
        expr := exprOfOp(r1,r2,ops[i]);
        result.Add(expr);
        v1 := r1^.rational;
        v2 := r2^.rational;
        if not rationalEqual(v1,v2) then begin
          expr := exprOfOp(r2,r1,ops[i]);
          result.Add(expr);
        end;
      end;
      '/': begin
        if calculateExpr(r2).n <> 0 then begin
          expr := exprOfOp(r1,r2,ops[i]);
          result.Add(expr);
        end;
        v1 := r1^.rational;
        v2 := r2^.rational;
        if not rationalEqual(v1,v2) then begin
          if calculateExpr(r1).n <> 0 then begin
            expr := exprOfOp(r2,r1,ops[i]);
            result.Add(expr);
          end;
        end;
      end;
    end;
  end;
end;

function calculateExpr(expr:PExpr):TRational;
begin
  if expr^.exprType = etTerminal then begin
    result:=expr^.rational;
  end else begin
    case expr^.op of
      '+': result := rationalAdd(calculateExpr(expr^.expr1),calculateExpr(expr^.expr2));
      '-': result := rationalSub(calculateExpr(expr^.expr1),calculateExpr(expr^.expr2));
      '*': result := rationalMul(calculateExpr(expr^.expr1),calculateExpr(expr^.expr2));
      '/': result := rationalDiv(calculateExpr(expr^.expr1),calculateExpr(expr^.expr2));
    end;
  end;
end;
function exprToStr(expr:PExpr):String;
begin
  if expr^.exprType = etTerminal then begin
    result:=rationalToStr(expr^.rational);
  end else begin
    result:=concat('(',exprToStr(expr^.expr1),expr^.op,exprToStr(expr^.expr1),')');
  end;
end;

procedure combination(n,r:integer;context:pointer;call:TIntArrayCallBack);
var
  ary:array of integer;
  i,k:integer;
  finished:boolean;
begin
   setLength(ary,r);

   for i:=0 to r-1 do ary[i]:=i;
   call(context,ary);
   finished:=false;
   while not finished do
   begin
       finished:=true;
       for i := r-1 downto 0 do
       begin
           if ary[i]<i+n-r then
           begin
               inc(ary[i]);
               finished := false;
               for k:=i+1 to r-1 do
               begin
                   ary[k]:=ary[k-1]+1;
               end;
               call(context,ary);
               break;
           end;
       end;
   end;


end;




end.

