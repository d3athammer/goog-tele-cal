require 'telegram/bot'
require 'google/apis/calendar_v3'

# Your Telegram bot token
token = <your_telegram_bot_token>

# Your Google Calendar API credentials
credentials = Google::Auth::UserRefreshCredentials.new(
  client_id: <your_client_id>,
  client_secret: <your_client_secret>,
  access_token: <your_access_token>,
  refresh_token: <your_refresh_token>,
)

# Initialize the Google Calendar API client
calendar = Google::Apis::CalendarV3::CalendarService.new
calendar.authorization = credentials

# Start a Telegram Bot
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    # Ask the user for the shared calendar to create an event
    bot.api.send_message(chat_id: message.chat.id, text: "Which shared calendar would you like to create the event on?")
    calendar_id = bot.listen do |message|
      break message.text
    end

    # Ask the user for the name of the event
    bot.api.send_message(chat_id: message.chat.id, text: "What is the name of the event?")
    event_summary = bot.listen do |message|
      break message.text
    end

    # Ask the user for the date of the event
    bot.api.send_message(chat_id: message.chat.id, text: "What is the date of the event (in the format YYYY-MM-DD)?")
    event_date = bot.listen do |message|
      break message.text
    end

    # Ask the user for the start time of the event
    bot.api.send_message(chat_id: message.chat.id, text: "What is the start time of the event (in the format HH:MM)?")
    start_time = bot.listen do |message|
      break message.text
    end

    # Ask the user for the end time of the event
    bot.api.send_message(chat_id: message.chat.id, text: "What is the end time of the event (in the format HH:MM)?")
    end_time = bot.listen do |message|
      break message.text
    end

    # Combine the date and time to create a full ISO-8601 formatted start and end time
    event_start_time = "#{event_date}T#{start_time}:00.000Z"
    event_end_time = "#{event_date}T#{end_time}:00.000Z"

    # Use the Google Calendar API to create a new event
    result = calendar.insert_event(
      calendar_id,
      Google::Apis::CalendarV3::Event.new(
        summary: event_summary,
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: event_start_time,
          time_zone: 'UTC'
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: event_end_time,
          time_zone: 'UTC'
        )
      )
    )
    bot.api.send_message(chat_id: message.chat.id, text: "Event '#{result.summary}' created successfully.")
  end
end
