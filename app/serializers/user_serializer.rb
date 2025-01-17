class UserSerializer < BaseSerializer
  attributes :id, :email, :first_name, :last_name, :full_name, :profile_pic, :roles, :created_at, :updated_at

  attribute :roles do |object|
    object.roles.map { |role| RolesSerializer.new(role).serializable_hash[:data][:attributes] }
  end

  attribute :full_name do |object|
    object.full_name
  end

  attribute :profile_pic do |object|
    object.profile_pic_url
  end
end
