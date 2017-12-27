class Dorsale::Email
  include ActiveModel::Model
  include Agilibox::ModelToS
  include Agilibox::ModelI18n

  validates :to,      presence: true
  validates :subject, presence: true
  validates :body,    presence: true

  attr_accessor(
    :current_user,
    :from,
    :to,
    :cc,
    :subject,
    :body,
    :attachments,
  )

  def initialize(*)
    super
    assign_default_values
  end

  def attachment_names
    attachments.keys.join(", ")
  end

  def save
    valid? && deliver_now
  end

  private

  def data
    # Real email :from is mailer default
    # The :from of this class is used as reply_to
    {
      :reply_to    => from,
      :to          => to,
      :cc          => cc,
      :subject     => subject,
      :body        => body,
      :attachments => attachments,
    }
  end

  def deliver_now
    Dorsale::GenericMailer.generic_email(data).deliver_now
  end

  def default_from
    "#{current_user} <#{current_user.email}>" if current_user
  end

  def assign_default_values
    self.from        ||= default_from
    self.to          ||= default_to
    self.cc          ||= default_cc
    self.subject     ||= default_subject
    self.body        ||= default_body
    self.attachments ||= default_attachments
  end

  def default_to
  end

  def default_cc
  end

  def default_subject
  end

  def default_body
  end

  def default_attachments
    {}
  end
end
