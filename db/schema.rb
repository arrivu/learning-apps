# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314093035551) do

  create_table "aboutdetails", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "abouts", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "account_themes", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "account_users", :force => true do |t|
    t.integer  "account_id",      :limit => 8
    t.integer  "user_id"
    t.string   "membership_type"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "no_of_courses"
    t.string   "no_of_users"
    t.string   "support_script"
    t.string   "google_analytics_script"
    t.boolean  "active"
    t.text     "settings"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "add_images", :force => true do |t|
    t.binary   "image"
    t.string   "image_type"
    t.string   "file_name"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "companynames", :force => true do |t|
    t.string   "string"
    t.string   "image"
    t.string   "binary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "metadata"
    t.string   "alpha_code"
    t.string   "alpha_mask"
    t.string   "digit_code"
    t.string   "digit_mask"
    t.string   "category_one"
    t.float    "amount_one",                     :default => 0.0
    t.float    "percentage_one",                 :default => 0.0
    t.string   "category_two"
    t.float    "amount_two",                     :default => 0.0
    t.float    "percentage_two",                 :default => 0.0
    t.date     "expiration"
    t.integer  "how_many",                       :default => 1
    t.integer  "redemptions_count",              :default => 0
    t.integer  "integer",                        :default => 0
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "account_id",        :limit => 8
  end

  add_index "coupons", ["alpha_code"], :name => "index_coupons_on_alpha_code"
  add_index "coupons", ["digit_code"], :name => "index_coupons_on_digit_code"

  create_table "course_previews", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "video_url"
    t.integer  "sequence"
    t.integer  "enable"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "course_id"
    t.integer  "account_id", :limit => 8
  end

  create_table "course_pricings", :force => true do |t|
    t.integer  "course_id"
    t.float    "price"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "account_id", :limit => 8
  end

  create_table "course_statuses", :force => true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.string   "status"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "account_id", :limit => 8
  end

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "image"
    t.text     "desc"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "ispublished",                        :default => 0
    t.string   "releasemonth",                       :default => "December"
    t.integer  "ispopular"
    t.string   "content_type"
    t.binary   "data"
    t.integer  "lms_id"
    t.integer  "topic_id"
    t.string   "short_desc"
    t.boolean  "isconcluded"
    t.string   "concluded_review"
    t.date     "concluded"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_coming_soon"
    t.binary   "background_image"
    t.string   "background_image_type"
    t.integer  "account_id",            :limit => 8
    t.boolean  "global"
  end

  add_index "courses", ["title", "author"], :name => "index_courses_on_title_and_author"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "footerlinks", :force => true do |t|
    t.string   "aboutus_url"
    t.string   "contactus_url"
    t.string   "privacy_policy_url"
    t.string   "terms_condition_url"
    t.string   "twitter_url"
    t.string   "youtube_url"
    t.string   "facebook_url"
    t.string   "google_url"
    t.string   "linkedin_url"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "account_id",          :limit => 8
    t.string   "copy_write"
  end

  create_table "header_details", :force => true do |t|
    t.binary   "logo"
    t.binary   "theme"
    t.string   "logo_name"
    t.string   "logo_type"
    t.string   "theme_name"
    t.string   "theme_type"
    t.string   "message"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "invoices", :force => true do |t|
    t.date     "due_at"
    t.date     "paid_at"
    t.decimal  "total"
    t.string   "company_name"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "invoice_number"
    t.string   "bill_to"
    t.string   "notes"
    t.decimal  "tax_rate"
    t.string   "tax_description"
    t.decimal  "coupon_rate"
    t.string   "coupon_code"
    t.string   "coupon_description"
    t.string   "currency"
    t.string   "invoice_details"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "account_id",         :limit => 8
  end

  create_table "line_items", :force => true do |t|
    t.decimal  "price"
    t.string   "description"
    t.integer  "quantity"
    t.integer  "display_price"
    t.integer  "display_quantity"
    t.integer  "invoice_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "invoice_number"
    t.string   "item_type"
  end

  create_table "omniauth_links", :force => true do |t|
    t.string   "face_book"
    t.string   "linked_in"
    t.string   "gmail"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "partners", :force => true do |t|
    t.string   "company_name"
    t.binary   "image"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "image_type"
    t.string   "file_name"
    t.integer  "account_id",   :limit => 8
    t.string   "comments"
  end

  create_table "privacypolicies", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "rating_caches", :force => true do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            :null => false
    t.integer  "qty",            :null => false
    t.string   "dimension"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], :name => "index_rating_caches_on_cacheable_id_and_cacheable_type"

  create_table "redemptions", :force => true do |t|
    t.integer  "coupon_id"
    t.string   "user_id"
    t.string   "transaction_id"
    t.text     "metadata"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "course_id"
    t.integer  "topic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sliders", :force => true do |t|
    t.binary   "image"
    t.binary   "background_image"
    t.string   "header"
    t.string   "body_tag"
    t.integer  "account_id",            :limit => 8
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "image_name"
    t.string   "image_type"
    t.binary   "data"
    t.string   "background_image_type"
    t.string   "background_image_name"
  end

  create_table "social_stream_comments", :force => true do |t|
    t.string   "twitter_comment_script"
    t.string   "facebook_comment_script"
    t.integer  "account_id",              :limit => 8
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "student_courses", :force => true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "status"
    t.integer  "account_id", :limit => 8
  end

  create_table "students", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "contact_no"
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "account_id",  :limit => 8
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "taggings", ["course_id"], :name => "index_taggings_on_course_id"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tax_rates", :force => true do |t|
    t.date     "valid_from",                                             :null => false
    t.date     "valid_until"
    t.decimal  "factor",                   :precision => 2, :scale => 2
    t.boolean  "is_default"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "description"
    t.integer  "account_id",  :limit => 8
  end

  create_table "teaching_staff_courses", :force => true do |t|
    t.integer  "course_id"
    t.integer  "teaching_staff_id"
    t.string   "teaching_staff_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "account_id",          :limit => 8
  end

  create_table "teaching_staffs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "qualification"
    t.integer  "user_id"
    t.integer  "account_id",           :limit => 8
    t.text     "linkedin_profile_url"
    t.boolean  "is_active",                         :default => true
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "terms_and_conditions", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "account_id", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "testimonials", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "job"
    t.string   "comment"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "account_id",   :limit => 8
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "desc"
    t.string   "color"
    t.integer  "account_id",      :limit => 8
    t.integer  "parent_topic_id", :limit => 8
    t.integer  "root_topic_id",   :limit => 8
    t.boolean  "is_global"
    t.string   "ancestry"
    t.integer  "position"
  end

  add_index "topics", ["ancestry"], :name => "index_topics_on_ancestry"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",       :null => false
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.binary   "omni_image_url"
    t.string   "provider",               :default => "signup"
    t.string   "phone"
    t.string   "user_type"
    t.string   "sub_plan"
    t.string   "user_desc"
    t.string   "name"
    t.string   "username"
    t.integer  "lms_id"
    t.string   "attachment"
    t.string   "content_type"
    t.binary   "image_blob"
    t.string   "uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
