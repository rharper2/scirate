# SciRate - Usydrate version.

This is a modified version of scirate, which I *know* I will struggle to keep up to date with the current scirate master.

The idea is that it introduces a new group page tab. Members can 'usydite' err scite, papers and they will be up for discussion at our group meetings.
Limited ability to add comments to be discussed at the meeting. Also a group page, with a timed message for the week etc.

Very basic functionality. Papers are sorted based on group scites and also Scirate scites (the scirate site is scaped periodically). There is no click through just now i.e. we don't try and update scites on scirate, but if you click the scirate count it will open scirate ready for you to scite the paper there.

## Things that I know are currently broken 

- the ability to attach images to comments.


### From the main Scirate README
----

[SciRate](https://scirate.com/) is an open source rating and commenting system for [arXiv](http://arxiv.org/) preprints. Papers are upvoted and discussed by the community, and we sometimes play host to more [in depth peer review](https://scirate.com/tqc-2014-program-committee).

Bug reports and feature requests should be submitted as [GitHub issues](https://github.com/scirate/scirate/issues).

----

# Instructions to set up on a clean version of UBUNTU 20.04

(Most of these instructions will work with a clean scirate install - I'll try and note when these files differ from the standard scirate one).

## The first thing is to get ruby and rails sorted. For this I used the following:

[https://gorails.com/setup/ubuntu/20.04](https://gorails.com/setup/ubuntu/20.04)

### INSTALL RUBY AND RAILS


- sudo apt-get update
- sudo apt install curl
- curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
- curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
- echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

- sudo apt-get update
- sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn


# change to a suitable directory

- git clone https://github.com/rbenv/rbenv.git ~/.rbenv
- echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
- echo 'eval "$(rbenv init -)"' >> ~/.bashrc
- exec $SHELL

- git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
- echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
- exec $SHELL

- rbenv install 3.0.0
- rbenv global 3.0.0
- ruby -v

- gem install bundler
- rbenv rehash

- gem install rails -v 6.1.1
- rbenv rehash

- rails -v
# Rails 6.1.1

# Setting Up PostgreSQL

#### NOTE gorails installs 11

sudo apt install postgresql-12 libpq-dev


sudo -u postgres createuser parallels -s

# If you would like to set a password for the user, you can do the following
sudo -u postgres psql

postgres=# \password parallels



cp config/database.yml.example config/database.yml


### Because I am using 3.0.0 I removed the Gemfile.lock, and changed the .ruby_env file to 3.0.0 and also in Gemfile

# We also need
- sudo apt-get update
- sudo apt-get install g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x


# We need elastic search
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-20-04

# if we don't have java (I didn't) java -version tells you
- sudo apt install default-jre
- sudo apt install default-jdk


### check with javac -version

```javac 11.0.9.1```

- curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
- echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
- sudo apt update
- sudo apt install elasticsearch

### You should check networkhost in /etc/elasticsearch/elasticsearch.yml*

- sudo systemctl start elasticsearch
- sudo systemctl enable elasticsearch

### There were a few other changes I did, you won't need to redo them - they are in this repo:

- I had to change the arxiv_feed_import.rake file (in lib/tasks) to read URI.open rather than just open on line 23
- Had to add -- gem 'rexml'  -- to the Gemfile (remember to bundle install again)


## Run the following

- bundle install


- rake db:setup
- rake es:migrate
- rake arxiv:feed_import
- rails server

(kill server - CTRL-C)

## How to get it up and running.

### Populating the database


- rake arxiv:oai_update
- rails s 

----
Note: (aide memoire to me), if you want to bind rails so it can have external access -b 0.0.0.0. And port e.g. -p 3000
Also nginx to proxypass from 80->3000

----

# And it seems to work!

## Still to do -

- recaptcha not working, so for this instance I have just removed references to it. I probably just needed to update keys.
- you will need to set up email credentials in application.rb (or something do a grep on GMAIL)

# Below is the readme taken from scirate (which is out of date)

-----

## Setting up for development

SciRate runs on [Ubuntu 14.04](http://releases.ubuntu.com/14.04/) in production. Development in other environments is possible, but this guide will assume you are running some variant of Debian.

We currently use Ruby 2.2.1 and Rails 4.2. To install this version of Ruby and [RVM](https://rvm.io/):

```shell
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.1
rvm use 2.2.1 --default
```

If you find this does not work, you may have more luck with the following:

```shell
sudo apt install gnupg2
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
cd /tmp
curl -sSL https://get.rvm.io -o rvm.sh
cat /tmp/rvm.sh | bash -s stable --ruby=2.2.1
source /home/<USERNAME>/.rvm/scripts/rvm
```

Source: [How To Install Ruby on Rails with RVM on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rvm-on-ubuntu-18-04)

You will also need some native packages:

```shell
sudo apt-get install git postgresql libpq-dev libxml2-dev libxslt-dev nodejs libodbc1 libqt4-dev openjdk-8-jre libqt5webkit5-dev
```

Our backend depends on [Elasticsearch](http://www.elasticsearch.org/) to sort through all the papers:

```shell
curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-amd64.deb -o elasticsearch.deb
sudo dpkg -i --force-confnew elasticsearch.deb
sudo chown -R elasticsearch:elasticsearch /etc/default/elasticsearch
sudo service elasticsearch restart
```

**Note**: You can run `sudo service elasticsearch status` to confirm elasticsearch is running.
If you are having issues running elastic search via the service, you can run it manually.
Find the binary location with `which elasticsearch` and run it from the location that is reported back to you.
e.g.

```shell
/usr/share/elasticsearch/bin/elasticsearch
```

Elasticsearch must be running for `rake es:migrate` and `rails server` commands to work.

Finally, clone the repository and install the Ruby gem dependencies:

```shell
git clone git@github.com:scirate/scirate
cd scirate
bundle install
```

**Note:** If you encounter issues with Capybara installing correctly, i.e. your computer complains `command qmake not available` you can do the following to ensure you have the correct dependencies:

```shell
sudo apt-get update
sudo apt-get install g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
```

**Note:** If the pg gem fails to install with the error message `Can't find the 'libpq-fe.h header` you can try the following (Debian/Ubuntu):

```shell
sudo apt-get install libpq-dev
```

Other OS specific solutions avaliable here: [Stack Overflow Link](https://stackoverflow.com/a/6040822/12848423)

SciRate is now set up for development! However, you'll also want a database with papers to fiddle with.

## Setting up the database

If you've just installed postgres, it'll be easiest to use the default 'peer' authentication method. Create a postgres role for your user account:

```shell
sudo -u postgres createuser --superuser $USER
```

Copy the example database configuration file (:

```
cp config/database.yml.example config/database.yml
```

If using peer authentication, you won't need to edit this file.

Then:

```shell
rake db:setup
rake es:migrate
rake arxiv:feed_import
rails server
```

This will initialize the database and Elasticsearch, download the basic feed layout, and start the server. If es:migrate is not working check that it is running, as per the notes above.

## Populating the database

```shell
rake arxiv:oai_update
```

When run for the first time, this will download and index paper metadata from the last day. Subsequent calls will download all metadata since the last time. The production server runs this task every day to keep the database in sync.

## Testing

There is a fairly comprehensive series of unit and integration tests in `spec`. Running `rspec` in the top-level directory will attempt all of them.

## Acknowledgements

- Maintained by [Noon van der Silk](https://github.com/silky)
- Original website by [Dave Bacon](http://dabacon.org)
- [Bill Rosgen](http://intractable.ca/bill/)
- [Aram Harrow](http://www.mit.edu/~aram/)
- [Draftable](https://draftable.com/)
