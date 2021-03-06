<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>项目列表</title>
    <meta name="description" content="项目、列表、管理、进度">
    <meta name="keywords" content="project,manager,prossce">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="icon" type="image/png" href="${contextPath}/resources/i/favicon.png">
    <link rel="apple-touch-icon-precomposed" href="${contextPath}/resources/i/app-icon72x72@2x.png">
    <meta name="apple-mobile-web-app-title" content="Amaze UI" />
    <link rel="stylesheet" href="${contextPath}/resources/css/amazeui.min.css" />
    <link rel="stylesheet" href="${contextPath}/resources/css/admin.css">
    <link rel="stylesheet" href="${contextPath}/resources/css/app.css">
</head>

<body data-type="generalComponents">
        <div class="tpl-content-wrapper">
            <div class="tpl-portlet-components">
                <div class="portlet-title">
                    <div class="caption font-green bold">
                        <span class="am-icon-code"></span> 
	                       <c:choose>
							   <c:when test="${id==0}"> 
							                           项目添加      
							   </c:when>
							   <c:otherwise>
							    	项目编辑
							   </c:otherwise>
							</c:choose>
                    </div>
                </div>
                <div class="tpl-block ">

                    <div class="am-g tpl-amazeui-form">


                        <div class="am-u-sm-12 am-u-md-9">
                            <form class="am-form am-form-horizontal" onsubmit="return false">
                                <div class="am-form-group">
                                    <label for="user-name" class="am-u-sm-3 am-form-label">项目名称</label>
                                    <div class="am-u-sm-9">
                                        <input type="text" id="title" placeholder="项目名称" required />
                                        <input type="hidden" id="id" />
                                    </div>
                                </div>
                                <div class="am-form-group">
                                    <label for="user-email" class="am-u-sm-3 am-form-label">项目负责人</label>
                                    <div class="am-u-sm-9">
                                        <select  id="principalID" >
										  
										</select>
                                    </div>
                                </div> 
                                <div class="am-form-group">
                                    <label for="user-phone" class="am-u-sm-3 am-form-label">项目组成员</label>
                                    <div class="am-u-sm-9">
                                        <select multiple   id="memberID" required>
										 
										</select>
                                    </div>
                                </div>

                                <div class="am-form-group">
                                    <label for="user-QQ" class="am-u-sm-3 am-form-label">项目开始时间</label>
                                    <div class="am-u-sm-9">
                                       <input type="text" class="am-form-field" placeholder="项目开始时间" id="startTime" data-am-datepicker  required />
                                    </div>
                                </div>

                                <div class="am-form-group">
                                    <label for="user-weibo" class="am-u-sm-3 am-form-label">项目结束时间</label>
                                    <div class="am-u-sm-9">
                                        <input type="text" class="am-form-field" placeholder="项目结束时间" id="endTime" data-am-datepicker required />
                                    </div>
                                </div>

                                <div class="am-form-group">
                                    <label for="user-intro" class="am-u-sm-3 am-form-label">项目简介</label>
                                    <div class="am-u-sm-9">
                                        <textarea class="" rows="5"  placeholder="输入项目简介" id="description" required ></textarea>
                                    </div>
                                </div>

                                <div class="am-form-group">
                                    <div class="am-u-sm-9 am-u-sm-push-3">
                                        <button type="submit" class="am-btn am-btn-primary" id="saveData">保存修改</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>
<script src="${contextPath}/resources/js/jquery.min.js"></script>
<script src="${contextPath}/resources/js/amazeui.min.js"></script>
<script src="${contextPath}/resources/js/app.js"></script>
<script src="${contextPath}/resources/layer/layer.js"></script>
 	<script>
 	$(function(){
 		
 		getAllUser();
 		
 		getProjectInfo();
 		
 		//新增项目按钮绑定
 		$('#saveData').bind('click',function(){
 			var id = $('#id').val();
 			
 			var title = $('#title').val();
 			var principalID = $('#principalID').val();
 			
 			var member = document.getElementById("memberID");
 			var memberID = "";
 		    for(i=0;i<member.length;i++){
 		        if(member.options[i].selected){
 		            memberID+=member[i].value+',';
 		        }
 		    }

 			var startTime = $('#startTime').val();
 			var endTime = $('#endTime').val();
 			var description = $('#description').val();
 			
 			if(title!='' && principalID!='' && memberID!='' && startTime!='' && endTime!='' && description!=''){
 				$.ajax({
 					url:'${contextPath}/project/insertProject',
 					type:'post',
 					dataType:'json',
 					data:{'id':id,'title':title,'principalID':principalID,'memberID':memberID,'startTime':startTime,'endTime':endTime,'description':description},
	 				success:function(res){
	 					if(res.code=="103"){
	 						layer.alert(res.msg, {
								  icon: 1,
								  skin: 'layer-ext-moon',
								  title:'提示信息',
								  time:1000,
								})
	 					}else if (res.code=="104"){
	 						layer.alert(res.msg, {
								  icon: 1,
								  skin: 'layer-ext-moon',
								  title:'提示信息',
								  time:1000,
								})
	 					}else{
	 						layer.alert(res.msg, {
								  icon: 2,
								  skin: 'layer-ext-moon',
								  title:'提示信息',
								  time:1000,
								})
	 					}
	 				}
 				})

 			}
 		})
 	})
 	//加载成员信息
 	function getAllUser(){
 		$.post("${contextPath}/user/getAllUser","",function(res){
 			var data=res.data;
 			if(data){
 				for(var i=0;i<data.length;i++){
 					document.getElementById("principalID").innerHTML +=' <option value="'+data[i].userID+'">'+data[i].name+'</option>';
 				}
 				for(var i=0;i<data.length;i++){
 					document.getElementById("memberID").innerHTML +=' <option value="'+data[i].userID+'">'+data[i].name+'</option>';
 				}
 			}
 		},"json");
 	}
 	//初始化项目信息
 	function getProjectInfo(){
		$.post("${contextPath}/project/getProjectInfoById/?id=${id}","",function(res){
			console.log(res.data);
			var data = res.data;
			if(data){
 			$('#id').val(data.id);
 			$('#title').val(data.title);
			
 			$('#principalID').val(data.principalid);
 			var arr = data.memberid.split(",");
 		
 			$('#memberID').val(arr).trigger('change');
 			
 			$('#startTime').datepicker('setValue',data.starttime);
 			$('#endTime').datepicker('setValue', data.endtime);
 			$('#description').val(data.description);
			}
		});
 	}
 	</script>
</body>

</html>