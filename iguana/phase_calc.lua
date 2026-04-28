-- phase_calc.lua
-- Handles cycle day and phase calculation

function PHASEcalculateDay(last_period_start)
   local year, month, day = last_period_start:match("(%d+)-(%d+)-(%d+)")
   
   local today = os.time()
   local start = os.time{year=year, month=month, day=day, hour=0, min=0, sec=0}
   
   local diff = os.difftime(today, start)
   local cycle_day = math.floor(diff / 86400) + 1
   
   iguana.logInfo("📅 Cycle Day: " .. tostring(cycle_day))
   
   return cycle_day
end

function PHASEgetCurrent(phases, cycle_day)
   for i = 1, #phases do
      local phase = phases[i]
      if cycle_day >= phase.start_day and cycle_day <= phase.end_day then
         iguana.logInfo("🌸 Current Phase: " .. phase.phase)
         iguana.logInfo("⚡ Energy: " .. phase.energy)
         iguana.logInfo("😊 Mood: " .. phase.mood)
         iguana.logInfo("💡 Recommendation: " .. phase.recommendation)
         return phase
      end
   end
   iguana.logError("❌ Could not determine current phase!")
   return nil
end

function PHASEgetAllDates(phases, last_period_start)
   local year, month, day = last_period_start:match("(%d+)-(%d+)-(%d+)")
   local period_start = os.time{year=year, month=month, day=day, hour=0, min=0, sec=0}
   
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
   
   return phase_dates
end