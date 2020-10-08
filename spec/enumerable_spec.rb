require './enumerable'

describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:array2) { [2, 4, 6, 8] }
  let(:range) { (1...5) }
  let(:hash) { { 1 => 'one', 2 => 'two' } }
  let(:animal) { %w[cat dog wombat] }
  describe '#my_each' do
    it 'return an array if block given' do
      expect(array.my_each { |x| x }).to eq(array)
    end

    it 'testing if it yield' do
      arr = []
      array.my_each { |x| arr << (x * 2) }
      expect(arr).to eq(array2)
    end

    it 'testing my_each with range' do
      arr = []
      range.my_each { |x| arr << (x * 2) }
      expect(arr).to eq(array2)
    end

    it 'testing my_each with hash' do
      arr = []
      hash.my_each { |x| arr << x }
      expect(arr[0][1]).to eq('one')
    end

    it 'return an Enumerator if not block given' do
      expect(array.my_each).to be_kind_of Enumerator
    end
  end
  describe '#my_each_with_index' do
    it 'return an Enumerator if not block given' do
      expect(array.my_each_with_index).to be_kind_of Enumerator
    end

    it 'testing if it yield' do
      arr = []
      array.my_each_with_index { |x, i| arr << "index #{i} is element #{x}" }
      expect(arr[3]).to eq('index 3 is element 4')
    end

    it 'testing my_each_with_index with range' do
      arr = []
      range.my_each_with_index { |x, i| arr << "index #{i} is element #{x}" }
      expect(arr[3]).to eq('index 3 is element 4')
    end

    it 'testing my_each_with_index with hash' do
      hash_new = {}
      animal.my_each_with_index { |x, i| hash_new[x] = i }
      expect(hash_new).to eq({ 'cat' => 0, 'dog' => 1, 'wombat' => 2 })
    end
  end

  describe '#my_select' do
    it 'returns an enum if no block is given ' do
      expect(array.my_select.is_a?(Enumerator)).to eq(true)
    end

    it '(when passing an array )returns an array of elements that makes the block\'s expression to be true ' do
      expect(array.my_select { |num| num > 2 }).to match_array [3, 4]
    end

    it '(when passing a range )returns an array of elements that makes the block\'s expression to be true ' do
      expect(range.my_select { |num| num < 3 }).to match_array [1, 2]
    end

    it '(when passing a hash )returns an array of elements that makes the block\'s expression to be true ' do
      expect(hash.my_select { |x| x[1] == 'one' }).to match_array [[1, 'one']]
    end

    # let(:hash) { { 1 => 'one', 2 => 'two' } }
    # [[1, "one"], [2, "two"]]
  end

  describe '#my_all?' do
    it 'if block is given passes each element of the collection to the given block. The method returns true if the block never returns false or nil. ' do
      expect(array.my_all? { |num| num.is_a?(Integer) }).to eq(true)
      expect(animal.my_all? { |word| word.length >= 4 }).to eq(false)
    end

    it '(If no block or pattern\'argument\' is given && the collection has no nil || false elements ) -> returns true else returns false' do
      expect(array.my_all?).to eql(true)
      array = [nil, 1, true]
      expect(array.my_all?).to eql(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Class])
     ->
     returns true if every elemnt of the collection is a kind of this [Class]
    else returns false' do
      expect(array.my_all?(Numeric)).to eq(true)
      expect(['1', '2', '3', 4].my_all?(Numeric)).to eq(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Regexp])
    ->
    returns true if every elemnt of the collection matches this regular expression; else returns false' do
      expect(animal.my_all?(/t/)).to eq(false)
      expect(%w[ant tiger cat].my_all?(/t/)).to eq(true)
    end
  end

  describe '#my_any?' do
    it 'if block is given passes each element of the collection to the given block. The method returns true if at least one element is true' do
      expect(animal.my_any? { |word| word.length >= 4 }).to eq(true)
      expect(animal.my_any? { |word| word.length > 8 }).to eq(false)
    end

    it '(If no block or pattern\'argument\' is given && the collection at least one of elemnts in the collection is no nil || false elements ) -> returns true else returns false' do
      expect([nil, 1, true].my_any?).to eql(true)
      expect([nil, false].my_any?).to eql(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Class])
    ->
    returns true if any of the elements in the collection is a kind of this [Class]
    else returns false' do
      expect(['1', '2', '3', 4].my_any?(Numeric)).to eq(true)
      expect(%w[1 2 3].my_any?(Numeric)).to eq(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Regexp])
    ->
    returns true if every any of the elements in the collection matches this regular expression; else returns false' do
      expect(animal.my_any?(/t/)).to eq(true)
      expect(%w[ant tiger cat].my_any?(/z/)).to eq(false)
    end
  end

  describe '#my_none?' do
    it 'if block is given passes each element of the collection to the given block. The method returns true if the block never returns true' do
      expect(animal.my_none? { |word| word.length > 8 }).to eq(true)
      expect(array.my_none? { |num| num.is_a?(Integer) }).to eq(false)
    end

    it '(If no block or pattern\'argument\' is given && none of the elements are true ) -> returns true else returns false' do
      expect([nil].my_none?).to eql(true)
      expect([nil, 1, true].my_none?).to eql(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Class])
    ->
    returns true if none of the elements in the collection are a kind of this [Class]
    else returns false' do
      expect(array.my_none?(String)).to eq(true)
      expect(['1', '2', '3', 4].my_none?(Numeric)).to eq(false)
    end

    it '(if no block is given but a pattern that\'s kind_of? [Regexp])
    ->
    returns true if none of the element in the collection matches this regular expression; else returns false' do
      expect(animal.my_none?(/e/)).to eq(true)
      expect(%w[ant tiger cat].my_none?(/t/)).to eq(false)
    end
  end
end
