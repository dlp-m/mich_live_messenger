# frozen_string_literal: true

module Administrators
  class AdministratorsController < AdministratorController
    before_action :set_administrator, only: %i[show edit destroy update]

    def index
      @q = authorized_scope(
        Administrator.all,
        with: Bo::Administrators::AdministratorPolicy
      ).order(:created_at).ransack(params[:q])
      @pagy, @administrators = pagy(@q.result(distinct: true))
    end

    def show
      authorize! @administrator, to: :show?, namespace:, strict_namespace: true
    end

    def new
      @administrator = Administrator.new
      authorize! @administrator, to: :new?, namespace:, strict_namespace: true
    end

    def edit
      authorize! @administrator, to: :edit?, namespace:, strict_namespace: true
    end

    def create
      @administrator = Administrator.new(administrator_params)
      authorize! @administrator, to: :create?, namespace:, strict_namespace: true

      if @administrator.save
        flash[:success] = t('bo.record.created')
        redirect_to administrators_administrators_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! @administrator, to: :update?, namespace:, strict_namespace: true

      if @administrator.update(administrator_params)
        flash[:success] = t('bo.record.updated')
        redirect_to administrators_administrator_path
      else
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! @administrator, to: :destroy?, namespace:, strict_namespace: true

      @administrator.destroy
      flash[:success] = t('bo.record.destroyed')

      redirect_to administrators_administrators_path, status: :see_other
    end

    def export_csv
      @administrators = fetch_authorized_administrators
      csv_data = generate_csv_data

      send_data csv_data,
                type: 'text/csv; charset=utf-8; header=present',
                disposition: "attachment; filename=#{I18n.t("bo.administrator.other")}_#{Time.zone.now}.csv"
    end

    private

    def fetch_authorized_administrators
      authorized_scope(
        Administrator.all,
        with: Bo::Administrators::AdministratorPolicy
      ).ransack(params[:q]).result(distinct: true)
    end

    def generate_csv_data
      CSV.generate(headers: true) do |csv|
        csv << translated_headers

        @administrators.each do |instance|
          csv << Administrator.column_names.map { |col| instance.send(col) }
        end
      end
    end

    def translated_headers
      Administrator.column_names.map do |col|
        I18n.t("bo.administrator.attributes.#{col}")
      end
    end

    def set_administrator
      @administrator = authorized_scope(
        Administrator.all,
        with: Bo::Administrators::AdministratorPolicy
      ).find(params[:id])
    end

    def administrator_params
      params.require(:administrator).permit(
        :email
      )
    end
  end
end
