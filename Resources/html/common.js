var url = 'http://115.29.161.226:85/weixin/jsonapi';
function ProgressAnimate(num){
	var oi = 0; 
	var tTimeout = null; 
	var timeOut = 1800;
	var getw = $("#progressbox").width();
	var sj= getw * (num/100); 
		$("#progressbox>.appmem").animate({left:sj-20},timeOut);
		$(".progressbar").animate({"width":sj},timeOut);
		var ct = timeOut / num;
		tTimeout = setInterval(function(){oi++; $("#progressNumber").text(oi); if(oi>= num){clearInterval(tTimeout);}},ct)
}

function getParam(para) {
    //获得html上的参数
    querystr = window.location.href.split("?");
	var iparam = "",
    tmp_arr = [];
    if (querystr[1]) {
        var GET1s = querystr[1].split("&");
		for (i = 0; i < GET1s.length; i++) {
            tmp_arr = GET1s[i].split("=");
			if (para == tmp_arr[0]) {
                iparam = tmp_arr[1];
            }
        }

    }
    return iparam;
}


function SubmitAlert(txt){
	
	if(getParam("plat") == "android"){
		window.jsObj.Alert(txt);	
	}else{
		$("#isLoadComplete").html("<iframe scrolling='no' src='showAlert://data?msg="+txt+"' frameborder='0'></iframe>");
	}
}
/*
	* SubmitToApp 方法 是提交数据给app集合体
	*apiName  触发API名称  String
	*SubmitData  数据json对象  Object
*/
function SubmitToApp(apiName,SubmitData){

	if(getParam("plat") == "android"){
		var jsonStringData = JSON.stringify({"route":apiName,"data":SubmitData});
		window.jsObj.GotoSubmitData(jsonStringData);	
	}else{
	//	submit://data?route=evaluationInfo&city=上海&
		var iosUrlString = 'submit://'+apiName+'?';
		$.each(SubmitData,function(i){
				iosUrlString+=i+"="+SubmitData[i]+"&"
		})
		iosUrlString = iosUrlString.substring(0,iosUrlString.length-1);

		$("#isLoadComplete").html("<iframe scrolling='no' src='"+iosUrlString+"' frameborder='0'></iframe>");
	}
}

function AppReturnFun(ReturnFunName,Data){
	ReturnFunName(Data);	
}

function getCity(){
		 var jsonarr = {
            cmd: JSON.stringify({
                "route": "estimateCity",
				"base":{},
				"data":{}
                
            })
        };
		$.ajax({
			//dataType:'jsonp',
			data:jsonarr,
			type:"POST",
			//jsonp:'jsonp_callback',
			dataType:"json",
			url:url,
			success:function(msg){
				if(msg.errmsg == "ok"){
				//	<option value="">请选择</option>    
					var data = eval("("+msg.result+")");
					if(data.length > 0 ){
						var istring = '';
						for(var i=0; i< data.length; i++){
							istring += '<option value="'+data[i]+'">'+data[i]+'</option>';
						}
						$("#city").append(istring);	
					}
				//	console.log(data);
				}
			},
		});	
	}
function SearchFun(o){
	var getValue = $.trim($(o).val());
	if(getValue == ""){
		$("#keywordBox").html('').hide();
		return false; 	
	}
	var jsonarr = {
            cmd: JSON.stringify({
                "route": "district",
				"base":{},
				"data":{keyword:getValue}
                
            })
        };
		$.ajax({
			//dataType:'jsonp',
			data:jsonarr,
			type:"POST",
			//jsonp:'jsonp_callback',
			dataType:"json",
			url:url,
			success:function(msg){
				if(msg.errmsg == "ok"){
				//	<option value="">请选择</option>    
					var data = eval("("+msg.result+")");
					if(data.length > 0 ){
						$("#keywordBox").show();
						var istring = '';
						for(var i=0; i< data.length; i++){
							istring += '<div class="keywordlist" onclick="getSelectFun(this)" val="'+data[i].housename+'">'+data[i].housename+'</div>';
						}
						$("#keywordBox").html(istring);	
					}else{
						$("#keywordBox").hide();
					}
				//	console.log(data);
				}
			},
		});	
}
function getSelectFun(o){
		var getV = $(o).text();
		$("#HouseName").val(getV).blur();
		$("#keywordBox").hide();
}
/**
 * 格式化数据  最后输出格式为 111.12
 */
var record={
    num:""
}
var checkDecimal=function(n){
    var decimalReg=/^\d{0,9}\.{0,1}(\d{1,2})?$/;//var decimalReg=/^[-\+]?\d{0,8}\.{0,1}(\d{1,2})?$/;
    if(n.value!=""&&decimalReg.test(n.value)){
        record.num=n.value;
    }else{
        if(n.value!=""){
            n.value=record.num;
        }
    }
}