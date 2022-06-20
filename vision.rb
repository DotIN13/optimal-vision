require 'cgi'
require 'nokogiri'

class OptimalVision
  class Converter
    attr_reader :opml, :html, :xml, :buffer

    def initialize(file_path)
      @opml = File.read file_path
      parse_xml
      @html = build_html file_path
      @buffer = [0]
    end

    def convert
      xml_body = xml.xpath '//body'
      xml_body.children.each { |child| traverse child }
      html
    end

    private

    def traverse(node, level = 1)
      puts "#{level}: #{node['text']}"
      @context = html.css("div.column-right.level-#{level}").last
      # Create left column box and fill in the left node
      @context << new_row(node, level, children: node.children.any?)
      buffer << level
      node.children.each do |outline|
        traverse outline, level + 1
      end
    end

    # Parse opml with no linebreaks and blank lines
    def parse_xml
      @xml = Nokogiri::XML opml, &:noblanks
    end

    def new_row(node, level = 0, children: true)
      <<~EOHTML
        <div class='row level-#{level}'>
          <div class='column column-left level-#{level}'>
            #{new_mindnode node, level}
          </div>
          #{"<div class='column column-right level-#{level + 1}'></div>" if children}
        </div>
      EOHTML
    end

    def new_mindnode(node, level)
      if node.is_a? String
        text = node
      else
        text = CGI.unescape(node[:_mubu_text]).gsub("\n", '<br>')
        note = CGI.unescape(node[:_mubu_note])&.gsub("\n", '<br>')
        note = "<span class='note'>#{note}</span>" if note
      end
      "<div class='node' data-level=#{level}>#{text}#{note}</div>"
    end

    def build_html(file)
      Nokogiri::HTML <<~EOHTML
        <!DOCTYPE HTML>
        <html>
          <head><title>#{file}</title></head>
          <body><main>
            #{new_row xml.xpath('//title').inner_text}
          </main></body>
        </html>
      EOHTML
    end
  end

  class CSSInjector
    def initialize(html)
      @html = html
    end

    def inject
      @html.at_css('head').add_child <<~EOHTML
        <style>
          #{css}
        </style>
        <script src="vision.js"></script>
      EOHTML
      @html
    end

    private

    def css
      File.read 'webpack/stylesheets/default.scss'
    end
  end
end

optimal = OptimalVision::Converter.new('opmls/BRICS_20210701.opml')
html = optimal.convert
html = OptimalVision::CSSInjector.new(html).inject
File.open('dist/index.html', 'w') { |file| file << html}
