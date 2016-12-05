require 'spec_helper'

module Console
  RSpec.describe 'console' do
    context '#want_more?' do
      let(:game) { Game.new }

      before do
        game.start
        allow(game).to receive(:get_variant?).and_return('1234')
        allow(game).to receive(:try_again?).and_return('3456')
      end

      it 'should puts want more' do
        expect{ game.want_more? }.to output('Want more? y/n').to_stdout
      end
    end
  end
end
