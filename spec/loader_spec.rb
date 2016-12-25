require 'spec_helper'

module Loader
  RSpec.describe 'loader mixin' do

    context '#save_achievement' do
    scores = 'name: Max attempts: 7 hints: 1 secret_code: 3343'

      it 'should write to file' do
        allow(File).to receive(:open).with('./data/data.yml', 'w').and_yield( scores )
        expect(File.exist?('./data/data.yml')).to eq true
        expect(scores).to eq(scores)
      end
    end

    context '#read_achievements' do
      filename = './data/data_test.yml'
      scores = 'name: Max attempts: 7 hints: 1 secret_code: 3343'

      it 'should read file' do
        allow(File).to receive(:readlines).with('./data/data.yml').and_return( scores )
        expect(scores).to eq(scores)
      end

    end
  end
end
