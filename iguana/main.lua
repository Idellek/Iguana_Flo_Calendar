-- main.lua
-- Cycle Intelligence Integration
-- Connects Flo cycle data to Google Calendar via IguanaX

require "cycle_reader"
require "phase_calc"
require "calendar_api"

-- Cache variables - stored in memory, not read from disk every tick
local CachedToken = nil
local EventsCreated = false

function main()
   -- Set timer - 5 seconds for demo, 86400000 for production (24 hours)
   component.setTimer{delay=5000}
   
   iguana.logInfo("🌸 Cycle Intelligence Integration Running...")
   
   -- Step 1: Read cycle data
   local cycle_data = CYCLEread()
   if not cycle_data then return end
   
   -- Step 2: Calculate current cycle day and phase
   local cycle_day = PHASEcalculateDay(cycle_data.last_period_start)
   local current_phase = PHASEgetCurrent(cycle_data.phases, cycle_day)
   if not current_phase then return end
   
   -- Step 3: Get token once and cache it
   if not CachedToken then
      iguana.logInfo("🔐 Loading token for first time...")
      CachedToken = CALENDARgetToken()
      if not CachedToken then return end
      iguana.logInfo("✅ Token cached successfully!")
   else
      iguana.logInfo("⚡ Using cached token - no disk read needed!")
   end
   
   -- Step 4: Create events only once
   if not EventsCreated then
      iguana.logInfo("📅 First run - creating calendar events...")
      local phase_dates = PHASEgetAllDates(cycle_data.phases, cycle_data.last_period_start)
      CALENDARcreateAllEvents(phase_dates, CachedToken)
      EventsCreated = true
      iguana.logInfo("✅ Events created and flag set - won't create again!")
   else
      iguana.logInfo("⚡ Events already exist - skipping API call!")
   end
   
   iguana.logInfo("✅ Cycle Intelligence Integration Complete!")
end

main()