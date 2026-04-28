from calendar_auth import authenticate_google_calendar

def clear_cycle_events():
    service = authenticate_google_calendar()
    total_deleted = 0
    
    while True:
        events_result = service.events().list(
            calendarId='primary',
            maxResults=2500
        ).execute()
        
        events = events_result.get('items', [])
        deleted = 0
        
        for event in events:
            summary = event.get('summary', '')
            if 'Phase' in summary and '🌸' in summary:
                service.events().delete(
                    calendarId='primary',
                    eventId=event['id']
                ).execute()
                print(f"🗑️ Deleted: {summary}")
                deleted += 1
        
        total_deleted += deleted
        if deleted == 0:
            break
    
    print(f"\n✅ Total deleted: {total_deleted} cycle events!")

if __name__ == '__main__':
    clear_cycle_events()