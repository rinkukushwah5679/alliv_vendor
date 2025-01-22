class PasswordValidation
  include ActiveModel::Validations

  attr_reader :password

  class << self
    def regex
      /^(?=.*[#!@$&*?<>',\[\]}{=\-)(^%`~+.:;_])(?=.*[0-9])(?=.*[a-zA-Z])(?!.*\s).{6,}$/
    end
  end

  validates :password, :format => {
    :with      => regex,
    :multiline => true,
  }

  def initialize(password)
    @password = password
  end
end
