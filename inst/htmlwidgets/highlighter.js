HTMLWidgets.widget({

  name: 'highlighter',

  type: 'output',

  factory: function(el, width, height) {

    var highlight = document.getElementById(el.id);

    return {

      renderValue: function(x) {
        highlight.innerHTML = '<pre class="hljs-' + x.style + '" style="height:100%"><code class="hljs-' + x.style + ' language-' + x.language + '"style>' + x.code + '</code></pre>';
        // hljs.initHighlightingOnLoad();
        hljs.highlightBlock(highlight);
      },
      resize: function(width, height) {
      },

      // Make the sigma object available as a property on the widget
      // instance we're returning from factory(). This is generally a
      // good idea for extensibility--it helps users of this widget
      // interact directly with sigma, if needed.
      highlight: highlight
    };
  }
});

