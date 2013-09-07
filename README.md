#Install Arrivuapps Portal app,

* 1.git clone -b develop http://github.com/m-narayan/arrivuapps.git
* 2.bundle install
* 3.change config/database.yml
         development:
            adapter: postgresql
            database: portal_development
            username: portal
            password: portal
            host: localhost
            reconnect: true
* 4.create database
*    $psql -U postgres
*    create role portal password portal login createdb;
*    create database portal_development;
*    \q
* 5.bundle exec rake db:migrate
* 6.bundle exec rake db:seed
* 7.bundle exec rake db:populate
* 8.bundle exec rake db:demo
* 9.rails s

in the browser:

portal.lvh.me
  and
demo.lvh.me
