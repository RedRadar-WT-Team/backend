# app/validators/user_validator.rb
# 
class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.email.blank?
      record.errors.add(:email, "can't be blank")
    elsif !URI::MailTo::EMAIL_REGEXP.match?(record.email)
      record.errors.add(:email, "is not a valid email format")
    end

    if record.state.blank?
      record.errors.add(:state, "can't be blank")
    end

    if record.zip.blank?
      record.errors.add(:zip, "can't be blank")
    elsif !/\A\d{5}\z/.match?(record.zip)
      record.errors.add(:zip, "must be a valid 5-digit zip code")
    end
  end
end
