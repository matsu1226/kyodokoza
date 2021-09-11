import * as $ from "jquery";

export default function narrow_down_posts() {
	$(function () {
		$('#post_user_id').change(function () {	//ブラウザの変更を検知
			$.ajax({	// 指定したパスにdataを送信
					url: "/posts/narrow_down",
					type: "GET",
					datatype: "json",
					data: {
						user_id: $('#post_user_id').has('option:selected').val(), 
						//params[:user_id]にoption selectedしたものを格納
					},
				})
				// .done(function(data){		// controllerからのレスポンスを受け取る(今回はposts#narrow_down)
				// 	console.log(data);
				// 	$('#post_list').html('<%= escape_javascript(render post_list) %>');
				// 	// $('#post_list').html(data);
					// $('#post_list span').remove();
					// $(data).each(function(i,post) {
					// 	$('#post_list').append(		// appned => DOMの挿入
					// 		`<li class="post-${i}"><a href="/posts/${post.id}">${post.content}</a></li>`
					// 	);
					// });
				// })
		});
	});
}