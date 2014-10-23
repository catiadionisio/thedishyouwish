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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140908164001) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "actividades", force: true do |t|
    t.integer  "user_id"
    t.string   "accao"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipoid"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "attrs", force: true do |t|
    t.string   "ReceitaTiporefeicao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categoria", force: true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comentarios", force: true do |t|
    t.integer  "user_id"
    t.text     "conteudo"
    t.integer  "receita_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome"
  end

  create_table "confeccaos", force: true do |t|
    t.integer  "receita_id"
    t.string   "passo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordem"
  end

  create_table "ementa", force: true do |t|
    t.integer  "user_id"
    t.date     "data"
    t.integer  "npessoas"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ementa_receitas", force: true do |t|
    t.integer  "ementa_id"
    t.integer  "receita_id"
    t.integer  "npessoas"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "celula"
  end

  create_table "ingredientes", force: true do |t|
    t.string   "nome"
    t.integer  "seccao_id"
    t.float    "peso_medio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medidas", force: true do |t|
    t.string   "nome"
    t.float    "ml"
    t.float    "gr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "receita_id"
    t.integer  "classificacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receita_categoria", force: true do |t|
    t.integer  "receita_id"
    t.integer  "categoria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receita_ingredientes", force: true do |t|
    t.integer  "receita_id"
    t.integer  "ingrediente_id"
    t.float    "quantidade"
    t.integer  "medida_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nota"
  end

  create_table "receita_tiporefeicaos", force: true do |t|
    t.integer  "receita_id"
    t.integer  "tiporefeicao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receitas", force: true do |t|
    t.string   "nome"
    t.integer  "tempo"
    t.integer  "dificuldade"
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calorias"
    t.float    "hidratos"
    t.float    "acucar"
    t.float    "gorduras"
    t.float    "proteinas"
    t.string   "imagem_file_name"
    t.string   "imagem_content_type"
    t.integer  "imagem_file_size"
    t.datetime "imagem_updated_at"
    t.integer  "pessoas"
  end

  create_table "restricaos", force: true do |t|
    t.integer  "user_id"
    t.integer  "ingrediente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seccaos", force: true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "tiporefeicaos", force: true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_receitas", force: true do |t|
    t.integer  "receita_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome"
    t.string   "provider"
    t.string   "uid"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "sexo"
    t.date     "datanasc"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
