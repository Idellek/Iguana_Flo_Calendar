-- phase_calc.lua
-- Handles cycle day and phase calculation
-- Includes error handling for invalid dates and missing phases

function PHASEcalculateDay(last_period_start)
   iguana.logInfo("🔢 Calculating current cycle day...")
   
   -- Validate date format
   local year, month, day = last_period_start:match("(%d+)-(%d+)-(%d+)")
   
   if not year or not month or not day then
      iguana.logError("❌ ERROR: Invalid date format in last_period_start!")
      iguana.logError("💡 Expected format: YYYY-MM-DD, got: " .. tostring(last_period_start))
      return nil
   end
   
   -- Safely calculate cycle day
   local success, result = pcall(function()
      local today = os.time()
      local start = os.time{
         year=tonumber(year), 
         month=tonumber(month), 
         day=tonumber(day), 
         hour=0, min=0, sec=0
      }
      local diff = os.difftime(today, start)
      return math.floor(diff / 86400) + 1
   end)
   
   if not success then
      iguana.logError("❌ ERROR: Failed to calculate cycle day!")
      iguana.logError("💡 Check that last_period_start is a valid date")
      return nil
   end
   
   -- Check if cycle day is reasonable
   if result < 1 then
      iguana.logError("❌ ERROR: Cycle day is negative - last_period_start is in the future!")
      return nil
   end
   
   if result > 60 then
      iguana.logWarning("⚠️ WARNING: Cycle day is " .. tostring(result) .. " - cycle data may be outdated!")
   end
   
   iguana.logInfo("📅 Cycle Day: " .. tostring(result))
   return result
end

function PHASEgetCurrent(phases, cycle_day)
   if not cycle_day then
      iguana.logError("❌ ERROR: Cannot determine phase - invalid cycle day!")
      return nil
   end
   
   iguana.logInfo("🔍 Finding current phase for day " .. tostring(cycle_day) .. "...")
   
   for i = 1, #phases do
      local phase = phases[i]
      
      -- Validate phase has required fields
      if not phase.phase or not phase.start_day or not phase.end_day then
         iguana.logError("❌ ERROR: Phase " .. tostring(i) .. " is missing required fields!")
         return nil
      end
      
      if cycle_day >= phase.start_day and cycle_day <= phase.end_day then
         iguana.logInfo("🌸 Current Phase: " .. phase.phase)
         iguana.logInfo("⚡ Energy: " .. phase.energy)
         iguana.logInfo("😊 Mood: " .. phase.mood)
         iguana.logInfo("💡 Recommendation: " .. phase.recommendation)
         return phase
      end
   end
   
   iguana.logWarning("⚠️ WARNING: Cycle day " .. tostring(cycle_day) .. " falls outside all defined phases!")
   iguana.logWarning("💡 This may indicate an irregular cycle - consider updating cycle data")
   return nil
end

function PHASEgetAllDates(phases, last_period_start)
   iguana.logInfo("📆 Calculating phase dates...")
   
   local year, month, day = last_period_start:match("(%d+)-(%d+)-(%d+)")
   local period_start = os.time{
      year=tonumber(year), 
      month=tonumber(month), 
      day=tonumber(day), 
      hour=0, min=0, sec=0
   }
   
   local phase_dates = {}
   for i = 1, #phases do
      local phase = phases[i]
      local start_date = period_start + ((phase.start_day - 1) * 86400)
      local end_date = period_start + ((phase.end_day) * 86400)
      
      table.insert(phase_dates, {
         phase = phase.phase,
         energy = phase.energy,
         mood = phase.mood,
         recommendation = phase.recommendation,
         color_id = phase.color_id,
         start_date = os.date("%Y-%m-%d", start_date),
         end_date = os.date("%Y-%m-%d", end_date)
      })
   end
   
   iguana.logInfo("✅ Calculated dates for " .. tostring(#phase_dates) .. " phases")
   return phase_dates
end