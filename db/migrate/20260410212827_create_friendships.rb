class CreateFriendships < ActiveRecord::Migration[8.1]
  def change
    create_table :friendships do |t|
      t.bigint :requester_id, null: false
      t.bigint :receiver_id, null: false
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    add_index :friendships, [ :requester_id, :receiver_id ], unique: true
    add_index :friendships, :receiver_id

    add_foreign_key :friendships, :users, column: :requester_id
    add_foreign_key :friendships, :users, column: :receiver_id

    add_check_constraint :friendships, "requester_id != receiver_id", name: "friendships_no_self_reference"
  end
end
