class Api::GithubActivityController < ApplicationController
  def analyze
    username = params[:username]

    if username.blank?
      render json: {
        error: "Username parameter is required"
      }, status: :bad_request
      return
    end

    # Perform the analysis
    analysis_service = ActivityAnalysisService.new(username)
    result = analysis_service.analyze

    if result[:error]
      render json: result, status: :unprocessable_entity
    else
      render json: result
    end
  end
end
