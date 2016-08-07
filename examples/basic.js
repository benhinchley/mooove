input.forEach(function (file) {
  if (!move(file,file)) {
    console.log("failed to move file")
  }
})
