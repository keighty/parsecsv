var removeButtons = document.getElementsByClassName('remove-button')

function addToMatched(el) {
  var data = el.dataset.line
  console.log('data: ', data)
  var xhr = new XMLHttpRequest()
  xhr.open('POST', '/addItem', true)
  xhr.send(data)
}
