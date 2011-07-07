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
  
  def changed_files(old_commit=nil)
    Dir.chdir(path) do
      # If there is an old_commit specified 
      # and there's more than one commit in the repo
      # Then show a diff between current commit and last-known commit (old_commit)
      if old_commit && `git log --oneline | wc -l`.to_i > 1
        return `git diff --name-only HEAD #{old_commit}`.split("\n")
      # Otherwise, return a list of files for this repository.
      else
        Dir["**/*"]
      end
    end
  end
  
  alias_method :files, :changed_files
  
  def current_commit
    Dir.chdir(path) do
      `git rev-parse HEAD`.strip
    end
  end
end