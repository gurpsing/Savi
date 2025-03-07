function GetUniqueElements(CommaSeperatedString) {
var StringArray = CommaSeperatedString.split(',');
var RemoveDuplicate = StringArray.filter((item,index) => StringArray.indexOf(item) === index);
var Apos = "&apos;&apos;";
var FinalArray1 = RemoveDuplicate.filter((str) => str.indexOf(Apos) === -1 );
var Quote = "''";
var FinalArray = FinalArray1.filter((str) => str.indexOf(Quote) === -1 );
return FinalArray;
}