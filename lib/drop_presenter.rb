require 'delegate'
require 'yajl'

class DropPresenter < SimpleDelegator
  def initialize(drop, template)
    @template = template

    super drop
  end

  def render_html
    cache_response

    if bookmark?
      @template.redirect_to_api
    else
      @template.erb template_name, locals: { drop: self, body_id: body_id }
    end
  end

  def render_json
    Yajl::Encoder.encode data
  end

private

  def cache_response
    return if text?
    @template.cache_control :public, :max_age => 900
  end

  def template_name
    if image?
      :image
    elsif text?
      :text
    else
      :other
    end
  end

  def body_id
    if image?
      'image'
    elsif text?
      'text'
    else
      'other'
    end
  end

end
