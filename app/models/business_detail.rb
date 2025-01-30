class BusinessDetail < ApplicationRecord
	validates :busi_name, presence: true
	belongs_to :user
	has_one_attached :business_logo
	after_save :check_business_logo_upload, if: -> { business_logo.attached? && saved_change_to_business_logo? }

	private
  def check_business_logo_upload
    if business_logo.attached?
      public_url = generate_public_url(business_logo)
      update_column(:business_logo_url, public_url)
    end
  end

  def generate_public_url(attachment)
    "https://" + "#{ENV['AWS_BUCKET']}" + ".s3." + "#{ENV['AWS_RESION']}" + ".amazonaws.com/" + "#{attachment.blob.key}"
  end

  def saved_change_to_business_logo?
    attachment_changes['business_logo'].present?
  end
end
