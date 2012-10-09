require 'metriks'

class MetricRecorder
  def self.record(name, value = nil)
    metric_name = "js.#{ name }"

    case name
    when 'page-load.waiting', 'page-load.image', 'page-load.text',
         'page-load.other',   'image-load'
      value = value.to_i
      Metriks.timer(metric_name).update(value) if value > 0
    when 'performance-capable', 'performance-incapable'
      Metriks.meter(metric_name).mark
    when 'image-error'
      Metriks.counter(metric_name).increment
    end
  end
end
