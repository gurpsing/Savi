function replaceKeywordsDot(inputString){
var stringToReplace = inputString.replace(/insert|delete|update|drop|truncate|alter|select|from/gi,function (x) {return (".".concat(x)).concat(".");});
return stringToReplace;
}