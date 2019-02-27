# frozen_string_literal: true

class HealthCheckController < ApplicationController
    def show
      if up?
        render plain: "OK", status: :ok
      else
        render plain: "DOWN", status: :service_unavailable
      end
    end

    private

    def up?
      database_connection_active?
    end

    def database_connection_active?
      ActiveRecord::Base.connection_pool.with_connection(&:active?)
    rescue PG::Error
      false
    end
  end
