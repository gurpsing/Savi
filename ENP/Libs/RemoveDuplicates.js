function removeDuplicateElements(CommaSeperatedString) {
var StringArray = CommaSeperatedString.split(',');
var Result = StringArray.filter((item,index) => StringArray.indexOf(item) === index);
var  FinalArray=Result.join(",");
return FinalArray;
}