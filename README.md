# 🌸 Cycle Awareness Integration

## The Problem
Women track their menstrual cycles in apps like Flo, but that 
data lives completely separately from where they plan their 
lives — their calendar. This disconnect means important 
meetings, presentations, and events get scheduled on low 
energy days without awareness.

## The Solution
A data integration pipeline built with IguanaX that bridges 
the gap between cycle health data and daily planning by 
automatically routing menstrual phase insights into 
Google Calendar.

## How It Works
Flo Health Data (JSON) → IguanaX Timer → Lua Translator → Google Calendar API
1. **cycle_data.json** — Simulates a Flo app JSON export containing cycle dates and phase data
2. **IguanaX Timer** — Triggers the integration daily at midnight
3. **Lua Translator** — Reads cycle data, calculates current phase, checks for existing events
4. **Google Calendar API** — Creates color coded phase events with energy, mood and scheduling recommendations

## Cycle Phases
| Phase | Days | Energy | Focus |
|-------|------|--------|-------|
| 🔴 Menstrual | 1-5 | Low | Rest and light tasks |
| 🟢 Follicular | 6-13 | High | Creative work and presentations |
| 🟡 Ovulation | 14-16 | Peak | Important decisions and interviews |
| 🟣 Luteal | 17-28 | Declining | Individual focused tasks |

## Features
- Automatically creates color coded cycle phase events in Google Calendar
- Calculates current cycle day and identifies active phase
- Prevents duplicate event creation
- 7 AM reminder the day before each phase transition
- Dynamic — updates automatically when cycle data changes
- Multi user potential for partners and family awareness

## Tech Stack
- **IguanaX** — Integration engine and orchestrator
- **Lua** — Native IguanaX scripting language for data transformation
- **Python** — Google Calendar OAuth authentication
- **Google Calendar API** — Event creation and management
- **JSON** — Structured cycle data format

## Project Structure
Iguana_Flo_Calendar/
├── iguana/
│── main.lua          # Entry point and orchestrator
│── cycle_reader.lua  # Reads and parses cycle JSON data
│── phase_calc.lua    # Calculates cycle day and phase
│ └── calendar_api.lua # Google Calendar API integration
├── cycle_data.json       # Sample Flo health data export
├── calendar_auth.py      # Google OAuth authentication
├── cycle_to_calendar.py  # Python Calendar integration
├── clear_calendar.py     # Utility to clear cycle events
└── requirements.txt      # Python dependencies

## Setup
1. Clone the repo
2. Install Python dependencies:
pip install -r requirements.txt
3. Add your Google OAuth credentials as `credentials.json`
4. Run authentication:
python calendar_auth.py
5. Open IguanaX and start the Timer component
6. Check Google Calendar for your cycle phase events!

## Impact
This integration goes beyond personal planning. Partners, 
family members and colleagues can benefit from cycle 
awareness — understanding when someone needs a quieter week 
or when they are at peak performance. Menstrual health is 
underaccommodated in technology and the workplace. This is 
a step toward changing that.

## Author
Idelle Kahyeba
