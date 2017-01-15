function show_top_alert_message(type, message) {
	console.log("type",type)
	console.log("message",message)
    if (!type)
        type = 'success';
    if (type == 'error')
        type = 'danger';
    $('.top-alert-box').remove();

    var html = '<div class="top-alert-box"><div class="alert alert-' + type + '">' + message +
        '<div class="close">x</div></div></div>';
    $(document.body).append(html);
    var alert = $($('.top-alert-box')[0]);
    alert.animate({top: 10}, 300).click(function () {
        $(this).animate({top: -30 - $(this).height()}, 300, function () {
            $(this).remove();
        });
    });
    setTimeout(function () {
        alert.animate({top: -30 - alert.height()}, 300, function () {
            alert.remove();
        });
    }, 5000);
}	