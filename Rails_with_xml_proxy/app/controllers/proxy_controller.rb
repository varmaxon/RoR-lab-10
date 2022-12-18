# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# second class
class ProxyController < ApplicationController
  before_action :parse_params, only: :show
  before_action :require_params, only: :show
  before_action :prepare_url, only: :show

  def input; end

  def show
    api_response = URI.open(@url)

    case @side
    when 'Серверный'
      @result = xslt_server_transform(api_response).to_html
    when 'Клиентский'
      render xml: xslt_browser_transform(api_response).to_xml
    else
      render xml: api_response
    end
  end

  private

  BASE_API_URL = 'http://localhost:3000/?format=xml'
  XSLT_SERVER_TRANSFORM  = "#{Rails.root}/public/server_transform.xslt".freeze
  XSLT_BROWSER_TRANSFORM = "/browser_transform.xslt"

  def parse_params
    @input = params[:input]
    @side = params[:side]
  end

  def require_params
    if @input.nil? || @input.empty?
      flash[:error] = 'Ничего не введено'
      redirect_to root_path
    elsif !@input.match(/^\d+$/)
      flash[:error] = "Введены символы, не являющиеся цифрами"
      redirect_to root_path
    end
  end

  def prepare_url
    @url = "#{BASE_API_URL}&input=#{@input}"
  end

  def xslt_server_transform(data)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XSLT(File.read(XSLT_SERVER_TRANSFORM))
    xslt.transform(doc)
  end

  def xslt_browser_transform(data)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XML::ProcessingInstruction.new(doc,'xml-stylesheet',"type=\"text/xsl\" href=\"#{XSLT_BROWSER_TRANSFORM}\"")
    doc.root.add_previous_sibling(xslt)
    doc
  end
end
