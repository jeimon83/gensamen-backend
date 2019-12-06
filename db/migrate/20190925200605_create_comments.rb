class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, null: false
      t.date :comment_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end