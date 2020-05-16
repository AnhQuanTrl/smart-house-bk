var stompClient = null;

function resetProperties(connected) {
    $("#button-start").prop("disabled", connected);
    $("#button-stop").prop("disabled", !connected);
    if (connected) {
        $("#input-group").show();
        $("#infotext").html("You are connected");
    }
    else {
        $("#input-group").hide();
        $("#infotext").html("You are not connected");
    }

}

function connect() {
    var socket = new SockJS('/messaging');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function (frame) {
        resetProperties(true);
        console.log("reset...");
        stompClient.subscribe('/topic/test/subscription', function (greeting) {
            showMessageOnPage(greeting.body);
        });
    });
}

function disconnect() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
    resetProperties(false);
}

function sendMessage() {
    stompClient.send("/app/test/endpoints", {}, JSON.stringify({'message': $("#message-input").val()}));
}

function showMessageOnPage(message) {
    $("#message").append("" + message + "");
}

$(function () {
    $("form").on('submit', function (e) {
        e.preventDefault();
    });
    resetProperties(false);
    $( "#button-start" ).click(function() { connect(); });
    $( "#button-stop" ).click(function() { disconnect(); });
    $( "#button-send" ).click(function() { sendMessage(); });
});