class ConfirmationEmail < Devise::Mailer
  layout 'confirmation_email'
  default from: I18n.t("mailer.default.from")
end