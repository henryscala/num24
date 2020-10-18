
const 
  Threshold:float = 1e-6    
  CardsNumber:int = 4 
  ResultValue:int = 24

#[
var 
  number:array[CardsNumber,float]
  resultExp:array[CardsNumber,string]
]#


  

proc pointsGame(n:int,number:var array[CardsNumber,float], resultExp:var array[CardsNumber,string]): bool =
  if n == 1:
    if abs(number[0] - ResultValue.float) < Threshold:
      return true 
    else:
      return false
  
  for i in 0..<n:
    for j in i+1..<n:
      var
        a,b:float
        expa,expb:string
      
      a = number[i]
      b = number[j]
      number[j] = number[n-1]
      expa = resultExp[i]
      expb = resultExp[j]
      resultExp[j] = resultExp[n-1]

      resultExp[i] = "(" & expa & "+" & expb & ")"
      number[i] = a + b 
      if pointsGame(n-1,number,resultExp):
        return true 

      resultExp[i] = "(" & expa & "-" & expb & ")"
      number[i] = a - b 
      if pointsGame(n-1,number,resultExp):
        return true 

      resultExp[i] = "(" & expb & "-" & expa & ")"
      number[i] = b - a 
      if pointsGame(n-1,number,resultExp):
        return true 

      resultExp[i] = "(" & expa & "*" & expb & ")"
      number[i] = a * b 
      if pointsGame(n-1,number,resultExp):
        return true 

      if b != 0:
        resultExp[i] = "(" & expa & "/" & expb & ")"
        number[i] = a / b 
        if pointsGame(n-1,number,resultExp):
          return true 
      
      if a != 0:
        resultExp[i] = "(" & expb & "/" & expa & ")"
        number[i] = b / a 
        if pointsGame(n-1,number,resultExp):
          return true 

      number[i] = a
      number[j] = b  
      resultExp[i] = expa 
      resultExp[j] = expb
  
  return false

# if result is not found, result string is empty(not null); otherwise, the result is the expression
proc pointsGameWrapper*(num1,num2,num3,num4:cint):cstring {.exportc.} = 
  var 
    number:array[CardsNumber,float]
    resultExp:array[CardsNumber,string]
    res:bool;
  number = [num1.float,num2.float,num3.float,num4.float]
  resultExp = [$num1,$num2,$num3,$num4]
  res = pointsGame(CardsNumber,number,resultExp)
  if not res:
    result = ""
  else:
    result = resultExp[0]

#when isMainModule:
  #echo pointsGameWrapper(3,4,1,2)
  #echo pointsGameWrapper(3,3,3,7)
  #echo pointsGameWrapper(5,5,5,1)
