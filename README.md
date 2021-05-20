# chef-demo
This repo will provide you a sample chef setup for a wordpress application. you will be using the Haproxy loadbalancer, webserver and mysql DB setup your wordpress application. It's a full automated process and can be only used with hosted chef (https://manage.chef.io).

Once the correct role is assigned to tha play list it will take care of the rest. Please refer below details for the syntax.

**Roles**
Roles are used to categorize your servers like webservers, dbservers, monitoring servers, etc.

Roles should run as a JSON format and upload to the chef server or directly can create on chef server GUI.

Roles can be use to create identical server sets at once.

Roles uses to overwrite default attributes in cookbooks. Because roles has high priority than cookbooks’ default attributes.

roles1

This is a sample role file in JSON format for webserver cookbook to overwite default attributes to port 9090 & domain as dushan.com

{
  "name" : "apache",
  "default_attributes" : {
    "webserver" : {
      "domain_name" : "dushan.com",
      "app_port" : "9090"
    }
  },
  "run_list" : [
    "recipe[webserver]"
  ]
}

1. Once you create above you can upload this to the chef server using following command;
# knife role from file  apache.json

2. List current runlist/roles for webserver3.example.com server
knife node show webserver3.example.com

3. Remove existing recipe
knife node run list remove webserver3.example.com "recipe[webserver]"

4. Add new role to webserver3.example.com node
knife node run list add webserver3.example.com "role[apache]"

5. login to the node and run chef-client
