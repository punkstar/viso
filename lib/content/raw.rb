class Content
  module Raw
    def content
      %{<pre><code>#{ escaped_raw }</code></pre>}
    end
  end
end
