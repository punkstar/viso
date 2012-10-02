var Metriks = {
  record: function(name, value) {
    value = value || 0
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
    Metriks.record("performance-capable")
  } else {
    Metriks.record("performance-incapable")
  }
});
