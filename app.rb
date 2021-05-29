# frozen_string_literal: true

require 'net/http'
require 'optparse'
require 'uri'

require_relative 'filmarks_exporter/filmarks_extracter'

# main application
class App
   def initialize(args)
      @url, @options = parse_args(args)
   end

   def run
      html = if @url =~ /^http.*/
                Net::HTTP.get(URI.parse(@url))
             else
                File.open(@url).read
             end

      File.open(@options[:serialize], 'w') { |f| f.write(html) } if @options[:serialize]

      extracter = FilmarksExporter::FilmarksExtracter.new
      info = extracter.extract(html)

      # TODO: make print order customizable
      print_as_row(info)
   end

   OPT_PARSER = OptionParser.new do |p|
      p.banner = "usage: #{File.basename($PROGRAM_NAME)} URL"
      p.on('-s FILE', '--serialize FILE', 'serialize HTML content into file')
   end.freeze

   def parse_args(args)
      options = {}
      pos_args = OPT_PARSER.parse(args, into: options)

      url = pos_args.shift
      raise 'No URL specified' unless url

      [url, options]
   end

   def print_as_row(info)
      puts [
         info[:title],
         info[:original],
         info[:duration],
         info[:release_date],
         info[:genres].join('、'),
         info[:prime_info]
      ].join("\t")
   end
end

App.new(ARGV).run if $PROGRAM_NAME == __FILE__
