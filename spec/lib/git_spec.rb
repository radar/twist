require 'spec_helper'

describe Git do
  let(:args) { ["radar", "rails3book_test"] }
  let(:test_repo) { Git.path + args.join("/") }

  before do
    FileUtils.rm_r(Git.path + args.join("/")) if File.exist?(test_repo)
  end

  it "returns the repository path" do
    Git.path.to_s.should == (Rails.root + "repos").to_s
  end

  it "checks to see if a repository exists" do
    Git.new(*args).exists?.should be_false
  end

  it "initializes a new repository" do
    git = Git.new(*args)
    git.should_receive(:`).with("git clone #{Git.host}#{args.join("/")} #{test_repo}")
    git.update!
  end
  
  it "updates an existing repository" do
    # Need to test this "live" to make sure everything goes through right
    git = Git.new(*args)
    git.update! # clones the repository

    git.should_receive(:`).with("git checkout")
    git.should_receive(:`).with("git pull origin master")
    git.update! # updates
  end

  it "retreives a list of files" do
    git = Git.new(*args)
    git.update!
    git.files.should == Dir[git.path + "**/*"]
  end
end