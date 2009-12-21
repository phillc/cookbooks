maintainer        "Phillip Campbell"
maintainer_email  "spyyderz+github@gmail.com"
description       "Sets up an app server for the Rails."

%w{ passenger_apache2::mod_rails rails git mysql::client }.each do |cb|
  depends cb
end
