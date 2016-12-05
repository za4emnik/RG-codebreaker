require 'spec_helper'

module CodebreakerGem
  RSpec.describe Game do
    context '#start' do
      let(:game) { Game.new }

      before do
        game.start
        allow(game).to receive(:get_variant?).and_return('1234')
        allow(game).to receive(:show_try_again?).and_return('2345')
      end

      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end
    end
  end
end
