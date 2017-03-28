require "rails_helper"

describe BookReceiver do
  context "when commits accept notes" do
    before { allow(subject).to receive(:enqueue) }

    let(:account) { FactoryGirl.create(:account) }
    let(:book) { FactoryGirl.create(:book, account: account) }
    let(:chapter) { FactoryGirl.create(:chapter, book: book) }
    let(:element) { FactoryGirl.create(:element, chapter: chapter) }
    let!(:note_1) { element.notes.create!(number: 1) }
    let!(:note_2) { element.notes.create!(number: 2) }

    subject { BookReceiver.new(book) }

    let(:payload) do
      {
        "after" => "abc123",
        "commits" => [
          {
            "id" => "abc123",
            "message" => "Fixes #1"
          },
          {
            "id" => "abc124",
            "message" => "Fixes #2"
          }
        ]
      }
    end

    context "when the commit message contains 'Fixes #\d+'" do
      let(:message) { "Fixes #1" }

      it "accepts the relevant note" do
        subject.perform(payload)
        expect(note_1.reload.state).to eq("accepted")
        expect(note_2.reload.state).to eq("accepted")
      end
    end
  end
end
