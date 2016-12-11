require 'spec_helper'

module CodebreakerGem
  RSpec.describe Game do

    context '#initialize' do
      subject { Game.new }

      constans = %w(HINTS ATTEMPTS)
      constans.each do |const|
        it "constans #{const} should be defined" do
          expect(subject.class).to be_const_defined("#{const}")
        end
      end

      constans.each do |const|
        it "constans #{const} should be integer" do
          expect(subject.class.const_get(const)).to be_kind_of(Integer)
        end
      end

      attr_readers = %w(response attempts hints hint secret_code)
      attr_readers.each do |item|
        it "class should have attr_reader: #{item}" do
          should have_attr_reader(item)
        end
      end

      it "class should have attr_accessor: guess" do
        should have_attr_accessor(:guess)
      end

      it "@hints should be equal HINTS" do
        expect(subject.instance_variable_get(:@hints)).to eq(subject.class.const_get('HINTS'))
      end

      it "@attempts should be equal ATTEMPTS" do
        expect(subject.instance_variable_get(:@hints)).to eq(subject.class.const_get('HINTS'))
      end

      it "@response should be Array" do
        expect(subject.instance_variable_get(:@response)).to be_kind_of(Array)
      end
    end

    context '#generate_code' do
      subject { Game.new }

      before do
        subject.generate_code
      end

      it 'secret_code should have 4 numbers' do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'secret_code should have numbers between 1 and 6' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it 'secret_code should be a string' do
        expect(subject.instance_variable_get(:@secret_code)).to be_kind_of(String)
      end
    end

    context '#check' do
      subject { Game.new }

      array = [['1234','1234','++++'],
               ['4444','4444','++++'],
               ['3331','3332','+++'],
               ['1113','1112','+++'],
               ['1312','1212','+++'],
               ['1234','1266','++'],
               ['1234','6634','++'],
               ['1234','1654','++'],
               ['1234','1555','+'],
               ['1234','4321','----'],
               ['5432','2345','----'],
               ['1234','2143','----'],
               ['1221','2112','----'],
               ['5432','2541','---'],
               ['1145','6514','---'],
               ['1244','4156','--'],
               ['1221','2332','--'],
               ['2244','4526','--'],
               ['5556','1115','-'],
               ['1234','6653','-'],
               ['3331','1253','--'],
               ['2345','4542','+--'],
               ['1243','1234','++--'],
               ['4111','4444','+'],
               ['1532','5132','++--'],
               ['3444','4334','+--'],
               ['1113','2155','+'],
               ['2245','4125','+--'],
               ['4611','1466','---'],
               ['5451','4445','+-']
              ]
      array.each do |item|
        it "response must be equal to #{item[2]} for numbers #{item[0]} and #{item[1]}" do
          subject.instance_variable_set(:@secret_code, item[0])
          subject.instance_variable_set(:@guess, item[1])
          subject.check
          expect(subject.instance_variable_get(:@response)).to eq(item[2])
        end
      end
    end

    context '#get_hint' do
      subject { Game.new }

      before do
        subject.instance_variable_set(:@secret_code, '1345')
      end

      it '@hint should be Integer' do
        subject.get_hint
        expect(subject.instance_variable_get(:@hint).to_i).to be_kind_of(Integer)
      end

      it '@hint should be between 1 and 6' do
        subject.get_hint
        expect(subject.instance_variable_get(:@hint).to_i).to be_between(1,6)
      end

      it '@secret_code should be include @hint' do
        subject.get_hint
        expect(subject.instance_variable_get(:@secret_code)).to be_include(subject.instance_variable_get(:@hint))
      end

      it '@hint should be false if @hints = 0' do
        subject.instance_variable_set(:@hints, 0)
        subject.get_hint
        expect(subject.instance_variable_get(:@hint)).to be_falsey
      end

      it '@hint should be reduced by 1' do
        hint_before = subject.instance_variable_get(:@hints)
        subject.get_hint
        expect(subject.instance_variable_get(:@hints)).to eq(hint_before-1)
      end
    end

    context '#get_scores' do
      subject { Game.new }
      keys = %w(hints attempts secret_code)

      it 'return value should be a hash' do
        expect(subject.get_scores).to be_kind_of(Hash)
      end

      keys.each do |key|
        it "return value should include :#{key}" do
          subject.instance_variable_set(:@secret_code, '1234')
          expect(subject.get_scores[:"#{key}"]).to be_truthy
        end
      end

      it 'return value :hint should not more than HINT' do
        expect(subject.get_scores[:hints]).to be <= subject.class.const_get('HINTS')
      end

      it 'return value :attempts should not more than ATTEMPTS' do
        expect(subject.get_scores[:attempts]).to be <= subject.class.const_get('ATTEMPTS')
      end

      it 'return value :secret_code should be equal @secret_code' do
        subject.instance_variable_set(:@secret_code, '1234')
        expect(subject.get_scores[:secret_code]).to eq(subject.instance_variable_get(:@secret_code))
      end
    end

  end
end
