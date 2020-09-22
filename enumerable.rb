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
end
