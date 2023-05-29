require 'json'
require 'yaml'

class Question
  attr_accessor :question_body
  attr_accessor :question_answers
  attr_accessor :question_correct_answer

  def initialize(raw_text, raw_answers, correct_answer)
    self.question_body = raw_text
    self.question_answers = raw_answers
    self.question_correct_answer = correct_answer
  end

  def display_answers()
    puts question_answers
    question_answers.each_with_index { |answer, index| "#{("A".ord + index).chr}.#{answer}" }
  end

  def to_s
    "#{question_body}\n" + display_answers.join("\n")
  end

  def to_h
    {
      :question_body => question_body,
      :question_correct_answer => question_correct_answer,
      :question_answers => question_answers,
    }
  end

  def to_json
    to_h.to_json
  end

  def to_yaml
    to_h.to_yaml
  end

  def load_answers(raw_answers)
    shuffled_answers = raw_answers.shuffle
    answers_hash = {}

    ('A'..'Z').each_with_index do |char, index|
      answers_hash[char] = shuffled_answers[index].strip
    end

    answers_hash
  end

  def find_answer_by_char(char)
    self.question_answers[char]
  end
end