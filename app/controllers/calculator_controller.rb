class CalculatorController < ApplicationController
  def index
    @calculations = $collection.find.to_a
  end

  def calculate
    num1 = params[:num1].to_f
    num2 = params[:num2].to_f
    operator = params[:operator]

    if num1.between?(1, 100) && num2.between?(1, 100)
      case operator
      when "+"
        result = num1 + num2
      when "-"
        result = num1 - num2
      when "*"
        result = num1 * num2
      when "/"
        if num2 != 0
          result = num1 / num2
        else
          result = nil # set result to nil for division by zero errors
        end
      end

      if result
        calculation = { num1: num1, num2: num2, operator: operator, result: result }
        existing_calculation = $collection.find(calculation).limit(1).first

        if existing_calculation
          @last_calculation = existing_calculation
          $collection.update_one({_id: existing_calculation["_id"]}, {"$inc" => {count: 1}})
          @color = "red"
        else
          $collection.insert_one(calculation.merge({count: 1}))
          @last_calculation = calculation.merge({count: 1})
          @color = "green"
        end

        flash[:success] = "Calculation Added!"
      else
        flash[:alert] = "Error: division by zero"
      end
    else
      flash[:alert] = "Error: input must be between 1 and 100"
    end

    respond_to do |format|
      format.html { redirect_to root_path(result: result, color: @color) }
      format.js
    end
  end
end
