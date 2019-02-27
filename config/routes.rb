# frozen_string_literal: true

Rails.application.routes.draw do
  get "/health_check", to: "health_check#show"
  get "/hostname", to: "hostname#show"
end
