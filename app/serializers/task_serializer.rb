class TaskSerializer < ActiveModel::Serializer
  attributes :id, :formatted_title, :description, :due_date, :formatted_status, :created_at, :updated_at

  def formatted_title
    object.title&.titleize
  end

  def formatted_status
    object.status&.titleize
  end
end