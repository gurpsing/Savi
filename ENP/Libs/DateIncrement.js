function dateIncrement(date, days) {
 date = new Date(date);
 var newDate = date.setDate(date.getDate() + Number(days));
 newDate = new Date(newDate);
 newDate = newDate.toISOString().split('T')[0];
 return newDate
}