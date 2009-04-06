class CreateOauthTables < ActiveRecord::Migration
  def self.up
    create_table :client_applications do |t|
      t.string :name
      t.string :url
      t.string :support_url
      t.string :callback_url
      t.string :key, :limit => 50
      t.string :secret, :limit => 50
      t.integer :user_id
      #start_additions
      t.string :resource_scope
      t.string :public_key
      #end_additions

      t.timestamps
    end
    add_index :client_applications, :key, :unique
    
    create_table :oauth_tokens do |t|
      t.integer :user_id
      t.string :type, :limit => 20
      t.integer :client_application_id
      t.string :token, :limit => 50
      t.string :secret, :limit => 50
      #start_additions
      t.timestamp :expired_on
      #end_additions
      t.timestamp :authorized_at, :invalidated_at

      t.timestamps
    end
    add_index :oauth_tokens, :token, :unique
    
    create_table :oauth_nonces do |t|
      t.string :nonce
      t.integer :timestamp

      t.timestamps
    end
    add_index :oauth_nonces,[:nonce, :timestamp], :unique

    #start_addition
    create_table :child_sps do |t|
      t.string :base_url
      t.string :shared_secret
      t.string :resources

      t.timestamps
    end
    add_index :child_sps, :unique

    create_table :table_resources do |t|
      t.string :name
      t.integer :child_sp_id

      t.timestamps
    end
    add_index :table_resources, :name, :unique
    #end_addition
    
  end

  def self.down
    drop_table :client_applications
    drop_table :oauth_tokens
    drop_table :oauth_nonces
    #start_addition
    drop_table :child_sps
    drop_table :table_resources
    #end_addition
  end

end
