class OrderController < ApplicationController
  protect_from_forgery with: :exception
  API_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21tZXJjZV9pZCI6ImNvbV9TeHRoekZQd2Q0QmZsLU1XOTJSZm5BIiwiYXBpX3Rva2VuIjp0cnVlfQ.31nLRFenix9_X0qlt1ng-FUzicaFjSrkBvFAkMpiOkA' # Reemplazar por el token de producción cuando quieras pasar a producción

  def order
    plans_url = "https://playground.qvo.cl/plans"

    @response = HTTParty.get(
      plans_url,
      { headers:
        {
          "Authorization" => "Bearer #{API_TOKEN}",
          'Content-Type' => 'application/json'
        }
      },
    ).body

    @response = JSON.parse(@response, symbolize_names: true)
  end


  def init
      create_plan_response = create_plan(
        name: params[:name],
        id: params[:id],
        price: params[:price]
      )
      
      if create_plan_response[:error].present?
        error_message = create_plan_response[:error][:message]
        redirect_to subscription_path, notice: error_message
      end
  end

  private
  def create_plan(id:, name:, price:)
    create_plan_url = "https://playground.qvo.cl/plans"

    response = HTTParty.post(
      create_plan_url,
      { headers:
        {
          "Authorization" => "Bearer #{API_TOKEN}",
          'Content-Type' => 'application/json'
        },
        body: {
          "id" => id,
          "name" => name,
          "price" => price,
          "currency" => "CLP",
          "trial_period_days" => 0
        }.to_json
      },
    ).body

    return JSON.parse(response, symbolize_names: true)
  end
end
