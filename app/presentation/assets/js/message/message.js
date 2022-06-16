console.log('message.js loaded');
$(document).load(function () {
    var log = $('.chat-history');
    log.animate({ scrollTop: log.prop('scrollHeight')}, 1000);
});