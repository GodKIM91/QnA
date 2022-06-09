class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource :class => "ActiveStorage::Attachment"

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if can?(:destroy, @file)
  end
end
