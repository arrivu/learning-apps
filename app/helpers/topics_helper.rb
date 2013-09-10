module TopicsHelper
  def nested_topics(topics)
    topics.map do |topic, sub_topics|
      render(topic) + content_tag(:div, nested_topics(sub_topics), :class => "nested_topics")
    end.join.html_safe
  end
    def nested_topic_index(topics)
    topics.map do |topic, sub_topics|
      render(topic_index) + content_tag(:div, nested_topics(sub_topics), :class => "accordion-inner")
    end.join.html_safe
  end
end
