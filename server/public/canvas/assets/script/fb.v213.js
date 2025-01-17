var page = $H({
	canvasHeight: 22,
	init: function()
	{
		//this.setHeight();
	},
	updateHeight: function()
	{
		this.canvasHeight = $('body').getScrollSize().y.toInt();
		this.setHeight();
	},
	addHeight: function(height)
	{
		if(this.canvasHeight < 1) this.canvasHeight = $('body').getScrollSize().y.toInt();
		this.canvasHeight += height;
		this.setHeight();
	},
	setHeight: function()
	{
		FB.CanvasClient.setCanvasHeight(this.canvasHeight+'px');
	}
});

function recordStats(event,cprops)
{
	var props = {
		userid: user.id,
		ip: user.ip,
		fbid: user.uid
	};
	if($type(cprops) == 'string' && cprops.length > 0) cprops = JSON.decode(cprops);
	if($type(cprops) == 'object')
	{
		for(var i in cprops) props[i] = cprops[i];
	}
	try{
		_kmq.push(['record', event, props]);
	} catch(err){}
}

function openbase(userid)
{
	return cc.openBase(userid);
}

function reloadPage()
{
	window.top.location = cc.options.baseurl;
}

function loadPage(page)
{
	window.top.location = baseurl+page;
}

function openUrl(url)
{
	window.open(url);
}

function getFBCredits(callback)
{
	FB.Bootstrap.requireFeatures(["Payments"], function() {
		callback(new FB.Payments());
	});
}

function requestBookmark(callback)
{
	FB.Bootstrap.requireFeatures(["CanvasUtil","Api","Connect"], function() {
		FB.Connect.showBookmarkDialog(function(){ if(callback){ Swiff.remote($('gameswf'),callback); } });
	});
}

function requestEmailPerms(ingame)
{
	FB.Bootstrap.requireFeatures(["CanvasUtil","Api","Connect"], function() {
		FB.Connect.showPermissionDialog('email',(ingame?allowPermIngame:allowPermRedir))
	});
}
function allowPerm(perms,onComplete)
{
	new Request({url:localurl+'session',onComplete:function(){ if(onComplete) onComplete.run(perms); }}).send('func=update&key=allowperm&value='+perms+'&'+fbdata);
}
function allowPermRedir(perms)
{
	var allow = 0;
	if(perms && perms.length > 0)
	{
		perms = perms.split(',');
		if(perms.length > 0) for(var i in perms) if(perms[i] == 'email') allow = 1;
	}
	if(allow) recordStats('emailsignup-action',{'allow':1});
	else recordStats('emailsignup-action',{'deny':1});
	allowPerm(perms,function(){ window.top.location = baseurl; });
}
function allowPermIngame(perms)
{
	allowPerm(perms,function(perms){
		var allow = 0;
		if(perms && perms.length > 0)
		{
			perms = perms.split(',');
			if(perms.length > 0) for(var i in perms) if(perms[i] == 'email') allow = 1;
		}
		Swiff.remote($('gameswf'),'checkEmailPerm',[allow]);
		if(allow) recordStats('emailsignup-ingame',{'allow':1});
		else recordStats('emailsignup-ingame',{'deny':1});
	});
}

function updateUserData()
{
	try{
		FB.Bootstrap.requireFeatures(["CanvasUtil","Api","Connect"], function()
		{
			FB.Facebook.apiClient.users_getInfo([user.uid],['birthday_date','current_location','sex'],function(data)
			{
				try{
					if(data[0])
					{
						data = JSON.encode(data[0]);
						new Request({url:localurl+'api/player/updateuserdata'}).send('userdata='+data+'&'+fbdata);
					}
				} catch(e){}
			});
		});
	} catch(e){}
}
