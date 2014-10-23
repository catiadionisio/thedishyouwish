class AddAttachmentImagemToReceitas < ActiveRecord::Migration
  def self.up
    change_table :receitas do |t|
      t.attachment :imagem
    end
  end

  def self.down
    drop_attached_file :receitas, :imagem
  end
end
