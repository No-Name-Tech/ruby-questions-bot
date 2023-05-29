

class Statistics
  def initialize(writer)
    @correct_answers = 0
    @incorrect_answers = 0
    @writer = writer
  end

  def correct_answer
    @correct_answers += 1
  end

  def incorrect_answer
    @incorrect_answers += 1
  end

  def total_answers
    @correct_answers + @incorrect_answers
  end

  def correct_percentage
    correct_percentage = 0

    if total_answers != 0
      correct_percentage = (@correct_answers.to_f / total_answers.to_f) * 100
    end

    correct_percentage
  end

  def report
    report = "Всього питань: #{total_answers}\n" + "Правильних відповідей: #{@correct_answers}\n" + "Неправильних відповідей: #{@incorrect_answers}\n" + "Відсоток коректності: #{'%.2f' % correct_percentage}%\n"

    @writer.write(report)

    report
  end
end