class Git
  attr_accessor :user, :repo
  
  def self.host
    if Rails.env.production? || Rails.env.development?
      # Rely on GitHub
      "git@github.com:"
    else
      # Otherwise, clone locally to speed up tests
      Rails.root + "spec/fixtures/repos/"
    end
  end

  def self.path
    Pathname.new(Rails.root + "repos")
  end

  def initialize(user, repo)
    @user = user
    @repo = repo
  end
  
  def path
    self.class.path + "#{user}/#{repo}"
  end

  def exists?
    File.exists?(path)
  end

  def clone
    `git clone -q #{self.class.host}#{user}/#{repo} #{path}`
  end

  def pull
    Dir.chdir(path) do
      `git checkout -q`
      `git pull -q origin master`
    end
  end

  def update!
    exists? ? pull : clone
  end

  def current_commit
    Dir.chdir(path) do
      `git rev-parse HEAD`.strip
    end
  end
end
