RSpec.shared_examples "new game if want_more?" do |method|

    subject {Codebreaker::Console.new}

    it 'should call #new_game method if #want_more? equal true' do
      allow($stdout).to receive(:puts)
      allow(subject).to receive(:want_more?).and_return true
      expect(subject).to receive(:new_game)
      subject.send(method)
    end
end
