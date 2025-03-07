function transformJson(inputJson) {
    inputJson = inputJson.replace(/\]\[/g, ",");
    var input = JSON.parse(inputJson);
    var output = [];
    for (var i = 0; i < input.length; i++) {
        var obj = input[i];
        var added = false;
        for (var j = 0; j < output.length; j++) {
            if (output[j].sku == obj.item_id__item_alternate_code) {
                snslist = output[j].sn;
                snslist.push(obj.serial_nbr);
                added = true;
                break;
            }
        }
        if (added == false) {
            var resultObj = {};
            var sns = [];
            sns.push(obj.serial_nbr);
            resultObj["sku"] = obj.item_id__item_alternate_code;
            resultObj["sn"] = sns;
            output.push(resultObj);
        }
    }
    var outputJson = JSON.stringify(output);
    return outputJson;
}