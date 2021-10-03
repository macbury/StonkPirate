class Data::HoldingsController < ApplicationController
  use Holdings::GenerateCsv, as: :generate_csv

  def show
    render plain: generate_csv
  end
end
