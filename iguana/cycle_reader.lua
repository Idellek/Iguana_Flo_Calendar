-- cycle_reader.lua
-- Handles reading and parsing cycle_data.json

function CYCLEread()
   local file = io.open("C:\\Users\\user\\OneDrive\\Documents\\Iguana_Flo_Calendar\\cycle_data.json", "r")
   
   if not file then
      iguana.logError("❌ Could not find cycle_data.json!")
      return nil
   end
   
   local content = file:read("*all")
   file:close()
   
   local cycle_data = json.parse{data=content}
   iguana.logInfo("✅ Cycle data loaded for: " .. cycle_data.user)
   
   return cycle_data
end