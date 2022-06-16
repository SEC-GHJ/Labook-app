console.log('register.js loaded');
function getschool(undergraduate_info){
  // console.log('in func');
  // console.log(undergraduate_info);
  var schoolElement = document.getElementById("ori-select").value;
  var departmentElement = document.getElementById('depart-select');
  while (departmentElement.firstChild) {
    departmentElement.removeChild(departmentElement.firstChild);
  }
  // console.log(schoolElement);
  for (school in undergraduate_info){
    // console.log(schoolElement===undergraduate_info[school].school);
    if (schoolElement===undergraduate_info[school].school){
      for (depart in undergraduate_info[school].department){
        var option = document.createElement("option");
        option.value = undergraduate_info[school].department[depart];
        option.text = undergraduate_info[school].department[depart];
        option.className = "dropdown-item";
        departmentElement.appendChild(option);
      }
      break;
    }
  }
}
