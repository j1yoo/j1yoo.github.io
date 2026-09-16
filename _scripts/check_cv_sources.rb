# Validate shared source records against the generated website and print view.
# This checks synchronization, not the truth or completeness of authored records.
require 'yaml'
require 'json'
require 'date'
require 'cgi'

root = File.expand_path('..', __dir__)
build = File.expand_path(ENV.fetch('CV_BUILD_DIR', '_site'), root)
read_yaml = lambda { |name| YAML.safe_load(File.read(File.join(root, '_data', name)), permitted_classes: [Date, Time]) }
normalize = lambda { |value| CGI.unescapeHTML(value.to_s.gsub(/<[^>]*>/, ' ')).unicode_normalize(:nfkc).gsub(/\s+/, ' ').strip }
pages = %w[cv_print/index.html research/index.html supervision/index.html talks/index.html].to_h do |name|
  [name, normalize.call(File.read(File.join(build, name)))]
end
profile = read_yaml.call('academic_profile.yml')
errors = []
contains = lambda do |value, targets|
  text = normalize.call(value)
  targets.each { |target| errors << "#{target}: missing #{text}" unless pages.fetch(target).include?(text) }
end
cv = ['cv_print/index.html']
profile.fetch('awards').each { |item| contains.call(item.fetch('title'), cv) }
profile.fetch('grants').each do |item|
  contains.call(item.fetch('title'), cv + (item['paper_key'] ? ['research/index.html'] : []))
end
# The full service list belongs in the CV. About is independently authored
# and deliberately includes only selected examples.
%w[reviewing conferences editorial].each do |kind|
  profile.fetch('service').fetch(kind).each do |item|
    contains.call(item['name'] || item.fetch('journal'), cv)
  end
end
profile.fetch('service').fetch('organizing', []).each do |item|
  contains.call(item.fetch('name'), cv)
  contains.call(item.fetch('role'), cv)
end
profile.fetch('paper_notes', []).each { |item| contains.call(item.fetch('text'), cv + ['research/index.html']) }
talks = read_yaml.call('talks.yml')
talks.each { |item| contains.call(item.fetch('title'), cv + ['talks/index.html']) }
# Grouping by date keeps the author's source order for same-day presentations.
# Sorting directly by date alone can reorder tied entries across Ruby versions.
expected_talks = talks.each_with_index.sort_by { |item, i| [item.fetch('date').to_s, -i] }.reverse.map { |item, _| [item.fetch('date').to_s, normalize.call(item.fetch('title'))] }
cv.each do |target|
  raw_cv = File.read(File.join(build, target))
  actual_talks = raw_cv.scan(/class="cv-entry cv-talk" data-talk-date="([^"]+)"[^>]*>\s*<div class="dated-row">\s*<strong>(.*?)<\/strong>/m).map { |date, title| [date, normalize.call(title)] }
  errors << "#{target}: CV talk order differs from descending date with original source order for ties" unless actual_talks == expected_talks
end
read_yaml.call('supervision.yml').each do |student|
  targets = cv + ['supervision/index.html']
  contains.call(student.fetch('name'), targets)
  contains.call(student['thesis'], targets) if student['thesis']
  if student['mentoring_award_id']
    award = profile.fetch('mentoring_awards').find { |item| item['id'] == student['mentoring_award_id'] }
    if award
      contains.call(award.fetch('title'), targets + ['research/index.html'])
    else
      errors << "Unknown mentoring award: #{student['mentoring_award_id']}"
    end
  end
end
resume = JSON.parse(File.read(File.join(root, 'assets/json/resume.json')))
contains.call(resume.fetch('basics').fetch('location').fetch('address'), cv)
errors << 'Empty CV address in source' if resume['basics']['location']['address'].strip.empty?
resume.fetch('work').each { |item| contains.call(item.fetch('name'), cv); contains.call(item.fetch('position'), cv) }
resume.fetch('education').each do |item|
  contains.call(item.fetch('institution'), cv)
  contains.call("#{item.fetch('studyType')} in #{item.fetch('area')}", cv)
  item.fetch('courses', []).each { |detail| contains.call(detail, cv) }
end
if errors.any?
  abort "Shared CV source checks failed:\n#{errors.join("\n")}"
end
puts 'Shared CV sources match Research, Talks, Supervision and print CV.'
