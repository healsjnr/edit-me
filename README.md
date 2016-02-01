edit-me
=======

Edit-me is a work in progress. The intention with Edit-me is to create a place that allows writers and editors to
collaborate without hassle. In particular we want to make it as easy as possible for editors to generate quotes and collect
payments from the clients.

Key features:
* Simple document workflow - Allow clients to submit documents and editors update with their changes. In Progress
* Document version control - Store all versions of documents submitted by clients and editors. In Progress
* Quoting - Allow clients to request and accept quotes based on samples of their work. TODO
* Payment Processing - Use stripe to process payments. TODO
* Billing Info - Generate Monthly invoices for editors. TODO

## Development

### Setup

    $ bundle install
    $ npm install

### Back-end tests

    $ bundle exec rake spec

### Front-end test

    $ npm test

### Run me

    $ rails s

or

    $ bundle exec unicorn_rails -E production

## Deployment

Push to develop on Github kicks off a Docker build on Docker Hub.

Once the new image is built, log into Digital Ocean and revert the dev instance to snapshot.

On boot, this box pulls down the latest image from DockerHub and runs it. See /deploy/deploy_notes for the init script.

TODO: this whole process can be automated using the dockerhub APIs

