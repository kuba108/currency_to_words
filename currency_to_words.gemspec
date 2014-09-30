Gem::Specification.new do |s|
  s.name = "currency_to_words"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jakub Malina"]
  s.date = "2014-09-29"
  s.description = "Rails 4 helper to_words that displays a currency amount in words (eg. 'one hundred dollars')"
  s.email = "majak108@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "VERSION",
    "lib/currency_to_words.rb",
    "lib/cs_currency.rb"
  ]
  s.homepage = "https://github.com/kuba108/currency_to_words"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.2.2"
  s.summary = "Rails 4 helper to_words that displays a currency amount in words (eg. 'one hundred dollars')"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.1"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.1"])
      s.add_dependency(%q<actionpack>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.1"])
    s.add_dependency(%q<actionpack>, [">= 3.1"])
  end
end

