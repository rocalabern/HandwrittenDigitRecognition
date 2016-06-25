shinyjs.exportCanvas = function(params) {
  var canvas = document.getElementById("tools_sketch");

  dummyCanvas = document.createElement("canvas");
  dummyCanvas.width = canvas.width;
  dummyCanvas.height = canvas.height;
  ctx = dummyCanvas.getContext('2d');
  ctx.fillStyle = "#FFFFFF";
  ctx.fillRect(0,0,canvas.width,canvas.height);
  ctx.drawImage(canvas, 0, 0);

  var image = dummyCanvas.toDataURL('image/png', 1);

  Shiny.onInputChange("jstextPNG", image);
}