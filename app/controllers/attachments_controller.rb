class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource :class => "ActiveStorage::Attachment"

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author_of?(@file.record)
  end
end
