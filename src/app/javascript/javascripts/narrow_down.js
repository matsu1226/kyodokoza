import * as $ from "jquery";

// export default function narrow_down_posts() {
// 	$(function () {
// 		$('#post_user_id').change(function () {
// 			$.get({
// 					url: "/posts/narrow_down",
// 					data: {
// 						user_id: $('#post_user_id').has('option:selected').val(), //params[:user_id]にoption selectedしたものを格納
// 					},
// 				})
// 		});
// 	});
// }
// もし、user_id=""ならget "posts/index"とする

export default function narrow_down_posts() {
	$(function () {
		$('#post_user_id').change(function () {
			$.ajax({
					url: "/posts/narrow_down",
					type: "GET",
					datatype: "json",
					data: {
						user_id: $('#post_user_id').has('option:selected').val(), //params[:user_id]にoption selectedしたものを格納
					},
				})
		});
	});
}