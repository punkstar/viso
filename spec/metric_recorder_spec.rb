require 'helper'
require 'metric_recorder'

describe MetricRecorder do
  after { Metriks::Registry.default.clear }

  it 'records image load time' do
    MetricRecorder.record 'image-load', 123
    timer = Metriks.get('viso.js.image-load')

    assert { timer.is_a? Metriks::Timer }
    assert { timer.count == 1 }
    assert { timer.max   == 123 }
  end

  it 'counts image errors' do
    MetricRecorder.record 'image-error'
    counter = Metriks.get('viso.js.image-error')

    assert { counter.is_a? Metriks::Counter }
    assert { counter.count == 1 }
  end

  it 'counts clients with awesome browsers' do
    MetricRecorder.record 'performance-capable'
    meter = Metriks.get('viso.js.performance-capable')

    assert { meter.is_a? Metriks::Meter }
    assert { meter.count == 1 }
  end

  it 'counts clients with incapable browsers' do
    MetricRecorder.record 'performance-incapable'
    meter = Metriks.get('viso.js.performance-incapable')

    assert { meter.is_a? Metriks::Meter }
    assert { meter.count == 1 }
  end

  it 'ignores low values' do
    MetricRecorder.record 'image-load', 0
    deny { Metriks.get('viso.js.image-load') }
  end

  it 'converts value to int' do
    MetricRecorder.record 'image-load', '1!'
    timer = Metriks.get('viso.js.image-load')

    assert { timer.count == 1 }
    assert { timer.max   == 1 }
  end

  it 'ignors unknown metrics' do
    MetricRecorder.record 'ignore', 123
    deny { Metriks.get('viso.js.ignore') }
  end
end
