var Metriks = {
  record: function(name, value) {
    value = value || 0;
    var script   = document.createElement("script");
    script.async = true;
    script.src   = "/metrics?name=" + name + "&value=" + value;
    document.body.appendChild(script);
  }
};

$(function() {
  function performanceCapable() {
    return window.performance && window.performance.timing;
  }

  if (performanceCapable()) {
    Metriks.record("performance-capable");

    var timing   = window.performance.timing,
        loadTime = timing.responseEnd - timing.navigationStart;

    Metriks.record("load", loadTime);
  } else {
    Metriks.record("performance-incapable");
  }
});
