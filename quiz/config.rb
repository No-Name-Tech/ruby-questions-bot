module Config
  attr_accessor :yaml_dir, :answers_dir, :in_ext

  def config
    yield self
  end

  self.yaml_dir = "quiz/yml"
  self.answers_dir = "quiz/answers"
  self.in_ext = "yml"
end