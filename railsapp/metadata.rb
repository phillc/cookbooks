maintainer        "Phillip Campbell"
maintainer_email  "pccampbell@patrickdavis.com"
description       "Sets up an app server for the Davis website."

%w{ passenger_apache2::mod_rails rails git mysql::client }.each do |cb|
  depends cb
end