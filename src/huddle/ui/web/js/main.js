$(function() {

	function getQueryVariable(variable) {
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return(false);
	}

	//$("#message").html(getQueryVariable("msg"));

	setTimeout(function() {
		$('#message').fadeIn(3000);
	}, 2000);

  if ($('#message2').length) {
    setTimeout(function() {
      $('#message').fadeOut(1000);
      setTimeout(function() {
        $('#message2').fadeIn(3000);
      }, 1000)
    }, 30000);
  }

});