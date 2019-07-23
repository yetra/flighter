module TestHelpers
  module JsonParams
    def user_params(first_name: 'First', last_name: 'Last',
                    email: 'a@b.com', password: 'pass', token: nil)
      {
        user:
        {
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          token: (token unless token.nil?)
        }
      }
    end
  end
end
