require 'rubygems'
require 'syntax'

class AsmTokenizer < Syntax::Tokenizer
  def setup
    @state = :newline
  end

  def step
    @state = :newline if bol?
    if @state == :newline
      if label = scan(/[a-zA-Z.][a-zA-z0-9_]*:/) then start_group :label, label
      elsif words = scan(/\.[a-zA-Z0-9_]*/)
        start_group :directive, words
        @state = :operands
      elsif words = scan(/[a-zA-Z]+/)
        start_group :operator, words
        @state = :operands
      else start_group(:normal, getch)
      end
    else
      if words = scan(/,/)                then start_group :comma, words
      elsif words = scan(/[\-0-9][0-9]*/) then start_group :number, words
      elsif words = scan(/%[a-zA-Z]+/)    then start_group :register, words
      elsif words = scan(/[\.a-zA-Z][a-zA-Z0-9]*/) then start_group :label, words
      elsif words = scan(/\$/)     then start_group :value, words
      elsif words = scan(/[\(\)]/) then start_group :paren, words
      elsif words = scan(/\".*\"/) then start_group :quoted, words
      else start_group(:normal, getch)
      end
    end
  end
end

Syntax::SYNTAX['asm'] = AsmTokenizer

