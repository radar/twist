# In The Beginning

This is a test of the markdown processing system.

T> **The constraint request object**
T> 
T> The `request` object passed in to the `matches?` call in any constraint is
T> an `ActionDispatch::Request` object, the same kind of object that is available
T> within your application's (and engine's) controllers.
T>
T> You can get other information out of this object as well, if you wish. For
T> instance, you could access the Warden proxy object with an easy call to
T> `request.env['warden']`, which you could then use to only allow routes for an
T> authenticated user.

W> **Don't do that!**
W>
W> Please keep all extremities clear of the whirring blades.

{title=lib/subscribem/constraints/subdomain_required.rb,lang=ruby,line-numbers=on}
    module Subscribem
      module Constraints
        class SubdomainRequired
          def self.matches?(request)
            request.subdomain.present? && request.subdomain != "www"
          end
        end
      end
    end
