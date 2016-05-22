require 'rails_helper'

describe Git do
  let(:args) { ["radar", "markdown_book_test"] }
  let(:test_repo) { Git.path + args.join("/") }

  before do
    FileUtils.rm_r(Git.path + args.join("/")) if File.exist?(test_repo)
  end

  it "returns the repository path" do
    expect(Git.path.to_s).to eq((Rails.root + "repos").to_s)
  end

  it "checks to see if a repository exists" do
    expect(Git.new(*args).exists?).to be(false)
  end

  it "initializes a new repository" do
    git = Git.new(*args)
    expect(git).to receive(:`).with("git clone -q #{Git.host}#{args.join("/")} #{test_repo}")
    git.update!
  end
  
  it "updates an existing repository" do
    # Need to test this "live" to make sure everything goes through right
    git = Git.new(*args)
    git.update! # clones the repository

    expect(git).to receive(:`).with("git checkout -q")
    expect(git).to receive(:`).with("git pull -q origin master")
    git.update! # updates
  end
end
