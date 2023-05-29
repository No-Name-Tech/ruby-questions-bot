require_relative 'question'
require_relative 'question_data'
require_relative 'file_writer'
require_relative 'input_reader'
require_relative 'statistics'
require_relative 'quiz'
require 'yaml'
require 'json'
require 'pathname'

class Engine
  def initialize(bot, chat_id, username)
    @bot = bot
    @chat_id = chat_id
    @username = username

    @question_data = QuestionData.new
    @question_data.load_data

    @current_time = Time.now.strftime("%d-%m-%Y_%H:%M:%S")
    @writer = FileWriter.new('a', Quiz.instance.answers_dir, "#{@username}_#{@current_time}.txt")
    @statistics = Statistics.new(@writer)
  end

  def start
    @bot.api.send_message(text: "Привіт, #{@username}!", chat_id: @chat_id)

    puts @question_data

    @question_data.each_with_index do |question, index|
      puts "\nQuestion #{index + 1}: #{question.text}"
      question.options.each_with_index do |option, option_index|
        puts "#{('A'..'Z').to_a[option_index]}) #{option}"
      end
      user_answer = get_answer_by_char(question)
      check(user_answer, question.answer)
      puts "\nYour answer: #{user_answer}"
      puts "Correct answer: #{question.answer}"
    end
    puts "\nQuiz finished!"
  end

  def check(user_answer, correct_answer)
    if user_answer == correct_answer
      @statistics.correct_answer
    else
      @statistics.incorrect_answer
    end
  end

  def get_answer_by_char(question)
    loop do
      user_answer = @input_reader.read('Enter your answer: ').upcase.strip
      return user_answer unless user_answer.empty?
    end
  end

  def start_bot
    answers_to_questions = {}
    @question_data.collection.each_with_index do |question, index|
      answers_to_questions[index] = nil
    end

    question_collection_enumerator = @question_data.collection.each
    index_question_collection = -1
    last_question = nil

    @bot.listen do |message|
      case message.text
      when '/stop'
        return stop(message)
      else
        if last_question != nil
          parse_respond_question(message, last_question, answers_to_questions, index_question_collection)
        end

        begin
          question = question_collection_enumerator.next
          index_question_collection += 1
        rescue StopIteration => ex
          stop(message)
          return
        end

        send_question(question, message, index_question_collection)
        last_question = question
      end
    end
  end

  def stop(message)
    kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    @bot.api.send_message(chat_id: message.chat.id, text: @statistics.report, reply_markup: kb)
  end

  def send_question(question, message, index_question_collection)
    question_text = "#{index_question_collection + 1}. #{question.question_body}"
    question_answers = question.question_answers
    text_answers = question_answers.map { |answer| [{ text: answer }] }
    answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: text_answers,
      one_time_keyboard: true
    )
    @bot.api.send_message(chat_id: message.chat.id, text: question_text, reply_markup: answers)
  end

  def parse_respond_question(message, last_question, answers_to_questions, index_question_collection)
    if message.text == last_question.question_correct_answer
      answers_to_questions[index_question_collection] = true
      @bot.api.send_message(chat_id: message.chat.id, text: "Правильно!", reply_to_message_id: message.message_id)
      @statistics.correct_answer
    else
      answers_to_questions[index_question_collection] = false
      @bot.api.send_message(chat_id: message.chat.id, text: "Неправильно!", reply_to_message_id: message.message_id)
      @statistics.incorrect_answer
    end
  end
end
