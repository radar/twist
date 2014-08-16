# Twist 

Twist provides an easy book-reviewing platform for authors using the LeanPub Markdown format. Twist will update your book *as soon as you push it to GitHub*. It's super easy!

You give people a login for the system (through the rails console), and then they can leave notes on the elements within the chapters within your books. Elements are anything ranging from paragraphs, to images, to blockquotes and so on.

Twist uses MongoDB (with the Mongoid adapter), because strangely enough they are suitable for
this purpose. MongoDB works extremely well with nested documents, and if you think about it, the information about books that's stored inside Twist are just nested documents:

    Book -> Chapters -> Elements -> Notes -> Comments

It also uses Redis for background job processing using Sidekiq.

I wrote the foundations for this application in one single day after I raged at [Manning's](http://manning.com) review tool lacking specific features I wanted, such as automatic updating when I pushed to a repo. Now I've released it into the wild, converted it to use Leanpub's Markdown so that myself and other Leanpub authors may use this tool.

## Installation

To run this, you'll need the following:

* Ruby 2.1.2
* Rails 4.1.4
* Redis
* MongoDB

Install the dependencies for the app and the submodules that Twist uses for testing using these commands:

    bundle install
    git submodule init
    git submodule update

The app also uses [Sidekiq](http://sidekiq.org) to run some background jobs for books. Books won't be processed at all unless you're running the workers, so make sure to do that.

To set up the application, you'll need to create a book and a user. The best place to do that is in the `rails console`:

    book = Book.create(:title => "Markdown Book Test", :path => 'radar/markdown_book_test')
    book.enqueue
    User.create(:email => "test@example.com", :password => "password")

Once you've done that (and made sure the Sidekiq workers are running!), you should be able to go into the application and see the book in its current state.

If you want to set up post-receive hooks -- which is basically the whole point of the application! -- then [set one up on GitHub](https://help.github.com/articles/post-receive-hooks), pointing it at http://yourserver.com/books/receive and Twist will do the rest.

## I SAW A BUG! I DID! I DID!

If you've seen a bug, please file an issue on https://github.com/radar/twist/issues and I'll try to deal with it when I get a moment. Twist's sourcecode is fairly light and so you may even be able to dive in to it yourself and figure it out. Go on, give it a try!