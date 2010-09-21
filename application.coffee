cls = $('div.specimen-editor textarea').attr('class') unless cls
$("link[charset]").remove()
$("body").children().remove()
$("body").append(templates["glassy"])
$($("body").children("div")[0]).find("*").addClass cls
