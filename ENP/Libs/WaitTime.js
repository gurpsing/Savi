function wait(milliseconds) {
var start = new Date().getTime();
while (true) {
if ((new Date().getTime() - start) > milliseconds){
 break;
}
}
return start;
} 