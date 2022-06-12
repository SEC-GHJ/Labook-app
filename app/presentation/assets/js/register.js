function getschool(){
    var schoolElement = document.getElementById("ori-select").value;
    console.log(schoolElement);
}

function getschool(){
    var schoolElement = document.getElementById("ori-select").value;
    for (var school of undergraduate_info){
      if (schoolElement==school){
          for (var depart in school['department']){
            getElementById("depart-select").innerHTML=depart;
            console.log(depart);
          }

      }
    }
}
