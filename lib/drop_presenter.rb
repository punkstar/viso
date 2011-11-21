require 'delegate'

class DropPresenter < SimpleDelegator
  def initialize(drop, template)
    @drop     = drop
    @template = template

    super @drop
  end

  def render_html
    if @drop.bookmark?
      @template.redirect_to_api
    else
      @template.erb template_name, locals: { drop: @drop, body_id: body_id }
    end
  end

private

  def template_name
    if @drop.image?
      :image
    elsif @drop.text?
      :text
    else
      :other
    end
  end

  def body_id
    if @drop.image?
      'image'
    elsif @drop.text?
      'text'
    else
      'other'
    end
  end

end
