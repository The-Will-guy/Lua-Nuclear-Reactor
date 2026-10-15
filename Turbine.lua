local SteamRPMCoefficient = 0.003252
local TurbineLag = 1
local SteamAmount = 0
local amountBoiled = 225
local SteamPressureCoefficient = 0.17 --Or 0.017 idk. Bc we multiply all values with it, the pressure change will scale the same and no change will be present. Will def affect mcc and cond I think since it Modifies the amount of steam in the reactor(See SteamAmount)
local TurbineValv = true
local GenBreaker =
local TurbineSetting = 19 -- percent
local BypassSetting = 0   -- percent
local TurbineSteamCoefficient = 0.2405
local BypassSteamCoefficient = 0.06943662

for i = 1, 10000 do
  

  
  local pressure = SteamAmount * SteamPressureCoefficient
  if TurbineValv and then 
    TurbineSteam = (TurbineSetting/100) * TurbineSteamCoefficient * pressure
  else
    TurbineSteam = 0
    end
  local BypassSteam = (BypassSetting/100) * BypassSteamCoefficient * pressure
  if not GenBreaker then
    local RPM = 0
    local RPMGoal = TurbineSteam * pressure * SteamRPMCoefficient
    RPM = RPM + (RPMGoal - RPM)/TurbineLag
  end
  TotalOutflow = TurbineSteam + BypassSteam
  if TotalOutflow > SteamAmount then
    Scale = SteamAmount/TotalOutflow
    TurbineSteam = TurbineSteam*Scale
    BypassSteam = BypassSteam*Scale
  end
  SteamAmount = SteamAmount + (amountBoiled - TurbineSteam - BypassSteam)
  pressure = SteamAmount * SteamPressureCoefficient
  

  
  --print(SteamAmount, pressure, TotalOutflow)
  print(RPM, pressure, TurbineSteam)


  end
  