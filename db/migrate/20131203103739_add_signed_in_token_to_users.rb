class AddSignedInTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signed_in_token, :string
    add_index  :users, :signed_in_token, unique: true  	

  end
end
