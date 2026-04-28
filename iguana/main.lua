-- main.lua
-- Cycle Intelligence Integration
-- Connects Flo cycle data to Google Calendar via IguanaX

require "cycle_reader"
require "phase_calc"
require "calendar_api"

function main()
   -- Set timer - 5 seconds for demo, 86400000 for production (24 hours)
   component.setTimer{delay=86400000}
   
   iguana.logInfo("🌸 Cycle Intelligence Integration Starting...")
   
   -- Step 1: Read cycle data
   local cycle_data = CYCLEread()
   if not cycle_data then return end
   
   -- Step 2: Calculate current cycle day and phase
   local cycle_day = PHASEcalculateDay(cycle_data.last_period_start)
   local current_phase = PHASEgetCurrent(cycle_data.phases, cycle_day)
   if not current_phase then return end
   
   -- Step 3: Get all phase dates for calendar
   local phase_dates = PHASEgetAllDates(cycle_data.phases, cycle_data.last_period_start)
   
   -- Step 4: Get Google Calendar token
   local token = CALENDARgetToken()
   if not token then return end
   
   -- Step 5: Create calendar events
   CALENDARcreateAllEvents(phase_dates, token)
   
   iguana.logInfo("✅ Cycle Intelligence Integration Complete!")
end

main()