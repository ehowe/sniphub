class Sniphub
  class User < Sequel::Model(:users)
    plugin :secure_password
    plugin :timestamps, update_on_create: true
    plugin :uuid

    def full_name
      "#{first_name} #{last_name}"
    end

    def validate
      super unless external_provider
    end

    def confirmed?
      !confirmation_token
    end
  end
end
