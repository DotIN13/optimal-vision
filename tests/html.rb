require 'nokogiri'

@doc = Nokogiri::HTML::DocumentFragment.parse <<~EOHTML
  <body>
    <h1>Three's Company</h1>
    <div>A love triangle.</div>
  </body>
EOHTML

h1 = @doc.at_css 'h1'

h3 = Nokogiri::XML::Node.new 'h3', @doc
h3.content = '1977 - 1984'
ah3 = h1.add_next_sibling("<div class='column'></div><div class='column'></div>")

h3.children.first.content = '22000'
h3[:class] = 'love'

p @doc.to_html
