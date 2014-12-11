require 'rubygems'
require 'syntax'

class DotTokenizer < Syntax::Tokenizer
  def setup
  end

  def step
    if words = scan(/digraph|graph|edge|node /)
      start_group(:keyword, words)
    elsif words = scan(/\{|\}|\[|\]|\;|\=/)
      start_group(:punct, words)
    elsif words = scan(/->/)
      start_group(:edge, words)
    elsif words = scan(/"[^"]*"/)
      start_group :string, words
    elsif words = scan(/([a-zA-Z0-9]+)/)
      start_group(:attr, words)
    else
      start_group(:normal, getch)
    end
  end
end

Syntax::SYNTAX['dot'] = DotTokenizer

