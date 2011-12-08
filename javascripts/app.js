/* Foundation v2.1.1 http://foundation.zurb.com */
/*$(document).ready(function() {


});*/
/* what an ugly hack */
title = "";
url = "";
function showShareDialog(_title, _url) {
  title = _title;
  url = _url;
  $('#modalSharingTitle').html("'"+_title+"'")
$('#sharingModalDialog').reveal();
}
function share(type) {
	switch(type) {
		case "twitter":
		link = "http://twitter.com/home/?status="+encodeURIComponent(title+": "+url)
		break;
		case "facebook":
		link="http://www.facebook.com/sharer.php?u="+encodeURIComponent(url)
		break;
		case "linkedin":
		link = "http://www.linkedin.com/shareArticle?mini=true&url="+encodeURIComponent(url)+"&title="+encodeURIComponent(title)
		break;
		case "instapaper":
		link = "http://www.instapaper.com/hello2?u="+encodeURIComponent(url)+"&t="+encodeURIComponent(title)+"&s=&a=";
		break;
		case "googleplus":
		link = "https://m.google.com/app/plus/x/?v=compose&content="+encodeURIComponent(title+": "+url)
		break;
	}
	//visit the site now.
	document.location.href=link;
}
