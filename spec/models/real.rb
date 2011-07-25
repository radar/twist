require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book") }
  let(:book) { Factory(:book) }
  
  
  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path) if File.exists?(git.path)
    git.update!
  end

  it "processes chapter one" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch01/ch01.xml")
    chapter = book.chapters.first
    chapter.title.should == "Ruby on Rails, the framework"
    chapter.identifier.should == "ch01_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["What is Ruby on Rails?",
                                     "Benefits",
                                     "Common Terms",
                                     "Rails in the wild",
                                     "Developing your first application",
                                     "Installing Rails",
                                     "Generating an application",
                                     "Starting the application",
                                     "Scaffolding",
                                     "Migrations",
                                     "Viewing & creating purchases",
                                     "Validations",
                                     "Showing off",
                                     "Routing",
                                     "Updating",
                                     "Deleting",
                                     "Summary"]
    chapter.figures.count.should == 13
    chapter.figures.first.filename.should == "ch01/app.jpg"
  end
  
  it "processes chapter two" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch02/ch02.xml")
    chapter = book.chapters.first
    chapter.title.should == "Testing saves your bacon"
    chapter.identifier.should == "ch02_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Test and Behavior Driven Development",
                                     "Test Driven Development",
                                     "Why test?",
                                     "Writing our first test",
                                     "Saving Bacon",
                                     "Behavior Driven Development",
                                     "RSpec",
                                     "Cucumber",
                                     "Summary"]
    chapter.figures.count.should == 0
  end
  
  it "processes chapter three" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch03/ch03.xml")
    chapter = book.chapters.first
    chapter.title.should == "Developing a real Rails application"
    chapter.identifier.should == "ch03_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Application setup",
                                     "The application story",
                                     "Version control",
                                     "The Gemfile & Generators",
                                     "Database configuration",
                                     "Applying a stylesheet",
                                     "First steps",
                                     "Creating projects",
                                     "RESTful routing",
                                     "Committing changes",
                                     "Setting a page title",
                                     "Validations",
                                     "Summary"]
    chapter.figures.count.should == 4
    chapter.figures.first.filename.should == "ch03/account_settings.png"
  end
end