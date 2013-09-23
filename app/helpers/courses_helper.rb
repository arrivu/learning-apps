module CoursesHelper
	def price_of_course_according_to_date(course)
		if course.course_pricings.empty?
			#raise CoursePriceNotFound
			return 0
		else
			price = course.course_pricings.where("start_date  <=? AND end_date >= ?", Date.today,Date.today)
			if price.empty?
				return 0
				raise CoursePriceNotFound
			else
				price.first.price
			end
		end
	end

  def nested_topics_for_course(topics_lists)
    topics_lists.map do |topics_list, sub_topic_lists|
      @topics_list=topics_list
      render("topics_list") + content_tag(:li, nested_topics_for_course(sub_topic_lists))
    end.join.html_safe
  end


end
