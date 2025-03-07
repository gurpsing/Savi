function truncateBefore  (str, pattern) {
    return str.slice(str.indexOf(pattern) + pattern.length);
}
function truncateAfter(str, pattern) {
    return str.slice(0, str.indexOf(pattern));
} 

function parseFaultForOrders(faultStringInput){

    var orderNumbers = "<orderStatus>";

    const instanceTagStart = "<nstrgdfl:instance>";      
    const instanceTagEnd = "</nstrgdfl:instance>";      


    const errorStartTag = "&lt;error&gt;"; 

    const stringToParse =   truncateAfter( truncateBefore( faultStringInput,  instanceTagStart), instanceTagEnd) ;

    var errors = stringToParse.split(errorStartTag);

    if(errors.length > 1) { 
        var i=1; 
        for ( ; i < errors.length; i++) {


            var key = truncateAfter( truncateBefore( errors[i],  "&lt;key&gt;"), "&lt;/key&gt;");
            var msg = truncateAfter( truncateBefore( errors[i],  "&lt;msg&gt;"), "&lt;/msg&gt;");

            var orderTag = "<order><orderNumber>"+ key + "</orderNumber><errorMsg>"+ msg.replace(/\r?\n|\r/g, "") +"</errorMsg></order>";

            orderNumbers+=orderTag;
        }
    }else{
   
        var errors = stringToParse.split("<error>");

        if(errors.length > 1) { 
            var i=1; 
            for ( ; i < errors.length; i++) {
    
                var key = truncateAfter( truncateBefore( errors[i],  "<key>"), "</key>");
                var msg = truncateAfter( truncateBefore( errors[i],  "<msg>"), "</msg>");
    
                var orderTag = "<order><orderNumber>"+ key + "</orderNumber><errorMsg>"+ msg +"</errorMsg></order>";
    
                orderNumbers+=orderTag;
            }
        }else{
            var errors = stringToParse.split("&lt;error>");

            if(errors.length > 1) { 
                var i=1; 
                for ( ; i < errors.length; i++) {
        
                    var key = truncateAfter( truncateBefore( errors[i],  "&lt;key>"), "&lt;/key>");
                    var msg = truncateAfter( truncateBefore( errors[i],  "&lt;msg>"), "&lt;/msg>");
        
                    var orderTag = "<order><orderNumber>"+ key + "</orderNumber><errorMsg>"+ msg +"</errorMsg></order>";
        
                    orderNumbers+=orderTag;
                }
            }
        }
    }

    orderNumbers+="</orderStatus>";

    return orderNumbers;
}

