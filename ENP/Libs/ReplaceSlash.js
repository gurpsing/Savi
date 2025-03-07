function replaceSlash(inputString){

        var stringToReplace = inputString.replace(/\//gi,function (x) {return ("~");});
        stringToReplace  = stringToReplace.replace(/\#/g, ".");
        return stringToReplace;

}