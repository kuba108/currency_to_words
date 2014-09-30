# encoding: utf-8
module CurrencyToWords

  # This is the strategy class for Czech language
  class CsCurrency

    def process number_parts
      # default values
      @skip_and = false

      # scopes for I18n
      @scope = [:number, :currency_in_words]
      @currency_scope = [:number, :currency_in_words, :currencies]

      # split to integer and decimal parts
      int_part, dec_part = number_parts.map(&:to_i)

      # find suitable unit form
      int_unit = (I18n.t :integer, scope: @currency_scope, count: int_part) # always use int unit
      dec_unit = (I18n.t :decimal, scope: @currency_scope, count: dec_part) if dec_part > 0

      # connector between words
      connector = (I18n.t :connector, scope: @scope)

      # skip constant
      @skip_and = (I18n.t :skip_and, scope: @scope)

      # load number forms
      @ones = (I18n.t :ones, scope: @scope)
      @teens = (I18n.t :teens, scope: @scope)
      @tens = (I18n.t :tens, scope: @scope)
      @hundreds = (I18n.t :hundreds, scope: @scope)
      @megs = (I18n.t :megs, scope: @scope)
      @thousand_ones = (I18n.t :thousands_ones, scope: @scope)

      # iteration algorithm for integer and decimal part
      processed_int_part = (processed_by_group(int_part).compact << int_unit).flatten.join(' ')
      processed_dec_part = (processed_by_group(dec_part).compact << dec_unit).flatten.join(' ')

      # if decimal part is not 0, connect it to integer part with connector
      if dec_part.zero?
        processed_int_part
      else
        processed_int_part << connector << processed_dec_part
      end
    end

    private

    def processed_by_group number, group=0
      return [under_100(number, group)] if number.zero?

      # q is modulo after dividing by 1000
      # r is residue
      q,r = number.divmod 1000

      # if q is bigger than 0, iterate!
      arr = processed_by_group(q, group+1) if q > 0

      # return arr if r is 0
      if r.zero?
        arr
      else
        arr = arr.to_a
        arr << under_1000(r, group)
        group.zero? ? arr : arr << (I18n.t @megs[group], scope: @scope, count: number)
        arr
      end
    end

    # algorithm part for numbers under 1000
    def under_1000 number, group
      q,r = number.divmod 100
      arr = []
      arr << @hundreds[q-1] if q > 0
      r.zero? ? arr : arr.to_a << under_100(r, group)
      arr << (' a' unless @skip_and || r.zero?).to_s if q > 0
      arr
    end

    # algorithm part for numbers under 100
    def under_100 number, group
      case number
        # in czech is different between form for ones, tens, hundreds and thousands
        when 0..9   then group.zero? ? @ones[number] : @thousand_ones[number]
        when 10..19 then @teens[number - 10]
        else
          q,r = number.divmod 10
          @tens[q] + (' ' + @ones[r] unless r.zero?).to_s
      end
    end
  end

end