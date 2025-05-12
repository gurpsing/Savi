function nodesToCSV(nodes) {
  let values = [];
  for (let i = 0; i < nodes.length; i++) {
    values.push(nodes[i].textContent.trim());
  }
  return values.join(',');
}