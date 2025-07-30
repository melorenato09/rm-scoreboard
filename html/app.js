QBScoreboard = {};

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QBScoreboard.Open(event.data);
                break;
            case "close":
                QBScoreboard.Close();
                break;
        }
    });
});

QBScoreboard.Open = function(data) {
    $(".scoreboard-block").fadeIn(150);
    $("#total-players").html("<p>"+data.players+"/"+data.maxPlayers+"</p>");

    // Mostrar número de polícias
    var policeBeam = $(".scoreboard-info").find('[data-type="police"]');
    var policeStatus = $(policeBeam).find(".info-beam-status");
    $(policeStatus).html(`<span>${data.currentCops} </span>`);

    // Mostrar número de ambulâncias
    var ambBeam = $(".scoreboard-info").find('[data-type="ambulance"]');
    var ambStatus = $(ambBeam).find(".info-beam-status");
    $(ambStatus).html(`<span>${data.currentAmbulance} </span>`);

    // Mostrar número de mecânicos
    if (data.currentMechanic !== undefined) {
        var mechBeam = $(".scoreboard-info").find('[data-type="mechanic"]');
        var mechStatus = $(mechBeam).find(".info-beam-status");
        $(mechStatus).html(`<span>${data.currentMechanic} </span>`);
    }
}

QBScoreboard.Close = function() {
    $(".scoreboard-block").fadeOut(150);
}
