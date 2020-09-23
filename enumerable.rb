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

  def my_count(*arg)
    sum = 0
    if block_given?
      puts("Con un bloque y sin argumento")
      my_each do |i|
        if yield(i)
          sum += 1
        end
      end
      sum
    elsif arg.empty?
      puts("Sin un bloque y sin argumento")
      self.length
    else
      puts("Con argumento y sin bloque")
      my_each do |i|
        if arg[0] == i
        sum += 1
        end
      end
      sum
      
    end
  end

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
      my_each do |i|
        yield(memo, i)
      end
    end
    memo
  end
end


# puts [1, 2, 4, 2, 5, 7].my_count
puts [1, 2, 4, 2, 3, 8, 6, 2].my_count(2)
puts [1, 2, 4, 2, 3, 8, 6, 2].my_count
puts [1, 2, 4, 2, 3, 8, 6, 2].my_count{ |x| x%2==0}




#puts (5..10).inject { |sum, n| sum + n }  