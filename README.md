= Gem currency_to_words

Provides a view helper for Rails that translate a currency amount to words (eg. <tt>to_words(200)</tt> \=> 'dvě stě').

This helper comes with two supported locales (Czech and Polish) but it is possible and easy to implement your own (see "Implementing a new locale").

== Installation

Add the gem to your Gemfile.

  gem 'currency_to_words'

== Usage

Will be updated.

== Examples

Will be updated.

== Inspiration

This project is heavily inspirated by [bcarrere/currency-in-words](https://github.com/bcarrere/currency-in-words) and uses blocks of code from this repository.

Reason for creating my own repository was requirement to use I18n gem for "currency to words" translation and also for settings.
This means, that this gem can be configured from locale file and translation is not hardcoded to source of library.

== Copyright

Copyright (c) 2014 Jakub Malina. See LICENSE.txt for
further details.
