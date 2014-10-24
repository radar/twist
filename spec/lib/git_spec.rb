require 'rails_helper'
require 'git'

describe Git do
  let(:args) { ["radar", "rails3book_test"] }
  let(:test_repo) { Git.path + args.join("/") }

  before do
    FileUtils.rm_r(Git.path + args.join("/")) if File.exist?(test_repo)
  end

  it "returns the repository path" do
    expect(Git.path.to_s).to eq((Rails.root + "repos").to_s)
  end

  it "checks to see if a repository exists" do
    expect(Git.new(*args).exists?).to be_falsey
  end

  it "initializes a new repository" do
    git = Git.new(*args)
    allow(git).to receive(:`).with("git clone #{Git.host}#{args.join("/")} #{test_repo}")
    git.update!
  end

  it "updates an existing repository" do
    # Need to test this "live" to make sure everything goes through right
    git = Git.new(*args)
    git.update! # clones the repository

    expect(git).to receive(:`).with("git checkout")
    expect(git).to receive(:`).with("git pull origin master")
    git.update! # updates
  end

  it "retreives a list of files" do
    git = Git.new(*args)
    git.update!
    Dir.chdir(git.path) do
      expect(git.files).to eq(Dir["**/*"])
    end
  end
  
  context "changed files" do
    before do
      @git = Git.new(*args)
      @git.update!
      @old_commit = @git.current_commit
    end

    it "first commit ever" do
      expect(@git.changed_files).to eq([
        "ch01",
        "ch01/app.jpg",
        "ch01/ch01.xml",
        "ch01/hello_world.png",
        "ch01/new_purchase.png",
        "ch01/purchase_destroy.png",
        "ch01/purchase_errors.png",
        "ch01/purchase_errors_2.png",
        "ch01/purchase_listing.png",
        "ch01/purchases.png",
        "ch01/purchases_edit.png",
        "ch01/purchases_show_with_url.png",
        "ch01/show_purchase.png",
        "ch01/update_purchase_fail.png",
        "ch01/updated_purchase.png",
        "ch01/welcome_aboard.png",
        "manifest.txt"
      ])
    end

    it "contains new files" do
      Dir.chdir(@git.path) do
        `touch test.txt`
        `git add .`
        `git commit -m "Testing changes"`
      end

      expect(@git.changed_files(@old_commit)).to eq(["test.txt"])
    end

    it "contains modified files" do
      Dir.chdir(@git.path) do
        `echo "string" > ch01/ch01.xml`
        `git add .`
        `git commit -m "Testing changes"`
      end

      expect(@git.changed_files(@old_commit)).to eq(["ch01/ch01.xml"])
    end

    it "contains deleted files" do
      Dir.chdir(@git.path) do
        `git rm ch01/ch01.xml`
        `git commit -m "Testing changes"`
      end

      expect(@git.changed_files(@old_commit)).to eq(["ch01/ch01.xml"])
    end
  end

  it "retreives the current commit" do
    git = Git.new(*args)
    git.update!
    expect(git.current_commit).to eq("a4e96c73960b96a4db1ff50983e9966846b81688")
  end
end
