import json
from datetime import datetime, timedelta
from calendar_auth import authenticate_google_calendar

def create_test_event():
    # Authenticate
    service = authenticate_google_calendar()
    
    # Define a test event
    event = {
        'summary': '🌸 Follicular Phase - High Energy Day',
        'description': 'You are in your follicular phase!\n\nEnergy: High\nMood: Confident\nRecommendation: Great day to schedule important meetings, presentations, or interviews!',
        'start': {
            'dateTime': (datetime.utcnow() + timedelta(days=1)).strftime('%Y-%m-%dT09:00:00'),
            'timeZone': 'America/Edmonton',
        },
        'end': {
            'dateTime': (datetime.utcnow() + timedelta(days=1)).strftime('%Y-%m-%dT10:00:00'),
            'timeZone': 'America/Edmonton',
        },
        'colorId': '2',  # Green for follicular phase
    }
    
    # Create the event
    created_event = service.events().insert(
        calendarId='primary',
        body=event
    ).execute()
    
    print(f"✅ Event created successfully!")
    print(f"📅 Event: {created_event['summary']}")
    print(f"🔗 Link: {created_event.get('htmlLink')}")

if __name__ == '__main__':
    create_test_event()