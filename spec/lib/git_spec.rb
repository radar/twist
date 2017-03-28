require 'rails_helper'
require 'shellwords'

describe Git do
  let(:args) { ["radar", "markdown_book_test"] }
  let(:test_repo) { Git.path + args.join("/") }

  before do
    FileUtils.rm_rf(Git.path + args.join("/")) if File.exist?(test_repo)
  end

  it "returns the repository path" do
    expect(Git.path.to_s).to eq((Rails.root + "repos").to_s)
  end

  it "checks to see if a repository exists" do
    expect(Git.new(*args).exists?).to be(false)
  end

  it "initializes a new repository" do
    git = Git.new(*args)
    origin = Shellwords.escape("#{Git.host}#{args.join("/")}")
    destination = Shellwords.escape(test_repo)
    expect(git).to receive(:`).with("git clone -q #{origin} #{destination}")
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
