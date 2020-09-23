# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    return to_enum(:my_each)unless block_given?
    for i in (self) do
      yield(i)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    for i in (0...self.length) do
      yield(self[i], i)
    end    
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    arr =[]
    for i in (self) do
      if yield(i) == true
       arr.push(i)
      end
    end
    arr  
  end

  def my_all
    test = true 
    my_each do |i|
    if block_given?
      if !yield(i)
        test = false
      end
    else !block_given?
      if i == false || i == nil
        test = false
      end
    end
  end
   puts test
  end

  def my_any
    test = false 
    my_each do |i|
    if block_given?
      if yield(i)
        test = true
      end
    else !block_given?
      if i == true
        test = true
      end
    end
  end
   puts test
  end

  def my_none
    test = true
    my_each do |i|
      if block_given?
        if yield(i)
          test = false
        end
      else !block_given?
        if i
          test = false
        end
      end
    end
    puts test
  end

  # def my_count(*arg)
  #   sum = 0
  #   case
  #     when arg.empty? == true and block_given? == false
  #       my_each do |i|
  #         if yield(i)
  #           sum += 1
  #         end
  #       end
  #       sum
  #     when arg.empty? == false
  #       my_each do |i|
  #         if arg[0] == i
  #         sum += 1
  #         end
  #       end
  #       sum
  #   else
  #     self.length
  #   end
  # end

  def my_map
    return to_enum(:my_map) unless block_given?
    arr = []
    my_each do |i|
      arr.push(yield(i))
    end
    arr
  end

  def my_inject(*arg)
    if arg.empty?
      memo = 0
      my_each do |i|
        memo = yield(memo, i)
      end
      return memo
    end
    if arg.empty? == false && block_given?
      memo = 0
      my_each do |i|
        memo = yield(arg[0], i)
        arg[0] = memo
      end
      return memo
    end
    if arg[0].is_a? Symbol
      puts arg[0].is_a?(Symbol)
      my_each do |i|
        send(i)
      end
    end
  end
end


puts (5..10).my_inject(:+) 
# puts (5..10).my_inject { |sum, n| sum + n }  
# puts (5..10).my_inject(1) { |product, n| product * n }