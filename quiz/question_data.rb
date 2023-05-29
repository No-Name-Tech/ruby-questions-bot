require 'json'
require 'yaml'
require_relative 'question'

class QuestionData
  attr_accessor :collection

  def initialize
    @collection = []
    @yaml_dir = Quiz.instance.yaml_dir
    @in_ext = Quiz.instance.in_ext
    @threads = []
  end

  def to_yaml
    @collection.to_yaml
  end

  def save_to_yaml(filename)
    File.write(filename, to_yaml)
  end

  def to_json
    @collection.to_json
  end

  def save_to_json(filename)
    File.write(filename, to_json)
  end

  def prepare_filename(filename)
    File.expand_path(filename, __dir__)
  end

  def each_file(&block)
    Dir.glob(prepare_filename(@yaml_dir) + "/#{@in_ext}") do |file|
      block.call(file)
    end
  end

  def in_thread(&block)
    @threads << Thread.new(&block)
  end

  def load_data
    @collection = []
    each_file do |filename|
      in_thread do
        load_from(filename)
      end
    end
    @threads.each(&:join)
  end

  def load_from(filename)
    data = YAML.load_file(filename)

    data.shuffle.each do |question_data|
      question = Question.new(question_data['question'], question_data['answers'], question_data['correct_answer'])
      @collection << question
    end

    puts @collection
  end
end