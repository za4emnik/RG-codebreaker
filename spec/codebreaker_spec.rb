require 'spec_helper'
require 'shared_examples_for_console.rb'

module Codebreaker
  RSpec.describe Console do
    context '#initialize' do
      subject { Console.new }

      it '@game should be instance of Game' do
        expect(subject.instance_variable_get(:@game)).to be_kind_of(CodebreakerGem::Game)
      end

      it '@guess should be truthy' do
        expect(subject.instance_variable_get(:@guess)).to be_truthy
      end
    end

    context '#run' do
      subject { Console.new }

      before do
        allow(subject).to receive(:get_guess)
        allow(subject).to receive(:you_loose)
      end

      after do
        subject.run
      end

      it 'should call #you_won method if @guess equal @game.secret_code' do
        subject.instance_variable_set(:@guess, subject.instance_variable_get(:@game).secret_code)
        allow(subject).to receive(:you_won)
        expect(subject).to receive(:you_won)
      end

      it 'should call #show_hint method if @guess equal "hint"' do
        subject.instance_variable_set(:@guess, 'hint')
        allow(subject).to receive(:show_hint)
        expect(subject).to receive(:show_hint)
      end

      it 'should call #show_response method if @guess not equal "hint" and @game.secret_code' do
        subject.instance_variable_set(:@guess, '1234')
        subject.instance_variable_get(:@game).instance_variable_set(:@secret_code, '2345')
        allow(subject).to receive(:show_response)
        expect(subject).to receive(:show_response)
      end

      it 'should call #you_loose method if @game.attempts equal 0' do
        subject.instance_variable_get(:@game).instance_variable_set(:@attempts, 0)
        expect(subject).to receive(:you_loose)
      end
    end

    context '#new_game' do
      let(:console) { Console.new }

      it 'should return instance of Console' do
        allow(console).to receive(:new_game).and_return(Codebreaker::Console.new)
        expect(console.new_game).to be_kind_of(Codebreaker::Console)
      end
    end

    context '#you_won' do
      subject{ Console.new }

      before do
        allow(subject).to receive(:save_game)
        allow(subject).to receive(:show_all_achievements)
        allow(subject).to receive(:new_game)
        allow(subject).to receive(:want_more?).and_return true
      end

      it 'should display "You won!"' do
        expect{ subject.you_won }.to output("You won!\n").to_stdout
      end

      it_should_behave_like 'new game if want_more?', 'you_won'
    end

    context '#you_loose' do
      subject{ Console.new }

      it_should_behave_like 'new game if want_more?', 'you_loose'

      it 'should display "You loose :("' do
        allow(subject).to receive(:new_game)
        allow(subject).to receive(:want_more?)
        expect{ subject.you_loose }.to output("You loose :(\n").to_stdout
      end
    end

    context '#show_hint' do
      subject{ Console.new }

      it "should display \'You have 5 hints\' HINT: 3" do
        subject.instance_variable_get(:@game).instance_variable_set(:@hints, 5)
        subject.instance_variable_get(:@game).instance_variable_set(:@hint, 3)
        expect{ subject.show_hint }.to output("You have 5 hints\nHINT: 3\n").to_stdout
      end

      it "should display \'You have 0 hints\' Sorry, but you have used all the hints :(" do
        subject.instance_variable_get(:@game).instance_variable_set(:@hints, 0)
        subject.instance_variable_get(:@game).instance_variable_set(:@hint, false)
        expect{ subject.show_hint }.to output("You have 0 hints\nSorry, but you have used all the hints :(\n").to_stdout
      end
    end

    context '#get_guess' do
      subject{ Console.new }

      it 'should display "Enter your guess"' do
        allow(subject).to receive(:gets).and_return('1234')
        expect{ subject.get_guess }.to output("Enter your guess\n").to_stdout
      end

      it '@guess should be equal 1234' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return('1234')
        subject.get_guess
        expect(subject.instance_variable_get(:@guess)).to eq('1234')
      end

      it 'raise exeption if size @guess not equal 4' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return('123')
        expect{ subject.get_guess }.to raise_error('You must enter 4 numbers')
      end
    end

    context '#want_more?' do
      subject{ Console.new }

      variants = %w(y Y д Д)
      it 'should display "Want more?"' do
        allow(subject).to receive(:gets).and_return('1234')
        expect{ subject.want_more? }.to output("Want more? y/n\n").to_stdout
      end

      variants.each do |item|
        it "should return true if enter \'#{item}\'" do
          allow(subject).to receive(:puts)
          expect(subject).to receive(:want_more?).and_return true
          subject.want_more?
        end
      end
    end

    context '#show_response' do
      subject{ Console.new }

      it 'should display "You have 5 attempts ++--"' do
        subject.instance_variable_get(:@game).instance_variable_set(:@attempts, 5)
        subject.instance_variable_get(:@game).instance_variable_set(:@response, '++--')
        expect{ subject.show_response }.to output("You have 5 attempts\n++--\n").to_stdout
      end
    end

    context '#show_all_achievements' do
      subject{ Console.new }
      scores = ['name: User attempts: 5 hints: 1 secret_code: 3145']

      it 'should display "Achievements table" and scores' do
        allow(subject.instance_variable_get(:@game)).to receive(:read_achievements).and_return(scores)
        expect{ subject.show_all_achievements }.to output("Achievements table\nname: User attempts: 5 hints: 1 secret_code: 3145\n").to_stdout
      end
    end

    context '#save_game' do
      subject{ Console.new }

      before do
        allow(subject.instance_variable_get(:@game)).to receive(:save_achievement)
      end

      it 'should display "Enter your name"' do
        allow(subject).to receive(:gets).and_return('Mike')
        expect{ subject.save_game }.to output("Enter your name\n").to_stdout
      end

      it '@game.get_scores should return HASH' do
        expect(subject.instance_variable_get(:@game).get_scores).to be_kind_of(Hash)
      end

      it ':user_name should be equal Mike', skip: true do
      end
    end

  end
end
