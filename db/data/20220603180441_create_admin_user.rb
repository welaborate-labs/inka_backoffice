# frozen_string_literal: true

class CreateAdminUser < ActiveRecord::Migration[7.0]
  def up
    User.create(
      provider: 'identity',
      uid: Identity.last.id,
      name: 'Admin',
      email: 'admin@inkabeautyspa.com.br'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
