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
		ProgressAnimate(100);
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
/**
 * 显示loading
 */
function showLoading(){
	if(getParam("plat") == "android"){
		window.jsObj.showLoading();	
	}else{
		$("#isLoadComplete").html("<iframe scrolling='no' src='showLoading://data?' frameborder='0'></iframe>");
	}
}
/**
 * 隐藏loading
 */
function hideLoading(){
	if(getParam("plat") == "android"){
		window.jsObj.hideLoading();	
	}else{
		$("#isLoadComplete").html("<iframe scrolling='no' src='hideLoading://data?' frameborder='0'></iframe>");
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
            beforeSend:function(){
                $(".loading").show();
                var numTime = 1000;
                var time10 = setInterval(function(){
                    numTime--;
                    if(numTime==0){
                        SubmitAlert('网络异常  请稍后！');
                        clearInterval(time10);
                    }
                    if($('#city option').length>1){
                        $('.loading').hide();
                        clearInterval(time10);
                    }
                },10);
            },
			success:function(msg){
                $(".loading").hide();
				if(msg.errmsg == "ok"){
				//	<option value="">请选择</option>    
					var data = msg.result;
					if(data.length > 0 ){
						var istring = '';
						for(var i=0; i< data.length; i++){
							istring += '<option value="'+data[i]+'">'+data[i]+'</option>';
						}
						$("#city").append(istring);	
					}
				//	console.log(data);
				}
			}
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
					var data =msg.result;
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
			}
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

/* 
用途：检查输入字符串是否符合电话格式
输入：
s：字符串 010-20123251-2356
返回：
如果通过验证返回true,否则返回false
*/
function isPhone(phone){
   var p1 = /^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{0,4}))?$/;
   if (p1.test(phone)) {
       return true;
   }
   else {
       return false;
   }
}

/* 
用途：检查输入字符串是否符合正整数格式
输入：
s：字符串
返回：
如果通过验证返回true,否则返回false
*/
function isNumber(s){
   var regu = "^[0-9]+$";
   var re = new RegExp(regu);
   if (s.search(re) != -1) {
       return true;
   }
   else {
       return false;
   }
}
/**
 中文 英文大小写 数字 中划线 下划线 空格 全角
 */
function isChinaOrNumbOrLett(s){
    var regu = "^[0-9a-zA-Z\u4e00-\u9fa5\uFE30-\uFFA0\-_\. ]+$";
    var re = new RegExp(regu);
    if (re.test(s)) {
        return true;
    }
    else {
        return false;
    }
}



