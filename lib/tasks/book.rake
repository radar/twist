namespace :book do
  task :load => :environment do
    Book.delete_all
    Book.create!(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book_test")
  end
end