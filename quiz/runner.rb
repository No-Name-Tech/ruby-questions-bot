require_relative 'quiz'
require_relative 'input_reader'
require_relative 'file_writer'
require_relative 'statistics'
require_relative 'engine'

class Runner
  def initialize(bot)
    @quiz = Quiz.instance
    @input_reader = InputReader.new
    @bot = bot
  end

  def run
    @bot.listen do |message|
      case message.text
      when '/start', 'Start'
        handle_start_command(message)
        send_initial_message(message)
      when '/stop', 'Stop'
        handle_stop_command(message)
      else
        send_initial_message(message)
      end
    end
  end

  private

  def handle_start_command(message)
    username = message.from.first_name
    start_time = Time.now
    send_start_message(message, username)
    engine = Engine.new(@bot, message.chat.id, username)
    engine.start_bot
    handle_quiz_completion(message, start_time)
  end

  def handle_stop_command(message)
    @bot.api.send_message(chat_id: message.chat.id, text: "До побачення, #{message.from.first_name}!")
  end

  def send_initial_message(message)
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [
        [{ text: "Start" }, { text: "Stop" }],
      ],
      one_time_keyboard: true,
      resize_keyboard: true
    )
  end

  def send_start_message(message, username)
    answer = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [
        [{ text: "Почати тестування" }],
      ],
      one_time_keyboard: true,
      resize_keyboard: true
    )
    text = "#{username}, натисніть кнопку Почати тестування\n/start для початку.\n/stop для виходу.\n"
    @bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: answer)
  end

  def handle_quiz_completion(message, start_time)
    end_time = Time.now

    puts start_time
    puts end_time

    @bot.api.send_message(chat_id: message.chat.id, text: "До побачення, #{message.from.first_name}!")
  end
end
