# encoding: utf-8
module CurrencyToWords

  require 'cs_currency'

  ActionView::Helpers::NumberHelper.class_eval do

    def currency_to_words number, options = {}
      # scopes
      scope = [:number, :currency_in_words]
      options_precision_scope = [:number, :currency_in_words, :options_precision]

      # format of number
      format = (I18n.t :format, scope: scope)

      # options for precision to split int and decimal part
      options_precision = {
        :precision => (I18n.t :precision, scope: options_precision_scope),
        :delimiter => (I18n.t :delimiter, scope: options_precision_scope),
        :significant => (I18n.t :significant, scope: options_precision_scope),
        :strip_insignificant_zeros => (I18n.t :strip_insignificant_zeros, scope: options_precision_scope),
        :separator => (I18n.t :separator, scope: options_precision_scope),
        :raise => (I18n.t :raise, scope: options_precision_scope)
      }

      # try to split number
      begin
        rounded_number = number_with_precision(number, options_precision)
      rescue ActionView::Helpers::NumberHelper::InvalidNumberError => e
        if options[:raise]
          raise
        else
          rounded_number = format.gsub(/%n/, e.number)
          return e.number.to_s.html_safe? ? rounded_number.html_safe : rounded_number
        end
      end

      # try to find locale class with language algorithm
      begin
        klass = "CurrencyToWords::#{I18n.locale.to_s.capitalize}Currency".constantize
      rescue NameError
        if options[:raise]
          raise NameError, "Implement a class #{options[:locale].to_s.capitalize}Currency to support this locale, please."
        else
          klass = CsCurrency
        end
      end

      # map number parts
      number_parts = rounded_number.split(options_precision[:separator]).map(&:to_i)

      # Create instance of base class and try to process through.
      base_class = CurrencyToWords::Currency.new(klass.new, number_parts, options)
      processed_number = base_class.process

      # return formatted number
      format.gsub(/%n/, processed_number).html_safe
    end
  end

  # Base class that will load language specific class with specific language algorithm.
  class Currency
    attr_reader :number_parts, :options, :texterizer

    # constructor of Currency class
    def initialize lang_class, splitted_number, options = {}
      @lang_class   = lang_class
      @number_parts = splitted_number
      @options      = options
    end

    # Process and try to find language specific for current locale!
    def process
      if @lang_class.respond_to?('process')
        processed_number = @lang_class.process @number_parts
        if processed_number.is_a?(String)
          return processed_number
        else
          raise TypeError, "a lang_class must return a String" if @options[:raise]
        end
      else
        raise NoMethodError, "a lang_class must provide a 'lang_class' method" if @options[:raise]
      end

      # fallback on CsCurrency
      unless @lang_class.instance_of?(CsCurrency)
        @lang_class = CsCurrency.new
        self.process
      else
        raise RuntimeError, "you should use the option ':raise => true' to see what goes wrong"
      end
    end
  end

end