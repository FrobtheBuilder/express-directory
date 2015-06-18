$ ->
	$('.edit').click ->
		$('.info').hide()
		$('.info-edit').show()
		$('.info-box').val $('.info > p').text()


		###
		$.ajax
			method: "get"
			url: "/user/async"
			dataType: "json"
			data:
				name: "ayy"
			success: (data) ->
				console.log data.name
		return
		###

	$('.submit-edit').click ->

		$.ajax
			method: "post"
			url: "/user/async"
			dataType: "json"
			data:
				change: "info"
				to: $('.info-box').val()
			success: (data) ->
				if data.success
					$('.info-edit').hide()
					$('.info').text(data.user.info).show()
				else
					$('.alert')
					.addClass('alert-danger')
					.text("Failure: #{data.reason}").show()

