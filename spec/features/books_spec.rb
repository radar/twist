require "rails_helper"

feature "Books" do
  let!(:account) { FactoryGirl.create(:account, :subscribed) }
  let!(:book) { create_markdown_book!(account) }

  before do
    process_book(book)
    login_as(account.owner)
    set_subdomain(account.subdomain)
  end

  context "navigating" do
    it "sees a list of frontmatter / mainmatter / backmatter" do
      visit book_path(book)

      within("#frontmatter") do
        expect { find_link("Introduction") }.not_to raise_error
      end

      within("#mainmatter") do
        expect { find_link("In the beginning") }.not_to raise_error
        expect { find_link("Another chapter") }.not_to raise_error
      end

      within("#backmatter") do
        expect { find_link("Appendix") }.not_to raise_error
      end
    end

    it "can navigate through all the book" do
      visit book_path(book)

      click_link "Introduction"
      expect(find("#previous_chapter").text).to be_blank
      expect(find("#next_chapter").text).to eq("Chapter 1: In the beginning »")

      click_link "Chapter 1: In the beginning"
      expect(find("#previous_chapter").text).to eq("« Introduction")
      expect(find("#next_chapter").text).to eq("Chapter 2: Another chapter »")

      click_link "Chapter 2: Another chapter"
      expect(find("#previous_chapter").text).to eq("« Chapter 1: In the beginning")
      expect(find("#next_chapter").text).to eq("Appendix »")

      click_link "Appendix"
      expect(find("#previous_chapter").text).to eq("« Chapter 2: Another chapter")
      expect(find("#next_chapter").text).to be_blank
    end
  end
end
