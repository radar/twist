# Twist 

Twist provides an easy book-reviewing platform for authors using the LeanPub Markdown format. You give people a login for the system (through the rails console), and then they can leave notes on the elements within the chapters within your books. Elements are anything ranging from paragraphs, to images, to blockquotes and so on.

Twist uses MongoDB (with the Mongoid adapter), because strangely enough they are suitable for
this purpose. MongoDB works extremely well with nested documents, and if you think about it, the information about books are just nested documents:

    Book -> Chapters -> Elements -> Notes -> Comments

It also uses Redis for background job processing using Sidekiq.

## Installation

To run this, you'll need the following:

* Ruby 2.1.0
* Rails 4.0.2
* Redis
* MongoDB
