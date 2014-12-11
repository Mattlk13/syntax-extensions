require 'rubygems'
require 'syntax'

class GherkinTokenizer < Syntax::Tokenizer
  def setup
  end

  def step
    bol = bol?
    spc = scan(/[ \t]*/)
    start_group(:normal,spc) if spc

    if bol && (words = scan(/When /))
      start_group(:when, words)
    elsif bol && (words = scan(/Given /))
      start_group(:given, words)
    elsif bol && (words = scan(/Then /))
      start_group(:then, words)
    elsif bol && (words = scan(/Feature: /))
      start_group :directive, words
      words = scan(/[\w ]+/)
      start_group :featurename, words
    elsif words = scan(/[\w ]+: */)
      start_group :directive, words
      words = scan(/[\w ]+/)
      start_group :name, words
    elsif words = scan(/\<[^>]+>/)
      start_group :subst, words
    elsif words = scan(/@[\w0-9]+/)
      start_group :tag, words
    elsif words = scan(/"[^"]*"/)
      start_group :string, words
    elsif words = scan(/\'[^\']*\'/)
      start_group :string, words
    else
      start_group(:normal, getch)
    end
  end
end

Syntax::SYNTAX['gherkin'] = GherkinTokenizer

