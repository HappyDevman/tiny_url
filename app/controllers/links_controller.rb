class LinksController < ApplicationController
  # GET /links
  def index
    links = Link.all
    render :index, locals: { links: links }
  end

  # GET /links/new
  def new
    link = Link.new
    render :new, locals: { link: link }
  end

  # POST /links
  def create
    link = Link.new(link_params)
    if link.save
      redirect_to links_path, notice: 'Link was successfully created.'
    else
      render :new, locals: { link: link }
    end
  end

  # GET /links/:path
  def redirect
    if link
      link.ip_addresses << request.remote_ip unless link.ip_addresses.include?(request.remote_ip)
      link.save
      redirect_to link.original_url
    else
      redirect_back(fallback_location: links_path, notice: "Can't find link with given short_url")
    end
  end

  # GET /links/:path/info
  def show
    if link
      render :show, locals: { link: link }
    else
      redirect_back(fallback_location: links_path, notice: "Can't find link with given short_url")
    end
  end

  private

  def link
    @link ||= Link.find_by(short_url: params[:path])
  end

  def link_params
    params.require(:link).permit(:original_url)
  end
end
