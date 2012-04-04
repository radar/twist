require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book") }
  let(:book) { FactoryGirl.create(:book) }
  
  
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
    chapter.xml_id.should == "ch01_1"
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
    chapter.xml_id.should == "ch02_1"
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
    chapter.xml_id.should == "ch03_1"
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
  
  it "processes chapter four" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch04/ch04.xml")
    chapter = book.chapters.first
    chapter.title.should == "Oh CRUD!"
    chapter.xml_id.should == "ch04_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Viewing Projects",
                                     "Writing a feature",
                                     "The Factory Girl",
                                     "Adding a link to a project",
                                     "Editing Projects",
                                     "The edit action",
                                     "The update action",
                                     "Deleting Projects",
                                     "Writing a feature",
                                     "Adding a destroy action",
                                     "Looking for what is not there",
                                     "Summary"]
    chapter.figures.count.should == 2
    chapter.figures.first.filename.should == "ch04/record_not_found.png"
  end
  
  it "processes chapter five" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch05/ch05.xml")
    chapter = book.chapters.first
    chapter.title.should == "Nested resources"
    chapter.xml_id.should == "ch05_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Creating tickets",
                                     "Nested routing helpers",
                                     "Creating a tickets controller",
                                     "Defining a has_many association",
                                     "Creating tickets within a project",
                                     "Finding tickets scoped by project",
                                     "Ticket validations",
                                     "Viewing tickets",
                                     "Listing tickets",
                                     "Culling tickets",
                                     "Editing tickets",
                                     "Adding the edit action",
                                     "Adding the update action",
                                     "Deleting tickets",
                                     "Summary"]
    chapter.figures.count.should == 0
  end
  
  it "processes chapter six" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch06/ch06.xml")
    chapter = book.chapters.first
    chapter.title.should == "Authentication & Basic Authorization"
    chapter.xml_id.should == "ch06_5015"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["What Devise Does",
                                     "Installing Devise",
                                     "User signup",
                                     "Confirmation link sign in",
                                     "Testing email",
                                     "Confirming confirmation",
                                     "Form sign in",
                                     "Linking tickets to users",
                                     "Attributing tickets to users",
                                     "We broke something!",
                                     "Fixing the Viewing Tickets feature",
                                     "Fixing the Editing Tickets feature",
                                     "Fixing the Deleting Tickets feature",
                                     "Summary"]
    chapter.figures.count.should == 0
  end
  
  it "processes chapter seven" do
    p git.path + "ch07/ch07.xml"
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch07/ch07.xml")
    chapter = book.chapters.first
    chapter.title.should == "Basic Access Control"
    chapter.xml_id.should == "ch07_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Projects can only be created by admins",
                                     "Adding the admin field to the users table",
                                     "Restricting actions to admins only",
                                     "Fixing three more broken scenarios",
                                     "Hiding the \"New Project\" link", 
                                     "Hiding the edit and delete links",
                                     "Namespace routing",
                                     "Generating a namespaced controller",
                                     "Wrapping up",
                                     "Namespace Based CRUD",
                                     "Writing a feature",
                                     "Adding a namespace root",
                                     "The index action",
                                     "The new action",
                                     "The create action",
                                     "Creating Admin Users",
                                     "Writing a feature",
                                     "Identifying admin users",
                                     "Wrapping up",
                                     "Editing users",
                                     "Writing a feature",
                                     "The show action",
                                     "The edit action",
                                     "The update action",
                                     "Wrapping up",
                                     "Deleting users",
                                     "Writing a feature",
                                     "The destroy action",
                                     "Ensuring you cannot delete yourself",
                                     "Wrapping up"]
    chapter.figures.count.should == 0
  end
  
  it "processes chapter eight" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch08/ch08.xml")
    chapter = book.chapters.first
    chapter.title.should == "More Authorization"
    chapter.xml_id.should == "ch08_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Restricting read access",
                                     "Restricting by scope",
                                     "Fixing what we broke",
                                     "Fixing editing projects",
                                     "Fixing the four failing features",
                                     "One more thing",
                                     "Fixing signing up",
                                     "Blocking access to tickets",
                                     "Locking out the bad guys",
                                     "Restricting write access",
                                     "Re-writing a feature",
                                     "Blocking creation",
                                     "What is CanCan?",
                                     "Adding abilities",
                                     "Restricting update access",
                                     "No updating for you!",
                                     "Authorizing editing",
                                     "Restricting delete access",
                                     "Enforcing destroy protection",
                                     "Hiding links based on permission",
                                     "Assigning permissions",
                                     "Viewing projects",
                                     "The permissions controller",
                                     "The permissions screen",
                                     "Defining a helper method",
                                     "And the rest",
                                     "Creating tickets",
                                     "The Double Whammy",
                                     "Seed data",
                                     "Summary"]
    chapter.figures.count.should == 6
  end
  
  it "processes chapter nine" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch09/ch09.xml")
    chapter = book.chapters.first
    chapter.title.should == "File uploading"
    chapter.xml_id.should == "ch09_5"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Attaching a file",
                                    "A feature featuring files",
                                    "Enter Stage Right, Paperclip",
                                    "Using Paperclip",
                                    "Attaching many files",
                                    "Two more files",
                                    "Using Nested Attributes",
                                    "Serving files through a controller",
                                    "Protecting files",
                                    "Showing our assets",
                                    "Public Assets",
                                    "Privatizing Assets",
                                    "Using JavaScript",
                                    "JavaScript testing",
                                    "Introducing jQuery",
                                    "Adding more files with JavaScript",
                                    "Responding to an asynchronous request",
                                    "Sending parameters for an asynchronous request",
                                    "Learning CoffeeScript",
                                    "Passing through a number",
                                    "Summary"]
    chapter.figures.count.should == 3
  end
  
  it "processes chapter ten" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch10/ch10.xml")
    chapter = book.chapters.first
    chapter.title.should == "Tracking State"
    chapter.xml_id.should == "ch10_3"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Leaving a comment",
                                     "Where's the ticket?",
                                     "The comment form",
                                     "The comment model",
                                     "The comments controller",
                                     "Changing a ticket's state",
                                     "Creating the state model",
                                     "Selecting states",
                                     "Callbacks",
                                     "Seeding states",
                                     "Fixing creating comments",
                                     "Tracking changes",
                                     "Ch-ch-changes",
                                     "Another C-c-callback",
                                     "Displaying changes",
                                     "Show me the page",
                                     "Automatic escaping saves our bacon",
                                     "Styling states",
                                     "Managing states",
                                     "Adding additional states",
                                     "Defining a default state",
                                     "Locking down states",
                                     "Hiding a select box",
                                     "Bestowing changing state permissions",
                                     "Hacking a form",
                                     "Ignoring a parameter",
                                     "Summary"]
    chapter.figures.count.should == 19
  end
  
  it "processes chapter eleven" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch11/ch11.xml")
    chapter = book.chapters.first
    chapter.title.should == "Tagging"
    chapter.xml_id.should == "ch11_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Creating tags",
                                     "Creating tags feature",
                                     "Using text_field_tag",
                                     "Showing tags",
                                     "Defining the tags association",
                                     "The Tag model",
                                     "Displaying a ticket's tags",
                                     "Adding more tags",
                                     "Adding tags through a comment",
                                     "Fixing comments controller spec",
                                     "Tag restriction",
                                     "Testing tag restriction",
                                     "Tags are allowed, for some",
                                     "Deleting a tag",
                                     "Testing tag deletion",
                                     "Adding a link to delete the tag",
                                     "Actually removing a tag",
                                     "Finding tags",
                                     "Testing search",
                                     "Searching by state with Searcher",
                                     "Searching by state",
                                     "Search, but without the search",
                                     "Summary"]
    chapter.figures.count.should == 7
  end
  
  it "processes chapter twelve" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch12/ch12.xml")
    chapter = book.chapters.first
    chapter.title.should == "Sending Email"
    chapter.xml_id.should == "ch12_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Sending ticket notifications",
                                     "Automatically watching a ticket",
                                     "Using observers",
                                     "Defining the watchers association",
                                     "Introducing Action Mailer",
                                     "An Action Mailer template",
                                     "Delivering HTML emails",
                                     "Subscribing to updates",
                                     "Testing comment subscription",
                                     "Automatically add a user to a watchlist",
                                     "Unsubscribing from ticket notifications",
                                     "Real world email",
                                     "Testing real world email",
                                     "Configuring Action Mailer",
                                     "Connecting to Gmail",
                                     "Receiving emails",
                                     "Setting a reply-to address",
                                     "Receiving a reply",
                                     "Summary"]
    chapter.figures.count.should == 9
  end
  
  it "processes chapter thirteen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch13/ch13.xml")
    chapter = book.chapters.first
    chapter.title.should == "Designing an API"
    chapter.xml_id.should == "ch13"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["The projects API",
                                     "Our first API",
                                     "Serving an API",
                                     "API Authentication",
                                     "Error reporting",
                                     "Serving XML",
                                     "Creating projects",
                                     "Restricting access to only admins",
                                     "A single project",
                                     "No project for you!",
                                     "Updating a project",
                                     "Exterminate!",
                                     "Beginning the Tickets API",
                                     "Rate limiting",
                                     "One request, two request, three request, four",
                                     "No more, thanks!",
                                     "Back to zero",
                                     "Versioning an API",
                                     "Creating a new version",
                                     "Summary"]
    chapter.figures.count.should == 0
  end
  
  it "processes chapter fourteen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch14/ch14.xml")
    chapter = book.chapters.first
    chapter.title.should == "Deployment"
    chapter.xml_id.should == "ch14"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Server setup",
                                     "Setting up a server using VirtualBox",
                                     "Installing the base",
                                     "RVM and Ruby",
                                     "Installing RVM",
                                     "Installing Ruby",
                                     "Creating a user for the app",
                                     "Key-based authentication",
                                     "Disabling password authentication",
                                     "The database server",
                                     "Creating a database and user",
                                     "Ident authentication",
                                     "Deploy away!",
                                     "Deploy keys",
                                     "Configuring Capistrano",
                                     "Setting up the deploy environment",
                                     "Deploying the application",
                                     "Bundling gems",
                                     "Choosing a database",
                                     "Serving requests",
                                     "Installing Passenger",
                                     "An init script",
                                     "Summary"]
    chapter.figures.count.should == 5
  end
  
  it "processes chapter fifteen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch15/ch15.xml")
    chapter = book.chapters.first
    chapter.title.should == "Alternative Authentication"
    chapter.xml_id.should == "ch15"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["How OAuth Works",
                                     "Twitter Authentication",
                                     "Setting up OmniAuth",
                                     "Registering an application with Twitter",
                                     "Setting up an OmniAuth testing environment",
                                     "Testing Twitter Sign-in",
                                     "GitHub Authentication",
                                     "Registering and Testing GitHub Auth",
                                     "Summary"]
    chapter.figures.count.should == 6
  end
  
  it "processes chapter sixteen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch16/ch16.xml")
    chapter = book.chapters.first
    chapter.title.should == "Basic performance enhancements"
    chapter.xml_id.should == "ch16"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Pagination",
                                     "Introducing Kaminari",
                                     "Paginating an interface",
                                     "Paginating an API",
                                     "Database query enhancements",
                                     "Eager loading",
                                     "Database indexes",
                                     "Page and action caching",
                                     "Caching a page",
                                     "Caching an action",
                                     "Cache sweepers",
                                     "Client-side caching",
                                     "Caching page fragments",
                                     "Background workers",
                                     "Summary"]
    chapter.figures.count.should == 11
  end
  
  it "processes chapter seventeen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch17/ch17.xml")
    chapter = book.chapters.first
    chapter.title.should == "Engines"
    chapter.xml_id.should == "ch17"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["A brief history of engines",
                                     "Why engines are useful",
                                     "Brand new engine",
                                     "Creating an engine",
                                     "The layout of an engine",
                                     "Engine routing",
                                     "Setting up a testing environment",
                                     "Removing Test::Unit",
                                     "Installing RSpec & Capybara",
                                     "Writing our first engine feature",
                                     "Our first Capybara test",
                                     "Setting up routes",
                                     "The topics controller",
                                     "The index action",
                                     "The new action",
                                     "The create action",
                                     "The show action",
                                     "Showing an association count",
                                     "Adding more posts to topics",
                                     "Classes outside our control",
                                     "Engine configuration",
                                     "A fake User model",
                                     "Authenticating topics",
                                     "Adding authorship to topics",
                                     "Post authentication",
                                     "Showing the last post",
                                     "Releasing as a gem",
                                     "Integrating with an application",
                                     "Summary"]
    chapter.figures.count.should == 4
  end
  
  it "processes chapter eighteen" do
    book.path = (Rails.root + "repos/radar/rails3book").to_s
    Chapter.process!(book, git, "ch18/ch18.xml")
    chapter = book.chapters.first
    chapter.title.should == "Rack-based Applications"
    chapter.xml_id.should == "value"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["Building Rack applications",
                                     "A basic Rack application",
                                     "Building bigger Rack applications",
                                     "We're breaking up",
                                     "Running a combined Rack application",
                                     "Mounting a Rack application with Rails",
                                     "Mounting Heartbeat",
                                     "Introducing Sinatra",
                                     "The API, by Sinatra",
                                     "Basic error checking",
                                     "Middleware",
                                     "Middleware in Rails",
                                     "Investigating ActionDispatch::Static",
                                     "Crafting middleware",
                                     "Summary"]
    chapter.figures.count.should == 6
  end
  
end
