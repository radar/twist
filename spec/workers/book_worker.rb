require 'spec_helper'

describe BookWorker do
  it "can perform async" do
    expect(BookWorker.respond_to?(:perform_async)).to be_true
  end
end