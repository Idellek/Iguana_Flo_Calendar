-- cycle_reader.lua
-- Handles reading and parsing cycle_data.json
-- Includes error handling for missing files and invalid JSON

function CYCLEread()
   iguana.logInfo("📂 Reading cycle data file...")
   
   -- Check if file exists
   local file = io.open("C:\\Users\\user\\OneDrive\\Documents\\Iguana_Flo_Calendar\\cycle_data.json", "r")
   
   if not file then
      iguana.logError("❌ ERROR: cycle_data.json not found!")
      iguana.logError("💡 Make sure cycle_data.json exists in the project folder")
      return nil
   end
   
   local content = file:read("*all")
   file:close()
   
   -- Check if file is empty
   if not content or content == "" then
      iguana.logError("❌ ERROR: cycle_data.json is empty!")
      return nil
   end
   
   -- Safely parse JSON
   local success, cycle_data = pcall(function()
      return json.parse{data=content}
   end)
   
   if not success then
      iguana.logError("❌ ERROR: Invalid JSON in cycle_data.json!")
      iguana.logError("💡 Check your JSON formatting")
      return nil
   end
   
   -- Validate required fields
   if not cycle_data.user then
      iguana.logError("❌ ERROR: Missing 'user' field in cycle_data.json!")
      return nil
   end
   
   if not cycle_data.last_period_start then
      iguana.logError("❌ ERROR: Missing 'last_period_start' field in cycle_data.json!")
      return nil
   end
   
   if not cycle_data.phases then
      iguana.logError("❌ ERROR: Missing 'phases' field in cycle_data.json!")
      return nil
   end
   
   if #cycle_data.phases == 0 then
      iguana.logError("❌ ERROR: No phases found in cycle_data.json!")
      return nil
   end
   
   iguana.logInfo("✅ Cycle data loaded successfully for: " .. cycle_data.user)
   iguana.logInfo("📋 Found " .. tostring(#cycle_data.phases) .. " phases")
   
   return cycle_data
end