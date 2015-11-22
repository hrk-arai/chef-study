# see https://docs.chef.io/attributes.html
default["wordpress"]["document_root"] = "/usr/share/nginx/html/wordpress"
default["wordpress"]["package"] = "wordpress-4.2.2-ja.tar.gz"
default["wordpress"]["db"]["host"] = ""
default["wordpress"]["db"]["name"] = "wordpress"
default["wordpress"]["user"]["name"] = "wordpress"
default["wordpress"]["user"]["password"] = "wordpress"
