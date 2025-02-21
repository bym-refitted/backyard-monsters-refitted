jQuery.noConflict();
		(function($) {
			//////////////////////////////////////
// adk.interstitial.jquery.01.09.js
// (c) 2010 Adknowledge Inc.
//////////////////////////////////////

if(typeof(adk) == "undefined" || !adk) {
  adk = {};
}

adk.interstitial = {
  version: "j1.09",
  modalContainerLabel: "adk_interstitial_container",
  modalContainerId: "#adk_interstitial_container",
  modalID: "#adk_interstitial_modal",
  confirmID: "#adk_btn_confirm",
  closeID: "#adk_btn_close",
  closeID2: "#adk_btn_close2",
  closeTextID: "#adk_btn_close_text",
  videoID: "#adk_ofr_video",
  videoTnID: "#adk_video_tn",
  tnID: "#adk_ofr_tn",
  ofrTitleID: "#adk_ofr_title",
  ofrDescID: "#adk_ofr_desc",
  ofrFootID: "#adk_ofr_content_footer",
  bodyID: "#adk_modal_body",
  completeID: "#adk_modal_complete",
  footID: "#adk_footer",
  
	json_url: "http://overlay.suparewards.com/tools/get_interstitial?",
	content_url: "http://overlay.suparewards.com/tools/get_interstitial_content?"
};

adk.interstitial.prototype =
{
    init: function(gameID, h, uid, showEmpty, collateral, callback) {
			this._h = h;
			this._uid = uid;
			this._gameID = "#"+gameID;
			this._showEmpty = (showEmpty == null) ? false : showEmpty;
			this._collateral = (collateral == null) ? false : collateral;
			this._callback = (callback == null) ? false : callback;
			
			this._init = false;
			if(!this._h || !this._uid) {
				// console.log("adk.interstitial.init(): A required param is not set.");
			} else {
				this._init = true;
			}
    },
    
    displayModal: function(gameID, h, uid, showEmpty, collateral, callback) {
    	adk.interstitial.prototype.init(gameID, h, uid, showEmpty, collateral, callback);
    	
    	if(this._init && ( (null == $(adk.interstitial.modalID)) || (!$(adk.interstitial.modalID).length)) ){
    		var json_params = "h="+this._h+"&uid="+this._uid+"&v="+adk.interstitial.version;
    		if(this._collateral) json_params += "&collateral="+this._collateral;
    		json_params += "&callback=?";
    		
    		$.getJSON(adk.interstitial.json_url + json_params, function(obj) {
    			adk.interstitial._o_returned = obj.o_returned;
    			if(adk.interstitial.prototype._showEmpty == false && obj.o_returned == false) {
    		    // console.log("adk.interstitial.displayModal(): No available offer.");
				} 
    			else {
						var new_adk_div = $("<div/>");
						new_adk_div.attr("id", adk.interstitial.modalContainerLabel);
						new_adk_div.html(obj.data);
						$(document.body).append(new_adk_div);
					  
						var adk_confirm = $(adk.interstitial.confirmID);               
						var adk_close = $(adk.interstitial.closeID);
						var adk_close2 = $(adk.interstitial.closeID2);
											
						if(adk_close) adk_close.live("click", function() { adk.interstitial.prototype.closeModal(); });
						if(adk_close2) adk_close2.live("click", function() { adk.interstitial.prototype.closeModal(); });

						if(adk_confirm) {
							switch (obj.type){
								case "video": 
									adk.interstitial.prototype._c_url = obj.c_url;
									adk.interstitial.prototype._ct = obj.ct;
									adk.interstitial.prototype._cm = obj.cm;
									adk.interstitial.prototype._ci = obj.ci;
									adk.interstitial.prototype._ch = obj.ch;
									adk.interstitial.prototype._cl = obj.cl;
									adk_confirm.live("click", function() { adk.interstitial.prototype.playVideo(); });
									break;
								default: 
									adk_confirm.live("click", function() { adk.interstitial.prototype.showComplete(); });
									break;
							}
						}
						
						adk.interstitial.prototype.alignModal();
					}
    		});
    		
    	}
    },
    
    playVideo: function() {
    	if (adk.interstitial._o_returned){

    		var adk_modal = $(adk.interstitial.modalID);
	  		var adk_confirm = $(adk.interstitial.confirmID);
	  		var adk_close = $(adk.interstitial.closeID);
	  		var adk_close_text = $(adk.interstitial.closeTextID);
	  		var adk_video = $(adk.interstitial.videoID);
	  		var adk_oDesc = $(adk.interstitial.ofrDescID);
	  		var adk_oFoot = $(adk.interstitial.ofrFootID);
	  		var adk_foot = $(adk.interstitial.footID);
	  		
	  		if(adk_modal) adk_modal.addClass("adk_play_video");
	  		if(adk_confirm){
	  			adk_confirm.live("click", function(){});
	  			adk_confirm.hide();
	  		}
	  		if(adk_close) adk_close.addClass("adk_lonely_btn");
	  		if(adk_close_text) adk_close_text.text("close");
	  		if(adk_oDesc) adk_oDesc.hide();
	  		if(adk_oFoot) adk_oFoot.hide();
	  		if(adk_foot) adk_foot.hide();
				if(adk_video){ 
					var content_params = "h="+adk.interstitial.prototype._h+"&uid="+adk.interstitial.prototype._uid+"&ch="+adk.interstitial.prototype._ch+"&cm="+adk.interstitial.prototype._cm+"&ci="+adk.interstitial.prototype._ci+"&ct="+adk.interstitial.prototype._ct+"&cl="+adk.interstitial.prototype._cl;
					adk_video.html('<iframe id="adk_video_iframe" src="'+adk.interstitial.content_url+content_params+'" scrolling="no" frameborder="0" width="480"></iframe>');
				}
    	}
    	else{
    		if(adk_video) adk_video.html("This video is not available.");
    	}
    	adk.interstitial.prototype.alignModal();
    },
    
    closeModal: function() {
    	if($(adk.interstitial.modalContainerId)) $(adk.interstitial.modalContainerId).remove();
    	if(adk.interstitial.prototype._callback) adk.interstitial.prototype._callback();
    },
    
    showComplete: function() {
    	if($(adk.interstitial.bodyID)) $(adk.interstitial.bodyID).hide();
    	if($(adk.interstitial.completeID)) $(adk.interstitial.completeID).show();
    },

    alignModal: function() {
    	var game = $(this._gameID);
    	var game_pos = game.position();
    	var adk_modal = $(adk.interstitial.modalID);
    	var adk_modal_pos = adk_modal.position();
    	
    	var adk_modal_height = (adk_modal.height() > 0) ? adk_modal.height() : 300;
    	
    	var h_pos = Math.floor((game_pos.left + (game.width() / 2) - (adk_modal.width() / 2)));
    	var v_pos = Math.floor((game_pos.top + (game.height() / 2) - (adk_modal_height / 2)));
    	
    	if (h_pos < 0) h_pos = 0;
    	if (v_pos < 0) v_pos = 0;
    	
    	adk_modal.css({left:h_pos+"px", top:"80px"});	
    }
    
};

		})(jQuery);