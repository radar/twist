require 'rails_helper'

describe 'chapters' do
  let(:user) { create_user! }
  before do
    create_book!
    actually_sign_in_as(user)
  end
  
  it "can view a given chapter and its parts" do
    visit book_chapter_path(@book, @book.chapters.first)
    
    within "div#chapter" do
    
      # Paragraph test
      within "p#ch01_3" do
        expect(page).to have_content("It's great to have you with us on this journey throughout the world of Ruby on Rails.")
      end
    
      # Footnote test
      within "span.footnote#ch01_11" do
        expect(page).to have_content("The MIT license")
      end
    
      # Callout test
      expect(lambda { page.find("img.callout") }).to_not raise_error
    
      # Section test
      within "h2#ch01_5" do
        expect(page).to have_content("1.1 What is Ruby on Rails?")
      end
    
      expect(page.find("a#ch01_797")["href"]).to eq("http://en.wikipedia.org/wiki/MIT_License")
    
      # Sub-section test
      within "h3#ch01_13" do
        expect(page).to have_content("1.1.1 Benefits")
      end

      # Formal paragraph
      expect(all("h4").first.text).to eq("MVC")

      # This content is within a formal paragraph
      expect(page).to have_content(" This paradigm is designed to keep the logically different")
    
      # Informal example
      expect(all("pre").first.text).to eq("rvm install 1.9.2")
    
      # Titled example
      within "div.example#ch01_428" do
        within ".title" do
          expect(page).to have_content("app/models/purchase.rb")
        end
      
        within "pre" do
          example_text = "class Purchase < ActiveRecord::Base"
          expect(page).to have_content(example_text)
        end
      end
    
      # Figure
      expect(page).to have_content("Figure 1.1 The app directory")
    
      # Table (oh boy, these are fun!)
      within "div.table" do
        within ".title" do
          expect(page).to have_content("Routing helpers and their routes")
        end

        within "table" do
          within "thead tr" do
            within "td:first" do
              expect(page).to have_content("Helper")
            end
            within "td:last" do
              expect(page).to have_content("Route")
            end
          end
        
          within("tbody tr:first") do
            within("td:first") do
              expect(page).to have_content("purchases_path")
            end

            within("td:last") do
              expect(page).to have_content("/purchases")
            end
          end
        end
      end
    
      # Notes
      within "div.note#ch01_920" do
        expect(page).to have_content("In the beginning...")
      end
    
      # pending("Parse footnote containing paragraph elements")
    end
  end
end
