cls = $('div.specimen-editor textarea').attr('class')
$("link[charset]").remove()
$("body").children().remove()
$("head").append(templates["embedded_img"]["head"])
$("body").append(templates["embedded_img"]["body"])
$($("body").children("div")[0]).find("*").addClass cls