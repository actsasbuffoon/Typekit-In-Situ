cls = $('div.specimen-editor textarea').attr('class')
$("link[charset]").remove()
$("body").children().remove()
$("body").append(templates["image_example"])
$($("body").children("div")[0]).find("*").addClass cls