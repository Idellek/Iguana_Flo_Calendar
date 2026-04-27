import json
from datetime import datetime, timedelta, timezone
from calendar_auth import authenticate_google_calendar

def load_cycle_data(filepath='cycle_data.json'):
    with open(filepath, 'r') as f:
        return json.load(f)

def get_current_phase(cycle_data):
    last_period = datetime.strptime(
        cycle_data['last_period_start'], '%Y-%m-%d'
    )
    today = datetime.now()
    cycle_day = (today - last_period).days + 1
    
    print(f"📅 Today is cycle day {cycle_day}")
    
    for phase in cycle_data['phases']:
        if phase['start_day'] <= cycle_day <= phase['end_day']:
            return phase, cycle_day
    
    return None, cycle_day

def create_phase_events(service, cycle_data):
    last_period = datetime.strptime(
        cycle_data['last_period_start'], '%Y-%m-%d'
    )
    
    created_events = []
    
    for phase in cycle_data['phases']:
        # Calculate phase start and end dates
        phase_start = last_period + timedelta(days=phase['start_day'] - 1)
        phase_end = last_period + timedelta(days=phase['end_day'])
        
        # Create event
        event = {
            'summary': f"🌸 {phase['phase'].capitalize()} Phase",
            'description': (
                f"Phase: {phase['phase'].capitalize()}\n"
                f"Energy: {phase['energy'].capitalize()}\n"
                f"Mood: {phase['mood'].capitalize()}\n\n"
                f"💡 Recommendation: {phase['recommendation']}"
            ),
            'start': {
                'date': phase_start.strftime('%Y-%m-%d'),
            },
            'end': {
                'date': phase_end.strftime('%Y-%m-%d'),
            },
            'colorId': phase['color_id'],
            'reminders': {
                'useDefault': False,
                'overrides': [
                    {'method': 'popup', 'minutes': 1440},
                    {'method': 'email', 'minutes': 60},
                ],
            },
        }
        
        created_event = service.events().insert(
            calendarId='primary',
            body=event
        ).execute()
        
        created_events.append(created_event)
        print(f"✅ Created: {created_event['summary']} "
              f"({phase_start.strftime('%b %d')} - "
              f"{phase_end.strftime('%b %d')})")
    
    return created_events

if __name__ == '__main__':
    print("🌸 Cycle to Calendar Integration Starting...\n")
    
    # Load cycle data
    cycle_data = load_cycle_data()
    print(f"👤 User: {cycle_data['user']}")
    print(f"📆 Cycle Length: {cycle_data['cycle_length']} days")
    print(f"🩸 Last Period Start: {cycle_data['last_period_start']}\n")
    
    # Get current phase
    current_phase, cycle_day = get_current_phase(cycle_data)
    if current_phase:
        print(f"🔍 Current Phase: {current_phase['phase'].capitalize()}")
        print(f"⚡ Energy: {current_phase['energy'].capitalize()}")
        print(f"😊 Mood: {current_phase['mood'].capitalize()}")
        print(f"💡 Recommendation: {current_phase['recommendation']}\n")
    
    # Authenticate and create events
    print("🔐 Authenticating with Google Calendar...")
    service = authenticate_google_calendar()
    print("✅ Authenticated!\n")
    
    print("📅 Creating cycle phase events in Google Calendar...")
    events = create_phase_events(service, cycle_data)
    
    print(f"\n🎉 Success! Created {len(events)} phase events in your calendar!")
    print("Open Google Calendar to see your cycle phases! 🌸")