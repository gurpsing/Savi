function arrayToCSVFunction(arrayValue) {
  var csv = '';
  for (var i = 0; i < array.length; i++) {
    var value = array[i];
    if (typeof value === 'string') {
      value = value.trim();
    }
    csv += value;
    if (i < array.length - 1) {
      csv += ',';
    }
  }
  return csv;
}
