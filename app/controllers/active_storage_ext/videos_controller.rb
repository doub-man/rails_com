# frozen_string_literal: true

class ActiveStorageExt::VideosController < RailsCom.config.app_controller.constantize
  before_action :set_video, only: [:show, :transfer]
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def show
    expires_in ActiveStorage::Blob.service.url_expires_in
  end

  def transfer
    attached = @attachment.transfer_faststart
    @video = attached.blob

    flash[:notice] = 'well done!'
    render 'show'
  end

  private
  def set_video
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @video = @attachment.blob
  end

end
