
local SteamRPMCoefficient = 0.0033262 --Calibrated to 10APRM = 3600rpm
local TurbineLag = 100 -- A bit of lag? Dunno, it felt right
local SteamAmount = 0
local amountBoiled = 225
local SteamPressureCoefficient = 0.17 --Or 0.017 idk. Bc we multiply all values with it, the pressure change will scale the same and no change will be present. Will def affect mcc and cond I think since it Modifies the amount of steam in the reactor(See SteamAmount)
local TurbineValv = true-- 
local GenBreaker = false -- Auto synce for the moment
local TurbineSetting = 19 -- percent
local BypassSetting = 0   -- percent
local TurbineSteamCoefficient = 0.2405 -- Tested in game 
local BypassSteamCoefficient = 0.06943662 -- Assuming 30APRM = 100% bypass
local RPM = 0
local phase = 0
local SyncRPM = 3600
local PhaseCoefficient = 3 -- In the documentation
local SyncTurbineSteam = 222.39
local SteamToMW = 209.84868
local GeneratorLoad = 0



-- saw it a lot, maybe useful
local function clamp(x,lo,hi)
  if x < lo then return lo 
elseif x > hi then return hi
else return x
end
end

for i = 1, 5000 do 
  if RPM < 0.5 then
    RPM = 0
    end

  
  local pressure = SteamAmount * SteamPressureCoefficient
  if TurbineValv then 
    TurbineSteam = (TurbineSetting/100) * TurbineSteamCoefficient * pressure
  else
    TurbineSteam = 0
    end
  local BypassSteam = (BypassSetting/100) * BypassSteamCoefficient * pressure
  
  TotalOutflow = TurbineSteam + BypassSteam
  if TotalOutflow > SteamAmount then
    Scale = SteamAmount/TotalOutflow
    TurbineSteam = TurbineSteam*Scale 
    BypassSteam = BypassSteam*Scale
  end
  
  if not GenBreaker then
    GeneratorLoad = 0
    local RPMGoal = TurbineSteam * pressure * SteamRPMCoefficient
    RPM = RPM + (RPMGoal - RPM)/TurbineLag
    local phase = math.fmod(phase + PhaseCoefficient * (RPM - SyncRPM), SyncRPM)
    local angle = phase/SyncRPM * 360
  
  if (angle > 355 or angle < 5) and RPM > 3595 and RPM < 3605 and pressure > 4000 and TurbineValv then
    GenBreaker = true
end

  else
    RPM = 3600
    GeneratorLoad = (TurbineSteam/SyncTurbineSteam - 1) * SteamToMW
  end
  


  SteamAmount = SteamAmount + (amountBoiled - TurbineSteam - BypassSteam)
  pressure = math.max(0,SteamAmount * SteamPressureCoefficient)
  

  
  --print(SteamAmount, pressure, TotalOutflow)
  print(RPM, pressure, TurbineSteam, GeneratorLoad)


end
  
