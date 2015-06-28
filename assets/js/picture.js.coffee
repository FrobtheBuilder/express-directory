$ ->
	$(".set").click ->
		$.ajax
			method: "post"
			url: "/user/async"
			dataType: "json"
			data:
				change: "profilePicture"
				to: $('.pictureID').text()
			success: (data) ->
				if data.success
					$('.alert')
					.addClass('alert-success')
					.text('Changed successfully!').show()
				else
					$('.alert')
					.addClass('alert-danger')
					.text("Failure: #{JSON.stringify data.reason}").show()