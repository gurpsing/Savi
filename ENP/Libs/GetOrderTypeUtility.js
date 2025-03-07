
function getOrderType(orderDetails,orderType) {

    var retunrVal = "";
    var orderTypeToFind = orderType + "-";

     if(orderDetails.indexOf(orderTypeToFind) !=-1 ){

        var splittedRecord = orderDetails.split(",");  
        var i = 0;
        
        for (; i < splittedRecord.length; i++) {

            var indexOfOrderType = splittedRecord[i].indexOf(orderTypeToFind);

            if(indexOfOrderType != -1 ){
                retunrVal = splittedRecord[i].substring(indexOfOrderType+orderTypeToFind.length);
                break;
            }
        }
    }

    return retunrVal;
}

//console.log(getOrderType("o1-o1val,o2-o2val,o3-o3val","o4"));