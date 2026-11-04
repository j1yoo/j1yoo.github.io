# frozen_string_literal: true

# Liquid filter for the print syllabus (_layouts/syllabus_print.liquid).
# It reads the weekly schedule of a course page in _teaching/ and hands it to the
# layout in the shape of the posted Word syllabus, so the syllabus PDF can be
# printed with the current schedule (see _scripts/generate_syllabus_pdfs.js).
module Jekyll
  module SyllabusPrint
    WEEK = /\A\*\*Week\s+(\d+)\s*\(([^)]*)\):\s*(.*?)\*\*\z/
    READING_BADGE = /\A<span class="badge-read[^"]*">(.*?)<\/span>\s*(.*)\z/m
    PREPARATION = /\A\*\*(Preparation:)\*\*\s*(.*)\z/m
    # Reading labels as the posted syllabus prints them
    LABELS = { 'Further reading (optional):' => 'Further (optional):' }.freeze

    # The weeks of the schedule, each with number, date, title, topics, reading
    # ([{label, items}]), notes and deliverables, all as HTML. The text before the
    # first week, slide and script links, and the Part headings are not printed,
    # as in the posted syllabus.
    def syllabus_schedule(markdown)
      weeks = []
      week = nil
      deliverables = nil
      markdown.to_s.each_line do |raw|
        line = raw.strip
        if deliverables
          if line.start_with?('</div>')
            week['deliverables'] = split_deliverables(deliverables.join("\n")) if week
            deliverables = nil
          else
            deliverables << line
          end
        elsif (m = line.match(WEEK))
          week = { 'number' => m[1], 'date' => m[2], 'title' => inline(m[3]),
                   'topics' => [], 'reading' => [], 'notes' => [], 'deliverables' => [] }
          weeks << week
        elsif line.start_with?('#')
          week = nil
        elsif line.start_with?('<div class="schedule-deliverables"')
          deliverables = []
        elsif line.start_with?('<a class="badge-slides"') || weeks.empty? || line.empty?
          next
        elsif week.nil?
          Jekyll.logger.warn 'Syllabus:', "not printed (text between a Part heading and the next week): #{line}"
        elsif line.start_with?('- ')
          add_bullet(week, line[2..])
        else
          Jekyll.logger.warn 'Syllabus:', "week heading not recognized, printed as a note: #{line}" if line.start_with?('**Week')
          week['notes'] << inline(line)
        end
      end
      weeks
    end

    private

    def add_bullet(week, text)
      if (m = text.match(READING_BADGE))
        label = m[1].gsub(/<[^>]+>/, '').strip
        week['reading'] << { 'label' => LABELS.fetch(label, label), 'items' => split_items(m[2]).map { |item| inline(item) } }
      elsif (m = text.match(PREPARATION))
        week['reading'] << { 'label' => m[1], 'items' => [inline(m[2])] }
      else
        week['topics'] << inline(text)
      end
    end

    # One reading per line, as in the posted syllabus: split at "; " outside
    # parentheses and inline code.
    def split_items(text)
      items = []
      depth = 0
      code = false
      start = 0
      text.each_char.with_index do |c, i|
        if c == '`'
          code = !code
        elsif code
          next
        elsif c == '('
          depth += 1
        elsif c == ')'
          depth -= 1 if depth.positive?
        elsif c == ';' && depth.zero? && text[i + 1] == ' '
          items << text[start...i]
          start = i + 2
        end
      end
      items << text[start..]
      items.map(&:strip).reject(&:empty?)
    end

    # Deliverable lines without the web icons and badges; the posted syllabus
    # prints them upright, so an <em> around a whole line is dropped.
    def split_deliverables(html)
      html.split(/<br\s*\/?>/).map do |item|
        item = item.gsub(/<i\b[^>]*><\/i>/, '').strip
        item = item.sub(/\A<em>((?:(?!<\/?em>).)*)<\/em>\z/m, '\1')
        item.gsub(/<span class="badge-due">(.*?)<\/span>/, '\1').strip
      end.reject(&:empty?)
    end

    def inline(markdown)
      converter = @context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown)
      converter.convert(markdown.to_s).strip.sub(/\A<p>/, '').sub(/<\/p>\z/, '')
    end
  end
end

Liquid::Template.register_filter(Jekyll::SyllabusPrint)
