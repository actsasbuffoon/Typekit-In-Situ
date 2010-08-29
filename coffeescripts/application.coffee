cls = $('div.specimen-editor textarea').attr('class')
$("body").children().remove()
$("body").append(templates["temp2"])
$($("body").children("div")[0]).find("*").addClass cls