# rubocop:disable Layout/LineLength

require './enumerable'

describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:array2) { [2, 4, 6, 8] }
  let(:range) { (1...5) }
  let(:hash) { { 1 => 'one', 2 => 'two' } }
  let(:animal) { %w[cat dog wombat] }
  describe '#my_each' do
    context 'with a block given' do
      it 'return an array' do
        expect(array.my_each { |num| puts num }).to eq(array.each { |num| puts num })
      end
    end

    context 'testing if it yield' do
      it 'with array' do
        arr = []
        array.my_each { |x| arr << (x * 2) }
        expect(arr).to eq(array2)
      end

      it 'with range' do
        arr = []
        range.my_each { |x| arr << (x * 2) }
        expect(arr).to eq(array2)
      end

      it 'with hash' do
        arr = []
        hash.my_each { |x| arr << x }
        expect(arr[0][1]).to eq('one')
      end
    end

    context ' not block given' do
      it 'return an Enumerator' do
        expect(array.my_each).to be_kind_of Enumerator
      end
    end
  end
  describe '#my_each_with_index' do
    context 'Not block given' do
      it 'return an Enumerator' do
        expect(array.my_each_with_index).to be_kind_of Enumerator
      end
    end
    context 'When a block is given' do
      it 'with hash' do
        hash_new = {}
        animal.my_each_with_index { |x, i| hash_new[x] = i }
        expect(hash_new).to eq({ 'cat' => 0, 'dog' => 1, 'wombat' => 2 })
      end
    end

    context 'testing if it yield' do
      it 'with array' do
        arr = []
        array.my_each_with_index { |x, i| arr << "index #{i} is element #{x}" }
        expect(arr[3]).to eq('index 3 is element 4')
      end
      it 'with range' do
        arr = []
        range.my_each_with_index { |x, i| arr << "index #{i} is element #{x}" }
        expect(arr[3]).to eq('index 3 is element 4')
      end
    end
  end

  describe '#my_select' do
    context 'When no block is given' do
      it 'returns an enum' do
        expect(array.my_select.is_a?(Enumerator)).to eq(true)
      end
    end

    context 'When block is given' do
      it 'with an array' do
        expect(array.my_select { |num| num > 2 }).to match_array [3, 4]
      end

      it 'with a range' do
        expect(range.my_select { |num| num < 3 }).to match_array [1, 2]
      end

      it 'with a hash' do
        expect(hash.my_select { |x| x[1] == 'one' }).to match_array [[1, 'one']]
      end
    end
  end

  describe '#my_all?' do
    context 'when a block given passes each element of the collection to that block' do
      it 'The method returns true if the block never returns false or nil.' do
        expect(array.my_all? { |num| num.is_a?(Integer) }).to eq(true)
      end
      it 'The method returns false if one of the elements returns false or nil.' do
        expect(animal.my_all? { |word| word.length >= 4 }).to eq(false)
      end
    end

    context 'no block or pattern are given' do
      context 'the collection has no nill or false' do
        it 'returns true' do
          expect(array.my_all?).to eql(true)
        end
      end
      context 'the collection has at least one element nil or false' do
        it 'return false' do
          array = [nil, 1, true]
          expect(array.my_all?).to eql(false)
        end
      end
    end

    context 'no block is given' do
      context 'pattern given that\'s kind_of? [Class]' do
        it 'returns true if every element of the collection belong to that [Class]' do
          expect(array.my_all?(Numeric)).to eq(true)
        end
        it 'return false if one of the element dont belong to that [Class]' do
          expect(['1', '2', '3', 4].my_all?(Numeric)).to eq(false)
        end
      end
      context 'pattern that\'s kind_of? [Regexp]' do
        it 'returns true if every elemnt of the collection matches this regular expression' do
          expect(%w[ant tiger cat].my_all?(/t/)).to eq(true)
        end

        it 'returns false if at least one element of the collection do not match this regular expression' do
          expect(animal.my_all?(/t/)).to eq(false)
        end
      end
    end
  end

  describe '#my_any?' do
    context 'when a block is given passes each element of the collection to that block' do
      it 'return true if at least one element is true' do
        expect(animal.my_any? { |word| word.length >= 4 }).to eq(true)
      end
      it 'return false if none of the element are true' do
        expect(animal.my_any? { |word| word.length > 8 }).to eq(false)
      end
    end

    context 'If no block or pattern is given' do
      context 'At least one element of the collection is not nil or false' do
        it 'return true' do
          expect([nil, 1, true].my_any?).to eql(true)
        end
      end
      context 'none element of the collection is true' do
        it 'return false' do
          expect([nil, false].my_any?).to eql(false)
        end
      end
    end

    context 'no block is given' do
      context 'pattern given that\'s kind_of? [Class]' do
        it 'returns true if at least one element of the collection belong to that [Class]' do
          expect(['1', '2', '3', 4].my_any?(Numeric)).to eq(true)
        end
        it 'return false if none of the element belong to that [Class]' do
          expect(%w[1 2 3].my_any?(Numeric)).to eq(false)
        end
      end
      context 'pattern that\'s kind_of? [Regexp]' do
        it 'returns true if at least one element of the collection match this regular expression' do
          expect(animal.my_any?(/t/)).to eq(true)
        end

        it 'returns false if none of the elements of the collection matches this regular expression' do
          expect(%w[ant tiger cat].my_any?(/z/)).to eq(false)
        end
      end
    end
  end

  describe '#my_none?' do
    context 'when a block is given passes each element of the collection to that block' do
      it 'The method returns true if the block never returns true' do
        expect(animal.my_none? { |word| word.length > 8 }).to eq(true)
      end
      it 'The method returns false if the block returns at least one true' do
        expect(array.my_none? { |num| num.is_a?(Integer) }).to eq(false)
      end
    end

    context 'If no block or pattern is given' do
      context 'None of the elements in the collection are true' do
        it 'return true' do
          expect([nil].my_none?).to eql(true)
        end
      end
      context 'At least one element in the collection is true' do
        it 'return false' do
          expect([nil, 1, true].my_none?).to eql(false)
        end
      end
    end

    context 'If no block is given' do
      context 'pattern given that\'s kind_of? [Class]' do
        it 'returns true if none of the elements in the collection belong to that [Class]' do
          expect(array.my_none?(String)).to eq(true)
        end
        it 'returns false if at least one element of the collection belong to that [Class]' do
          expect(['1', '2', '3', 4].my_none?(Numeric)).to eq(false)
        end
      end
      context 'pattern that\'s kind_of? [Regexp]' do
        it 'returns true if none of the elements of the collection matches this regular expression' do
          expect(animal.my_none?(/e/)).to eq(true)
        end
        it 'returns false if at least one element of the collection match this regular expression' do
          expect(%w[ant tiger cat].my_none?(/t/)).to eq(false)
        end
      end
    end
  end

  describe '#my_count' do
    context 'with a block given' do
      context ' with an array' do
        it 'counts the number of elements yielding a true value.' do
          expect(array.my_count { |num| num >= 2 }).to eq(3)
          expect(array2.my_count { |num| num == 1 }).to_not eq(array2.length)
        end
      end
      context 'with a range' do
        it 'counts the number of elements yielding a true value.' do
          expect(range.my_count { |num| num >= 2 }).to eq(3)
          expect(range.my_count { |num| num == 1 }).to_not eq(4)
        end
      end
    end
    context 'with an argument given' do
      context 'with an array' do
        it 'counts the number of items in the collection that are eql to the argument' do
          expect(array.my_count(&:even?)).to eq(2)
          expect(array.my_count(&:odd?)).not_to eq(0)
        end
      end
      context 'with a range' do
        it 'counts the number of items in the collection that are eql to the argument' do
          expect(range.my_count(&:even?)).to eq(2)
          expect(range.my_count(&:odd?)).not_to eq(0)
        end
      end
    end

    context 'with (no block && no argument) given' do
      context 'with an array' do
        it 'Returns the number of items in the collection' do
          expect(array.my_count).to eq(array.length)
          expect(array.my_count).to_not eq(array.length - 1)
        end
      end
      context 'with a range' do
        it 'Returns the number of items in the collection' do
          expect(range.my_count).to eq(4)
          expect(range.my_count).to_not eq(3)
        end
      end
    end
  end

  describe '#my_map' do
    context 'with a proc given' do
      context 'with an array' do
        it 'Returns a new array with the results of running proc once for every element in collection.' do
          proc = proc { |x| x * 2 }
          expect(array.my_map(&proc)).to match_array array2
          expect(array.my_map(&proc)).to_not match_array array
        end
      end
      context 'with a range' do
        it 'Returns a new array with the results of running proc once for every element in collection.' do
          proc = proc { |x| x * 2 }
          expect(range.my_map(&proc)).to match_array array2
          expect(range.my_map(&proc)).to_not match_array array
        end
      end
    end

    context 'with a block given' do
      context 'with an array' do
        it 'Returns a new array with the results of running block once for every element in the collection.' do
          expect(array.my_map { |x| x * 2 }).to match_array array2
          expect(array.my_map { |x| x * 2 }).to_not match_array array
        end
      end
      context 'with a range' do
        it 'Returns a new array with the results of running block once for every element in the collection.' do
          expect(range.my_map { |x| x * 2 }).to match_array array2
          expect(range.my_map { |x| x * 2 }).to_not match_array array
        end
      end
    end

    context 'with (no block && no argument) given' do
      context 'with an array' do
        it 'returns an Enumerator ' do
          expect(array.my_map.is_a?(Enumerator)).to eq(true)
          expect(array.my_map.is_a?(Enumerator)).to_not match_array array
        end
      end
      context 'with a range' do
        it 'returns an Enumerator ' do
          expect(range.my_map.is_a?(Enumerator)).to eq(true)
          expect(range.my_map.is_a?(Enumerator)).to_not match_array array
        end
      end
    end
  end
  describe '#my_inject' do
    context 'a block is given' do
      context 'with no argument' do
        it 'goes over array one by one and returns the vlaue by applying a binary operation, specified by this block' do
          expect(animal.my_inject { |memo, word| memo.length > word.length ? memo : word }).to eq(animal.inject { |memo, word| memo.length > word.length ? memo : word })
        end
      end

      context '&& one argument' do
        context 'this one argument is a number' do
          it 'goes over array one by one and returns the vlaue by applying a binary operation, specified by this block with this number as a seed for memo ' do
            expect(array.my_inject(1) { |product, n| product * n }).to eq(array.inject(1) { |product, n| product * n })
          end
        end
      end
    end
    context 'a block is not given' do
      context 'this one argument is a symbol' do
        it 'goes over array one by one and returns the vlaue by applying a binary operation, specified by this block based on the binary operation passed as a Symbol in the argument ' do
          expect(range.my_inject(:+)).to eq range.inject(:+)
        end
      end
      context 'with two arguments' do
        it "goes over array one by one and returns the vlaue by applying a binary operation, specified by this block based on the binary operation passed as a Symbol in the argument
        with this number as a seed for memo" do
          expect(array2.my_inject(1, :*)).to eq array2.inject(1, :*)
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
