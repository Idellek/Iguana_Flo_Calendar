-- calendar_api.lua
-- Handles Google Calendar API calls via HTTP

function CALENDARgetToken()
   local file = io.open("C:\\Users\\user\\OneDrive\\Documents\\Iguana_Flo_Calendar\\token.json", "r")
   if not file then
      iguana.logError("❌ Could not find token.json!")
      return nil
   end
   local content = file:read("*all")
   file:close()
   
   local token_data = json.parse{data=content}
   return token_data.token
end

function CALENDARcheckEventsExist(token)
   local response = net.http.get{
      url = "https://www.googleapis.com/calendar/v3/calendars/primary/events?q=Phase",
      headers = {
         ["Authorization"] = "Bearer " .. token,
         ["Content-Type"] = "application/json"
      },
      live = true
   }
   
   if response then
      local data = json.parse{data=response}
      local items = data.items or {}
      for i = 1, #items do
         if items[i].summary and 
            items[i].summary:find("Phase") and 
            items[i].summary:find("🌸") then
            return true
         end
      end
   end
   return false
end

function CALENDARcreateEvent(phase_date, token)
   local event = {
   summary = "🌸 " .. phase_date.phase:gsub("^%l", string.upper) .. " Phase",
   description = "Phase: " .. phase_date.phase:gsub("^%l", string.upper) .. "\n" ..
                "Energy: " .. phase_date.energy:gsub("^%l", string.upper) .. "\n" ..
                "Mood: " .. phase_date.mood:gsub("^%l", string.upper) .. "\n\n" ..
                "💡 Recommendation: " .. phase_date.recommendation,
   start = {date = phase_date.start_date},
   ["end"] = {date = phase_date.end_date},
   colorId = phase_date.color_id,
   reminders = {
      useDefault = false,
      overrides = {
         {method = "popup", minutes = 1020},
         {method = "email", minutes = 1020},
      }
   }
}
   local response = net.http.post{
      url = "https://www.googleapis.com/calendar/v3/calendars/primary/events",
      headers = {
         ["Authorization"] = "Bearer " .. token,
         ["Content-Type"] = "application/json"
      },
      body = json.serialize{data=event},
      live = true
   }
   
   if response then
      iguana.logInfo("✅ Created calendar event: " .. phase_date.phase)
   else
      iguana.logError("❌ Failed to create event for: " .. phase_date.phase)
   end
end

function CALENDARcreateAllEvents(phase_dates, token)
   -- Check if events already exist
   if CALENDARcheckEventsExist(token) then
      iguana.logInfo("📅 Calendar events already exist - skipping creation")
      return
   end
   
   iguana.logInfo("📅 Creating " .. tostring(#phase_dates) .. " calendar events...")
   for i = 1, #phase_dates do
      CALENDARcreateEvent(phase_dates[i], token)
   end
   iguana.logInfo("🎉 All calendar events created successfully!")
end