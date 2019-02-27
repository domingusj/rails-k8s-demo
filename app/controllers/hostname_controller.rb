
# frozen_string_literal: true

class HostnameController < ApplicationController
  def show
    render plain: `hostname -f`.chomp + " - version 1", status: :ok
  end
end
