// Call a function or class method from inside Flash
function callFunc(func, args) {
  //console.log([func,args]);
  if (func.indexOf(".") > -1) {
    func = func.split(".");
    var handle = window[func[0]];
    var base = handle;
    for (var i = 1; i < func.length; i++) handle = handle[func[i]];
    handle.run(args, base);
  } else window[func].run(args, window[func]);
}

// Deprecated streamPublish function
function sendFeed(
  ident,
  name,
  caption,
  image,
  targetid,
  actiontext,
  flash,
  ref
) {
  return cc.streamPublish(
    ident,
    name,
    caption,
    image,
    targetid,
    actiontext,
    flash,
    null,
    ref
  );
}

var CCFramework = new Class({
  Implements: [Options, Events],

  options: {
    bookmarked: null,
    liked: null,
    friends: null,
    appfriends: null,
    userdata: null,
  },

  friendSwfInjected: false,

  initialize: function (options, nocanvas) {
    if (options) this.setOptions(options);
    this.user = new Hash(this.options.user);
    if (options.userdata) {
      this.iaSendData = false;
      this.addToUser(options.userdata);
    }
    this.fbid = this.user.fbid;
    //		this.logEvent('CANVAS.FRAMEWORK.INIT');
    this.initPage(nocanvas);

    this.logLoadEvent("ccinit");
  },

  addToUser: function (data) {
    this.user.extend(data);
  },

  initPage: function (nocanvas) {
    if (this.options.integ == "hi5") hi5.Api.init();
    if (this.options.integ == "vx" && !this.options.novx) this.viximo = viximo;
    if (this.options.integ == "kg") this.getKgApi(function (api) {});
    if (this.options.integ == "fbg") this.initFbg();
    if (!nocanvas) this.setCanvasHeight.delay(1000, this);
  },

  initFbg: function (attempt) {
    this.setAccessToken(true);
    this.fireCcfReady();
  },

  fireCcfReady: function () {
    if (typeOf(window.cc) != "null") window.fireEvent("ccfready");
    else this.fireCcfReady.delay(500, this);
  },

  accessToken: null,
  setAccessToken: function (use_server_token) {
    if (use_server_token === true) {
      var params = this.options.fbdata.parseQueryString();
      return (this.accessToken = params["access_token"] || null);
    }
    return (this.accessToken = FB.getAccessToken());
  },

  getAccessToken: function () {
    return this.accessToken;
  },

  // DEPRECATED - Removing once BP is migrated away
  logEvent: function (event, loadtime) {
    if (typeof loadtime == "undefined")
      loadtime = new Date().getTime() - this.options.canvas_init_time;

    if (this.options.logurl != "" && this.options.logsessionid != "") {
      logvars =
        "ts=0&logsession=" +
        this.options.logsessionid +
        "&key=" +
        event +
        "&userid=" +
        this.options.user.id +
        "&loadtime=" +
        loadtime;
      logvars += "&h=" + this.options.log_h + "&hn=" + this.options.log_hn;
      new Request.JSONP({
        url: this.options.logurl + "debug/recordloadjs?" + logvars,
        onSuccess: function (data) {
          //console.log('[logEvent] ' + this.options.logsessionid + ' - ' + event);
        }.bind(this),
      }).send();
    }
  },

  logGenericEvent: function (props, ignoreSplit) {
    try {
      if (this.options.kx_logger_url == "" || this.options.kx_logger_key == "")
        return false;
      if (this.options.logsessionid == "" && !ignoreSplit) return false;

      var defaultProps = {
        p: this.options.integ,
        g: this.options.game.toUpperCase(),
        key: this.options.kx_logger_key,
        s: this.options.user.fbid,
        type: "image",
      };

      props = Object.merge(defaultProps, props);
      props = Object.toQueryString(props);

      this.callUrl(this.options.kx_logger_url + "?" + props);
    } catch (e) {}
  },

  // Record the load event.  loadtime: duration
  logLoadEvent: function (event, loadtime) {
    try {
      var st = this.options.kx_logger_st || "load";
      var t = new Date().getTime();

      if (typeof loadtime == "undefined")
        loadtime = t - this.options.canvas_init_time;

      var props = {
        t: t,
        tag: "load",
        stage: event,
        loadtime: loadtime,
      };

      if (this.options.logsessionid)
        props["loadid"] = this.options.logsessionid;

      this.logGenericEvent(props);
    } catch (e) {}
  },

  logFlashCapabilities: function (flashProps) {
    var t = new Date().getTime();
    //check the cookie

    var last_log_ts = JSON.parse(Cookie.read("flashcap"));
    if (last_log_ts) {
      if (
        last_log_ts[this.options.userid] &&
        t - last_log_ts[this.options.userid] < 24 * 60 * 60
      )
        return;
    }
    //t: unix time stamp
    //u: required user id
    //l: user level
    try {
      //browser
      //browser_version
      //os
      //flash_version
      //screen_resolution: 1024x768
      //screen_dpi

      var props = {
        browser: BrowserDetect.browser,
        browser_version: BrowserDetect.version,
        os: BrowserDetect.OS,
        u: this.options.userid,
        t: t,
        l: this.options.userlevel,
        window_size: window.innerWidth + "x" + window.innerHeight,
        tag: "canvasload",
      };

      props = Object.merge(flashProps, props);
      this.logGenericEvent(props);

      //store cookie
      if (!last_log_ts) last_log_ts = {};
      last_log_ts[this.options.userid] = t;
      Cookie.write("flashcap", JSON.stringify(last_log_ts));
    } catch (e) {}
  },

  getCanvasLoadTime: function () {
    this.logEvent("CANVAS.DOMREADY", this.options.canvas_load_time);
    //		this.sendToSwf('canvasLoadTimeCallback',JSON.encode({'canvas_load_time':this.options.canvas_load_time}));
  },

  kgApi: null,
  kgApiLoadingState: 0,
  gkgActive: false,
  gkgCallbacks: null,
  getKgApi: function () {
    if (this.kgApi !== null) {
      return this.kgApi;
    }
    if (this.kgApiLoadingState == 0) {
      kongregateAPI.loadAPI(function () {
        cc.kgApi = kongregateAPI.getAPI();
        cc.kgApiLoadingState = 2;
        cc.kg_onPurchaseResult({ success: 1 });
      });
      this.kgApiLoadingState = 1;
      return true;
    } else if (this.kgApiLoadingState == 1) {
    }
    return true;
  },
  shinyDialog: null,
  giveKgTopupPopup: function (url) {
    var loadingBg = "";
    if (!this.shinyDialog) {
      this.shinyDialog = new Element("div", {
        class: "shinydialog",
        styles: {
          position: "absolute",
          top: 10,
          left: ((this.options.game_width - 724) / 2).round(),
          width: 724,
          height: 467,
          overflow: "visible",
          background:
            "url('" +
            this.options.cdnurl +
            "images/feeddialog/outside3.png') no-repeat",
          padding: "10px 0 0 11px",
          "z-index": 9,
        },
      });
      this.shinyDialog.adopt(
        new Element("div", {
          styles: {
            "background-image": "url(" + loadingBg + ")",
            position: "absolute",
            top: "12px",
            left: "14px",
            width: "697px",
            height: "446px",
          },
        }),
        new Element("div", {
          id: "shiny-dialog",
          styles: {
            position: "absolute",
            top: "12px",
            left: "14px",
            width: "697px",
            height: "446px",
          },
        }),
        new Element("img", {
          src: this.options.cdnurl + "images/close2.png",
          styles: {
            width: 33,
            height: 33,
            cursor: "pointer",
            position: "absolute",
            top: 0,
            right: 18,
          },
        }).addEvent(
          "click",
          function () {
            this.kgHideShinyDialog();
          }.bind(this)
        )
      );

      $("content").grab(this.shinyDialog);

      new Request({
        url:
          this.options.localurl + "canvas/kgtopupiframe?" + this.options.fbdata,
        evalScripts: true,
        onSuccess: function (data) {
          $("shiny-dialog").set("html", data);
        }.bind(this),
      }).send();
    }
  },
  kgHideShinyDialog: function () {
    if (this.shinyDialog) {
      this.shinyDialog.dispose().empty();
      this.shinyDialog = null;
    }
  },
  buyKgItem: function (item) {
    var cartItems = [];
    cartItems.push(item);
    this.kg_showTopup(cartItems);
  },

  setCanvasHeight: function () {
    if (this.options.integ == "kg") return true;
    var height = document.getScrollSize().y + 10;
    if (this.options.integ == "hi5") hi5.Api.setCanvasHeight(height);
    if (this.options.integ == "vx" && !this.options.novx)
      this.viximo.Container.setHeight(height);
    if (this.options.integ == "fb") {
      FB.Bootstrap.requireFeatures(
        ["CanvasUtil", "Api", "Connect"],
        function () {
          FB.CanvasClient.setCanvasHeight(height + "px");
        }
      );
    }
    if (this.options.integ == "fbg") {
      FB.Canvas.setSize();
    }
  },

  loadGame: function (el, args) {
    el = $(el);
    if (!el) return false;
    var fvars = this.options.jflashvars;
    fvars.gameversion = args.gameversion;
    fvars.softversion = args.softversion;

    var loadername, loaderversion, filename;

    if (args.loaderversion > 0) {
      loadername = "gameloader";
      loaderversion = args.loaderversion;
      filename = args.gameurl + loadername + "-v" + loaderversion + ".swf";
    } else {
      loadername = "game";
      loaderversion = args.gameversion;
      filename =
        args.gameurl +
        loadername +
        "-v" +
        loaderversion +
        ".v" +
        fvars.softversion +
        ".swf";
    }

    swfobject.embedSWF(
      filename,
      "game",
      args.game_width,
      args.game_height,
      "10.0.0",
      "",
      fvars,
      {
        allowfullscreen: true,
        allowscriptaccess: "always",
        wmode: "transparent",
      },
      { id: "gameswf" },
      function () {
        this.setGameSwf($("gameswf"));
        this.logLoadEvent("loaderstart");
        /* DISABLED FOR NOW
				new RightClick({
					'objectid': 'gameswf',
					'containerid': 'game',
					'callback': 'rightclick'
				});*/
      }.bind(this)
    );

    return true;
  },

  expectedIaResults: null,
  receivedIaResults: 0,
  defaultIaResults: {
    userdata: 0,
    friends: 0,
    appfriends: 0,
    bookmarked: 0,
    liked: 0,
  },
  iaResults: {},
  iaCallback: null,
  iaVersion: 0,
  iaSendData: true,
  iaAttemptNo: 1,
  inited: false,
  initApplication: function (version, callback) {
    this.iaResults = this.defaultIaResults;

    if (!$defined(version)) return false;
    this.logLoadEvent("initstart");
    this.iaVersion = version;
    if (callback) this.iaCallback = callback;
    if (this.receivedIaResults > 0 || !this.iaSendData)
      return this.sendIaResults();

    if (this.options.integ == "hi5") this.hi5_gatherIaResults();
    else if (this.options.integ == "kg") this.kg_gatherIaResults();
    else if (this.options.integ == "vx") this.vx_gatherIaResults();
    else this.gatherIaResults();
  },

  noInit: function () {
    this.inited = true;
  },

  gatherIaResults: function (force) {
    if (!force) force = false;

    this.expectedIaResults = 6;
    this.getFriends(
      function (data) {
        this.iaResult("friends", data);
      }.bind(this),
      force
    );
    this.getAppFriends(
      function (data) {
        this.iaResult("appfriends", data);
      }.bind(this),
      force
    );
    this.getUserData(
      function (data) {
        this.iaResult("userdata", data);
      }.bind(this),
      force
    );
    this.getBookmarked(
      function (data) {
        this.iaResult("bookmarked", data);
      }.bind(this),
      force
    );
    this.getLiked(
      function (data) {
        this.iaResult("liked", data);
      }.bind(this),
      force
    );
    this.getAppRequests(
      function (data) {
        this.iaResult("apprequests", data);
      }.bind(this),
      force
    );
  },

  hi5_gatherIaResults: function () {
    this.expectedIaResults = 3;
    this.hi5_getFriends(
      function (data) {
        this.iaResult("friends", data);
      }.bind(this)
    );
    this.hi5_getAppFriends(
      function (data) {
        this.iaResult("appfriends", data);
      }.bind(this)
    );
    this.hi5_getUserData(
      function (data) {
        this.iaResult("userdata", data);
      }.bind(this)
    );
  },

  vx_gatherIaResults: function () {
    this.expectedIaResults = 2;
    this.vx_getFriends(
      function (data) {
        this.iaResult("friends", data);
      }.bind(this)
    );
    this.vx_getUserData(
      function (data) {
        this.iaResult("userdata", data);
      }.bind(this)
    );
  },

  kg_gatherIaResults: function () {
    //this.expectedIaResults = 1;
    //this.kg_getFriends(function(data){ this.iaResult('friends',data); }.bind(this));
    //this.kg_getAppFriends(function(data){ this.iaResult('appfriends',data); }.bind(this));
    //this.kg_getUserData(function(data){ this.iaResult('userdata',data); }.bind(this));
    this.iaSendData = false;
    this.sendIaResults();
  },

  iaResult: function (name, data) {
    this.iaResults[name] = data;

    if (name == "userdata" && this.debugData !== null) {
      this.iaResults["error"] = this.debugData;
    }

    this.receivedIaResults++;
    if (this.expectedIaResults == this.receivedIaResults) {
      try {
        // If userdata is empty, retry
        if (!this.iaResults.userdata.uid) {
          if (this.iaAttemptNo == 5) {
            this.iaResults.error =
              "Userdata could not be retrieved after 5 attempts";
            this.sendIaResults();
          } else {
            this.iaResults = this.defaultIaResults;
            this.receivedIaResults = 0;

            // Delay retry to allow for temporary network issues
            (function () {
              this.iaAttemptNo++;
              this.gatherIaResults(true);
            })
              .bind(this)
              .delay(this.iaAttemptNo * 1500, this); // Increase interval with each retry
          }
        } else this.sendIaResults();
      } catch (e) {
        this.sendIaResults();
      }
    }
  },

  sendIaResults: function () {
    this.setTabs();
    new Request({
      url: this.options.localurl + "backend/initapplication",
      onSuccess: function (data) {
        this.logLoadEvent("initend");
        this.inited = true;

        try {
          window.initAllianceDialog();
        } catch (err) {
          //ignore
        }
        if (this.iaVersion == "reload") {
          this.reloadParent();
        } else {
          if (this.iaCallback) {
            if ($type(this.iaCallback) == "function") this.iaCallback();
            else this.sendToSwf(this.iaCallback, data);
          }
          this.giftRedir();
          this.injectFriendsSwf();
          try {
            this.recordUserInfo();
          } catch (e) {}
        }
      }.bind(this),
    }).send(
      "version=" +
        this.iaVersion +
        (this.iaSendData ? "&data=" + JSON.encode(this.iaResults) : "") +
        "&returninfo=" +
        (this.iaCallback ? 1 : 0) +
        "&" +
        this.options.fbdata
    );
  },

  injectFriendsSwf: function () {
    if (this.friendSwfInjected == true) return true;
    this.friendSwfInjected = true;
    if (!$("friends")) return false;

    swfobject.embedSWF(
      this.options.cdnurl +
        "flash/friends.v" +
        this.options.fswfversion +
        ".swf",
      "friends",
      this.options.game_width,
      this.options.fswf_height,
      "10.0.0",
      "",
      this.options.jflashvarsf,
      {
        allowfullscreen: false,
        allowscriptaccess: "always",
        wmode: "transparent",
      },
      { id: "friendsswf" }
    );

    this.setCanvasHeight.delay(500, this);
  },

  giftRedir: function () {
    if (
      this.options.integ != "fbg" ||
      !this.options.giftredir ||
      $type(this.options.appfriends) != "array"
    )
      return false;
    var af = this.options.appfriends;
    if (af.length < 5) this.showFeedDialog("invite");
    else this.showFeedDialog(this.options.giftredir);
  },

  getFriends: function (callback, force) {
    if (force) this.options.friends = null;

    if (this.options.friends !== null) {
      if ($defined(callback) && $type(callback) == "function")
        callback(this.options.friends);
      return this.options.friends;
    }
    if (this.options.integ == "fbg") {
      FB.api(
        "/me/friends?access_token=" + this.getAccessToken(),
        function (res) {
          var data = [];
          if ($type(res.data) == "array") {
            var tmp = $A(res.data);
            tmp.each(function (v) {
              data.push(parseInt(v.id));
            });
          }

          this.options.friends = data;
          if ($defined(callback) && $type(callback) == "function")
            callback(data);
        }.bind(this)
      );
    } else {
      FB.Bootstrap.requireFeatures(
        ["Api", "Connect"],
        function () {
          FB.Facebook.apiClient.friends_get(
            null,
            function (data) {
              if ($type(data) != "array") data = [];
              this.options.friends = data;
              if ($defined(callback) && $type(callback) == "function")
                callback(data);
            }.bind(this)
          );
        }.bind(this)
      );
    }
  },

  getAppRequests: function (callback, force) {
    FB.api(
      "/me/apprequests?access_token=" + this.getAccessToken(),
      function (res) {
        var data = [];
        if ($type(res.data) == "array") data = res.data;
        if ($defined(callback) && $type(callback) == "function") callback(data);
      }
    );
  },

  getAppFriends: function (callback, force) {
    if (force) this.options.appfriends = null;

    if (this.options.appfriends !== null) {
      if ($defined(callback) && $type(callback) == "function")
        callback(this.options.appfriends);
      return this.options.appfriends;
    }
    if (this.options.integ == "fbg") {
      FB.api(
        {
          method: "fql.query",
          query:
            'select uid from user where is_app_user="1" and uid in (select uid2 from friend where uid1=' +
            this.fbid +
            ")",
          access_token: this.getAccessToken(),
        },
        function (res) {
          var data = [];
          if ($type(res) == "array") {
            var tmp = $A(res);
            tmp.each(function (v) {
              data.push(parseInt(v.uid));
            });
          }

          this.options.appfriends = data;
          if ($defined(callback) && $type(callback) == "function")
            callback(data);
        }.bind(this)
      );
    } else {
      FB.Bootstrap.requireFeatures(
        ["Api", "Connect"],
        function () {
          FB.Facebook.apiClient.fql_query(
            'select uid from user where is_app_user="1" and uid in (select uid2 from friend where uid1=' +
              this.fbid +
              ")",
            function (data) {
              if (!$defined(data) || $type(data) != "array") out = [];
              else {
                var out = [];
                data = $A(data);
                data.each(function (v) {
                  out.push(parseInt(v.uid));
                });
              }
              this.options.appfriends = out;
              if ($defined(callback) && $type(callback) == "function")
                callback(out);
            }.bind(this)
          );
        }.bind(this)
      );
    }
  },

  debugData: null,
  getUserData: function (callback, force) {
    if (force) this.options.userdata = null;

    if (this.options.userdata !== null) {
      if ($defined(callback) && $type(callback) == "function")
        callback(this.options.userdata);
      return this.options.userdata;
    }
    if (this.options.integ == "fbg") {
      FB.api(
        {
          method: "users.getInfo",
          uids: [this.fbid],
          fields: [
            "first_name",
            "last_name",
            "pic",
            "profile_url",
            "pic_square",
            "email",
            "proxied_email",
            "birthday_date",
            "current_location",
            "sex",
          ],
          access_token: this.getAccessToken(),
        },
        function (res) {
          var data = {};
          if ($defined(res) && $type(res) == "array" && res.length > 0)
            data = res[0];

          this.options.userdata = data;
          this.addToUser(data);
          if ($defined(callback) && $type(callback) == "function")
            callback(data);
        }.bind(this)
      );
    } else {
      FB.Bootstrap.requireFeatures(
        ["Api", "Connect"],
        function () {
          FB.Facebook.apiClient.users_getInfo(
            [this.fbid],
            [
              "first_name",
              "last_name",
              "pic",
              "profile_url",
              "pic_square",
              "email",
              "proxied_email",
              "birthday_date",
              "current_location",
              "sex",
            ],
            function (data, error) {
              if ($defined(data) && $type(data) == "array" && data.length > 0)
                data = data[0];
              else {
                if ($defined(error) && $type(error) == "object") {
                  this.debugData = "type=" + $type(data) + ";fbid=" + this.fbid;
                  if ($type(error.userData) == "object") {
                    this.debugData =
                      this.debugData +
                      ";error_code=" +
                      error.userData.error_code +
                      ";error_msg=" +
                      error.userData.error_msg;
                  }
                } else {
                  this.debugData = "type=" + $type(data) + ";fbid=" + this.fbid;
                }
                data = {};
              }
              this.options.userdata = data;
              this.addToUser(data);
              if ($defined(callback) && $type(callback) == "function")
                callback(data);
            }.bind(this)
          );
        }.bind(this)
      );
    }
  },

  getBookmarked: function (callback, force) {
    if (force) this.options.bookmarked = null;

    if (this.options.bookmarked !== null) {
      if ($defined(callback) && $type(callback) == "function")
        callback(this.options.bookmarked);
      return this.options.bookmarked;
    }
    if (this.options.integ == "fbg") {
      FB.api(
        {
          method: "fql.query",
          query: "SELECT bookmarked FROM permissions WHERE uid = " + this.fbid,
          access_token: this.getAccessToken(),
        },
        function (res) {
          var data = 0;
          if (
            $defined(res) &&
            $type(res) == "array" &&
            res.length > 0 &&
            res[0].bookmarked
          )
            data = 1;
          this.options.bookmarked = data;
          if ($defined(callback) && $type(callback) == "function")
            callback(data);
        }.bind(this)
      );
    } else {
      FB.Bootstrap.requireFeatures(
        ["Api", "Connect"],
        function () {
          FB.Facebook.apiClient.fql_query(
            "SELECT bookmarked FROM permissions WHERE uid = " + this.fbid,
            function (data) {
              if (
                $defined(data) &&
                $type(data) == "array" &&
                data.length > 0 &&
                data[0].bookmarked
              )
                data = 1;
              else data = 0;
              this.options.bookmarked = data;
              if ($defined(callback) && $type(callback) == "function")
                callback(data);
            }.bind(this)
          );
        }.bind(this)
      );
    }
  },

  getLiked: function (callback, force) {
    if (force) this.options.liked = null;

    if (this.options.liked !== null) {
      if ($defined(callback) && $type(callback) == "function")
        callback(this.options.liked);
      return this.options.liked;
    }
    if (this.options.integ == "fbg") {
      FB.api(
        {
          method: "fql.query",
          query:
            "SELECT uid FROM page_fan WHERE uid = " +
            this.fbid +
            " AND page_id = " +
            this.options.app_id,
          access_token: this.getAccessToken(),
        },
        function (res) {
          var data = 0;
          if (
            $defined(res) &&
            $type(res) == "array" &&
            res.length > 0 &&
            res[0].uid
          )
            data = 1;
          this.options.liked = data;
          if ($defined(callback) && $type(callback) == "function")
            callback(data);
        }.bind(this)
      );
    } else {
      FB.Bootstrap.requireFeatures(
        ["Api", "Connect"],
        function () {
          FB.Facebook.apiClient.fql_query(
            "SELECT uid FROM page_fan WHERE uid = " +
              this.fbid +
              " AND page_id = " +
              this.options.app_id,
            function (data) {
              if (
                $defined(data) &&
                $type(data) == "array" &&
                data.length > 0 &&
                data[0].uid
              )
                data = 1;
              else data = 0;
              this.options.liked = data;
              if ($defined(callback) && $type(callback) == "function")
                callback(data);
            }.bind(this)
          );
        }.bind(this)
      );
    }
  },

  setTabs: function () {
    proto = "http";
    if (window.location.href.indexOf("https:") > -1) {
      proto = "https";
    }

    if (
      this.options.integ != "fbg" ||
      !$("mmenu") ||
      $("mmenu").getElement(".right")
    )
      return false;
    if (!this.options.liked) {
      $("mmenu").innerHTML +=
        '<li><a id="menu-like" href="' +
        proto +
        "://www.facebook.com/apps/application.php?id=" +
        this.options.app_id +
        '" class="wimg" target="_top">Like <img src="' +
        this.options.cdnurl +
        'images/like.png" style="position: absolute; right: 4px; top: 1px;" /></a></li>';
    }
  },

  gameswf: null,
  setGameSwf: function (swf) {
    this.gameswf = swf;
  },
  getGameSwf: function () {
    return this.gameswf;
  },
  sendToSwf: function (callback, params) {
    Swiff.remote(this.getGameSwf(), callback, params);
  },

  checkFlashVersion: function (version) {
    if (
      !Browser.Plugins.Flash.version ||
      Browser.Plugins.Flash.version < version
    )
      return false;
    return true;
  },

  redirect: function (to) {
    window.top.location = to;
  },

  setCounter: function (to) {
    if (!to) return false;
    FB.Bootstrap.requireFeatures(["Api"], function () {
      FB.Facebook.apiClient.callMethod(
        "dashboard_setCount",
        [to, this.fbid],
        function (data) {}
      );
    });
  },

  fbCredits: null,
  getFbCredits: function () {
    if (this.fbCredits !== null) return this.fbCredits;
    return (this.fbCredits = new FBCredits());
  },

  buyFbCredits: function () {
    fbc = this.getFbCredits();
    return fbc.buyFbCredits();
  },

  fbcGetBalance: function () {
    //console.log('fbcGetBalance');
    fbc = this.getFbCredits();
    return fbc.getBalance(
      this.options.app_id,
      this.options.userdata.fbid,
      this.options.fb_access_token
    );
  },

  fbcBuyCredits: function (blockid, flash, viewid, clicked, giftids) {
    fbc = this.getFbCredits();
    return fbc.buyCredits(blockid, flash, viewid, clicked, giftids);
  },

  fbcBuyItem: function (itemid, flash) {
    fbc = this.getFbCredits();
    return fbc.buyItem(itemid, flash, this.options.fbdata, this.options.integ);
  },

  reqNewPerm: false,
  cogFeed: function (action, obj, custom) {
    new Request.JSON({
      url: this.options.localurl + "cog/send",
      onSuccess: function (data) {
        if (data.error) {
          var code =
            typeof data.error.code == "undefined" ? 0 : data.error.code;
          switch (code) {
            case 1:
              FB.login(
                function (response) {
                  if (response.perms && response.perms == "publish_actions") {
                    cc.cogFeed(action, obj, custom);
                  }
                },
                { perms: "publish_actions" }
              );
              break;
            default:
              break;
          }
        }
      },
    }).send(
      this.options.fbdata +
        "&action=" +
        action +
        "&object=" +
        obj +
        "&custom=" +
        (typeof custom != "string" ? JSON.encode(custom) : custom)
    );
  },
  fdMask: null,

  feedDialog: null,
  fdCallback: null,
  showingFD: false,
  showFeedDialog: function (type, callback) {
    if (!this.inited) return false;

    try {
      if (alliances) {
        alliances.hideAlliancesDialog();
      }
    } catch (err) {
      //ignore
    }

    if (!this.inited) return false;
    if (this.showingFD) return false;
    this.showingFD = true;

    // Only invites are different for hi5 & vx
    if (this.options.integ == "hi5" && type == "invite")
      return this.hi5_showFeedDialog(type, callback);
    if (this.options.integ == "vx" && type == "invite")
      return this.vx_showInvite(callback);
    if (this.options.integ == "kg")
      return this.kg_showFeedDialog(type, callback);

    if (callback) this.fdCallback = callback;

    // special feed dialog popup for vx
    if (this.options.integ == "vx") {
      if (!this.feedDialog) {
        this.fdMask = new Element("div", {
          class: "fd-mask",
          styles: { opacity: 0.4 },
        });
        this.feedDialog = new Element("div", {
          class: "feeddialog",
          styles: {
            position: "absolute",
            top: 10,
            left: ((this.options.game_width - 724) / 2).round(),
            width: 724,
            height: 467,
            overflow: "visible",
            background:
              "url('" +
              this.options.cdnurl +
              "images/feeddialog/outside3.png') no-repeat",
            padding: "10px 0 0 11px",
          },
        });
      }
      this.feedDialog.adopt(
        new Element("img", {
          src: this.options.cdnurl + "images/close2.png",
          styles: {
            width: 33,
            height: 33,
            cursor: "pointer",
            position: "absolute",
            top: 0,
            right: 18,
            "z-index": 9,
          },
        }).addEvent(
          "click",
          function () {
            this.hideFeedDialog();
          }.bind(this)
        ),
        new Element("div", {
          styles: {
            "background-color": "#DBB47C",
            position: "absolute",
            top: 25,
            left: 30,
            width: 665,
            height: 416,
            "z-index": 1,
          },
        }),
        new Element("iframe", {
          src:
            this.options.localurl +
            "canvas/feeddialog?type=" +
            type +
            "&" +
            this.options.fbdata,
          class: "fd-container",
          styles: {
            width: 665,
            "min-height": 650,
            border: 0,
            "background-color": "transparent",
            "z-index": 2,
            position: "absolute",
            top: 25,
            left: 30,
          },
          scrolling: "no",
          frameborder: 0,
        })
      );
      $("content").grab(this.feedDialog);
      $("content").grab(this.fdMask);
      return;
    }
    if (!this.feedDialog) {
      this.feedDialog = new Element("div", {
        class: "feeddialog",
        styles: {
          left: (
            ($("content").getSize().x -
              (this.options.game == "wc" ? 640 : 724)) /
            2
          ).round(),
        },
      });

      this.fdMask = new Element("div", {
        class: "fd-mask",
        styles: {
          opacity: 0.4,
        },
      });
    }

    this.feedDialog.grab(
      new Element("img", {
        src: this.options.assetsurl + "images/feeddialog/close-button.png",
        alt: "X",
        class: "fd-close",
      }).addEvent(
        "click",
        function () {
          this.hideFeedDialog();
        }.bind(this)
      )
    );

    var loadingBg =
      this.options.assetsurl +
      "images/feeddialog/feed-dialog-popup-loading-screen.jpg";
    var cssProps = {};
    if (this.options.game != "wc")
      cssProps = { "background-image": "url(" + loadingBg + ")" };

    this.feedDialog.adopt(
      new Element("div", {
        id: "feed-content-wrapper",
        class: "fd-wrapper",
      }),
      new Element("div", {
        id: "feed-content",
        class: "fd-content",
      })
    );

    $("content").grab(this.feedDialog);
    $("content").grab(this.fdMask);

    new Request.HTML({
      url:
        this.options.localurl +
        "canvas/requestdialog?type=" +
        type +
        "&" +
        this.options.fbdata,
      update: $("feed-content"),
    }).send();
  },

  hideFeedDialog: function (result, type, ku, recipients, splitid) {
    if (!this.showingFD) return false;
    if (typeof this.feedDialog.remove == "function") {
      // handle jQuery object
      this.feedDialog.html("").remove();
      this.fdMask.html("").remove();
    } else {
      this.feedDialog.dispose().empty();
      this.fdMask.dispose();
    }
    this.showingFD = false;
    if (this.fdCallback) {
      this.sendToSwf(this.fdCallback, JSON.encode({ success: result ? 1 : 0 }));
      this.fdCallback = null;
    }
    //if($defined(type) && $defined(ku) && $defined(recipients) && $defined(splitid)) this.recordFeed(type,ku,recipients,splitid);
  },

  switchFeedDialog: function (type, callback) {
    this.hideFeedDialog();
    this.showFeedDialog(type, callback);
  },

  hi5_showFeedDialog: function (type, callback) {
    if (type == "invite") {
      hi5.Api.inviteFriends();
      (function () {
        this.showingFD = false;
        if ($defined(callback))
          this.sendToSwf(callback, JSON.encode({ success: 1 }));
      }).delay(3000, this);
    }
  },

  vx_showInvite: function (callback) {
    this.viximo.Container.friends_invite({
      success: function () {
        this.showingFD = false;
        if ($defined(callback))
          this.sendToSwf(callback, JSON.encode({ success: 1 }));
      }.bind(this),
      close: function () {
        this.showingFD = false;
        if ($defined(callback))
          this.sendToSwf(callback, JSON.encode({ success: 0 }));
      }.bind(this),
      title: "Invite 12 Friends",
      content:
        "Play Backyard Monsters with me and I will help make your base as awesome as mine.",
      type: "awesome",
      acceptlabel: "Play",
    });
  },

  kg_showFeedDialog: function (type, callback) {
    if (callback) this.fdCallback = callback;
    if (!this.feedDialog)
      this.feedDialog = new Element("div", {
        class: "feeddialog",
        styles: {
          position: "absolute",
          top: 10,
          left: ((this.options.game_width - 724) / 2).round(),
          width: 724,
          height: 467,
          overflow: "visible",
          background:
            "url('" +
            this.options.cdnurl +
            "images/feeddialog/outside3.png') no-repeat",
          padding: "10px 0 0 11px",
        },
      });
    this.feedDialog.adopt(
      new Element("img", {
        src: this.options.cdnurl + "images/close2.png",
        styles: {
          width: 33,
          height: 33,
          cursor: "pointer",
          position: "absolute",
          top: 0,
          right: 18,
          "z-index": 9,
        },
      }).addEvent(
        "click",
        function () {
          this.hideFeedDialog();
        }.bind(this)
      ),
      new Element("div", {
        styles: {
          "background-color": "#DBB47C",
          position: "absolute",
          top: 25,
          left: 30,
          width: 665,
          height: 416,
          "z-index": 1,
        },
      }),
      new Element("iframe", {
        src:
          this.options.localurl +
          "canvas/feeddialog?type=" +
          type +
          "&" +
          this.options.fbdata,
        class: "fd-container",
        styles: {
          width: 665,
          "min-height": 420,
          border: 0,
          "background-color": "transparent",
          "z-index": 2,
          position: "absolute",
          top: 25,
          left: 30,
        },
        scrolling: "no",
        frameborder: 0,
      })
    );
    $("content").grab(this.feedDialog);
  },

  kg_statsUpdate: function (stats) {
    for (var stat in stats) {
      this.getKgApi().stats.submit(stat, stats[stat]);
    }
  },

  /**
   * @function cc.fbNewRequest
   * @param {message} arg1  The message to be included in the request
   * @param {filters} arg2  Can be one of four options: all, app_users,
   * app_non_users or a custom filter. An application can suggest custom
   * filters as dictionaries with a name key and a user_ids key, which
   * respectively have values that are a string and a list of user ids. name
   * is the name of the custom filter that will show in the selector. user_ids
   * is the list of friends to include, in the order they are to appear. (More
   * info here: http://fbdevwiki.com/wiki/FB.ui)
   * @param {callbacks} arg3 (Optional) Contains one or both object indexes
   * of: success or fail that contain functions for what to do when this
   * function returns
   * @param {trackData} arg4  Contains a tracking string
   **/
  fbNewRequest: function (message, filters, callbacks, trackData) {
    if (typeof filters != "string" && typeof filters != "object") return false; // Invalid filter type(s)
    if (!FB) return false; // FB JS SDK not initilized.

    FB.ui(
      {
        method: "apprequests",
        message: message,
        filters: filters,
        data: trackData,
      },
      function (response) {
        if (!callbacks) return;

        if (response && response.request_ids) {
          if (typeof callbacks.success == "function") {
            callbacks.success(response.request_ids);
          }
        } else if (response && response.request && response.to) {
          if (typeof callbacks.success == "function") {
            callbacks.success(response.request, response.to);
          }
        } else {
          if (typeof callbacks.fail == "function") {
            callbacks.fail(response);
          }
        }
      }
    );

    return true;
  },

  streamPublish: function (
    ident,
    name,
    caption,
    image,
    targetid,
    actiontext,
    flash,
    callback,
    ref
  ) {
    if (!ident || !name || !image) return false;

    var user = this.user;
    var ku = this.uniqueRef();

    var trkurl =
      this.options.baseurl +
      "track?fid=" +
      user.id +
      "&from=stream-" +
      ident +
      "&ku=" +
      ku +
      "&st1=" +
      ident;
    var action_links = [
      { href: trkurl, text: actiontext ? actiontext : "Play now!" },
    ];

    if (this.options.integ == "kg") {
      caption = caption
        .replace(/#fname#/g, this.options.jflashvars.fb_kongregate_username)
        .replace(/#lname#/g, "");

      if (caption == "" || caption == null) {
        caption = name
          .replace(/#fname#/g, this.options.jflashvars.fb_kongregate_username)
          .replace(/#lname#/g, "");
      }
    }

    name = name
      .replace(/#fname#/g, user.first_name)
      .replace(/#lname#/g, user.last_name);
    caption = caption
      .replace(/#fname#/g, user.first_name)
      .replace(/#lname#/g, user.last_name);

    if (this.options.integ == "vx")
      return this.vx_streamPublish(
        ident,
        name,
        caption,
        image,
        targetid,
        actiontext,
        flash
      );

    var media = null;
    if (flash)
      media = [
        {
          type: "flash",
          imgsrc: this.options.cdnurl + "images/feed/" + image,
          swfsrc: this.options.cdnurl + "flash/feed/" + flash,
          width: 87,
          height: 87,
          expanded_width: 450,
          expanded_height: 200,
        },
      ];
    else
      media = [
        {
          type: "image",
          src: this.options.assetsurl + "images/feeddialog/" + image,
          href: trkurl,
        },
      ];

    var attachment = {
      name: name,
      href: trkurl,
      caption: caption,
      media: media,
    };

    if (this.options.integ == "fbg") {
      var feed_args = {
        method: "feed",
        name: name,
        link: trkurl,
        picture: media[0].src,
        caption: caption,
        message: "",
        to: targetid,
      };

      FB.ui(
        feed_args,
        function (response) {
          if (response && response.post_id) {
            new Request({
              url: this.options.localurl + "backend/recordsendfeed",
            }).send(
              "ident=" + ident + "&name=" + name + "&" + this.options.fbdata
            );
            this.recordKontagent("pst", { tu: "stream", u: ku, st1: ident });
            if (callback) callback(true);
          } else if (callback) callback(false);
        }.bind(this)
      );
    } else if (this.options.integ == "fb") {
      FB.Connect.streamPublish(
        "",
        attachment,
        action_links,
        targetid ? targetid : null,
        "Write something...",
        function (postid, exception, data) {
          if (postid != null && postid != "null") {
            new Request({
              url: this.options.localurl + "backend/recordsendfeed",
            }).send(
              "ident=" + ident + "&name=" + name + "&" + this.options.fbdata
            );
            this.recordKontagent("pst", { tu: "stream", u: ku, st1: ident });
            if (callback) callback(true);
          } else if (callback) callback(false);
        }.bind(this)
      );
    } else if (this.options.integ == "hi5") {
      delete attachment.name;
      name +=
        ' <a href="' +
        trkurl.replace("http://www.hi5.com", "") +
        '">Play Now!</a>';
      hi5.Api.streamPublish(
        name,
        attachment,
        action_links,
        targetid ? targetid : null
      );
    } else if (this.options.integ == "kg") {
      this.getKgApi().services.showShoutBox(caption);
    }
  },

  vx_streamPublish: function (
    ident,
    name,
    caption,
    image,
    targetid,
    actiontext,
    flash
  ) {
    this.viximo.Container.streamPublish({
      type: "activity",
      message: name,
      attachment: {
        caption: "",
        description: caption,
        media: {
          type: "image",
          src: this.options.assetsurl + "images/feeddialog/" + image,
        },
      },
      action_links: [
        {
          text: "Play Now!",
        },
      ],
      complete: function () {},
    });
  },

  vx_sendGiftMessage: function (name, caption, image, targets, hidefd) {
    this.viximo.Container.streamPublish({
      target: targets,
      type: "message",
      message: name,
      attachment: {
        caption: "",
        description: caption,
        media: {
          type: "image",
          src: this.options.cdnurl + "images/feed/" + image,
        },
      },
      action_links: [
        {
          text: "Play Now!",
        },
      ],
      complete: function () {},
    });
    if (hidefd) this.hideFeedDialog(true);
  },

  showTopup: function (params) {
    try {
      alliances.hideAlliancesDialog();
    } catch (err) {
      //ignore
    }

    if (!params) params = {};

    if (this.options.integ == "hi5") return this.hi5_showTopup();
    else if (this.options.integ == "vx") return this.vx_showTopup();
    else if (this.options.integ == "kg") return this.kg_showTopup();
    else if (this.options.integ == "fbg") return this.fb_showTopup(params);
    else this.navTo("topup");
  },
  hideTopup: function () {
    if (this.options.integ == "hi5") return this.hi5_hideTopup();
    else if (this.options.integ == "fbg") return this.fb_hideTopup({});
  },

  getTopupCallback: function () {
    if ($defined(this[this.options.integ + "TopupCallback"]))
      return this[this.options.integ + "TopupCallback"];
  },

  fbTopupContainer: null,
  fbTopupShowing: false,
  fbTopupCallback: null,
  fb_showTopup: function (params) {
    if (this.fbTopupShowing) return false;
    this.fbTopupShowing = true;

    if (params.callback) this.fbTopupCallback = params.callback;

    if (params.type == "offers") this.fb_showTopupOffers(params);
    else if (params.type == "daily") this.fb_showTopupDaily(params);
    else this.fb_showTopupFbc(params);
  },

  fb_showTopupFbc: function (params) {
    var pu;
    if (params.special == "gift") {
      pu = {
        height: 368,
        width: 488,
        background:
          "url('" +
          this.options.cdnurl +
          "images/topup/promotion/giftbg.png') no-repeat",
      };
    } else {
      pu = {
        height: 331,
        width: 484,
        background:
          "url('" +
          this.options.cdnurl +
          "images/topup/popupbg5.png') no-repeat",
      };
    }

    (function ($) {
      if (!this.fbTopupContainer) {
        this.fbTopupContainer = $("<div />");
        this.fbTopupContainer.css({
          position: "absolute",
          top: "0px",
          left: "0px",
          width: this.options.game_width,
          height: this.options.game_height,
          overflow: "visible",
          "z-index": "1337",
        });
      }

      this.fbTopupContainer.append("<div />");

      var innerContainer = this.fbTopupContainer.children("div:last");

      innerContainer.addClass("topup-popup").css({
        position: "relative",
        "margin-top": "10px",
        "margin-left": "auto",
        "margin-right": "auto",
        width: pu.width,
        height: pu.height,
        overflow: "visible",
        background: pu.background,
        padding: "10px 0 0 11px",
      });

      innerContainer.append("<a />");
      innerContainer
        .children("a:last")
        .attr({
          href: "javascript:void(0);",
        })
        .css({
          width: 25,
          height: 25,
          cursor: "pointer",
          display: "block",
          position: "absolute",
          top: 0,
          right: 18,
          border: 0,
          "z-index": 11,
        })
        .click(
          function () {
            this.hideTopup();
          }.bind(this)
        );

      innerContainer.append("<div />");
      innerContainer
        .children("div:last")
        .attr({ id: "topup-popup-content" })
        .css({
          height: 195,
          left: 33,
          position: "absolute",
          top: 60,
          width: 420,
          "z-index": 10,
        });

      var script =
        "canvas/topuppopup" +
        (params.special ? "?special=" + params.special + "&" : "?");

      $.get(
        this.options.localurl + script + this.options.fbdata,
        function (data) {
          $("#topup-popup-content").html(data);
        }.bind(this)
      );

      /*
			$.get(this.options.localurl+'canvas/topuppopup?&'+this.options.fbdata, function(data)
			{
				$('#topup-popup-content').html(data);
			}.bind(this));
			*/

      $("#content").append(this.fbTopupContainer);
    }).bind(this)(jQuery);
  },

  fb_showTopupOffers: function (params) {
    TRIALPAY.fb.show_overlay(this.options.app_id, "fbpayments", {
      sid: this.options.tpid,
      onClose: this.hideTopup.bind(this, { showTopup: true, params: params }),
    });
  },

  fb_showTopupDaily: function (params) {
    TRIALPAY.fb.show_overlay(this.options.app_id, "fbpayments", {
      dealspot: 1,
      sid: this.options.tpid,
      onClose: this.hideTopup.bind(this, { showTopup: true, params: params }),
    });
  },

  fb_hideTopup: function (params) {
    if (this.fbTopupContainer) {
      if (typeof this.fbTopupContainer.remove == "function") {
        // handle jQuery object
        this.fbTopupContainer.html("").remove();
      } else {
        this.fbTopupContainer.dispose().empty();
      }
    }

    this.fbTopupShowing = false;

    if (params.showTopup) {
      params.params.type = "fbc";
      this.fb_showTopup(params);
    } else if (this.fbTopupCallback)
      this.sendToSwf(this.fbTopupCallback, JSON.encode({ status: "canceled" }));
  },

  vx_showTopup: function () {
    this.viximo.Container.currency_makeTransfer({
      success: function (data) {
        //this.sendToSwf('callbackshiny',JSON.encode({credits:data.amount}));
        location.reload();
      }.bind(this),
      close: function () {},
    });
  },

  topupPopup: null,
  hi5_showTopup: function () {
    $("topuppopup").setStyle("display", "block");
  },
  hi5_hideTopup: function () {
    $("topuppopup").setStyle("display", "none");
    $("topuppopup").getElements("input").set("disabled", false);
    $("topuppopup").getElement(".funds").setStyle("display", "none");
    $("topuppopup")
      .getElement(".buynow")
      .setStyle("display", "block")
      .removeClass("on");
  },

  kg_showTopup: function (cartArray) {
    if (!cartArray) {
      this.giveKgTopupPopup();
      return;
    }
    this.getKgApi().mtx.purchaseItems(
      cartArray,
      cc.kg_onPurchaseResult.bind(this)
    );
  },

  kg_onPurchaseResult: function (result) {
    if (result.success) {
      new Request.JSON({
        url: this.options.localurl + "backend/redeemKgItems",
        onSuccess: function (data) {
          this.kgHideShinyDialog();

          if ($type(data) != "object") {
          } else if (data.error) {
          } else if (data.credits) {
            var updateCredits = function () {
              cc.sendToSwf("updateCredits", JSON.encode(data));
            };
            setTimeout(updateCredits, 7500);
          }
        }.bind(this),
      }).send(this.options.fbdata);
    }
  },

  startTopup: function (el) {
    if (this.options.integ == "hi5") this.hi5_startTopup(el);
  },
  hi5_startTopup: function (el) {
    var inp = $("topuppopup").getElement("input:checked");
    if (!inp) return false;
    $(el).addClass("on");
    $("topuppopup").getElements("input").set("disabled", true);
    var val = inp.get("value");
    new Request.JSON({
      url: this.options.localurl + "backend/buyshiny",
      onSuccess: function (data) {
        if ($type(data) != "object") {
          this.hi5_hideTopup();
        } else if (data.error) {
          if (data.error == "funds") {
            $(el).setStyle("display", "none");
            $("topuppopup").getElement(".funds").setStyle("display", "block");
          }
        } else if (data.credits) {
          this.hi5_hideTopup();
          this.sendToSwf("updateCredits", JSON.encode(data));
        }
      }.bind(this),
    }).send(this.options.fbdata + "&creditvalue=" + val);
  },

  topupFunds: function () {
    this.hideTopup();
    this.showTopup();
    this.showBuyCoins();
  },

  showBuyCoins: function () {
    if (this.options.integ == "hi5") return this.hi5_showBuyCoins();
  },
  hi5_showBuyCoins: function () {
    hi5.Api.buyCoins();
  },

  hi5api: null,
  hi5_getApi: function () {
    if (this.hi5api !== null) return this.hi5api;
    return (this.hi5api = new Hi5_Rest_Api({
      api_key: this.options.api_key,
      session_key: this.options.session_key,
      sigs: this.options.hi5sigs,
    }));
  },
  hi5_getFriends: function (callback) {
    var api = this.hi5_getApi();
    api.sendRequest(
      "friends.get",
      null,
      function (data) {
        if ($type(data) != "array" || data.length < 1) data = [];
        this.options.friends = data;
        if ($type(callback) == "function") callback(data);
      }.bind(this)
    );
  },
  vx_getFriends: function (callback) {
    this.viximo.API.friends_get(
      function (data) {
        var out = [];
        if ($type(data) == "array" || data.length > 0) {
          data.each(function (v) {
            out.push(v);
          });
        }
        this.options.friends = out;
        callback(out);
      }.bind(this)
    );
  },
  hi5_getAppFriends: function (callback) {
    var api = this.hi5_getApi();
    api.sendRequest(
      "friends.getAppUsers",
      null,
      function (data) {
        if ($type(data) != "array" || data.length < 1) data = [];
        this.options.appfriends = data;
        if ($type(callback) == "function") callback(data);
      }.bind(this)
    );
  },
  hi5_getUserData: function (callback) {
    var api = this.hi5_getApi();
    api.sendRequest(
      "users.getInfo",
      { uids: this.fbid, fields: "uid,first_name,last_name,pic_square,sex" },
      function (data) {
        if ($type(data) != "array" || data.length < 1) data = {};
        else data = data[0];
        this.options.userdata = data;
        this.addToUser(data);
        if ($type(callback) == "function") callback(data);
      }.bind(this)
    );
  },
  vx_getUserData: function (callback) {
    this.viximo.API.users_getCurrentUser(
      function (data) {
        if ($type(data) != "object") data = {};
        else data.first_name = data.name.split(" ")[0];
        this.options.userdata = data;
        this.addToUser(data);
        if ($type(callback) == "function") callback(data);
      }.bind(this)
    );
  },
  //http://www.kongregate.com/api/user_info.json?username=Casualcollective&friends=true
  kg_getUserName: function (callback) {
    this.getKgApi().services.getUsername();
  },
  kg_getUserData: function (callback) {
    new Request.JSONP({
      url:
        "http://www.kongregate.com/api/user_info.jsonp?user_id=" +
        this.fbid +
        "&friends=true",
      onSuccess: function (data) {}.bind(this),
    }).send();
  },

  sendNotification: function (ids, note, type, callback, sig, call_id) {
    if (this.options.integ == "hi5")
      return this.hi5_sendNotification(ids, note, type, callback, sig, call_id);
  },
  hi5_sendNotification: function (ids, note, type, callback, sig, call_id) {
    var api = this.hi5_getApi();
    api.sendRequest(
      "notifications.send",
      { to_ids: ids, notification: note, type: type },
      function (data) {
        if ($type(callback) == "function") callback();
      }.bind(this),
      sig,
      call_id
    );
  },

  navTo: function (page, absolute) {
    if (!page && this.options.integ == "vx") location.reload();
    else window.top.location = (absolute ? "" : this.options.baseurl) + page;
  },

  reloadParent: function () {
    var dest = this.options.baseurl;
    var loc = location.href
      .replace(/\/$/, "")
      .replace("http://", "")
      .replace("https://", "");
    if (loc.indexOf("/") > -1) {
      loc = location.href.split("/");
      loc = loc[loc.length - 1];
      dest += loc;
    }
    window.top.location = dest;
  },

  showRating: function () {
    this.navTo(
      "https://www.facebook.com/apps/application.php?id=" +
        this.options.app_id +
        "&v=app_6261817190",
      true
    );
  },

  showSrOverlay: function (callback) {
    adk.interstitial.prototype.displayModal(
      "content",
      "oydikdq.72572890927",
      this.fbid,
      true,
      null,
      function () {
        if (callback) {
          this.sendToSwf(callback);
        }
      }.bind(this)
    );
  },

  showEvent: function (id) {
    this.navTo(
      "https://www.facebook.com/event.php?eid=" + (id ? id : 142016142510717),
      true
    );
  },

  uniqueRef: function () {
    return (this.fbid + new Date().getTime()).toString().toMD5().substr(0, 16);
  },

  // kixeye internal logging.
  // no t param as we record server time and not client time
  // called from flash client during install
  recordKxLogger: function (props) {
    var params = "";
    if ($type(props) == "object") {
      var rprops = new Hash(props);
      rprops.extend({
        s: this.fbid,
      });
      params = rprops.toQueryString();
    }

    this.callUrl(
      this.options.kx_logger_url +
        "?key=" +
        this.options.kx_logger_key +
        "&" +
        params
    );
  },

  recordKontagent: function (type, props) {
    var params = "";
    if ($type(props) == "object") {
      var rprops = new Hash(props);
      rprops.extend({
        s: this.fbid,
        t: parseInt(new Date().getTime() / 1000),
      });
      params = rprops.toQueryString();
    }
    this.callUrl(
      this.options.kontagent_url +
        "api/v" +
        this.options.kontagent_api_version +
        "/" +
        this.options.kontagent_api_key +
        "/" +
        type +
        "/" +
        (params ? "?" + params : "")
    );
  },

  recordEvent: function (name, props) {
    if ($type(props) == "object") {
      var rprops = {
        n: name,
      };
      if (props.level) rprops.l = props.level;
      if (props.value) rprops.v = props.value;
      if (props.n1) rprops.n1 = props.n1;
      if (props.n2) rprops.n2 = props.n2;
      if (props.n3) rprops.n3 = props.n3;
      if (props.n4) rprops.n4 = props.n4;
      if (props.n5) rprops.n5 = props.n5;
      if (props.st1) rprops.st1 = props.st1;
      if (props.st2) rprops.st2 = props.st2;
      if (props.st3) rprops.st3 = props.st3;
      if (props.json) rprops.json = props.json;
    }
    this.recordKontagent("evt", rprops);
  },

  recordFeed: function (type, ku, recipients, splitid) {
    var r = "";
    recipients.each(function (v) {
      r += "," + v;
    });
    r = r.substr(1);
    var props = { r: r, u: ku };
    if (type == "gift") props.st1 = "gift";
    if (type == "invite") props.st1 = splitid;
    this.recordKontagent(type == "invite" ? "ins" : "nts", props);
  },

  callUrl: function (src) {
    return this.callUrlImg(src); // Use image injection
    //try
    //{
    //	new Request.JSONP({
    //		'url': src,
    //		callbackKey: 'jsoncallback'
    //	}).send();
    //} catch(e){}
  },

  callUrlImg: function (src) {
    var img = new Image();
    img.src = src;
    (function () {
      try {
        img.destroy();
      } catch (e) {}
    }).delay(60000);
  },

  recordUserInfo: function () {
    var userdata = this.getUserData();
    var friends = this.getAppFriends();
    var props = {};

    if ($type(friends) == "array") props.f = friends.length;
    if ($type(userdata) == "object") {
      var sex = userdata.sex.toLowerCase();
      if (sex == "female" || sex == "f") props.g = "female";
      else props.g = "male";

      var bday = userdata.birthday_date;
      if (
        bday &&
        bday != "null" &&
        bday.length - bday.replace("/", "").length == 2
      ) {
        var year = bday.substr(-4, 4);
        props.b = year;
      }
    }

    this.recordKontagent("cpu", props);
  },

  openingBase: false,
  openBase: function (baseid) {
    if (this.options.game == "bm" || this.options.game == "wc") {
      if (this.openingBase) return false;
      this.openingBase = true;

      new Request.JSON({
        url: this.options.localurl + "backend/locatebase",
        onSuccess: function (data) {
          if (data.baseid || data.userid || data.userid == 0) {
            this.sendToSwf("openbase", JSON.encode(data));
          }
        }.bind(this),
        onComplete: function () {
          (function () {
            this.openingBase = false;
          })
            .bind(this)
            .delay(2000);
        }.bind(this),
      }).send("userid=" + baseid + "&" + this.options.fbdata);
    } else this.sendToSwf("openbase", baseid);
  },
  openLeaderBase: function (userid, baseid) {
    if (this.options.game == "bm" || this.options.game == "wc") {
      new Request.JSON({
        url: this.options.localurl + "backend/locatebase",
        onSuccess: function (data) {
          if (data.baseid || data.userid || data.userid == 0) {
            data.viewleader = 1;
            this.sendToSwf("openbase", JSON.encode(data));
          }
        }.bind(this),
      }).send("userid=" + userid + "&" + this.options.fbdata);
    } else {
      this.sendToSwf("openbase", baseid);
    }
  },

  adminTakeover: function (x, y) {
    $("adminTakeoverX").set("disabled", true);
    $("adminTakeoverY").set("disabled", true);
    $("adminTakeoverSubmit").set("disabled", true).set("text", "Taking...");
    new Request.JSON({
      url: this.options.localurl + "worldmapv2/pilferoutpost",
      onSuccess: function (data) {
        $("adminTakeoverX").set("disabled", false).set("value", "");
        $("adminTakeoverY").set("disabled", false).set("value", "");
        $("adminTakeoverSubmit").set("disabled", false).set("text", "Take");
      }.bind(this),
    }).send("x=" + x + "&y=" + y + "&" + this.options.fbdata);
  },

  getCreditBalance: function (callback, returnHashedData) {
    if (!callback) return false;
    new Request.JSON({
      url: this.options.localurl + "backend/getcreditbalance",
      onSuccess: function (data) {
        if (returnHashedData) callback(data);
        else {
          var credits = false;
          if (data.credits) credits = data.credits;
          callback(credits);
        }
      }.bind(this),
    }).send(this.options.fbdata);
  },

  pad: function (num, count) {
    var lenDiff = count - String(num).length;
    var padding = "";

    if (lenDiff > 0) while (lenDiff--) padding += "0";

    return padding + num;
  },

  postBuyPixels: function (amount) {
    var date = new Date(cc.options.installts * 1000);
    var year = date.getFullYear();
    var month = cc.pad(date.getMonth() + 1, 2);
    var day = cc.pad(date.getDate(), 2);

    var apsource = cc.options.fromstr.substr(0, 6);
    if (apsource == "fbbpap") {
      cc.callUrl(
        "https://fbads.adparlor.com/Engagement/action.php?id=311&adid=545&vars=7djDxM/P1uDV4OfKs7SxjdbV1ObN4ebE3NXXz9jPwtjg1OTE58XK0Nni1Ky6vp7X3tnWwtbkwNrb5OTYs5aO1tfVtOfOqcuqzA==&subid=" +
          amount.amount +
          "&action_date=" +
          year +
          "-" +
          month +
          "-" +
          day
      );
      cc.callUrl(
        "https://fbads.adparlor.com/Engagement/action.php?id=312&adid=712&vars=7djDxM/P1uDV4OfKs7SxjdbV1ObN4ebE3NXXz9jPwtjg1OTE58XK0Nni1Ky6vp7X3tnWwtbkwNrb5OTYs5aO1tfVtOfOqcuqzA==&subid=" +
          amount.amount +
          "&action_date=" +
          year +
          "-" +
          month +
          "-" +
          day
      );
    }
    if (apsource == "fbbpbo") {
      cc.callUrl("https://track.brighteroption.com/b?p=sx2u49&l=1");
    }
    if (apsource == "fbbpbo") {
      cc.callUrl("https://track.brighteroption.com/b?p=sx2tu7&l=1");
    }
    if (apsource == "fbwcbo") {
      cc.callUrl("https://track.brighteroption.com/b?p=sx2t1y&l=1");
    }
    if (apsource == "fbbpsp") {
      if (cc.options.adid != -1)
        cc.callUrl(
          "http://bp-pixel.socialcash.com/100560/pixel.ssps?spruce_adid=" +
            cc.options.adid +
            "&spruce_sid=" +
            cc.fbid +
            "&amt=" +
            amount.amount +
            "&spruce_pixelid=2"
        );
    }
  },

  postTutorialPixels: function () {
    var apsource = cc.options.fromstr.substr(0, 6);
    if (apsource == "fbbpsp") {
      if (cc.options.adid != -1)
        cc.callUrl(
          "http://bp-pixel.socialcash.com/100560/pixel.ssps?spruce_adid=" +
            cc.options.adid +
            "&spruce_sid=" +
            cc.fbid +
            "&spruce_pixelid=1"
        );
    }
  },

  checkTopupGift: function () {
    new Request({
      url: this.options.localurl + "backend/checktopupgift",
      onSuccess: function (data) {
        var obj = JSON.decode(data);
        if (obj.error == 0) this.sendToSwf("purchaseReceive", data);
        else this.checkTopupGift.delay(30000, this);
      }.bind(this),
    }).send(this.options.fbdata);
  },

  startPromoTimer: function (params) {
    new Request.JSON({
      url: this.options.localurl + "backend/startpromotimer",
      onSuccess: function (data) {
        if (data.endtime) this.sendToSwf(params.callback, JSON.encode(data));
      }.bind(this),
    }).send(this.options.fbdata);
  },

  recordStats: function (event) {
    this.logLoadEvent(event);
    //try{
    //	var flashver = FlashDetect.major + '.' + FlashDetect.minor;
    //	new Request({
    //		url: this.options.localurl+'backend/recordstats'
    //	}).send(this.options.fbdata+'&event='+event+'&loadid='+loadid+'&flashver='+flashver);
    //} catch(e){}
  },

  log: function (data) {
    try {
      if (window.console) console.log(data);
    } catch (e) {}
  },

  alDialog: false,
  alView: null,
  showAttackLog: function (view) {
    if (!this.inited) return false;
    if (!view) view = "both";

    if (!this.alDialog) {
      this.alDialog = new ccfDialog({
        url: this.options.localurl + "canvas/attacklogdialog",
        props: {
          contentWrapper: {
            styles: {
              "background-image":
                "url('" + this.options.cdnurl + "images/attacklog/dialog.png')",
            },
          },
        },
        cachecontent: true,
        cachetimeout: 20,
        stylesuffix: "al",
        onHide: function () {
          if (this.arDialog) this.arDialog.hide();
        }.bind(this),
      });
    }

    if (this.alDialog.showing) {
      if (this.alView == view) return false;
      this.alDialog.loadUrl(this.options.localurl + "canvas/attacklogdialog", {
        view: view,
      });
    } else this.alDialog.show();

    this.alView = view;
  },

  arDialog: false,
  arShowingID: false,
  showAttackReport2: function (attackid) {
    if (!attackid) return false;

    if (!this.arDialog) {
      this.arDialog = new ccfDialog({
        url: this.options.localurl + "backend/getattackreport",
        props: {
          contentWrapper: {
            styles: {
              "background-image":
                "url('" +
                this.options.cdnurl +
                "images/attacklog/report3.png')",
            },
          },
        },
        cachecontent: true,
        cachetimeout: 10,
        stylesuffix: "ar",
        postdata: { attackid: attackid },
      });
      this.arDialog.show();
    } else if (this.arDialog.showing) {
      this.arDialog.loadUrl(
        this.options.localurl + "backend/getattackreport",
        null,
        { attackid: attackid }
      );
    } else {
      this.arDialog.reInit({
        url: this.options.localurl + "backend/getattackreport",
        postdata: { attackid: attackid },
      });
      this.arDialog.show();
    }
  },

  showingAR: false,
  attackReports: {},
  showAttackReport: function (attackid, version) {
    if (this.showingAR) return false;
    this.showingAR = true;
    //if(this.attackReports[attackid]) return this.doShowAttackReport(this.attackReports[attackid]);
    new Request({
      url: this.options.localurl + "backend/getattackreport",
      onSuccess: function (data) {
        this.attackReports[attackid] = data;
        this.doShowAttackReport(data);
      }.bind(this),
      onFailure: function () {
        this.showingAR = false;
      }.bind(this),
    }).send("attackid=" + attackid + "&" + this.options.fbdata);
  },
  doShowAttackReport: function (html) {
    new MooDialog({
      title: "Attack Report",
      onClose: function () {
        this.showingAR = false;
      }.bind(this),
      size: { height: "auto", width: 350 },
      offset: { x: 0, y: -($("body").getScrollSize().y / 2 - 100) },
      scroll: false,
      useScrollBar: false,
      overlay: { color: "#fff" },
    })
      .setContent(new Element("div", { html: html }))
      .open();
  },

  lbDialog: false,
  lbShowingID: false,
  showLeaderboard: function () {
    if (!this.inited) return false;
    if (!this.lbDialog) {
      this.lbDialog = new ccfDialog({
        url: this.options.localurl + "backend/getleaderboard",
        props: {
          contentWrapper: {
            styles: {
              "background-image":
                "url('" +
                this.options.cdnurl +
                "images/leaderboard/background.png')",
            },
          },
        },
        cachecontent: true,
        cachetimeout: 20,
        stylesuffix: "lb",
      });
      this.lbDialog.show();
    } else if (this.lbDialog.showing) {
      this.lbDialog.loadUrl(this.options.localurl + "backend/getleaderboard");
    } else {
      this.lbDialog.reInit({
        url: this.options.localurl + "backend/getleaderboard",
      });
      this.lbDialog.show();
    }
  },

  reloadingCSS: false,
  reloadCSS: function () {
    if (this.reloadingCSS) return false;
    this.reloadingCSS = true;

    var url = $("style-default")
      .get("href")
      .replace(/v[0-9]+\./, "v" + Math.round(Math.random() * 100000) + ".");
    $$("head")[0].grab(
      (newel = new Element("link", {
        rel: "stylesheet",
        type: "text/css",
        href: url,
      }))
    );

    (function () {
      $("style-default").destroy();
      newel.set("id", "style-default");
      this.reloadingCSS = false;
    })
      .bind(this)
      .delay(5000);
  },
});

function dump(arr, level) {
  var dumped_text = "";
  if (!level) level = 0;

  //The padding given at the beginning of the line.
  var level_padding = "";
  for (var j = 0; j < level + 1; j++) level_padding += "    ";

  if (typeof arr == "object") {
    //Array/Hashes/Objects
    for (var item in arr) {
      var value = arr[item];

      if (typeof value == "object") {
        //If it is an array,
        dumped_text += level_padding + "'" + item + "' ...\n";
        dumped_text += dump(value, level + 1);
      } else {
        dumped_text += level_padding + "'" + item + "' => \"" + value + '"\n';
      }
    }
  } else {
    //Stings/Chars/Numbers etc.
    dumped_text = "===>" + arr + "<===(" + typeof arr + ")";
  }
  return dumped_text;
}

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

var FBCredits = new Class({
  getCreditsApi: function (callback) {
    FB.Bootstrap.requireFeatures(["Payments"], function () {
      callback(new FB.Payments());
    });
  },

  getBalance: function (app_id, to, token) {
    //console.log('FBCredits.getBalance');
    var myRequest = new Request.JSON({
      url: localurl + "backend/fbcredits/balance",
      method: "post",
      onSuccess: function (data) {
        if (typeof data.balance != "undefined") {
          //alert("You FBC Balance: "+data.balance);
          cc.sendToSwf("updateFBC", JSON.encode(data));
        }
      },
    }).send(fbdata);
  },

  openGetCreditsDialog: function (order_info, flash) {
    FB.ui(
      {
        method: "pay",
        order_info: order_info,
        purchase_type: "item",
      },
      function (data) {
        if (data["order_id"]) {
          if (flash)
            var returnData = { success: 1, order_id: data["order_id"] };

          var apsource = cc.options.fromstr.substr(0, 6);
          if (apsource == "fbbpap") {
            new Request.JSONP({
              url: "https://fbads.adparlor.com/Engagement/action.php?id=178&adid=545&vars=7djDxM/P1uDV4OfKs7SxjdbV1ObN4ebE3NXXz9jPwtjg1OTE58XK0Nni1Ky6vp7X3tnWwtbkwNrb5OTYs5aO1tfVtOfOqcC0",
            }).send();
          }
        } else {
          var returnData = { success: 0 };
          //handle errors here
          if (
            typeof data["error_message"] != "undefined" &&
            data["error_message"] == "User canceled the order."
          ) {
            flash = "purchaseCancelled";
            returnData.canceled = 1;
          }
        }
        cc.fbcGetBalance();
        if (flash && cc.getGameSwf() !== null)
          cc.sendToSwf(flash, JSON.encode(returnData));
      }
    );
  },

  buyFbCredits: function () {
    FB.ui(
      {
        method: "pay",
        credits_purchase: true,
      },
      function (data) {
        this.getBalance();
        if (cc.getGameSwf() !== null)
          cc.sendToSwf("fbcBuyCreditsCallback", JSON.encode(""));
      }.bind(this)
    );
  },

  buyCredits: function (blockid, flash, viewid, clicked, giftids, special) {
    if (cc.options.integ == "fbg") {
      FB.ui(
        {
          method: "pay.prompt",
          order_info: {
            blockid: blockid,
            viewid: viewid ? viewid : 0,
            clicked: clicked ? clicked : 0,
            giftids: giftids ? giftids : "",
            special: special ? special : "",
          },
          purchase_type: "item",
        },
        function (data) {
          this.buyCreditsComplete(blockid, data, flash, null, special);
        }.bind(this)
      );
    } else
      this.getCreditsApi(
        function (api) {
          this.buyCreditsCallback(
            blockid,
            api,
            flash,
            viewid,
            clicked,
            giftids,
            special
          );
        }.bind(this)
      );
  },

  getBalance: function (app_id, to, token) {
    var myRequest = new Request.JSON({
      url: localurl + "backend/fbcredits/balance",
      method: "post",
      onSuccess: function (data) {
        if (typeof data.balance != "undefined") {
          cc.sendToSwf("updateFBC", JSON.encode(data));
        }
      },
    }).send(fbdata);
  },
  buyCreditsCallback: function (
    blockid,
    api,
    flash,
    viewid,
    clicked,
    giftids,
    special
  ) {
    api.setParam("order_info", {
      blockid: blockid,
      viewid: viewid ? viewid : 0,
      clicked: clicked ? clicked : 0,
      giftids: giftids ? giftids : "",
      special: special ? special : "",
    });
    api.setParam(
      "next_js",
      function (data) {
        this.buyCreditsComplete(
          blockid,
          data,
          flash,
          giftids ? true : false,
          special
        );
      }.bind(this)
    );
    api.submitOrder();
  },

  buyCreditsComplete: function (blockid, data, flash, checkgift, special) {
    if (!flash) flash = cc.getTopupCallback();

    if (data && data.order_id && data.status == "settled") {
      var returnData = { status: "settled" };
      if (!cc.getGameSwf())
        return cc.redirect(
          cc.options.baseurl +
            "?r=fbcts&oid=" +
            data.order_id +
            (checkgift ? "&cg=1" : "")
        );
    } else if (data && data.error_message) {
      if (flash)
        var returnData = {
          status: "failed",
          error_message: data.error_message,
        };
      //else return cc.redirect(cc.options.baseurl+'?r=fbctf&msg='+data.error_message);
    } else var returnData = { status: "canceled" };
    if (cc.getGameSwf()) {
      cc.getCreditBalance(function (data) {
        if (flash) cc.sendToSwf(flash, JSON.encode(returnData));
        cc.sendToSwf("updateCredits", JSON.encode(data));
        cc.hideTopup();
      }, true);

      if (special == "gift" && data && data.status == "settled") {
        cc.checkTopupGift();
      }
    }
  },

  // itemid - item json data from client for fbg
  buyItem: function (itemid, flash, srdata, integ) {
    if (!itemid) return false;
    if (integ != "fbg") {
      this.getCreditsApi(
        function (api) {
          this.buyItemCallback(itemid, api, flash);
        }.bind(this)
      );
    } else {
      var itemObj = JSON.decode(itemid);
      if (cc.getGameSwf() === null) {
        cc.setGameSwf($("gameswf"));
        //if(cc.getGameSwf() !== null) cc.sendToSwf(itemObj.callback,JSON.encode({'success':0,'jserror':1}));
        //return false;
      }

      var order_info = {
        callback: itemObj.callback,
        cost: itemObj.cost,
        title: itemObj.title,
        description: itemObj.description,
        h: itemObj.h,
        hn: itemObj.hn,
      };

      // New method of passing data
      if (itemObj.referrer) order_info.referrer = itemObj.referrer;
      if (itemObj.itemInfo) order_info.iteminfo = itemObj.itemInfo;
      if (itemObj.storeCode) order_info.item = itemObj.storeCode;

      // Grandfathered method of passing itemids so other games wont break
      if (itemObj.itemid) order_info.item = itemObj.itemid;

      if (itemObj.stats) order_info.stats = itemObj.stats;

      // Open Facebook Payment Dialog
      this.openGetCreditsDialog(order_info, itemObj.callback);
    }
    return true;
  },

  buyItemCallback: function (itemid, api, flash) {
    api.setParam("order_info", { itemid: itemid });
    api.setParam(
      "next_js",
      function (data) {
        this.buyItemComplete(itemid, data, flash);
      }.bind(this)
    );
    api.submitOrder();
  },

  buyItemComplete: function (itemid, data, flash) {
    if (data.order_id && data.status == "settled") {
      if (flash) var returnData = { success: 1 };
      else
        return cc.redirect(
          cc.options.baseurl + "?r=fbcts&oid=" + data.order_id
        );
    } else if (data.error_message) {
      if (flash)
        var returnData = { success: 0, error_message: data.error_message };
    } else if (data.order_id && !isNumber(data.order_id)) {
      if (data.order_id == "error") {
        var myRequest = new Request.JSON({
          url: localurl + "backend/fbtxnlogging/getnewid",
          method: "post",
          timeout: 10000,
          onSuccess: function (data) {
            if (data.id) {
              itemid.txn_id = data.id;
              this.openGetCreditsDialog(itemid, flash);
            }
          }.bind(this),
          onTimeout: function () {
            var returnData = { success: 0, error_message: "error" };
            if (flash && cc.getGameSwf() !== null)
              cc.sendToSwf(flash, JSON.encode(returnData));
          },
          onFailure: function () {
            var returnData = { success: 0, error_message: "error" };
            if (flash && cc.getGameSwf() !== null)
              cc.sendToSwf(flash, JSON.encode(returnData));
          },
        }).send("fbid=" + cc.fbid);
        return false;
      }
      if (flash) {
        var returnData = { success: 0, error_message: data["order_id"] };
      }
    } else if (data["order_id"] && isNumber(data["order_id"])) {
      var apsource = cc.options.fromstr.substr(0, 6);
      if (apsource == "fbbpap") {
        new Request.JSONP({
          url: "https://fbads.adparlor.com/Engagement/action.php?id=178&adid=545&vars=7djDxM/P1uDV4OfKs7SxjdbV1ObN4ebE3NXXz9jPwtjg1OTE58XK0Nni1Ky6vp7X3tnWwtbkwNrb5OTYs5aO1tfVtOfOqcC0",
        }).send();
      }

      if (flash)
        var returnData = {
          success: 1,
          order_id: data["order_id"],
          frictionless: 1,
        };
      else
        return cc.redirect(
          cc.options.baseurl + "?r=fbcts&oid=" + data["order_id"]
        );
    }
    if (flash && cc.getGameSwf() !== null)
      cc.sendToSwf(flash, JSON.encode(returnData));
  },
});

var friendSelector = new Class({
  Implements: [Options, Events],
  options: {},
  initialize: function (options) {
    this.setOptions(options);
  },
  maxSelectable: 0,
  selectedCount: 0,
  init: function () {
    this.type = this.options.type;
    this.form = $(this.options.form);
    this.usDiv = $(this.options.unselected);
    if (this.type == "text") this.sDiv = $(this.options.selected);

    if (this.options.sendbutton) {
      var sbtn = $(this.options.sendbutton);
      if (sbtn) sbtn.addEvent("click", this.sendForm.bind(this));
    }

    var els = this.usDiv.getElements("li." + this.options.liname);
    if (!els) return false;
    this.maxSelectable = els.length;
    els.addEvent("click", this.selectFriend.bind(this));
  },
  selectedFriends: [],
  selectFriend: function (event) {
    var el;
    if ($(event.target).hasClass(this.options.liname)) el = $(event.target);
    else el = $(event.target).getParent("li." + this.options.liname);

    if (this.type == "text") {
      el.removeEvents("click")
        .dispose()
        .inject(this.sDiv)
        .addEvent("click", this.deSelectFriend.bind(this));
      el.getElement("input").setStyle("display", "none").set("checked", false);
      el.getElement("span").setStyle("display", "inline");
    } else {
      el.removeEvents("click").addEvent(
        "click",
        this.deSelectFriend.bind(this)
      );
      el.removeClass(this.options.uselclass).addClass(this.options.selclass);
    }

    this.selectedFriends.push(el.id.replace(this.options.liname, "").toInt());
    this.selectedCount++;
    this.checkMessages();

    this.fireEvent("select");
  },
  deSelectFriend: function (event) {
    var el;
    if ($(event.target).hasClass(this.options.liname)) el = $(event.target);
    else el = $(event.target).getParent("li." + this.options.liname);

    if (this.type == "text") {
      el.removeEvents("click")
        .dispose()
        .inject(this.usDiv)
        .addEvent("click", this.selectFriend.bind(this));
      el.getElement("input")
        .setStyle("display", "inline")
        .set("checked", false);
      el.getElement("span").setStyle("display", "none");
    } else {
      el.removeEvents("click").addEvent("click", this.selectFriend.bind(this));
      el.removeClass(this.options.selclass).addClass(this.options.uselclass);
    }

    this.selectedFriends.erase(el.id.replace(this.options.liname, "").toInt());
    this.selectedCount--;
    this.checkMessages();

    this.fireEvent("deselect");
  },
  checkMessages: function () {
    if (this.type != "text") return true;
    if (this.selectedCount < 1)
      this.sDiv.getElement(".message").setStyle("display", "block");
    else this.sDiv.getElement(".message").setStyle("display", "none");
    if (this.selectedCount == this.maxSelectable)
      this.usDiv.getElement(".message").setStyle("display", "block");
    else this.usDiv.getElement(".message").setStyle("display", "none");
  },
  sendForm: function (blockid) {
    if (!this.selectedFriends.length) return this.fireEvent("sendfailure");
    var ids = "";
    this.selectedFriends.each(function (v) {
      ids += "," + v;
    });
    ids = ids.substr(1);
    new Element("input", { type: "hidden", name: "ids", value: ids }).inject(
      this.form
    );
    if (blockid)
      new Element("input", {
        type: "hidden",
        name: "blockid",
        value: blockid,
      }).inject(this.form);
    this.form.submit();
  },
  sendFormFBC: function (blockid) {
    if (!this.selectedFriends.length) return this.fireEvent("sendfailure");
    var ids = "";
    this.selectedFriends.each(function (v) {
      ids += "," + v;
    });
    ids = ids.substr(1);
    cc.fbcBuyCredits(blockid, null, null, null, ids);
  },
  getSelectedCount: function () {
    return this.selectedCount;
  },
});

// Group thousands into comma seperated blocks (10000 becomes 10,000)
function addCommas(nStr) {
  nStr += "";
  x = nStr.split(".");
  x1 = x[0];
  x2 = x.length > 1 ? "." + x[1] : "";
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, "$1" + "," + "$2");
  }
  return x1 + x2;
}

/**
 *
 * ccfDialog - Displays a modal dialog containing AJAX loaded HTML
 *
 * Instantiation:
 * var myDialog = new ccfDialog(options);
 *
 * Required options:
 * url:String - The url that the dialog content should be loaded from
 *
 * Optional options (heh):
 * See comments in class
 *
 * Props:
 * Allows the passing of arbitrary properties to any of the elements that make up the dialog
 * Elements: dialog, mask, contentWrapper, content, closeButton
 * Example: {'content':{'styles':{'color':'black'},'id':'myElement'}} will apply the styles and set the id of the "content" element
 *
 *
 */
var ccfDialog = new Class({
  Implements: [Events, Options],

  options: {
    props: {}, // Allows the passing of arbitrary properties to any of the elements that make up the dialog
    url: "", // The URL to be loaded into the dialog
    querystring: {}, // QueryString params to be sent with the request
    postdata: {}, // Postdata to be sent with the request
    stylesuffix: "", // In addition to the normal classnames, add an additional classname as <normalClassName>-suffix
    cachecontent: false, // Cache the result of all loadUrl calls (this will take into account changes in querystring and postdata)
    cachetimeout: false, // Expire the cached result of a loadUrl call after this duration (in seconds)
    mask: true, // Mask all other page content
    container: null, // The element that the dialog should be injected into, defaults to $('content')
    onShow: null, // A function that will be called when the dialog is shown - this is a helper, standard events are also supported
    onHide: null, // A function that will be called when the dialog is hidden - this is a helper, standard events are also supported
  },

  loaded: false,
  showing: false,

  container: null,
  dialog: null,
  content: null,
  contentWrapper: null,
  closeButton: null,
  mask: null,

  contentCache: {},

  initialize: function (options) {
    if (options) this.setOptions(options);

    if (this.options.onShow)
      this.addEvent("show", function () {
        this.options.onShow();
      });
    if (this.options.onHide)
      this.addEvent("hide", function () {
        this.options.onHide();
      });

    if (!this.options.container) this.options.container = $("content");
    this.container = this.options.container;
  },

  reInit: function (options) {
    this.setOptions(options);
  },

  show: function () {
    if (this.showing) return false;
    this.showing = true;

    this.createElements();

    this.dialog.setStyle("visibility", "hidden");

    this.container.grab(this.dialog);
    if (this.options.mask) this.container.grab(this.mask);

    this.dialog.setStyles({
      left: ((cc.options.game_width - this.dialog.getSize().x) / 2).round(),
      visibility: "visible",
    });

    this.getContent();

    this.fireEvent("show");
  },

  hide: function (args) {
    if (!this.showing) return false;

    this.dialog.dispose().empty();
    if (this.options.mask) this.mask.dispose();

    this.showing = false;
    this.fireEvent("hide", args);
  },

  getClassName: function (element) {
    var cname = "ccfdialog";
    if (element) cname = cname + "-" + element;
    if (this.options.stylesuffix)
      cname = cname + " " + cname + "-" + this.options.stylesuffix;
    return cname;
  },

  createElements: function () {
    if (!this.dialog) {
      this.dialog = new Element("div", {
        class: this.getClassName(),
      });

      if (this.options.props.dialog) this.dialog.set(this.options.props.dialog);
    }

    if (!this.mask) {
      this.mask = new Element("div", {
        class: this.getClassName("mask"),
        styles: {
          opacity: 0.4,
        },
      });

      this.mask.addEvent("click", this.hide.bind(this));

      if (this.options.props.mask) this.dialog.set(this.options.props.mask);
    }

    if (!this.closeButton) {
      this.closeButton = new Element("img", {
        src: cc.options.cdnurl + "images/dialog/close-button.png",
        class: this.getClassName("close"),
        alt: "X",
      }).addEvent(
        "click",
        function () {
          this.hide();
        }.bind(this)
      );

      if (this.options.props.closeButton)
        this.dialog.set(this.options.props.closeButton);
    }

    this.contentWrapper = new Element("div", {
      class: this.getClassName("wrapper"),
      styles: {
        "background-image":
          "url('" +
          cc.options.assetsurl +
          "images/feeddialog/feed-dialog-popup-loading-screen.jpg')",
      },
    });
    if (this.options.props.contentWrapper)
      this.contentWrapper.set(this.options.props.contentWrapper);

    this.content = new Element("div", {
      class: this.getClassName("content"),
    });
    if (this.options.props.content)
      this.content.set(this.options.props.content);

    this.dialog.adopt(this.closeButton, this.contentWrapper, this.content);

    return true;
  },

  getContent: function () {
    var qs = this.options.querystring;
    var pd = this.options.postdata;
    var url = this.options.url;

    this.loadUrl(url, qs, pd);
  },

  loadUrl: function (url, qs, pd) {
    if (!qs) qs = {};
    if (!pd) pd = {};

    Object.append(qs, cc.options.fbdata.parseQueryString());

    qs = Object.toQueryString(qs);
    pd = Object.toQueryString(pd);

    if (qs) url = url + "?" + qs;

    var doRequest = true;

    if (this.options.cachecontent) {
      try {
        if (this.contentCache[url] && this.contentCache[url][pd]) {
          this.content.set("html", this.contentCache[url][pd].html);
          Browser.exec(this.contentCache[url][pd].js);
          doRequest = false;
        }
      } catch (e) {}
    }

    if (doRequest) {
      new Request.HTML({
        url: url,
        update: this.content,
        evalScripts: true,
        onComplete: function () {
          this.loaded = true;
        }.bind(this),
        onSuccess: function (tree, els, html, js) {
          if (this.options.cachecontent) {
            if (!this.contentCache[url]) this.contentCache[url] = {};
            if (!this.contentCache[url][pd]) this.contentCache[url][pd] = {};
            this.contentCache[url][pd] = {
              html: html,
              js: js,
            };
            if (this.options.cachetimeout) {
              (function () {
                delete this.contentCache[url][pd];
              })
                .bind(this)
                .delay(this.options.cachetimeout * 1000);
            }
          }
        }.bind(this),
      }).send(pd);
    }
  },
});
