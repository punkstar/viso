require 'metriks'

class MetricRecorder
  def self.record(name, value = nil)
    metric_name = "viso.js.#{ name }"

    case name
    when 'image-load'
      value = value.to_i
      Metriks.timer(metric_name).update(value) if value > 0
    when 'performance-capable', 'performance-incapable'
      Metriks.meter(metric_name).mark
    when 'image-error'
      Metriks.counter(metric_name).increment
    end
  end
end
