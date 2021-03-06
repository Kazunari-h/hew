<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id = (String)session.getAttribute("userId");
	if(id == null){//転送
		RequestDispatcher disp = request.getRequestDispatcher("msg.jsp");
		//メッセージをリクエストに設定
		request.setAttribute("msg", "無効なアクセスです。");
		//フォワード
		disp.forward(request, response);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script type="text/javascript" src="js/upload.js"></script>
</head>
<body>
	ようこそ<%= id %>さん。<br>
	<ul>
		<li><a href="index.jsp">home</a></li>
		<li><a href="upload.jsp">upload</a></li>
	</ul>
	

	<label>商品名：<input type="text" name="name"></label><br>
	<label>商品説明：<br>
	<textarea rows="4" cols="40" placeholder="商品説明をご記入下さい" name="description"></textarea></label><br>
	<label>購入ポイント：<input type="text" name="point" id="point"></label><br>
	<label for="select">カテゴリ：</label>
	<select id="select" name="select">
		<option>カテゴリ</option>
		<option>ゲーム</option>
		<option>ツール</option>
		<option>ニュース</option>
		<option>test</option>
		<option>-----</option>
		<option>-----</option>
	</select>
	<br>
	<div id="drag-area" style="width:400px;height:200px;border:dashed 1px #333;">
		<p>アップロードするファイルをドロップ</p>
	</div>
	<div id="fileNameArea"></div>
	<button id="button" >送信</button>
	<input type="hidden" name="msg" value="送信しました。">
	<script type="text/javascript">
	$(function(){
		var files = null;
		$('document').ready(function(){
			$('#button').click(function(e){
				e.preventDefault();
				if(files && checkName() && checkDesc() && checkPoint() && checkCategory()){
					uploadFiles(files);
				}else{
					alert('入力項目を確認して下さい');
				}
			});
		});
		
		function checkName(){
			var val = $('input[name="name"]').val();
			if(val != '') return true;
			else return false;
		}
		
		function checkDesc(){
			var val = $('textarea[name="description"]').val();
			if(val != '') return true;
			else return false;
		}
		
		function checkPoint(){
			var val = $('#point').val();
			val = val.replace(/[Ａ-Ｚａ-ｚ０-９]/g,function(s){
				return String.fromCharCode(s.charCodeAt(0)-0xFEE0);
				});
			if(val != '' && val.match(/\d/)) return true;
			else return false;
		}
		
		function checkCategory(){
			var val = $('select[name="select"]').val();
			if(val != '' && val != 'カテゴリ') return true;
			else return false;
		}
		
		/*================================================
		  ファイルをドロップした時の処理
		=================================================*/
		$('#drag-area').bind('drop', function(e){
			// デフォルトの挙動を停止
			e.preventDefault();
			// ファイル情報を取得
			files = e.originalEvent.dataTransfer.files;
			for(var i=0; i<files.length; i++){
				var elm = $('<p>' + files[i].name + " " + files[i].size + "byte" + '</p>');
				$('#fileNameArea').append(elm);
			}
			
		}).bind('dragenter', function(){
			// デフォルトの挙動を停止
			return false;
		}).bind('dragover', function(){
			// デフォルトの挙動を停止
			return false;
		});
	});
		/*================================================
		  アップロード処理
		=================================================*/
		function uploadFiles(files) {
			// FormDataオブジェクトを用意
			var fd = new FormData();
			// ファイルの個数を取得
			var filesLength = files.length;
			// ファイル情報を追加
			for (var i = 0; i < filesLength; i++) {
				fd.append("files[]", files[i]);
			}
			//フォームの値をFormDataオブジェクトに追加
			fd.append('name', $('input[name="name"]').val());
			fd.append('description', $('textarea[name="description"]').val());
			fd.append('point', $('#point').val());
			fd.append('select', $('select[name="select"]').val());
			
			// Ajaxでアップロード処理をするファイルへ内容渡す
			$.ajax({
				url: './UploadFileServlet',
				type: 'POST',
				data: fd,
				processData: false,
				contentType: false,
				success: function(data) {
					console.log('ファイルがアップロードされました。');
				}
			});
		}
	</script>
</body>
</html>