# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_23_155650) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.json "history"
    t.string "q_and_a", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.text "content"
    t.integer "cached_scoped_like_votes_total", default: 0
    t.integer "cached_scoped_like_votes_score", default: 0
    t.integer "cached_scoped_like_votes_up", default: 0
    t.integer "cached_scoped_like_votes_down", default: 0
    t.integer "cached_weighted_like_score", default: 0
    t.integer "cached_weighted_like_total", default: 0
    t.float "cached_weighted_like_average", default: 0.0
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "elements", force: :cascade do |t|
    t.string "element_type"
    t.bigint "post_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort"
    t.index ["post_id"], name: "index_elements_on_post_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.string "role"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.string "object_type", null: false
    t.bigint "object_id", null: false
    t.text "content"
    t.boolean "as_read"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_type", "object_id"], name: "index_notifications_on_object"
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "published"
    t.datetime "published_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_scoped_like_votes_total", default: 0
    t.integer "cached_scoped_like_votes_score", default: 0
    t.integer "cached_scoped_like_votes_up", default: 0
    t.integer "cached_scoped_like_votes_down", default: 0
    t.integer "cached_weighted_like_score", default: 0
    t.integer "cached_weighted_like_total", default: 0
    t.float "cached_weighted_like_average", default: 0.0
    t.integer "cached_scoped_bookmark_votes_total", default: 0
    t.integer "cached_scoped_bookmark_votes_score", default: 0
    t.integer "cached_scoped_bookmark_votes_up", default: 0
    t.integer "cached_scoped_bookmark_votes_down", default: 0
    t.integer "cached_weighted_bookmark_score", default: 0
    t.integer "cached_weighted_bookmark_total", default: 0
    t.float "cached_weighted_bookmark_average", default: 0.0
    t.boolean "already_published", default: false
    t.integer "total_views"
    t.boolean "is_ban", default: false
    t.boolean "status", default: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.string "detail"
    t.boolean "is_ban", default: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 1
    t.string "phone_number"
    t.datetime "birthday"
    t.string "address"
    t.integer "sex", default: 0
    t.boolean "is_ban", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vcomments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "video_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "cached_scoped_like_votes_total", default: 0
    t.integer "cached_scoped_like_votes_score", default: 0
    t.integer "cached_scoped_like_votes_up", default: 0
    t.integer "cached_scoped_like_votes_down", default: 0
    t.integer "cached_weighted_like_score", default: 0
    t.integer "cached_weighted_like_total", default: 0
    t.float "cached_weighted_like_average", default: 0.0
    t.index ["user_id"], name: "index_vcomments_on_user_id"
    t.index ["video_id"], name: "index_vcomments_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.bigint "user_id", null: false
    t.boolean "already_published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_scoped_like_votes_total", default: 0
    t.integer "cached_scoped_like_votes_score", default: 0
    t.integer "cached_scoped_like_votes_up", default: 0
    t.integer "cached_scoped_like_votes_down", default: 0
    t.integer "cached_weighted_like_score", default: 0
    t.integer "cached_weighted_like_total", default: 0
    t.float "cached_weighted_like_average", default: 0.0
    t.integer "cached_scoped_bookmark_votes_total", default: 0
    t.integer "cached_scoped_bookmark_votes_score", default: 0
    t.integer "cached_scoped_bookmark_votes_up", default: 0
    t.integer "cached_scoped_bookmark_votes_down", default: 0
    t.integer "cached_weighted_bookmark_score", default: 0
    t.integer "cached_weighted_bookmark_total", default: 0
    t.float "cached_weighted_bookmark_average", default: 0.0
    t.integer "total_views"
    t.boolean "is_ban", default: false
    t.boolean "status", default: false
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "elements", "posts"
  add_foreign_key "messages", "chats"
  add_foreign_key "notifications", "users", column: "receiver_id"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "posts", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "vcomments", "users"
  add_foreign_key "vcomments", "videos"
  add_foreign_key "videos", "users"
end
