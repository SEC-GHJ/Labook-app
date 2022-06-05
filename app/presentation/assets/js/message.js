$(document).load(function () {
    var log = $('.chat-histroy');
    log.animate({ scrollTop: log.prop('scrollHeight')}, 1000);
});