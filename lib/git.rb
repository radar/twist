class Git
  attr_accessor :user, :repo
  
  def self.host
    if Rails.env.test?
      # Clone locally to speed up tests
      Rails.root + "spec/fixtures/repos/"
    else
      # Otherwise, rely on GitHub
      "git@github.com:"
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
    `git clone #{self.class.host}#{user}/#{repo} #{path}`
  end
  
  def pull
    Dir.chdir(path) do
      `git checkout`
      `git pull origin master`
    end
  end
  
  def update!
    exists? ? pull : clone
  end

  def files
    Dir[path + "**/*"]
  end
  
  def changed_files(old_commit)
    Dir.chdir(path) do
      return `git diff --name-only HEAD #{old_commit}`.split("\n")
    end
  end
  
  def current_commit
    Dir.chdir(path) do
      `git rev-parse HEAD`.strip
    end
  end
end