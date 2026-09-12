MooTools.More = { version: "1.2.3.1" };
String.implement({
  parseQueryString: function () {
    var b = this.split(/[&;]/),
      a = {};
    if (b.length) {
      b.each(function (g) {
        var c = g.indexOf("="),
          d = c < 0 ? [""] : g.substr(0, c).match(/[^\]\[]+/g),
          e = decodeURIComponent(g.substr(c + 1)),
          f = a;
        d.each(function (j, h) {
          var k = f[j];
          if (h < d.length - 1) {
            f = f[j] = k || {};
          } else {
            if ($type(k) == "array") {
              k.push(e);
            } else {
              f[j] = $defined(k) ? [k, e] : e;
            }
          }
        });
      });
    }
    return a;
  },
  cleanQueryString: function (a) {
    return this.split("&")
      .filter(function (e) {
        var b = e.indexOf("="),
          c = b < 0 ? "" : e.substr(0, b),
          d = e.substr(b + 1);
        return a ? a.run([c, d]) : $chk(d);
      })
      .join("&");
  },
});
Element.implement({
  isDisplayed: function () {
    return this.getStyle("display") != "none";
  },
  toggle: function () {
    return this[this.isDisplayed() ? "hide" : "show"]();
  },
  hide: function () {
    var b;
    try {
      if ("none" != this.getStyle("display")) {
        b = this.getStyle("display");
      }
    } catch (a) {}
    return this.store("originalDisplay", b || "block").setStyle(
      "display",
      "none"
    );
  },
  show: function (a) {
    return this.setStyle(
      "display",
      a || this.retrieve("originalDisplay") || "block"
    );
  },
  swapClass: function (a, b) {
    return this.removeClass(a).addClass(b);
  },
});

// Log
(function () {
  var global = this;
  var log = function () {
    if (global.console && console.log) {
      try {
        console.log.apply(console, arguments);
      } catch (e) {
        console.log(Array.slice(arguments));
      }
    } else {
      Log.logged.push(arguments);
    }
    return this;
  };
  var disabled = function () {
    this.logged.push(arguments);
    return this;
  };
  this.Log = new Class({
    logged: [],
    log: disabled,
    resetLog: function () {
      this.logged.empty();
      return this;
    },
    enableLog: function () {
      this.log = log;
      this.logged.each(function (args) {
        this.log.apply(this, args);
      }, this);
      return this.resetLog();
    },
    disableLog: function () {
      this.log = disabled;
      return this;
    },
  });
  Log.extend(new Log()).enableLog();
  Log.logger = function () {
    return this.log.apply(this, arguments);
  };
})();

// JSONP
Request.JSONP = new Class({
  Implements: [Chain, Events, Options, Log],
  options: {
    url: "",
    data: {},
    retries: 0,
    timeout: 0,
    link: "ignore",
    callbackKey: "callback",
    injectScript: document.head,
  },
  initialize: function (a) {
    this.setOptions(a);
    if (this.options.log) this.enableLog();
    this.running = false;
    this.requests = 0;
    this.triesRemaining = [];
  },
  check: function () {
    if (!this.running) return true;
    switch (this.options.link) {
      case "cancel":
        this.cancel();
        return true;
      case "chain":
        this.chain(this.caller.bind(this, arguments));
        return false;
    }
    return false;
  },
  send: function (b) {
    if (!$chk(arguments[1]) && !this.check(b)) return this;
    var c = $type(b),
      old = this.options,
      index = $chk(arguments[1]) ? arguments[1] : this.requests++;
    if (c == "string" || c == "element") b = { data: b };
    b = $extend({ data: old.data, url: old.url }, b);
    if (!$chk(this.triesRemaining[index]))
      this.triesRemaining[index] = this.options.retries;
    var d = this.triesRemaining[index];
    (function () {
      var a = this.getScript(b);
      this.log("JSONP retrieving script with url: " + a.get("src"));
      this.fireEvent("request", a);
      this.running = true;
      (function () {
        if (d) {
          this.triesRemaining[index] = d - 1;
          if (a) {
            a.destroy();
            this.send(b, index).fireEvent("retry", this.triesRemaining[index]);
          }
        } else if (a && this.options.timeout) {
          a.destroy();
          this.cancel().fireEvent("failure");
        }
      }).delay(this.options.timeout, this);
    }).delay(Browser.Engine.trident ? 50 : 0, this);
    return this;
  },
  cancel: function () {
    if (!this.running) return this;
    this.running = false;
    this.fireEvent("cancel");
    return this;
  },
  getScript: function (a) {
    var b = Request.JSONP.counter,
      data;
    Request.JSONP.counter++;
    switch ($type(a.data)) {
      case "element":
        data = document.id(a.data).toQueryString();
        break;
      case "object":
      case "hash":
        data = Hash.toQueryString(a.data);
    }
    var c =
      a.url +
      (a.url.test("\\?") ? "&" : "?") +
      (a.callbackKey || this.options.callbackKey) +
      "=Request.JSONP.request_map.request_" +
      b +
      (data ? "&" + data : "");
    if (c.length > 2083)
      this.log(
        "JSONP " +
          c +
          " will fail in Internet Explorer, which enforces a 2083 bytes length limit on URIs"
      );
    var d = new Element("script", { type: "text/javascript", src: c });
    Request.JSONP.request_map["request_" + b] = function () {
      this.success(arguments, d);
    }.bind(this);
    return d.inject(this.options.injectScript);
  },
  success: function (a, b) {
    if (b) b.destroy();
    this.running = false;
    this.log("JSONP successfully retrieved: ", a);
    this.fireEvent("complete", a).fireEvent("success", a).callChain();
  },
});
Request.JSONP.counter = 0;
Request.JSONP.request_map = {};

// MD5
(function () {
  function utf8(c) {
    var a,
      b,
      result = "",
      from = String.fromCharCode;
    for (a = 0; (b = c.charCodeAt(a)); a++) {
      if (b < 128) {
        result += from(b);
      } else if (b > 127 && b < 2048) {
        result += from((b >> 6) | 192);
        result += from((b & 63) | 128);
      } else {
        result += from((b >> 12) | 224);
        result += from(((b >> 6) & 63) | 128);
        result += from((b & 63) | 128);
      }
    }
    return result;
  }
  String.implement({
    toUTF8: function () {
      return utf8(this);
    },
  });
})();
(function () {
  var j = {
    f: function (a, b, c) {
      return (a & b) | (~a & c);
    },
    g: function (a, b, c) {
      return (a & c) | (b & ~c);
    },
    h: function (a, b, c) {
      return a ^ b ^ c;
    },
    i: function (a, b, c) {
      return b ^ (a | ~c);
    },
    rotateLeft: function (a, b) {
      return (a << b) | (a >>> (32 - b));
    },
    addUnsigned: function (a, b) {
      var c = a & 0x80000000,
        b8 = b & 0x80000000,
        a4 = a & 0x40000000,
        b4 = b & 0x40000000,
        result = (a & 0x3fffffff) + (b & 0x3fffffff);
      if (a4 & b4) {
        return result ^ 0x80000000 ^ c ^ b8;
      }
      if (a4 | b4) {
        if (result & 0x40000000) {
          return result ^ 0xc0000000 ^ c ^ b8;
        } else {
          return result ^ 0x40000000 ^ c ^ b8;
        }
      } else {
        return result ^ c ^ b8;
      }
    },
    compound: function (a, b, c, d, e, f, g, h) {
      var i = j,
        add = i.addUnsigned,
        temp = add(b, add(add(i[a](c, d, e), g), f));
      return add(i.rotateLeft(temp, h), c);
    },
  };
  function convertToArray(a) {
    var b = a.length,
      numberOfWords = ((b + 8 - ((b + 8) % 64)) / 64 + 1) * 16,
      wordArray = new Array(),
      wordCount = (bytePosition = byteCount = 0);
    while (byteCount < b) {
      wordCount = (byteCount - (byteCount % 4)) / 4;
      bytePosition = (byteCount % 4) * 8;
      wordArray[wordCount] =
        wordArray[wordCount] | (a.charCodeAt(byteCount) << bytePosition);
      byteCount++;
    }
    wordCount = (byteCount - (byteCount % 4)) / 4;
    bytePosition = (byteCount % 4) * 8;
    wordArray[wordCount] = wordArray[wordCount] | (0x80 << bytePosition);
    wordArray[numberOfWords - 2] = b << 3;
    wordArray[numberOfWords - 1] = b >>> 29;
    return wordArray;
  }
  function convertToHex(a) {
    var b = (temp = nibble = i = "");
    for (i = 0; i <= 3; i++) {
      nibble = (a >>> (i * 8)) & 255;
      temp = "0" + nibble.toString(16);
      b = b + temp.substr(temp.length - 2, 2);
    }
    return b;
  }
  function md5(e) {
    var f,
      t2,
      t3,
      t4,
      x = convertToArray(e.toUTF8()),
      a = 0x67452301,
      b = 0xefcdab89,
      c = 0x98badcfe,
      d = 0x10325476,
      s1 = 7,
      s2 = 12,
      s3 = 17,
      s4 = 22,
      s5 = 5,
      s6 = 9,
      s7 = 14,
      s8 = 20,
      s9 = 4,
      s10 = 11,
      s11 = 16,
      s12 = 23,
      s13 = 6,
      s14 = 10,
      s15 = 15,
      s16 = 21;
    for (var k = 0; k < x.length; k += 16) {
      f = a;
      t2 = b;
      t3 = c;
      t4 = d;
      a = j.compound("f", a, b, c, d, 0xd76aa478, x[k + 0], s1);
      d = j.compound("f", d, a, b, c, 0xe8c7b756, x[k + 1], s2);
      c = j.compound("f", c, d, a, b, 0x242070db, x[k + 2], s3);
      b = j.compound("f", b, c, d, a, 0xc1bdceee, x[k + 3], s4);
      a = j.compound("f", a, b, c, d, 0xf57c0faf, x[k + 4], s1);
      d = j.compound("f", d, a, b, c, 0x4787c62a, x[k + 5], s2);
      c = j.compound("f", c, d, a, b, 0xa8304613, x[k + 6], s3);
      b = j.compound("f", b, c, d, a, 0xfd469501, x[k + 7], s4);
      a = j.compound("f", a, b, c, d, 0x698098d8, x[k + 8], s1);
      d = j.compound("f", d, a, b, c, 0x8b44f7af, x[k + 9], s2);
      c = j.compound("f", c, d, a, b, 0xffff5bb1, x[k + 10], s3);
      b = j.compound("f", b, c, d, a, 0x895cd7be, x[k + 11], s4);
      a = j.compound("f", a, b, c, d, 0x6b901122, x[k + 12], s1);
      d = j.compound("f", d, a, b, c, 0xfd987193, x[k + 13], s2);
      c = j.compound("f", c, d, a, b, 0xa679438e, x[k + 14], s3);
      b = j.compound("f", b, c, d, a, 0x49b40821, x[k + 15], s4);
      a = j.compound("g", a, b, c, d, 0xf61e2562, x[k + 1], s5);
      d = j.compound("g", d, a, b, c, 0xc040b340, x[k + 6], s6);
      c = j.compound("g", c, d, a, b, 0x265e5a51, x[k + 11], s7);
      b = j.compound("g", b, c, d, a, 0xe9b6c7aa, x[k + 0], s8);
      a = j.compound("g", a, b, c, d, 0xd62f105d, x[k + 5], s5);
      d = j.compound("g", d, a, b, c, 0x2441453, x[k + 10], s6);
      c = j.compound("g", c, d, a, b, 0xd8a1e681, x[k + 15], s7);
      b = j.compound("g", b, c, d, a, 0xe7d3fbc8, x[k + 4], s8);
      a = j.compound("g", a, b, c, d, 0x21e1cde6, x[k + 9], s5);
      d = j.compound("g", d, a, b, c, 0xc33707d6, x[k + 14], s6);
      c = j.compound("g", c, d, a, b, 0xf4d50d87, x[k + 3], s7);
      b = j.compound("g", b, c, d, a, 0x455a14ed, x[k + 8], s8);
      a = j.compound("g", a, b, c, d, 0xa9e3e905, x[k + 13], s5);
      d = j.compound("g", d, a, b, c, 0xfcefa3f8, x[k + 2], s6);
      c = j.compound("g", c, d, a, b, 0x676f02d9, x[k + 7], s7);
      b = j.compound("g", b, c, d, a, 0x8d2a4c8a, x[k + 12], s8);
      a = j.compound("h", a, b, c, d, 0xfffa3942, x[k + 5], s9);
      d = j.compound("h", d, a, b, c, 0x8771f681, x[k + 8], s10);
      c = j.compound("h", c, d, a, b, 0x6d9d6122, x[k + 11], s11);
      b = j.compound("h", b, c, d, a, 0xfde5380c, x[k + 14], s12);
      a = j.compound("h", a, b, c, d, 0xa4beea44, x[k + 1], s9);
      d = j.compound("h", d, a, b, c, 0x4bdecfa9, x[k + 4], s10);
      c = j.compound("h", c, d, a, b, 0xf6bb4b60, x[k + 7], s11);
      b = j.compound("h", b, c, d, a, 0xbebfbc70, x[k + 10], s12);
      a = j.compound("h", a, b, c, d, 0x289b7ec6, x[k + 13], s9);
      d = j.compound("h", d, a, b, c, 0xeaa127fa, x[k + 0], s10);
      c = j.compound("h", c, d, a, b, 0xd4ef3085, x[k + 3], s11);
      b = j.compound("h", b, c, d, a, 0x4881d05, x[k + 6], s12);
      a = j.compound("h", a, b, c, d, 0xd9d4d039, x[k + 9], s9);
      d = j.compound("h", d, a, b, c, 0xe6db99e5, x[k + 12], s10);
      c = j.compound("h", c, d, a, b, 0x1fa27cf8, x[k + 15], s11);
      b = j.compound("h", b, c, d, a, 0xc4ac5665, x[k + 2], s12);
      a = j.compound("i", a, b, c, d, 0xf4292244, x[k + 0], s13);
      d = j.compound("i", d, a, b, c, 0x432aff97, x[k + 7], s14);
      c = j.compound("i", c, d, a, b, 0xab9423a7, x[k + 14], s15);
      b = j.compound("i", b, c, d, a, 0xfc93a039, x[k + 5], s16);
      a = j.compound("i", a, b, c, d, 0x655b59c3, x[k + 12], s13);
      d = j.compound("i", d, a, b, c, 0x8f0ccc92, x[k + 3], s14);
      c = j.compound("i", c, d, a, b, 0xffeff47d, x[k + 10], s15);
      b = j.compound("i", b, c, d, a, 0x85845dd1, x[k + 1], s16);
      a = j.compound("i", a, b, c, d, 0x6fa87e4f, x[k + 8], s13);
      d = j.compound("i", d, a, b, c, 0xfe2ce6e0, x[k + 15], s14);
      c = j.compound("i", c, d, a, b, 0xa3014314, x[k + 6], s15);
      b = j.compound("i", b, c, d, a, 0x4e0811a1, x[k + 13], s16);
      a = j.compound("i", a, b, c, d, 0xf7537e82, x[k + 4], s13);
      d = j.compound("i", d, a, b, c, 0xbd3af235, x[k + 11], s14);
      c = j.compound("i", c, d, a, b, 0x2ad7d2bb, x[k + 2], s15);
      b = j.compound("i", b, c, d, a, 0xeb86d391, x[k + 9], s16);
      a = j.addUnsigned(a, f);
      b = j.addUnsigned(b, t2);
      c = j.addUnsigned(c, t3);
      d = j.addUnsigned(d, t4);
    }
    return (
      convertToHex(a) +
      convertToHex(b) +
      convertToHex(c) +
      convertToHex(d)
    ).toLowerCase();
  }
  String.implement({
    toMD5: function () {
      return md5(this);
    },
  });
})();

// Dialog - modified to always have top:100
var Overlay = new Class({
  Implements: [Options, Events],
  options: {
    id: "overlay",
    color: "#000",
    duration: 500,
    opacity: 0.5,
    zIndex: 5000,
  },
  initialize: function (a, b) {
    this.setOptions(b);
    this.container = document.id(a);
    if (Browser.Engine.trident && Browser.Engine.version <= 6) this.ie6 = true;
    this.bound = {
      window: {
        resize: this.resize.bind(this),
        scroll: this.scroll.bind(this),
      },
      overlayClick: this.overlayClick.bind(this),
      tweenStart: this.tweenStart.bind(this),
      tweenComplete: this.tweenComplete.bind(this),
    };
    this.build().attach();
  },
  build: function () {
    this.overlay = new Element("div", {
      id: this.options.id,
      opacity: 0,
      styles: {
        position: this.ie6 ? "absolute" : "fixed",
        background: this.options.color,
        left: 0,
        top: 0,
        "z-index": this.options.zIndex,
      },
    }).inject(this.container);
    this.tween = new Fx.Tween(this.overlay, {
      duration: this.options.duration,
      link: "cancel",
      property: "opacity",
    });
    return this;
  }.protect(),
  attach: function () {
    window.addEvents(this.bound.window);
    this.overlay.addEvent("click", this.bound.overlayClick);
    this.tween.addEvents({
      onStart: this.bound.tweenStart,
      onComplete: this.bound.tweenComplete,
    });
    return this;
  },
  detach: function () {
    var b = Array.prototype.slice.call(arguments);
    b.each(function (a) {
      if (a == "window") window.removeEvents(this.bound.window);
      if (a == "overlay")
        this.overlay.removeEvent("click", this.bound.overlayClick);
    }, this);
    return this;
  },
  overlayClick: function () {
    this.fireEvent("click");
    return this;
  },
  tweenStart: function () {
    this.overlay.setStyles({
      width: "100%",
      height: this.container.getScrollSize().y,
    });
    return this;
  },
  tweenComplete: function () {
    this.fireEvent(
      this.overlay.get("opacity") == this.options.opacity ? "show" : "hide"
    );
    return this;
  },
  open: function () {
    this.fireEvent("open");
    this.tween.start(this.options.opacity);
    return this;
  },
  close: function () {
    this.fireEvent("close");
    this.tween.start(0);
    return this;
  },
  resize: function () {
    this.fireEvent("resize");
    this.overlay.setStyle("height", this.container.getScrollSize().y);
    return this;
  },
  scroll: function () {
    this.fireEvent("scroll");
    if (this.ie6) this.overlay.setStyle("left", window.getScroll().x);
    return this;
  },
});
var MooDialog = new Class({
  Implements: [Options, Events],
  options: {
    size: { width: 300, height: 100 },
    offset: { x: 0, y: -100 },
    overlay: { color: "#000" },
    title: null,
    scroll: true,
    useEscKey: true,
    disposeOnClose: true,
    closeButton: true,
    closeOnOverlayClick: true,
    useScrollBar: true,
    fx: {
      type: "tween",
      open: 1,
      close: 0,
      options: { property: "opacity", duration: 400 },
    },
  },
  initialize: function (a) {
    this.setOptions(a);
    this.ie6 = Browser.Engine.trident && Browser.Engine.version <= 4;
    a = this.options;
    var b = a.size,
      x = b.width,
      y = b.height,
      wrapper = (this.wrapper = new Element("div", {
        class: "MooDialog",
        styles: {
          width: x,
          height: y,
          position: a.scroll && !this.ie6 ? "fixed" : "absolute",
          "z-index": 6000,
          opacity: 0,
        },
      }).inject(document.body));
    this.content = new Element("div", {
      styles: {
        width: x,
        height: y,
        overflow: a.useScrollBar ? "auto" : "hidden",
      },
    }).inject(wrapper);
    if (a.title) {
      this.title = new Element("div", { class: "title", text: a.title }).inject(
        wrapper
      );
      wrapper.addClass("MooDialogTitle");
    }
    if (a.closeButton) {
      this.closeButton = new Element("a", {
        class: "close",
        events: { click: this.close.bind(this) },
      }).inject(wrapper);
    }
    var c = document.id(document.body).getSize();
    this.setPosition((c.x - x) / 2, (c.y - y) / 2);
    if (a.scroll && this.ie6) {
      window.addEvent(
        "scroll",
        function () {
          this.setPosition((c.x - x) / 2, (c.y - y) / 2);
        }.bind(this)
      );
    }
    if (!this.fx) {
      this.fx =
        a.fx.type == "morph"
          ? new Fx.Morph(wrapper, a.fx.options)
          : new Fx.Tween(wrapper, a.fx.options);
    }
    this.fx.addEvent(
      "complete",
      function () {
        this.fireEvent(this.open ? "show" : "hide");
        if (a.disposeOnClose && !this.open) this.dispose();
      }.bind(this)
    );
    this.overlay = new Overlay(document.body, {
      duration: this.options.fx.options.duration,
      color: this.options.overlay.color,
    });
    if (a.closeOnOverlayClick)
      this.overlay.addEvent("click", this.close.bind(this));
  },
  setContent: function (a) {
    this.content.empty();
    switch ($type(a)) {
      case "element":
        this.content.adopt(a);
        break;
      case "string":
      case "number":
        this.content.set("text", a);
        break;
    }
    return this;
  },
  setPosition: function (x, y) {
    var a = this.options,
      wrapper = this.wrapper;
    x += a.offset.x;
    y += a.offset.y;
    x = x < 10 ? 10 : x;
    y = y < 10 ? 10 : y;
    y = 100;
    if (wrapper.getStyle("position") != "fixed") {
      var b = document.id(document.body).getScroll();
      x += b.x;
      y += b.y;
    }
    wrapper.setStyles({ left: x, top: y });
    return this;
  },
  open: function () {
    this.open = true;
    this.fireEvent("open");
    this.fx.start(this.options.fx.open);
    this.overlay.open();
    if (this.options.useEscKey) {
      document.id(document.body).addEvent(
        "keydown",
        function (e) {
          if (e.key == "esc") this.close();
        }.bind(this)
      );
    }
    return this;
  },
  close: function () {
    this.open = false;
    this.fireEvent("close");
    this.fx.start(this.options.fx.close);
    this.overlay.close();
    return this;
  },
  dispose: function () {
    this.wrapper.destroy();
    this.overlay.overlay.destroy();
  },
  toElement: function () {
    return this.wrapper;
  },
});
Element.implement({
  MooDialog: function (a) {
    var b = new MooDialog(a).setContent(this).open();
    this.store("MooDialog", b);
    return this;
  },
});
