function addToMatched(el, index) {
  var data = el.dataset.line

  var xhr = new XMLHttpRequest()
  xhr.open('POST', '/addItem', true)
  xhr.send(data)

  // move element
  var newParent = document.getElementById('matched_table');
  var tr = document.querySelector("tr[data-id='"+ index +"']")
  newParent.appendChild(tr)
}
