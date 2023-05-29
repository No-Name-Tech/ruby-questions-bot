class InputReader
  def read(welcome_message: nil, validator: nil, error_message: nil, process: nil)
    loop do
      puts welcome_message if welcome_message
      input = gets.chomp
      input = process.call(input) if process
      next if input.empty?

      if validator && !validator.call(input)
        puts error_message if error_message
        next
      end

      return input
    end
  end
end