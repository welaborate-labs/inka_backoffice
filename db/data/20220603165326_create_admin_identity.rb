# frozen_string_literal: true

class CreateAdminIdentity < ActiveRecord::Migration[7.0]
  def up
    pass = BCrypt::Password.create('harmonia!@3')

    Identity.create(
      name: 'Admin',
      email: 'admin@inkabeautyspa.com.br',
      password_digest: pass
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
