unit urational;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TRational = record
    n:integer;
    d:integer;
  end;
  function rationalToStr(r:TRational):String;
  function rationalToInt(r:TRational):Integer;
  function intToRational(int:integer):TRational;
  function rationalSimplify(r:TRational):TRational;
  function rationalAdd(r1,r2:TRational):TRational;
  function rationalSub(r1,r2:TRational):TRational;
  function rationalMul(r1,r2:TRational):TRational;
  function rationalDiv(r1,r2:TRational):TRational;
  function rationalEqual(r1,r2:TRational):boolean;
  //great common divider
  function gcd(a,b:integer):integer;
  //least common multiple
  function lcm(a,b:integer):integer;
implementation
  function gcd(a,b:integer):integer;
  var
    rem :integer;
  begin
    while b <> 0 do begin
      rem := a mod b;
      a := b;
      b := rem;
    end;
    result := a;
  end;
  function lcm(a,b:integer):integer;
  begin
    result := a * b div gcd(a,b);
  end;
  function rationalAdd(r1,r2:TRational):TRational;
  begin
    result.n := r1.n * r2.d + r2.n * r1.d;
    result.d := r1.d * r2.d;
    result := rationalSimplify(result);
  end;

  function rationalSub(r1,r2:TRational):TRational;
  begin
    result := r2;
    result.n:= -result.n;
    result := rationalAdd(r1,result);
  end;

  function rationalMul(r1,r2:TRational):TRational;
  begin
    result.n := r1.n*r2.n;
    result.d := r1.d*r2.d;
    result := rationalSimplify(result);
  end;
  function rationalDiv(r1,r2:TRational):TRational;
  begin
    result.n := r2.d;
    result.d := r2.n;
    result:=rationalMul(r1,result);
  end;
  function rationalSimplify(r:TRational):TRational;
  var
    commonFactor:integer;
    sign:integer;
  begin
    sign:=r.n*r.d;
    result.n:=abs(r.n);
    result.d:=abs(r.d);
    commonFactor := gcd(result.n,result.d);

    if commonFactor > 1 then begin
       result.n:=result.n div commonFactor;
       result.d:=result.d div commonFactor;
    end;
    if sign < 0 then begin
       result.n := -result.n;
    end;
  end;
  function rationalToStr(r:TRational):String;
  begin
    if r.d > 1 then begin
      result := format('%d/%d',[r.n,r.d]);
    end else begin
      result := format('%d',[r.n]);
    end;
  end;
  function rationalToInt(r:TRational):Integer;
  begin
    if r.d = 1 then begin
      result := r.n;
    end else begin
      result := trunc(real(r.n) / real(r.d));
    end;
  end;

  function intToRational(int:integer):TRational;
  begin
    result.n:=int;
    result.d:=1;
  end;
  function rationalEqual(r1,r2:TRational):boolean;
  begin
    result := (r1.n = r2.n) and (r1.d = r2.d);
  end;

end.

