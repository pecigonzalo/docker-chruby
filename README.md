# pecigonzalo/docker-chruby
[![Build Status](https://travis-ci.org/pecigonzalo/docker-chruby.svg?branch=master)](https://travis-ci.org/pecigonzalo/docker-chruby)

[![Logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/ruby/logo.png)](https://en.wikipedia.org/wiki/Ruby_%28programming_language%29)

## What is Ruby?
Ruby is a dynamic, reflective, object-oriented, general-purpose, open-source programming language. According to its authors, Ruby was influenced by Perl, Smalltalk, Eiffel, Ada, and Lisp. It supports multiple programming paradigms, including functional, object-oriented, and imperative. It also has a dynamic type system and automatic memory management.

## Motive
You might wonder, why should i use this instead the official Ruby image?
I believe its a really good practive to not use the system ruby system to run non system application, so i decided to use **chruby** to generate an easy to setup, easy to use set of ruby base images.
In addition, this Dockerfile allows to generate images quickly for any version of ruby supported by **ruby-install**.

## Usage
### Run a single Ruby script
```
docker run -it --rm --name MyAwesomeScript \  
    -v "$PWD":/usr/src/app 
    -w /usr/src/app pecigonzalo/chruby:2.2 ruby script.rb
```

### As base image for another Dockerfile
Creat Dockerfile on the in your project folder
```
FROM pecigonzalo/chruby:2.3

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./ /usr/src/app

RUN gem install bundler
RUN bundle install

CMD ["irb"]
```
You can then build and run the image using
```
docker build -t MyAwesomeAppImage .
docker run -it --name MyAwesomeApp MyApp
```

### GEMRC
I have bundled what i believe is a good standard gemrc file, feel free to overwrite it 
before installing any gems

## TODO

I would like to support different base distros, altough i think it might be better
to do it under a different repository
[] Support Ubuntu 16.04 images
[] Support Debian images
[] Support CentOS images
[] Support Alpine images
