class Groupmessage < ActiveRecord::Base
   validates :user_id,  :content, :meeting, presence: true
   #has_attached_file :image, styles: { small: "64x64", med: "200x200", large: "600x600"}
   #validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]}
  
    def edit!(content, user_id)
      update!(content: content)
    end

end
