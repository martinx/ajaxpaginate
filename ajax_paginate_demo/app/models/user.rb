class User < ActiveRecord::Base
    class<<self
        def per_page
            20
        end
    end
end
