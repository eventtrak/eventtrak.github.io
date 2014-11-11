module Admin
  #   module webhooks
  class WebhooksController < ApplicationController
    def mailgun
      render json: { success: 1 }
    end
  end
  #   end
end
