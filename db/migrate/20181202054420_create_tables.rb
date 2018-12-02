class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users, force: true do |t|
      t.string :discord_id, null: false
      t.timestamps
    end

    add_index :users, :discord_id, unique: true

    create_table :characters, force: true do |t|
      t.string :discord_id, null: false
      t.integer :preawakening_attack_power, null: false
      t.integer :awakening_attack_power, null: false
      t.integer :defense_power, null: false
      t.integer :renown_score, null: false
      t.decimal :level, null: false
      t.string :class_name, null: false
      t.string :family_name, null: false
      t.string :character_name, null: false
      t.string :image_url
      t.boolean :primary, null: false, default: false
      t.timestamps
    end

    add_index :characters, :family_name, unique: true
    add_index :characters, [:family_name, :character_name, :discord_id], unique: true, name: 'characters_composite_idx'
    add_index :characters, :character_name
    add_index :characters, :class_name
    add_index :characters, :preawakening_attack_power
    add_index :characters, :awakening_attack_power
    add_index :characters, :defense_power
    add_index :characters, :renown_score
  end
end
