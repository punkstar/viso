var Metriks = {
  record: function(name, value) {
    value = value || 0
    console.log(name, value);
    var script   = document.createElement("script");
    script.async = true;
    script.src   = "/metrics?name=" + name + "&value=" + value;
    document.body.appendChild(script);
  }
};
