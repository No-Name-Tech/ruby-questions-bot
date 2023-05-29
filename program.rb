require 'telegram/bot'

require './quiz/runner'

token = '6001141184:AAGmYL9zZTgtPsYhupg-rPLG2FE1o9iQOdE'

Telegram::Bot::Client.run(token) do |bot|
  runner_quiz = Runner.new(bot)
  runner_quiz.run
end