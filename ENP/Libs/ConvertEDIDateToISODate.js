function convertEDIDateToISODate(date){  

	var convertedDate = "";
	if(date.length > 0){
		var year = date.substring(0, 4);
		var month = date.substring(4, 6);
		var day = date.substring(6, 8);
		 convertedDate = year + '-' + month + '-' + day;//+'T00:00:00.000+00:00';
	}
	
	return convertedDate;  
}