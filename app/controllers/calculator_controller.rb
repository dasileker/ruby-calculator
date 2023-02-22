class CalculatorController < ApplicationController

  def index
  end
  
  def Calculator 
    expression = params[:expression]
    operands = expression.split
    operator = operands.delete_at(1)

    if operands.all? { |operand| operand.match?(/^\d{1,2}$/) && operand.to_i >= 0 && operand.to_i < 100 }
      result = eval(operands.join(operator))
      render plain: "Result: #{result}"
    else
      render plain: "Invalid input? Expression must be a valid non-negative mathematical expression with operands lower than 100."
    end
  end
end
