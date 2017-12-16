class RelatedContentsController < ApplicationController
  VALID_URL = /#{Setting['url']}\/.*\/.*/

  skip_authorization_check

  def create
    if relationable_object && related_object
      @relationable.relate_content(@related)

      flash[:success] = t('related_content.success')
    else
      flash[:error] = t('related_content.error', url: Setting['url'])
    end

    redirect_to @relationable
  end

  private

  def valid_url?
    params[:url].match(VALID_URL)
  end

  def relationable_object
    @relationable = params[:relationable_klass].singularize.camelize.constantize.find_by(id: params[:relationable_id])
  end

  def related_object
      if valid_url?
        url = params[:url]

        related_klass = url.match(/\/(#{RelatedContent::RELATIONABLE_MODELS.join("|")})\//)[0].delete("/")
        related_id = url.match(/\/[0-9]+/)[0].delete("/")

        @related = related_klass.singularize.camelize.constantize.find_by(id: related_id)
      end
  rescue
      nil
  end
end