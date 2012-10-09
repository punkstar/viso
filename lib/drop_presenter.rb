require 'delegate'
require 'metriks'
require 'yajl'

class DropPresenter < SimpleDelegator
  def initialize(drop, template)
    @template = template
    super drop
  end

  def render_html
    timer = render_timer
    if bookmark?
      @template.redirect remote_url
    else
      @template.erb template_name, layout: layout_name,
                                   locals: { drop: self, body_id: body_id }
    end
  ensure
    timer.stop
  end

  def render_json
    timer = render_timer
    Yajl::Encoder.encode data
  ensure
    timer.stop
  end

  def render_content
    @template.redirect_to_content slug, remote_url, updated_at
  end

private

  def layout_name
    "#{ (beta? || pending?) ? 'new_' : '' }layout".to_sym
  end

  def template_name
    if pending?
      :new_waiting
    elsif image?
      if beta?
        :new_image
      else
        :image
      end
    elsif text?
      if beta?
        :new_markdown
      else
        :text
      end
    else
      if beta?
        :new_download
      else
        :other
      end
    end
  end

  def body_id
    if pending?
      'waiting'
    elsif image?
      'image'
    elsif text?
      'text'
    else
      'other'
    end
  end

  def render_timer
    Metriks.timer("drop.render.#{ body_id }").time
  end
end
