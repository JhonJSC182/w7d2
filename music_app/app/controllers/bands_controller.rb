class BandsController < ApplicationController

    before_action :set_band, only: [:show, :edit, :update, :destroy]

    # UI methods (returns HTML forms)
    def index
        @bands = Band.all
        render :index
    end
    
    def new
        @new_band = Band.new
        render :new
    end

    def edit
        render :edit
    end
    
    # API methods (acts on the DB)
    def show

        if @band
            render :show
        else
            flash[:errors] = ['get your shit together']
            redirect_to :index
        end
    end

    def create
        @new_band = Band.new(band_params)
        if @new_band.save
            redirect_to band_url(@new_band)
        else
            flash.now[:errors] = @new_band.errors.full_messages
            render :new
        end
    end

    def set_band
        @band = Band.find_by(id: params[:id])
    end

    def update
    end

    private

    def band_params
        params.require(:band).permit(:name)
    end

end
