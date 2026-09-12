(function () {
  function $() {
    if (!alliances.userData.userCanCreateAlliance)
      return (
        l(
          '<img src="' +
            cc.options.assetsurl +
            alliances.userData.strings.header_image_error +
            '" style="vertical-align:middle;">',
          alliances.userData.strings.error_user_cannot_create_alliances
        ),
        !1
      );
    var a = aa(1);
    jQuery(".defaultText", a).focus(function () {
      jQuery(this).val() == jQuery(this)[0].title &&
        (jQuery(this).removeClass("defaultTextActive"), jQuery(this).val(""));
    });
    jQuery(".defaultText", a).blur(function () {
      jQuery(this).val() === "" &&
        (jQuery(this).addClass("defaultTextActive"),
        jQuery(this).val(jQuery(this)[0].title));
    });
    jQuery(".defaultText", a).focus();
    jQuery(".defaultText", a).blur();
    t("createModalDialog", a);
    jQuery("#create-alliance-button").click(function () {
      new ba().execute();
    });
    S(q);
    return !0;
  }

  function aa(a) {
    var c = jQuery("<div />");
    c.attr({ id: "inner-content" }).css({
      position: "absolute",
      top: "0px",
      left: "0px",
      width: "442px",
      height: "347px",
    });
    c.html(jQuery("#alliance-create-ui").html());
    var d = _.template(jQuery("#create-alliance-ui").html());
    c.html(d());
    var d = 0,
      b;
    for (b = 0; b < 41; b++) {
      var i = b + 1;
      if (i != 40) {
        var e = Ea(i, 3 + Math.floor(d / 4) * 55, 3 + (d % 4) * 55);
        i == a && ((u = e), u.css({ "background-color": "#333333" }), (q = a));
        jQuery("#alliance-image-selection", c).append(e);
        d++;
      }
    }
    return c;
  }

  function Fa() {
    var a = aa(alliances.allianceInfo.image);
    t("createModalDialog", a);
    jQuery("#create-alliance-button").click(function () {
      new ca().execute();
    });
    jQuery("#create-alliance-header").html(
      '<img src="' +
        cc.options.assetsurl +
        alliances.userData.strings.header_image_edit_alliance +
        '" style="vertical-align:middle;">'
    );
    jQuery("#create-alliance-desc").text(
      alliances.userData.strings.edit_alliance_description
    );
    jQuery("#create-alliance-button").text(
      alliances.userData.strings.button_edit_alliance
    );
    jQuery("#create-alliance-input-name").val(alliances.allianceInfo.name);
    jQuery("#create-alliance-input-name").attr({ readonly: "readonly" });
    jQuery("#create-alliance-input-desc").val(
      alliances.allianceInfo.description
    );
    S(q);
  }

  function Ea(a, c, d) {
    var b = jQuery(
      '<div><img src="' +
        p(a, "medium") +
        '" style="padding:0px;margin:0px;width:50px;height:50px;"></div>'
    );
    b.css({
      position: "absolute",
      top: c,
      left: d,
      width: "50px",
      height: "50px",
      padding: "2px",
      cursor: "pointer",
    });
    b.click(function () {
      u !== null && u.css({ "background-color": "transparent" });
      u = jQuery(this);
      q = a;
      u.css({ "background-color": "#333333" });
      S(q);
    });
    return b;
  }

  function S(a) {
    jQuery("#create-alliance-selected-image-display").empty();
    var c = jQuery(J(a, "large"))
        .attr({ align: "top" })
        .css({ width: "50px", height: "50px" }),
      d = jQuery(J(a, "medium"))
        .attr({ align: "top" })
        .css({ "margin-left": "5px", width: "25px", height: "25px" }),
      a = jQuery(J(a, "small"))
        .attr({ align: "top" })
        .css({ "margin-left": "5px", width: "12px", height: "12px" });
    jQuery("#create-alliance-selected-image-display").append(c);
    jQuery("#create-alliance-selected-image-display").append(d);
    jQuery("#create-alliance-selected-image-display").append(a);
  }

  function l(a, c, d, b) {
    var i = jQuery("<div />");
    i.attr({ id: "inner-error-content" });
    var e = jQuery("<div />").css({
      position: "relative",
      width: "100%",
      "margin-top": "3px",
      "text-align": "center",
    });
    e.html(a);
    i.append(e);
    a = jQuery("<div />").css({
      position: "relative",
      width: "100%",
      height: "120px",
      "text-align": "center",
      overflow: "hidden",
      "margin-top": "15px",
      "word-wrap": "break-word",
      "font-size": "12px",
      "font-family": "Verdana",
      "font-weight": "normal",
    });
    a.text(c);
    d != void 0 &&
      ((c = jQuery("<div />").css({
        position: "relative",
        "margin-top": "20px",
        width: "100%",
        "text-align": "center",
      })),
      c.html(
        '<a href="javascript:void(0);" class="standardButton enabledButton" id="error-dialog-button" style="margin:auto;">' +
          d +
          "</a>"
      ),
      a.append(c));
    i.append(a);
    t("errorModalDialog", i);
    d != void 0 &&
      jQuery("#error-dialog-button").click(function () {
        b != void 0 ? b() : k();
      });
  }

  function Ga(a) {
    var c = "",
      d,
      b,
      i = jQuery('<div id="buttons" style="float:right;"></div>');
    if (a.status == "pending") {
      if (a.type == "invite") {
        c =
          '<img src="' +
          cc.options.assetsurl +
          alliances.userData.strings.header_image_alliance_invitation +
          '" style="vertical-align:middle;">';
        d = {
          pic_square: p(a.alliance_image, "small"),
          name: a.invited_by_name + " - " + a.alliance_name,
          subject: _.template(
            alliances.userData.strings.message_dialog_subject_invite,
            { alliance: a.alliance_name }
          ),
          text: _.template(
            alliances.userData.strings.message_dialog_body_invite,
            { invited_by_name: a.invited_by_name, alliance: a.alliance_name }
          ),
        };
        b = jQuery(
          '<a href="javascript:void(0);" class="buttonMessages enabledButton" id="error-dialog-button" style="float:left;">' +
            alliances.userData.strings.decline +
            "</a>"
        );
        b.click(function () {
          new B().execute(a, "declined");
        });
        var e = jQuery(
          '<a href="javascript:void(0);" class="buttonMessages enabledButton" id="error-dialog-button" style="float:left;">' +
            alliances.userData.strings.join +
            "</a>"
        );
        e.click(function () {
          new B().execute(a, "accepted");
        });
        i.append(b);
      } else
        (c =
          '<img src="' +
          cc.options.assetsurl +
          alliances.userData.strings.header_image_request_to_join +
          '" style="vertical-align:middle;">'),
          (d = {
            pic_square: a.user_pic_square,
            name: a.user_name,
            subject: _.template(
              alliances.userData.strings.message_dialog_subject_request,
              { alliance: a.alliance_name }
            ),
            text: _.template(
              alliances.userData.strings.message_dialog_body_request,
              { alliance: a.alliance_name, name: a.user_name }
            ),
          }),
          (b = jQuery(
            '<a href="javascript:void(0);" class="buttonMessages enabledButton" id="error-dialog-button" style="float:left;">' +
              alliances.userData.strings.decline +
              "</a>"
          )),
          b.click(function () {
            new B().execute(a, "declined");
          }),
          (viewBaseButton = jQuery(
            '<a href="javascript:void(0);" class="buttonMessages enabledButton" id="error-dialog-button" style="float:left;">' +
              alliances.userData.strings.button_visit_base +
              "</a>"
          )),
          viewBaseButton.click(function () {
            k();
            cc.openLeaderBase(a.user_id, a.base_id);
            alliances.hideAlliancesDialog();
          }),
          (e = jQuery(
            '<a href="javascript:void(0);" class="buttonMessages enabledButton" id="error-dialog-button" style="float:left;">' +
              alliances.userData.strings.accept +
              "</a>"
          )),
          e.click(function () {
            new B().execute(a, "accepted");
          }),
          i.append(b),
          i.append(viewBaseButton);
      i.append(e);
    } else
      a.status == "accepted"
        ? a.type == "invite"
          ? ((c =
              '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_invite_accepted +
              '" style="vertical-align:middle;">'),
            (d = {
              pic_square: a.user_pic_square,
              name: a.user_name,
              subject:
                alliances.userData.strings
                  .message_dialog_subject_invite_accepted,
              text: alliances.userData.strings
                .message_dialog_body_invite_accepted,
            }))
          : ((c =
              '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_request_accepted +
              '" style="vertical-align:middle;">'),
            (d = {
              pic_square: p(a.alliance_image, "small"),
              name: a.alliance_name,
              subject:
                alliances.userData.strings
                  .message_dialog_subject_request_accepted,
              text: _.template(
                alliances.userData.strings.message_dialog_body_request_accepted,
                { invited_by_name: a.leader_name, alliance: a.alliance_name }
              ),
            }))
        : a.status == "declined" &&
          (a.type == "invite"
            ? ((c =
                '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_image_invite_declined +
                '" style="vertical-align:middle;">'),
              (d = {
                pic_square: a.user_pic_square,
                name: a.user_name,
                subject:
                  alliances.userData.strings
                    .message_dialog_subject_invite_declined,
                text: alliances.userData.strings
                  .message_dialog_body_invite_declined,
              }))
            : ((c =
                '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_image_request_declined +
                '" style="vertical-align:middle;">'),
              (d = {
                pic_square: p(a.alliance_image, "small"),
                name: a.alliance_name,
                subject:
                  alliances.userData.strings
                    .message_dialog_subject_request_declined,
                text: _.template(
                  alliances.userData.strings
                    .message_dialog_body_request_declined,
                  { alliance: a.alliance_name }
                ),
              })));
    b = a.update_at_formatted.split("/");
    d.date = "<b>" + b[0] + "/" + b[1] + "</b>";
    c = { header: c, message: alliances.templates.messageTextTemplate(d) };
    t("messageModalDialog", alliances.templates.messageDialogTemplate(c));
    jQuery("#message-dialog").append(i);
  }

  function k() {
    for (; C.length > 0; ) C.pop().html("").remove();
  }

  function m() {
    try {
      jQuery("#actionsBox").remove(), jQuery("#relationshipsHover").remove();
    } catch (a) {}
  }

  function t(a, c) {
    var d = jQuery("<div />");
    d.css({
      position: "absolute",
      top: "0px",
      left: "0px",
      width: "100%",
      "z-index": da,
    });
    da++;
    C.push(d);
    d.append("<div />");
    d.children("div:last").css({
      backgroundColor: "#000",
      opacity: "0.4",
      position: "absolute",
      top: "0px",
      left: "0px",
      width: "100%",
      height: cc.options.game_height,
    });
    d.append("<div />");
    var b = d.children("div:last");
    b.css({
      position: "absolute",
      top: "0px",
      left: "0px",
      width: "100%",
      height: cc.options.game_height,
    });
    b.append("<div />");
    b = b.children("div:last");
    b.attr({ id: "inner-modal-dialog" }).addClass(a);
    b.append("<img />");
    b.children("img:last")
      .attr({
        src: cc.options.assetsurl + "images/alliances/redx.png",
        alt: "X",
      })
      .click(function () {
        var b = C.indexOf(d);
        b != -1 && C.splice(b, 1);
        d.html("").remove();
      })
      .addClass("modalRedX");
    b.append("<div />");
    b.children("div:last").attr({ id: "modal-content" }).append(c);
    jQuery("#content").append(d);
    return !0;
  }

  function T() {
    if (v === null) {
      var a = 61e3,
        c = 0,
        c = new Date().getTime(),
        c = D !== null ? c - D : a;
      c >= a
        ? new E().execute()
        : ((a -= c), (v = setTimeout("pollAlliancePowerups()", a)));
    }
  }

  function K() {
    v !== null && (clearTimeout(v), (v = null));
  }

  function Ha(a) {
    U = a;
    for (a = 0; a < U.length; a++) {
      var c = U[a],
        d = jQuery("#powerups-container"),
        b = jQuery("#powerup-" + c.powerup_id, d);
      b.length == 0 &&
        ((b = jQuery(alliances.templates.powerupTemplate({}))),
        b.attr({ id: "powerup-" + c.powerup_id }),
        d.append(b));
      a != 0 && b.css({ "margin-top": "-1px" });
      d =
        '<img src="' +
        cc.options.assetsurl +
        alliances.userData.strings[c.image] +
        '">';
      jQuery("#icon", b).html(d);
      jQuery("#name", b).text(alliances.userData.strings[c.name]);
      jQuery("#description", b).text(alliances.userData.strings[c.description]);
      Ia(jQuery("#progress-bar", b), c);
      b = jQuery("#actions", b);
      b.empty();
      b.removeClass();
      var d = function (b) {
          return function () {
            new ea().execute(b);
          };
        },
        i = function (b) {
          return function () {
            Ja(b);
          };
        };
      if (!c.active) {
        var e = Math.round(new Date().getTime() / 1e3);
        c.endTime - e <= 0
          ? alliances.userData.is_leader
            ? ((e = jQuery(
                '<a href="javascript:void(0);" class="standardButton enabledButton" style="position:relative;">' +
                  alliances.userData.strings.button_activate +
                  "</a>"
              )),
              e.click(d(c)))
            : ((e = jQuery(
                '<a href="javascript:void(0);" class="standardButton disabledButton" style="position:relative;" title="' +
                  alliances.userData.strings.error_only_leaders_can_activate +
                  '">' +
                  alliances.userData.strings.button_activate +
                  "</a>"
              )),
              e.click(function () {
                f(alliances.userData.strings.error_only_leaders_can_activate);
              }),
              e.css({
                "background-image": "none",
                "background-color": "#ffffff",
              }),
              jQuery(".ui-button-text", e).css({
                "background-image": "none",
                "background-color": "#ffffff",
              }))
          : ((e = jQuery(
              '<a href="javascript:void(0);" class="goldButton enabledButton" style="position:relative;">' +
                alliances.userData.strings.button_speed_up +
                "</a>"
            )),
            e.click(i(c)));
        b.append(e);
      }
    }
  }
  
  function Ja(a) {
    var c = jQuery(jQuery("#speedup-powerup-dialog-template").html()),
      d =
        '<img src="' +
        cc.options.assetsurl +
        alliances.userData.strings[a.headerImage] +
        '">';
    jQuery("#header", c).html(d);
    var d = jQuery("#selection", c),
      b = Math.round(new Date().getTime() / 1e3),
      b = Math.ceil((a.endTime - b) / 3600),
      i =
        '<img style="vertical-align:middle;margin-left:5px;" src="' +
        cc.options.assetsurl +
        'images/alliances/shiny-icon.png">',
      e = a.hourly_cost * 1,
      e = _.template(alliances.userData.strings.reduce_cooldown_time_hour, {
        hours: 1,
        cost: e,
      });
    d.append(
      '<div class="checkbox-row"><input type="radio" name="speedupGroup" value="1" checked="checked">' +
        e +
        i +
        "</div>"
    );
    e = a.hourly_cost * 2;
    $disabledText = b < 2 ? 'disabled="disabled"' : "";
    e = _.template(alliances.userData.strings.reduce_cooldown_time_hours, {
      hours: 2,
      cost: e,
    });
    d.append(
      '<div class="checkbox-row"><input type="radio" name="speedupGroup" value="2" ' +
        $disabledText +
        ">" +
        e +
        i +
        "</div>"
    );
    e = a.hourly_cost * 4;
    $disabledText = b < 4 ? 'disabled="disabled"' : "";
    e = _.template(alliances.userData.strings.reduce_cooldown_time_hours, {
      hours: 4,
      cost: e,
    });
    d.append(
      '<div class="checkbox-row"><input type="radio" name="speedupGroup" value="4" ' +
        $disabledText +
        ">" +
        e +
        i +
        "</div>"
    );
    $disabledText = b < 2 ? 'disabled="disabled"' : "";
    e = a.hourly_cost * b;
    e = _.template(alliances.userData.strings.finish_now, { cost: e });
    d.append(
      '<div class="checkbox-row"><input type="radio" name="speedupGroup" value="' +
        b +
        '" ' +
        $disabledText +
        ">" +
        e +
        i +
        "</div>"
    );
    jQuery("#buy-button", c).click(function () {
      var b = jQuery("input[name=speedupGroup]:checked").val();
      new fa().execute(a, b);
    });
    t("speedupModalDialog", c);
  }
  
  function ga() {
    var a = jQuery('<div class="gold" style="width:542;height:180px"></div>'),
      c = jQuery(
        '<a href="javascript:void(0);" class="goldButton enabledButton" style="position:absolute;top:84px;right:33px;">' +
          alliances.userData.strings.button_get_more_shiny +
          "</a>"
      );
    c.click(function () {
      cc.showTopup();
    });
    a.append(c);
    t("notEnoughShinyModalDialog", a);
  }
  function Ia(a, c) {
    var d = Math.round(new Date().getTime() / 1e3),
      d = c.endTime - d,
      b = "",
      i = 0,
      i = 0,
      e,
      g = d,
      i = (e = b = 0);
    g >= 86400 && ((b = Math.floor(g / 86400)), (g -= b * 86400));
    g >= 3600 && ((e = Math.floor(g / 3600)), (g -= e * 3600));
    i = Math.ceil(g / 60);
    i >= 60 && (i = 59);
    g = "";
    b > 0 && (g = b == 1 ? g + b + "day" : g + b + "days");
    if (b > 0 || e > 0) g = e == 1 ? g + " " + e + "hr" : g + " " + e + "hrs";
    e = i == 1 ? g + " " + i + "min" : g + " " + i + "mins";
    c.active
      ? ((b = "#13dd05"),
        (i = d / c.total_running_time),
        (i = Math.round(i * 428)),
        (e =
          alliances.userData.strings.powerup_active +
          " " +
          e +
          " " +
          alliances.userData.strings.powerup_remaining))
      : ((b = "#00fdfc"),
        (i = (c.total_recharge_time - d) / c.total_recharge_time),
        (i = Math.round(i * 428)),
        (e =
          d <= 0
            ? alliances.userData.strings.powerup_ready
            : alliances.userData.strings.powerup_ready_in + " " + e));
    jQuery("#progress-color", a).css({ width: i, "background-color": b });
    jQuery("#progress-text", a).text(e);
  }
  function J(a, c) {
    return '<img src="' + p(a, c) + '" style="padding:0px;margin:0px;">';
  }
  function p(a, c) {
    a = parseInt(a, 10);
    c == "small"
      ? (c = "25x25")
      : c == "medium"
      ? (c = "50x50")
      : c == "large" && (c = "75x75");
    a < 10 && (a = "0" + a);
    return (
      cc.options.assetsurl + "images/alliances/icons/" + c + "_" + a + ".png"
    );
  }
  function ha(a) {
    return (
      jQuery(a).hasClass("enabledButton") ||
      jQuery(a).hasClass("enabledButton25") ||
      jQuery(a).hasClass("pageEnabledButton")
    );
  }
  function n(a) {
    jQuery(a).hasClass("enabledButton")
      ? (jQuery(a).removeClass("enabledButton"),
        jQuery(a).addClass("disabledButton"))
      : jQuery(a).hasClass("disabledButton")
      ? (jQuery(a).removeClass("disabledButton"),
        jQuery(a).addClass("enabledButton"))
      : jQuery(a).hasClass("enabledButton25")
      ? (jQuery(a).removeClass("enabledButton25"),
        jQuery(a).addClass("disabledButton25"))
      : jQuery(a).hasClass("disabledButton25")
      ? (jQuery(a).removeClass("disabledButton25"),
        jQuery(a).addClass("enabledButton25"))
      : jQuery(a).hasClass("pageEnabledButton")
      ? (jQuery(a).removeClass("pageEnabledButton"),
        jQuery(a).addClass("pageDisabledButton"))
      : jQuery(a).hasClass("pageDisabledButton") &&
        (jQuery(a).removeClass("pageDisabledButton"),
        jQuery(a).addClass("pageEnabledButton"));
  }
  function f(a) {
    m();
    l(
      '<img src="' +
        cc.options.assetsurl +
        alliances.userData.strings.header_image_error +
        '" style="vertical-align:middle;">',
      a
    );
  }
  function r() {
    var a = function () {
      return (((1 + Math.random()) * 65536) | 0).toString(16).substring(1);
    };
    return (
      a() + a() + "-" + a() + "-" + a() + "-" + a() + "-" + a() + a() + a()
    );
  }
  function o(a) {
    a.st1 = "alliance";
    cc.recordKontagent("evt", a);
  }
  function L(a) {
    jQuery("#" + a).empty();
    var c = "<thead>" + jQuery("#member-header-template").html() + "</thead>";
    jQuery("#" + a).append(c);
    c = jQuery("<tbody></tbody");
    jQuery("#" + a).append(c);
    return c;
  }
  function ia(a, c, d, b) {
    c.row_class = a % 2 === 0 ? "alternating0" : "alternating1";
    c.user_id == alliances.userData.userid && (c.row_class = "alternating-me");
    a = "";
    a =
      c.status.online === !0
        ? '<img src="' +
          cc.options.assetsurl +
          'images/alliances/online_1.png" title="' +
          alliances.userData.strings.status_online +
          '" style="margin-top:1px">'
        : '<img src="' +
          cc.options.assetsurl +
          'images/alliances/offline_1.png" title="' +
          alliances.userData.strings.status_offline +
          '" style="margin-top:1px">';
    c.status.damage_protection === !0 &&
      (a =
        a +
        '<img src="' +
        cc.options.assetsurl +
        'images/alliances/damage_protection_1.png" title="' +
        alliances.userData.strings.status_damage_protection +
        '" style="margin-top:1px">');
    c.status_icons = a;
    c.actions_id = b;
    d.append(alliances.templates.memberRowTemplate(c));
  }
  function h(a) {
    var c = new Date().getTime();
    return a + "&ts=" + c + "&" + cc.options.fbdata;
  }
  function w(a, c) {
    jQuery("#powerups-container").empty();
    a
      ? ((alliances.userData.userInAlliance = !0),
        (alliances.userData.userCanCreateAlliance = !1),
        jQuery("#createButton").css({ display: "none" }),
        jQuery("#members-tab-li").css({ display: "inline" }),
        jQuery("#members-tab-link").css({ display: "inline" }),
        alliances.headquartersEnabled &&
          (jQuery("#headquarters-tab-li").css({ display: "inline" }),
          jQuery("#headquarters-tab-link").css({ display: "inline" })),
        / AppleWebKit\//.test(navigator.userAgent)
          ? jQuery("#alliance-tabs-nav li").css({
              height: "27px",
              "margin-left": "1px",
              "padding-top": "1px",
            })
          : jQuery("#alliance-tabs-nav li").css({ height: "26px" }),
        c
          ? (alliances.useImageTabButtons ||
              (M = alliances.headquartersEnabled ? 5 : 4),
            (alliances.userData.invite_permission = !0),
            (alliances.userData.is_leader = !0),
            (alliances.userData.changeRelationship = !0),
            jQuery("#suggested-members-tab-li").css({ display: "inline" }),
            jQuery("#suggested-members-tab-link").css({ display: "inline" }),
            jQuery("#edit-button").css({ display: "inline" }))
          : (alliances.useImageTabButtons ||
              (M = alliances.headquartersEnabled ? 4 : 3),
            (alliances.userData.invite_permission = !1),
            (alliances.userData.is_leader = !1),
            (alliances.userData.changeRelationship = !1),
            jQuery("#suggested-members-tab-li").css({ display: "none" }),
            jQuery("#suggested-members-tab-link").css({ display: "none" }),
            jQuery("#edit-button").css({ display: "none" })))
      : (alliances.useImageTabButtons || (M = 2),
        (alliances.userData.userInAlliance = !1),
        (alliances.userData.userCanCreateAlliance = !0),
        (alliances.userData.invite_permission = !1),
        (alliances.userData.is_leader = !1),
        (alliances.userData.changeRelationship = !1),
        jQuery("#headquarters-tab-li").css({ display: "none" }),
        jQuery("#headquarters-tab-link").css({ display: "none" }),
        jQuery("#members-tab-li").css({ display: "none" }),
        jQuery("#members-tab-link").css({ display: "none" }),
        jQuery("#suggested-members-tab-li").css({ display: "none" }),
        jQuery("#suggested-members-tab-link").css({ display: "none" }),
        jQuery("#edit-button").css({ display: "none" }),
        jQuery("#createButton").css({ display: "inline" }));
  }
  function V() {
    if (x === null) {
      var a = 6e4,
        c = 0,
        c = new Date().getTime(),
        c = y !== null ? c - y : a;
      c >= a
        ? new W().execute()
        : ((a -= c), (x = setTimeout("pollAllianceShouts()", a)));
    }
  }
  function z() {
    x !== null && (clearTimeout(x), (x = null));
  }
  function ja(a) {
    a = Math.round(new Date().getTime() / 1e3) - a;
    a < 0 && (a = 0);
    var c = "";
    a < 60
      ? (c = a == 1 ? a + " second ago" : a + " seconds ago")
      : a < 3569
      ? ((a = Math.round(a / 60)),
        (c = a == 1 ? a + " minute ago" : a + " minutes ago"))
      : a < 84599
      ? ((a = Math.round(a / 3600)),
        (c = a == 1 ? a + " hour ago" : a + " hours ago"))
      : ((a = Math.round(a / 86400)),
        (c = a == 1 ? a + " day ago" : a + " days ago"));
    return c;
  }
  if (!Function.prototype.bind)
    Function.prototype.bind = function (a) {
      if (typeof this !== "function")
        throw new TypeError(
          "Function.prototype.bind - what is trying to be fBound is not callable"
        );
      var c = Array.prototype.slice.call(arguments, 1),
        d = this,
        b = function () {},
        i = function () {
          return d.apply(
            this instanceof b ? this : a || window,
            c.concat(Array.prototype.slice.call(arguments))
          );
        };
      b.prototype = this.prototype;
      i.prototype = new b();
      return i;
    };
  var ka = 0,
    N = 1,
    la = 2,
    M = 5,
    ma;
  ma = (function () {
    function a() {
      this.userData = {};
      this.userData.suggestedMembers = null;
      this.userData.searchLocal = !0;
      this.initializedUI = !1;
      this.callback =
        this.selectedTab =
        this.allianceInfo =
        this.templates =
          null;
      this.useImageTabButtons = this.visible = !1;
      this.lastImageTabButtonSelector = "#browse-tab-link";
      this.headquartersEnabled = !0;
    }
    function c(b) {
      b = JSON.parse(b);
      b.error === void 0
        ? b.can_join_alliance === !1
          ? (alliances.hideAlliancesDialog(),
            l(
              '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_image_join_the_fellowship +
                '" style="vertical-align:middle;">',
              alliances.userData.strings.error_cannot_view_alliances_yet
            ))
          : (jQuery("#alliance-feed-content").css({ display: "inline" }),
            w(b.in_alliance, b.is_leader),
            (this.userData.userid = b.userid),
            (this.userData.allianceid = b.allianceid),
            (this.userData.credits = b.credits),
            new A().execute(0, "", !0),
            this.userData.allianceid ? new F().execute() : new s().execute(),
            jQuery("#tabs").tabs("select", ka),
            alliances.selectedTab != "search" &&
              (alliances.selectedTab == "messages"
                ? jQuery("#tabs").tabs("select", M)
                : alliances.selectedTab == "hq" &&
                  alliances.userData.userInAlliance &&
                  jQuery("#tabs").tabs("select", la)))
        : (jQuery("#alliance-feed-content").css({ display: "inline" }),
          f(b.error));
    }
    function d() {
      jQuery("#alliance-feed-content").css({ display: "inline" });
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.initializeUI = function () {
      if (this.initializedUI === !1) {
        if (this.userData.strings === void 0) throw "strings is undefined";
        this.initializedUI = !0;
        this.templates = new na();
        this.templates.initializeTemplates();
        new oa().initializeUI();
        new O().execute();
      }
    };
    a.prototype.showAlliancesDialog = function (b, a) {
      if (!this.visible) {
        this.visible = !0;
        if (b)
          if (typeof b === "string")
            (this.selectedTab = b), (this.callback = a);
          else
            try {
              if (b.type) this.selectedTab = b.type;
            } catch (e) {}
        jQuery("#alliance-dialog-wrapper").css({ display: "inline" });
        jQuery("#alliance-feed-dialog").removeClass("hideDialog");
        jQuery.ajax({
          url: h("/alliance/userinfo?"),
          dataType: "text",
          success: c.bind(this),
          error: d.bind(this),
        });
      }
    };
    a.prototype.hideAlliancesDialog = function () {
      k();
      if (alliances.visible) {
        alliances.visible = !1;
        z();
        jQuery("#alliance-feed-content").css({ display: "none" });
        jQuery("#alliance-feed-dialog").addClass("hideDialog");
        jQuery("#alliance-dialog-wrapper").css({ display: "none" });
        alliances.callback && alliances.callback();
        w(!1, !1);
        alliances.userData.userid = null;
        alliances.userData.allianceid = null;
        alliances.userData.suggestedMembers = null;
        alliances.allianceInfo = null;
        alliances.selectedTab = null;
        alliances.callback = null;
        z();
        y = null;
        K();
        D = null;
        jQuery("#search-results-table").empty();
        var b =
          "<thead>" + jQuery("#alliance-header-template").html() + "</thead>";
        jQuery("#search-results-table").append(b);
        b = jQuery("<tbody></tbody");
        jQuery("#search-results-table").append(b);
        jQuery("#search-results-paging").empty();
        jQuery("#alliance-name").text("");
        jQuery(".myAllianceValue", "#alliance-rank").text("");
        jQuery(".myAllianceValue", "#alliance-level").text("");
        jQuery(".myAllianceValue", "#alliance-leader").text("");
        jQuery(".myAllianceValue", "#alliance-members").text("");
        jQuery("#alliance-description").text("");
        jQuery("#alliance-image").html("");
        L("members-table");
        L("suggested-members-table");
        jQuery("#messages-table").empty();
        b = "<thead>" + jQuery("#message-header-template").html() + "</thead>";
        jQuery("#messages-table").append(b);
        b = jQuery("<tbody></tbody");
        jQuery("#messages-table").append(b);
        jQuery("#powerups-container").empty();
        try {
          cc.sendToSwf("alliancesupdate", JSON.encode({}));
        } catch (a) {}
      }
    };
    return a;
  })();
  var u = null,
    q = -1,
    oa;
  oa = (function () {
    function a() {}
    a.prototype.initializeUI = function () {
      jQuery(".redx", "#alliance-feed-dialog").click(function () {
        alliances.hideAlliancesDialog();
      });
      jQuery("#tabs").tabs({
        select: function (a, d) {
          m();
          if (d.index == N)
            if (alliances.userData.userInAlliance) V();
            else
              return (
                l(
                  '<img src="' +
                    cc.options.assetsurl +
                    alliances.userData.strings.header_image_create_an_alliance +
                    '" style="vertical-align:middle;">',
                  alliances.userData.strings.error_not_in_alliance_create,
                  alliances.userData.strings.create_an_alliance,
                  function () {
                    k();
                    $();
                  }
                ),
                !1
              );
          else z();
          d.index == la ? T() : K();
          alliances.userData.is_leader && d.index == 4 && new pa().execute();
          if (alliances.useImageTabButtons)
            if ((n(alliances.lastImageTabButtonSelector), d.index == 0))
              n("#browse-tab-link"),
                (alliances.lastImageTabButtonSelector = "#browse-tab-link");
            else if (d.index == 1)
              n("#alliance-tab-link"),
                (alliances.lastImageTabButtonSelector = "#alliance-tab-link");
            else if (d.index == 2)
              n("#headquarters-tab-link"),
                (alliances.lastImageTabButtonSelector =
                  "#headquarters-tab-link");
            else if (d.index == 3)
              n("#members-tab-link"),
                (alliances.lastImageTabButtonSelector = "#members-tab-link");
            else if (d.index == 4)
              n("#suggested-members-tab-link"),
                (alliances.lastImageTabButtonSelector =
                  "#suggested-members-tab-link");
            else if (d.index == 5)
              n("#messages-tab-link"),
                (alliances.lastImageTabButtonSelector = "#messages-tab-link");
          return !0;
        },
      });
      / AppleWebKit\//.test(navigator.userAgent)
        ? jQuery("#alliance-tabs-nav li").css({
            height: "27px",
            "margin-left": "1px",
            "padding-top": "1px",
          })
        : jQuery("#alliance-tabs-nav li").css({ height: "26px" });
      jQuery("#searchButton").click(function () {
        new A().execute();
      });
      jQuery("#search-input").keypress(function (a) {
        a.keyCode == 13 && new A().execute();
      });
      jQuery("body").click(function () {
        m();
      });
      jQuery("#createButton").click(function () {
        $();
      });
      jQuery("#edit-button").click(function () {
        Fa();
      });
      jQuery("#leave-button").click(function () {
        new qa().execute();
      });
      jQuery("#check-all-messages").click(function () {
        jQuery('input[name="messages[]"]').each(function () {
          jQuery(this).attr("checked", "checked");
        });
      });
      jQuery("#delete-messages").click(function () {
        new ra().execute();
      });
      jQuery("#shout-post").click(function () {
        new X().execute();
      });
      jQuery("#shout-input").keypress(function (a) {
        a.keyCode == 13 && new X().execute();
      });
      jQuery("#ask-join-button").click(function () {
        alliances.hideAlliancesDialog();
        cc.showFeedDialog("invitealliance");
      });
      jQuery("#allButton").click(function () {
        if (ha("#allButton"))
          n("#allButton"),
            n("#worldButton"),
            (alliances.userData.searchLocal = !1),
            new A().execute(0, G);
      });
      jQuery("#worldButton").click(function () {
        if (ha("#worldButton"))
          n("#allButton"),
            n("#worldButton"),
            (alliances.userData.searchLocal = !0),
            new A().execute(0, G);
      });
      alliances.useImageTabButtons &&
        (jQuery("#tabs").tabs("add", "#tabs-browse", "label"),
        jQuery("#tabs").tabs("add", "#tabs-my-alliance", "label"),
        jQuery("#tabs").tabs("add", "#tabs-headquarters", "label"),
        jQuery("#tabs").tabs("add", "#tabs-members", "label"),
        jQuery("#tabs").tabs("add", "#tabs-suggested-members", "label"),
        jQuery("#tabs").tabs("add", "#tabs-messages", "label"),
        jQuery("#browse-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 0);
        }),
        jQuery("#alliance-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 1);
        }),
        jQuery("#headquarters-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 2);
        }),
        jQuery("#members-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 3);
        }),
        jQuery("#suggested-members-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 4);
        }),
        jQuery("#messages-tab-link").click(function () {
          jQuery("#tabs").tabs("select", 5);
        }));
    };
    return a;
  })();
  var C = [],
    da = 20,
    U = null,
    v = null,
    D = null;
  window.pollAlliancePowerups = function () {
    v = null;
    new E().execute();
  };
  var na;
  na = (function () {
    function a() {}
    a.prototype.initializeTemplates = function () {
      this.rowTemplate = _.template(jQuery("#alliance-row-template").html());
      this.actionsTemplate = _.template(
        jQuery("#browse-alliance-actions").html()
      );
      this.memberRowTemplate = _.template(
        jQuery("#member-row-template").html()
      );
      this.messageRowTemplate = _.template(
        jQuery("#message-row-template").html()
      );
      this.relationshipHoverTemplate = _.template(
        jQuery("#change-relationship-actions").html()
      );
      this.messageDialogTemplate = _.template(
        jQuery("#message-dialog-template").html()
      );
      this.messageTextTemplate = _.template(
        jQuery("#message-text-template").html()
      );
      this.userShoutMessageTemplate = _.template(
        jQuery("#user-shout-message-template").html()
      );
      this.systemShoutMessageTemplate = _.template(
        jQuery("#system-shout-message-template").html()
      );
      this.systemShoutRelationshipMessage = _.template(
        jQuery("#system-shout-relationship-message").html()
      );
      this.powerupTemplate = _.template(jQuery("#powerup-template").html());
    };
    return a;
  })();
  var sa = null,
    ea;
  ea = (function () {
    function a() {}
    function c(b) {
      b = JSON.parse(b);
      b.error === void 0
        ? (o({
            st2: "triggerpowerup",
            n: sa.type,
            v: alliances.userData.allianceid,
          }),
          new E().execute())
        : f(b.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (b) {
      sa = b;
      jQuery.ajax({
        url: h("/alliance/activatepowerup?powerup_id=" + b.powerup_id),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var B;
  B = (function () {
    function a() {}
    function c(b) {
      b = JSON.parse(b);
      b.error === void 0
        ? (this.newStatus == "accepted"
            ? this.message.type == "invite"
              ? (w(!0, !1),
                jQuery("#tabs").tabs("select", N),
                jQuery("#members-tab-link").text(
                  alliances.userData.strings.tab_members
                ),
                new F().execute(function () {
                  o({ n: "join", v: alliances.userData.allianceid });
                }))
              : (o({ n: "join", v: alliances.userData.allianceid }),
                new H().execute())
            : new s().execute(),
          new O().execute())
        : f(b.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (b, a) {
      this.newStatus = a;
      this.message = b;
      k();
      var e = "invite_id=" + this.message.invite_id;
      e += "&status=" + this.newStatus;
      jQuery.ajax({
        url: h("/alliance/changeinvitestatus?" + e),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var I, ta, ua, P;
  P = (function () {
    function a() {}
    function c(b) {
      b = JSON.parse(b);
      b.error === void 0
        ? ((b = jQuery("#" + ua)),
          b.removeClass(),
          I == "friendly"
            ? b.addClass("relationship-friendly")
            : I == "neutral"
            ? b.addClass("relationship-neutral")
            : I == "hostile" && b.addClass("relationship-hostile"),
          o({
            n: "setstance",
            v: alliances.userData.allianceid,
            n2: I,
            n3: ta,
          }),
          m())
        : f(b.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (b, a, e) {
      I = b;
      ta = a;
      ua = e;
      jQuery.ajax({
        url: h(
          "/alliance/changerelationship?target_alliance_id=" +
            a +
            "&relationship=" +
            b
        ),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var Q = !1,
    ba;
  ba = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? (k(),
          w(!0, !0),
          jQuery("#tabs").tabs("select", N),
          jQuery("#members-tab-link").text(
            alliances.userData.strings.tab_members
          ),
          new F().execute(function () {
            o({ n: "selectimage", v: alliances.userData.allianceid, n2: q });
            o({ n: "create", v: alliances.userData.allianceid });
          }))
        : f(a.error);
      Q = !1;
    }
    function d() {
      Q = !1;
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      if (Q !== !0)
        if (
          jQuery("#create-alliance-input-name").val() ==
          jQuery("#create-alliance-input-name")[0].title
        )
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_error +
              '" style="vertical-align:middle;">',
            alliances.userData.strings.error_name_too_short
          );
        else if (
          jQuery("#create-alliance-input-desc").val() ==
          jQuery("#create-alliance-input-desc")[0].title
        )
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_error +
              '" style="vertical-align:middle;">',
            alliances.userData.strings.error_description_too_short
          );
        else {
          Q = !0;
          var a =
            "alliance_name=" +
            escape(jQuery("#create-alliance-input-name").val());
          a +=
            "&alliance_desc=" +
            escape(jQuery("#create-alliance-input-desc").val());
          a += "&alliance_image=" + q;
          jQuery.ajax({
            url: h("/alliance/createalliance?" + a),
            dataType: "text",
            success: c.bind(this),
            error: d.bind(this),
          });
        }
    };
    return a;
  })();
  var ra;
  ra = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0 ? (new s().execute(), new O().execute()) : f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      var a = "";
      jQuery('input[name="messages[]"]:checked').each(function () {
        a !== "" && (a += ",");
        a += jQuery(this).val();
      });
      a !== "" &&
        jQuery.ajax({
          url: h("/alliance/deletemessages?invite_ids=" + a),
          dataType: "text",
          success: c.bind(this),
          error: d.bind(this),
        });
    };
    return a;
  })();
  var ca;
  ca = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0 ? (k(), new F().execute()) : f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      if (
        jQuery("#create-alliance-input-desc").val() ==
        jQuery("#create-alliance-input-desc")[0].title
      )
        l(
          '<img src="' +
            cc.options.assetsurl +
            alliances.userData.strings.header_image_error +
            '" style="vertical-align:middle;">',
          alliances.userData.strings.error_description_too_short
        );
      else {
        var a = "alliance_desc=" + jQuery("#create-alliance-input-desc").val();
        a += "&alliance_image=" + q;
        jQuery.ajax({
          url: h("/alliance/editalliance?" + a),
          dataType: "text",
          success: c.bind(this),
          error: d.bind(this),
        });
      }
    };
    return a;
  })();
  var H;
  H = (function () {
    function a() {}
    function c(a) {
      var c = L("members-table");
      alliances.userData.allianceMembers = JSON.parse(a);
      if (alliances.userData.allianceMembers.error === void 0) {
        var d = 0,
          a = alliances.userData.allianceMembers.length;
        jQuery.each(alliances.userData.allianceMembers, function (a, b) {
          var j = r();
          ia(a, b, c, j);
          b.status.online === !0 && d++;
          b.user_id == alliances.userData.userid
            ? jQuery("#" + j).css({ display: "none" })
            : jQuery("#" + j).click(function (a) {
                a.stopPropagation();
                m();
                alliances.userData.is_leader
                  ? (jQuery("body").append(
                      jQuery("#leader-members-actions").html()
                    ),
                    jQuery("#actionsBox").css("height", 81),
                    jQuery("#kick-button", "#actionsBox").click(function () {
                      a.stopPropagation();
                      new va().execute(b.user_id, b.display_name);
                      m();
                    }),
                    jQuery("#promote-button", "#actionsBox").click(function () {
                      a.stopPropagation();
                      new wa().execute(b.user_id, b.display_name);
                      m();
                    }))
                  : (jQuery("body").append(jQuery("#members-actions").html()),
                    jQuery("#actionsBox").css("height", 26));
                jQuery("#visit-button", "#actionsBox").click(function () {
                  a.stopPropagation();
                  m();
                  alliances.hideAlliancesDialog();
                  cc.openLeaderBase(b.user_id, b.base_id);
                });
                var c = jQuery(this).offset();
                jQuery("#actionsBox").css("top", c.top + 6);
                jQuery("#actionsBox").css("left", c.left - 35);
                jQuery("#actionsBox").topZIndex({ increment: 10 });
                jQuery("#actionsBox").click(function (a) {
                  a.stopPropagation();
                });
                jQuery("#actionsBox").fadeIn("250");
                return !1;
              });
        });
        jQuery("#members-tab-link").text(
          alliances.userData.strings.tab_members + " (" + d + "/" + a + ")"
        );
      } else
        f(alliances.userData.allianceMembers.error),
          (alliances.userData.allianceMembers = null);
      new s().execute();
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      jQuery.ajax({
        url: h("/alliance/myalliancemembers?"),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var F;
  F = (function () {
    function a() {}
    function c(a) {
      alliances.allianceInfo = JSON.parse(a);
      alliances.allianceInfo.error === void 0
        ? ((alliances.userData.allianceid = alliances.allianceInfo.alliance_id),
          jQuery("#alliance-name").text(alliances.allianceInfo.name),
          jQuery("#alliance-name").shorten({ width: 175 }),
          jQuery(".myAllianceValue", "#alliance-rank").text(
            alliances.allianceInfo.rank
          ),
          jQuery(".myAllianceValue", "#alliance-level").text(
            alliances.allianceInfo.avg_level
          ),
          jQuery(".myAllianceValue", "#alliance-leader").text(
            alliances.allianceInfo.leader_name
          ),
          jQuery(".myAllianceValue", "#alliance-members").text(
            alliances.allianceInfo.number_of_members
          ),
          jQuery("#alliance-description").text(
            alliances.allianceInfo.description
          ),
          jQuery("#alliance-image").html(
            J(alliances.allianceInfo.image, "large")
          ),
          this.callback && this.callback(),
          new H().execute())
        : new s().execute();
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a) {
      this.callback = a;
      jQuery.ajax({
        url: h("/alliance/myalliance?"),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var O;
  O = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      if (a.error === void 0)
        if (((a = a.notification_count), a > 0)) {
          var c = jQuery("#alliance_menu_item").offset().top,
            d = jQuery("#alliance_menu_item").offset().left;
          jQuery("#allianceNotifications").css({
            display: "inline",
            top: c - 9,
            left: d + 59,
            "background-image":
              'url("' +
              cc.options.assetsurl +
              'images/alliances/noticebadge.png")',
          });
          jQuery("#allianceNotifications").text(a);
        } else jQuery("#allianceNotifications").css("display", "none");
      else jQuery("#allianceNotifications").css("display", "none");
    }
    function d() {
      jQuery("#allianceNotifications").css("display", "none");
    }
    a.prototype.execute = function () {
      jQuery.ajax({
        url: h("/alliance/getnotificationcount?"),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var s;
  s = (function () {
    function a() {}
    function c(a) {
      jQuery("#messages-table").empty();
      var b =
        "<thead>" + jQuery("#message-header-template").html() + "</thead>";
      jQuery("#messages-table").append(b);
      var c = jQuery("<tbody></tbody");
      jQuery("#messages-table").append(c);
      a = JSON.parse(a);
      a.error === void 0
        ? (jQuery("#messages-tab-link").text(
            alliances.userData.strings.tab_messages + " (" + a.length + ")"
          ),
          jQuery.each(a, function (a, b) {
            b.row_class = a % 2 === 0 ? "alternating0" : "alternating1";
            var e = r();
            b.checkbox_guid = e;
            e = r();
            b.checkbox_div_guid = e;
            b.status == "pending"
              ? b.type == "invite"
                ? ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/invite.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_invite,
                    {
                      invited_by_name: b.invited_by_name,
                      invited_by_alliance: b.alliance_name,
                    }
                  )))
                : ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/request.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_request,
                    { name: b.user_name, alliance: b.alliance_name }
                  )))
              : b.status == "accepted"
              ? b.type == "invite"
                ? ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/accepted.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_invite_accepted,
                    { alliance: b.alliance_name }
                  )))
                : ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/accepted.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_accepted,
                    { alliance: b.alliance_name }
                  )))
              : b.status == "declined"
              ? b.type == "invite"
                ? ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/declined.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_invite_declined,
                    { alliance: b.alliance_name }
                  )))
                : ((b.message_image =
                    cc.options.assetsurl +
                    "images/alliances/messages/declined.png"),
                  (b.subject = _.template(
                    alliances.userData.strings.message_subject_declined,
                    { alliance: b.alliance_name }
                  )))
              : ((b.message_image = ""), (b.subject = ""));
            b.status == "pending"
              ? b.type == "invite"
                ? ((b.pic_square = p(b.alliance_image, "small")),
                  (b.from = b.alliance_name))
                : ((b.pic_square = b.user_pic_square), (b.from = b.user_name))
              : b.type != "invite"
              ? ((b.pic_square = p(b.alliance_image, "small")),
                (b.from = b.alliance_name))
              : ((b.pic_square = b.user_pic_square), (b.from = b.user_name));
            b.date = b.update_at_formatted;
            e = jQuery(alliances.templates.messageRowTemplate(b));
            jQuery("#from", e).click(d(b));
            jQuery("#subject", e).click(d(b));
            jQuery("#date", e).click(d(b));
            c.append(e);
          }))
        : (f(a.error), (alliances.userData.suggestedMembers = null));
    }
    function d(a) {
      return function (b) {
        b.stopPropagation();
        Ga(a);
        return !1;
      };
    }
    function b() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      jQuery.ajax({
        url: h("/alliance/getmessages?"),
        dataType: "text",
        success: c.bind(this),
        error: b.bind(this),
      });
    };
    return a;
  })();
  var E;
  E = (function () {
    function a() {}
    function c(a) {
      alliances.visible && ((D = new Date().getTime()), T());
      a = JSON.parse(a);
      a.error === void 0 ? ((a = new xa().parse(a)), Ha(a)) : f(a.error);
    }
    function d() {
      alliances.visible && ((D = new Date().getTime()), T());
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      K();
      jQuery.ajax({
        url: h("/alliance/getpowerups?"),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var R = null,
    W;
  W = (function () {
    function a() {}
    function c(a) {
      alliances.visible && ((y = new Date().getTime()), V());
      a = JSON.parse(a);
      jQuery("#shouts").attr("scrollHeight");
      jQuery("#shouts").scrollTop();
      jQuery("#shouts").empty();
      if (a.error === void 0) {
        R = a;
        for (var c = a.length - 1; c >= 0; c--) {
          var d = a[c];
          d.row_class =
            c % 2 === 0 ? "shout-alternating0" : "shout-alternating1";
          d.background_color == "gold" && (d.row_class = "shout-gold");
          d.time = ja(parseInt(d.created_at, 10));
          var g;
          d.system_generated === !1
            ? (g = alliances.templates.userShoutMessageTemplate)
            : d.relationship === null
            ? (g = alliances.templates.systemShoutMessageTemplate)
            : ((d.target_alliance_pic = p(d.target_alliance_pic, "medium")),
              (d.relationship_pic = ""),
              (g = alliances.templates.systemShoutRelationshipMessage));
          g = jQuery(g(d));
          jQuery("#message", g).text(d.message);
          jQuery("#shouts").append(g);
          d = jQuery("#shouts")
            .children("div:last")
            .children("#message")
            .height();
          g = jQuery("#shouts")
            .children("div:last")
            .children("#message")
            .position().top;
          jQuery("#shouts")
            .children("div:last")
            .height(d + g + 5);
        }
        a = jQuery("#shouts")[0].scrollHeight;
        jQuery("#shouts").scrollTop(a);
      } else f(a.error);
    }
    function d() {
      alliances.visible && ((y = new Date().getTime()), V());
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      z();
      jQuery.ajax({
        url: h("/alliance/getallianceshouts?"),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var pa;
  pa = (function () {
    function a() {}
    function c(a) {
      var c = L("suggested-members-table"),
        a = JSON.parse(a);
      alliances.userData.suggestedMembers = a;
      a.error === void 0
        ? jQuery.each(a, function (a, b) {
            var d = r();
            ia(a, b, c, d);
            jQuery("#" + d).click(function (a) {
              a.stopPropagation();
              m();
              jQuery("body").append(
                jQuery("#suggested-members-actions").html()
              );
              jQuery("#invite-button", "#actionsBox").click(function () {
                a.stopPropagation();
                b.world != alliances.allianceInfo.world ||
                b.sector != alliances.allianceInfo.sector
                  ? l(
                      '<img src="' +
                        cc.options.assetsurl +
                        alliances.userData.strings.header_cant_invite +
                        '" style="vertical-align:middle;">',
                      _.template(
                        alliances.userData.strings
                          .error_cannot_invite_outside_world,
                        { name: b.display_name }
                      ),
                      alliances.userData.strings.button_open_map,
                      function () {
                        cc.sendToSwf("openmap", JSON.encode({}));
                        k();
                        alliances.hideAlliancesDialog();
                      }
                    )
                  : new ya().execute(b.user_id);
                m();
              });
              jQuery("#visit-button", "#actionsBox").click(function () {
                a.stopPropagation();
                m();
                cc.openLeaderBase(b.user_id, b.base_id);
                alliances.hideAlliancesDialog();
              });
              var c = jQuery(this).offset();
              jQuery("#actionsBox").css("top", c.top + 6);
              jQuery("#actionsBox").css("left", c.left - 35);
              jQuery("#actionsBox").topZIndex({ increment: 10 });
              jQuery("#actionsBox").click(function (a) {
                a.stopPropagation();
              });
              jQuery("#actionsBox").fadeIn("250");
              return !1;
            });
          })
        : (f(a.error), (alliances.userData.suggestedMembers = null));
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      alliances.userData.suggestedMembers === null &&
        jQuery.ajax({
          url: h("/alliance/getsuggestedmembers?"),
          dataType: "text",
          success: c.bind(this),
          error: d.bind(this),
        });
    };
    return a;
  })();
  var ya;
  ya = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? (k(),
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_invite_sent +
              '" style="vertical-align:middle;">',
            alliances.userData.strings.invite_sent
          ),
          new s().execute())
        : f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a) {
      jQuery.ajax({
        url: h("/alliance/inviteuser?user_id=" + a),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var za, Y, va;
  va = (function () {
    function a() {}
    function c() {
      jQuery.ajax({
        url: h("/alliance/kickmember?user_id=" + Y),
        dataType: "text",
        success: d.bind(this),
        error: b.bind(this),
      });
    }
    function d(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? (k(),
          (a = _.template(alliances.userData.strings.kick_response, {
            name: za,
            alliance: alliances.allianceInfo.name,
          })),
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_booted +
              '" style="vertical-align:middle;">',
            a
          ),
          o({ n: "kick", v: alliances.userData.allianceid, n2: Y }),
          new H().execute())
        : f(a.error);
    }
    function b() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a, b) {
      za = b;
      Y = a;
      l(
        '<img src="' +
          cc.options.assetsurl +
          alliances.userData.strings.header_image_are_you_sure +
          '" style="vertical-align:middle;">',
        _.template(alliances.userData.strings.kick_confirmation, { name: b }),
        alliances.userData.strings.button_kick_user,
        function () {
          c();
        }.bind(this)
      );
    };
    return a;
  })();
  var qa;
  qa = (function () {
    function a() {}
    function c() {
      z();
      K();
      jQuery.ajax({
        url: h("/alliance/leavealliance?"),
        dataType: "text",
        success: d.bind(this),
        error: b.bind(this),
      });
    }
    function d(a) {
      a = JSON.parse(a);
      if (a.error === void 0)
        k(),
          o({ n: "leave", v: alliances.userData.allianceid }),
          (alliances.userData.allianceid = null),
          w(!1, !1),
          jQuery("#tabs").tabs("select", ka);
      else {
        k();
        var b = a.error,
          c = alliances.allianceInfo.name;
        try {
          b = _.template(b, { alliance: c });
        } catch (d) {
          b = a.error;
        }
        f(b);
      }
    }
    function b() {
      k();
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      var a = alliances.allianceInfo.name,
        b = "",
        d = "",
        f = "",
        b = 0;
      if (alliances.userData.allianceMembers !== null)
        b = alliances.userData.allianceMembers.length;
      alliances.userData.is_leader && b > 1
        ? ((b =
            '<img src="' +
            cc.options.assetsurl +
            alliances.userData.strings.header_name_your_successor +
            '" style="vertical-align:middle;">'),
          (d = _.template(
            alliances.userData.strings.error_leader_cannot_leave,
            { alliance: a }
          )),
          (f = alliances.userData.strings.tab_members),
          l(b, d, f, function () {
            jQuery("#tabs").tabs("select", 3);
            k();
          }))
        : (alliances.userData.is_leader
            ? ((b =
                '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_double_checking +
                '" style="vertical-align:middle;">'),
              (d = _.template(
                alliances.userData.strings.disband_alliance_description,
                { alliance: a }
              )))
            : ((b =
                '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_image_are_you_sure +
                '" style="vertical-align:middle;">'),
              (d = _.template(
                alliances.userData.strings.leave_alliance_description,
                {
                  leader_name: alliances.allianceInfo.leader_name,
                  alliance: alliances.allianceInfo.name,
                }
              ))),
          (f = alliances.userData.strings.leave_alliance),
          l(b, d, f, c));
    };
    return a;
  })();
  var X;
  X = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      if (a.error === void 0) {
        o({
          n: "shoutbox",
          v: alliances.userData.allianceid,
          n2: this.message.length,
        });
        var c = 0;
        if (R) R.push(a), (c = R.length);
        a.row_class = c % 2 === 0 ? "shout-alternating0" : "shout-alternating1";
        a.time = ja(parseInt(a.created_at, 10));
        c = alliances.templates.userShoutMessageTemplate;
        c = jQuery(c(a));
        jQuery("#message", c).text(a.message);
        jQuery("#shouts").append(c);
        a = jQuery("#shouts")
          .children("div:last")
          .children("#message")
          .height();
        c = jQuery("#shouts")
          .children("div:last")
          .children("#message")
          .position().top;
        jQuery("#shouts")
          .children("div:last")
          .height(a + c + 5);
        a = jQuery("#shouts")[0].scrollHeight;
        jQuery("#shouts").scrollTop(a);
      } else f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function () {
      this.message = jQuery("#shout-input").val();
      if (this.message !== "") {
        var a = "message=" + escape(this.message);
        jQuery("#shout-input").val("");
        jQuery.ajax({
          url: h("/alliance/createallianceshout?" + a),
          dataType: "text",
          success: c.bind(this),
          error: d.bind(this),
        });
      }
    };
    return a;
  })();
  var Aa, Z, wa;
  wa = (function () {
    function a() {}
    function c() {
      jQuery.ajax({
        url: h("/alliance/promotemember?user_id=" + Z),
        dataType: "text",
        success: d.bind(this),
        error: b.bind(this),
      });
    }
    function d(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? (k(),
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_promoted +
              '" style="vertical-align:middle;">',
            _.template(alliances.userData.strings.promote_response, {
              name: Aa,
              alliance: alliances.allianceInfo.name,
            })
          ),
          w(!0, !1),
          o({ n: "promote", v: alliances.userData.allianceid, n2: Z }),
          new H().execute())
        : f(a.error);
    }
    function b() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a, b) {
      Aa = b;
      Z = a;
      l(
        '<img src="' +
          cc.options.assetsurl +
          alliances.userData.strings.header_image_are_you_sure +
          '" style="vertical-align:middle;">',
        _.template(alliances.userData.strings.promote_confirmation, {
          name: b,
        }),
        alliances.userData.strings.button_promote_user,
        function () {
          c();
        }.bind(this)
      );
    };
    return a;
  })();
  var Ba = null,
    fa;
  fa = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? ((alliances.userData.credits = a.balance),
          cc.sendToSwf("callbackshiny", JSON.encode({ credits: a.balance })),
          z(),
          (y = null),
          alliances.visible &&
            (l(
              '<img src="' +
                cc.options.assetsurl +
                alliances.userData.strings.header_image_purchase_successful +
                '" style="vertical-align:middle;">',
              _.template(
                alliances.userData.strings.message_purchase_successful,
                { powerup: alliances.userData.strings[Ba.name] }
              ),
              alliances.userData.strings.button_purchase_successful,
              function () {
                k();
                jQuery("#tabs").tabs("select", N);
              }
            ),
            new E().execute()))
        : a.error == "funds"
        ? ga()
        : f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a, i) {
      Ba = a;
      alliances.userData.credits < i * a.hourly_cost
        ? ga()
        : (k(),
          jQuery.ajax({
            url: h(
              "/alliance/purchasepowerup?" +
                ("powerup_id=" + a.powerup_id + "&purchase_hours=" + i)
            ),
            dataType: "text",
            success: c.bind(this),
            error: d.bind(this),
          }));
    };
    return a;
  })();
  var Ca, Da;
  Da = (function () {
    function a() {}
    function c(a) {
      a = JSON.parse(a);
      a.error === void 0
        ? (k(),
          l(
            '<img src="' +
              cc.options.assetsurl +
              alliances.userData.strings.header_image_join_request_sent +
              '" style="vertical-align:middle;">',
            alliances.userData.strings.join_request_sent
          ),
          o({ n: "requestjoin", v: Ca }))
        : f(a.error);
    }
    function d() {
      f(alliances.userData.strings.error_generic_error);
    }
    a.prototype.execute = function (a) {
      Ca = a;
      jQuery.ajax({
        url: h("/alliance/requestjoin?alliance_id=" + a),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var G = "",
    A;
  A = (function () {
    function a() {}
    function c(b) {
      jQuery("#search-results-table").empty();
      var c =
        "<thead>" + jQuery("#alliance-header-template").html() + "</thead>";
      jQuery("#search-results-table").append(c);
      var d = jQuery("<tbody></tbody");
      jQuery("#search-results-table").append(d);
      jQuery("#search-results-paging").empty();
      var g = JSON.parse(b);
      if (g.error === void 0 && g.totalResults > 0) {
        if (g.totalResults > g.pageSize) {
          var f = parseInt(g.page, 10) + 1,
            b = Math.ceil(
              parseInt(g.totalResults, 10) / parseInt(g.pageSize, 10)
            );
          f > b && (f = parseInt(b, 10));
          var c = jQuery("<div />").css({ float: "right" }),
            j;
          f > 1
            ? ((j = jQuery(
                '<a href="javascript:void(0);" class="pageEnabledButton" style="float:left;"></a>'
              )),
              j.text("<<"),
              j.click(function () {
                new a().execute(f - 2, g.search);
              }))
            : ((j = jQuery(
                '<a href="javascript:void(0);" class="pageDisabledButton" style="float:left;"></a>'
              )),
              j.text("<<"));
          c.append(j);
          for (var h = 0, h = 1; h <= b; h++) {
            var n = h - 1;
            h == f
              ? ((j =
                  '<a href="javascript:void(0);" class="pageDisabledButton" style="float:left;">' +
                  h +
                  "</a>"),
                (j = jQuery(j)))
              : ((j =
                  '<a href="javascript:void(0);" class="pageEnabledButton" style="float:left;">' +
                  h +
                  "</a>"),
                (j = jQuery(j)),
                j.click(
                  (function (b, c) {
                    return function () {
                      new a().execute(b, c);
                    };
                  })(n, g.search)
                ));
            c.append(j);
          }
          f < b
            ? ((j = jQuery(
                '<a href="javascript:void(0);" class="pageEnabledButton" style="float:left;"></a>'
              )),
              j.text(">>"),
              j.click(function () {
                new a().execute(f, g.search);
              }))
            : ((j = jQuery(
                '<a href="javascript:void(0);" class="pageDisabledButton" style="float:left;"></a>'
              )),
              j.text(">>"));
          c.append(j);
          jQuery("#search-results-paging").append(c);
        }
        jQuery.each(g.alliances, function (a, b) {
          b.row_class = a % 2 === 0 ? "alternating0" : "alternating1";
          b.image_tag =
            '<img src="' +
            p(b.image, "small") +
            '" width="25" height="25" style="padding:0px;margin:0px;float:left;margin-right:5px;position:relative;">';
          g.local === !0 && (b.rank = b.sector_rank);
          var c = r();
          b.relationship_id = c;
          b.alliance_id == alliances.userData.allianceid
            ? ((b.relation_div_class = "relationship-friendly"),
              (b.row_class = "alternating-me"))
            : b.relationship == "friendly"
            ? (b.relation_div_class = "relationship-friendly")
            : b.relationship == "neutral"
            ? (b.relation_div_class = "relationship-neutral")
            : b.relationship == "hostile" &&
              (b.relation_div_class = "relationship-hostile");
          var f = r(),
            i = r(),
            j = r();
          b.name_id = f;
          b.actions_id = j;
          b.leader_name_id = i;
          rowString = alliances.templates.rowTemplate(b);
          d.append(rowString);
          jQuery("#" + f).text(b.name);
          jQuery("#" + i).text(b.leader_name);
          jQuery("#" + f).shorten({ width: 175 });
          jQuery("#" + i).shorten({ width: 90 });
          b.alliance_id == alliances.userData.allianceid
            ? jQuery("#" + j).css({ display: "none" })
            : jQuery("#" + j).click(function (a) {
                a.stopPropagation();
                m();
                var d;
                alliances.userData.changeRelationship
                  ? ((d =
                      '<img src="' +
                      p(b.image, "small") +
                      '" width="25" height="25" style="padding:0px;margin:0px;float:left;margin-right:5px;position:relative;">'),
                    (d = _.template(
                      jQuery("#leader-browse-alliance-actions").html(),
                      { image_tag: d }
                    )))
                  : (d = jQuery("#browse-alliance-actions").html());
                jQuery("body").append(d);
                jQuery("#request-button", "#actionsBox").click(function () {
                  a.stopPropagation();
                  new Da().execute(b.alliance_id);
                  m();
                });
                jQuery("#visit-button", "#actionsBox").click(function () {
                  a.stopPropagation();
                  m();
                  cc.openLeaderBase(b.leader_user_id, b.leader_base_id);
                  alliances.hideAlliancesDialog();
                });
                d = jQuery(this).offset();
                jQuery("#actionsBox").css("top", d.top + 6);
                jQuery("#actionsBox").css("left", d.left - 35);
                jQuery("#actionsBox").topZIndex({ increment: 10 });
                jQuery("#actionsBox").click(function (a) {
                  a.stopPropagation();
                });
                alliances.userData.changeRelationship &&
                  (jQuery(".relationship-hostile", "#actionsBox").click(
                    function () {
                      a.stopPropagation();
                      var d = _.template(
                        alliances.userData.strings
                          .relationship_change_hostile_text,
                        { alliance: b.name }
                      );
                      m();
                      l(
                        '<img src="' +
                          cc.options.assetsurl +
                          alliances.userData.strings.header_sticks_and_stones +
                          '" style="vertical-align:middle;">',
                        d,
                        alliances.userData.strings.button_ok,
                        function () {
                          k();
                          new P().execute("hostile", b.alliance_id, c);
                        }
                      );
                    }
                  ),
                  jQuery(".relationship-neutral", "#actionsBox").click(
                    function () {
                      a.stopPropagation();
                      new P().execute("neutral", b.alliance_id, c);
                      m();
                    }
                  ),
                  jQuery(".relationship-friendly", "#actionsBox").click(
                    function () {
                      a.stopPropagation();
                      var d = _.template(
                        alliances.userData.strings
                          .relationship_change_friendly_text,
                        { alliance: b.name }
                      );
                      m();
                      l(
                        '<img src="' +
                          cc.options.assetsurl +
                          alliances.userData.strings.header_united_we_stand +
                          '" style="vertical-align:middle;">',
                        d,
                        alliances.userData.strings.button_ok,
                        function () {
                          k();
                          new P().execute("friendly", b.alliance_id, c);
                        }
                      );
                    }
                  ));
                jQuery("#actionsBox").fadeIn("250");
                return !1;
              });
        });
      } else
        (b = jQuery(
          '<tr><td colspan="8" class="noResults">' +
            alliances.userData.strings.status_no_results +
            "</td></tr>"
        )),
          jQuery("#search-results-table").append(b);
      jQuery("#search-indicator").css("display", "none");
    }
    function d() {
      jQuery("#search-results-table").empty();
      var a =
        "<thead>" + jQuery("#alliance-header-template").html() + "</thead>";
      jQuery("#search-results-table").append(a);
      a = jQuery("<tbody></tbody");
      jQuery("#search-results-table").append(a);
      jQuery("#search-results-paging").empty();
      a = jQuery(
        '<tr><td colspan="8" class="noResults">' +
          alliances.userData.strings.status_no_results +
          "</td></tr>"
      );
      jQuery("#search-results-table").append(a);
      jQuery("#search-indicator").css("display", "none");
    }
    a.prototype.execute = function (a, f, e) {
      jQuery("#search-indicator").css("display", "inline");
      var g = "";
      e === !0 || jQuery("#search-input").val() === "" || f === ""
        ? ((g += "top_ten=true"), (G = ""))
        : ((g += "search="),
          f !== void 0
            ? ((g += f), (G = f))
            : ((g += jQuery("#search-input").val()),
              (G = jQuery("#search-input").val())));
      a !== void 0 && (g += "&page=" + a);
      g += alliances.userData.searchLocal ? "&local=true" : "&local=false";
      jQuery.ajax({
        url: h("/alliance/searchalliances?" + g),
        dataType: "text",
        success: c.bind(this),
        error: d.bind(this),
      });
    };
    return a;
  })();
  var y = null,
    x = null;
  window.pollAllianceShouts = function () {
    x = null;
    new W().execute();
  };
  var xa;
  xa = (function () {
    function a() {}
    a.prototype.parse = function (a, d) {
      d || (d = Math.round(new Date().getTime() / 1e3));
      for (
        var b = [], f = parseInt(a.serverTime, 10), e = d - f, g = 0;
        g < a.powerups.length;
        g++
      ) {
        var h = a.powerups[g],
          j = {};
        j.powerup_id = h.powerup_id;
        j.type = h.type;
        j.total_recharge_time = parseInt(h.total_recharge_time, 10);
        j.total_running_time = parseInt(h.total_running_time, 10);
        j.hourly_cost = parseInt(h.hourly_cost, 10);
        j.image = h.type + "_icon";
        j.name = h.type + "_name";
        j.description = h.type + "_description";
        j.headerImage = "header_image_purchase_" + h.type;
        var k = f - parseInt(h.last_activated_at, 10);
        k < parseInt(h.total_running_time, 10)
          ? ((j.active = !0),
            (j.endTime =
              parseInt(h.last_activated_at, 10) +
              e +
              parseInt(h.total_running_time, 10)))
          : ((j.active = !1),
            (h =
              parseInt(h.total_running_time, 10) +
              parseInt(h.total_recharge_time, 10) -
              k -
              parseInt(h.purchased_time, 10)),
            h < 0 && (h = 0),
            (j.endTime = f + e + h));
        b.push(j);
      }
      return b;
    };
    return a;
  })();
  window.alliances = new ma();
})();
