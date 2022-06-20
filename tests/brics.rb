require_relative '../vision'

optimal = OptimalVision::Converter.new('opmls/BRICS_20210701.opml')
html = optimal.convert
html = OptimalVision::CSSInjector.new(html).inject
File.open('build/brics.html', 'w') { |file| file << html}
