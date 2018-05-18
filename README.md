[![CircleCI](https://img.shields.io/circleci/project/markmercedes/krudmin.svg)](https://circleci.com/gh/markmercedes/krudmin/tree/master)
[![Code Climate](https://codeclimate.com/github/markmercedes/krudmin/badges/gpa.svg)](https://codeclimate.com/github/markmercedes/krudmin)
[![Test Coverage](https://d3s6mut3hikguw.cloudfront.net/github/markmercedes/krudmin/badges/coverage.svg)](http://codeclimate.com/github/markmercedes/krudmin/badges/)
[![codebeat badge](https://codebeat.co/badges/e619cc8c-3212-4fa7-b75c-2fe266e1305b)](https://codebeat.co/projects/github-com-markmercedes-krudmin-master)

# Krudmin
A Framework on top of Rails engine that provides powerful ways to manage your backend data.

 [Try this demo App](https://krudmin.herokuapp.com/admin)

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'krudmin', github: 'markmercedes/krudmin'
```

**Installing an specific tag**

```ruby
gem 'krudmin', github: 'markmercedes/krudmin', tag: '0.1.7.9.5.1'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install krudmin
```

## What is krudmin?

Krudmin is a Rails library that facilitates the generation of easy to use admin panels. User interfaces generated with Krudmin come out of the box with regular CRUD functionalities, powerful search capabilities and mechanisms for toggling the status of models.

The problem krudmin tries to solve has been already addressed by other libraries in the Rails' ecosystem. Krudmin's approach tries to provide a better developer and user experience in tasks related with the generation and usage of admin panels.

**Other similar projects in the rails' ecosystem:**

- [Administrate](https://github.com/thoughtbot/administrate)
- [Rails Admin](https://github.com/sferik/rails_admin)
- [Active Admin](https://github.com/activeadmin/activeadmin)

By using no custom DSL and having respect for Rails' conventions, the developer should be on board sooner that later with the library.

By keeping the code as decoupled as possible in order to ensure the maintanability of the codebase, this also helps rappid iterations in terms of fixing possible bugs and the addition of new features.

In terms of user experience, generated interfaces should be out of the box easy to use by the average Joe. JS libraries such as Turbolinks, sweet alert, js calendars and others are included by default in order to enchance the usage of the generated interfaces.

## Contributing
See at [contributing.md](/docs/contributing.md).

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
