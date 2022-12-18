# frozen_string_literal: true

# class that creates prime twins
class RenderXmlController < ApplicationController
  before_action :parse_params, only: :show

  def show
    # twinsarr = find_prims_numb(@input)
    twinsarr = foo_request(find_prime_numbers(@input.to_i * 2), @input.to_i)

    data = if twinsarr.empty?
             { message: "Неверные параметры запроса" }
           else
             twinsarr.map { |elem| { first: elem[0], second: elem[1] } }
           end

    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.rss { render xml: data.to_xml }
    end
  end

  private

  def parse_params
    @input = params[:input] 
  end


  def init_mas(num)
    mas = []
    mas[0] = 0
    mas[1] = 0
    i = 2
    (num - 2).times do
      mas[i] = 1
      i += 1
    end
    mas
  end

  def init_one(num, mas, k_iter = 2)
      (num - 2).times do
        break if k_iter * k_iter >= num

        if mas[k_iter] == 1
          l = k_iter * k_iter
          while l <= num      # убрать while
            mas[l] = 0
            l += k_iter
          end
        end
        k_iter += 1
      end
      mas
  end

  def find_prime_numbers(num)
      # mas = Prime.each(num.to_i*2).to_a
      mas = init_mas num
      mas = init_one num, mas
      massive = []
      mas.each_index do |item|
        massive.push(item) if mas[item] == 1
      end
      massive
  end

  def foo_request(mas, num)
      array = []
      (mas.length - 1).times do |i|                               # | можно убрать
        array.push([mas[i], mas[i + 1]]) if (mas[i] >= num) && (mas[i + 1] - mas[i] == 2)
      end
      array
  end

  # n = 10
  # print foo_request(find_prime_numbers(n*2), n)



  # def find_prims_numb(inp)
  #   arr = Prime.each(inp.to_i).to_a
  #   twins = []
  #   twins2 = []
  #   arr.each_index { |i| arr.each_index { |j| twins.push(arr[i]) if (arr[i] - arr[j]).abs == 2 } }
  #   k = 0
  #   loop do
  #     twins2.push([twins[k], twins[k+1]])
  #     k += 2
  #     break if k >= (twins.size - 1)
  #   end
  #   twins2
  # end

end
