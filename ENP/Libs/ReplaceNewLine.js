function replaceNewLine(inputString){

        var stringToReplace = inputString.replace(/\n/gi,function (x) {return ("~");});
		stringToReplace  = inputString.replace(/\n/g, ".");
        return stringToReplace;
}