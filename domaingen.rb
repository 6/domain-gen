require 'whois'
require 'trollop'

class DomainGenerator
  attr_reader :whois, :options, :tld
  attr_accessor :available_domains, :index
  def initialize(options = {})
    @whois = Whois::Client.new(timeout: 10)
    @options = options
    @tld = "." + options[:tld]
    @available_domains = []
    @index = options[:start_index] || 0
  end

  def check(domain)
    if @whois.lookup(domain).available?
      puts "#{index}. #{domain} available"
      available_domains << domain
    else
      puts "#{index}. #{domain} unavailable"
    end
  end

  def before_exit
    puts "====== Total Available: #{available_domains.size} ======\n", available_domains.join(",")
  end
end

class PermutationGenerator < DomainGenerator
  def start!
    raise StandardError.new("Specify a domain prefix/suffix")  unless options[:domain_prefix] || options[:domain_suffix]
    letter_permutations[index..-1].each do |letters|
      domain = if options[:domain_suffix]
        letters + options[:domain_suffix]
      else
        options[:domain_prefix] + letters
      end + tld
      check(domain)
      sleep 1
      @index += 1
    end
    before_exit
  end

  private

  def letter_permutations
    raise StandardError.new("Permutation length cannot exceed 2")  if  options[:permutation_length] > 2

    ('a'..'z').to_a.repeated_permutation(options[:permutation_length]).collect { |x| x.join('') }
  end
end

opts = Trollop::options do
  opt :tld, "Top-level domain (e.g. 'org')", :type => :string, :default => 'com'
  opt :domain_prefix, 'Domain prefix', :type => :string
  opt :domain_suffix, 'Domain suffix', :type => :string
  opt :permutation_length, 'Suffix/prefix permutation length', :type => :integer, :default => 1
  opt :start_index, 'Starting point of search', :type => :integer, :default => 0
end

PermutationGenerator.new(opts).start!
