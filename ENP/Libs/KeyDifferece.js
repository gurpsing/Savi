function ArrayDifference(BIP_String,SFDC_String){
var BIP_Array = BIP_String.split(','); // [1, 2, 3, 4]
var SFDC_Array = SFDC_String.split(','); // [3, 4];
var Minus_Array = BIP_Array.filter(function(x) {
if(SFDC_Array.indexOf(x) != -1)
return false;
else
return true;
});
var returnString = Minus_Array.toString();
return returnString;
}