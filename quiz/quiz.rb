require 'singleton'

class Quiz
  include Singleton

  attr_accessor :yaml_dir, :in_ext, :answers_dir

  def initialize
    @yaml_dir = "./yml"
    @in_ext = "*.yml"
    @answers_dir = "./quiz/answers"
  end

  def config(&block)
    yield self
  end
end