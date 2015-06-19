$ ->
	$('.edit').click ->
		$('.info').hide()
		$('.edit').hide()
		$('.info-edit').show()
		$('.info-box').val $('.info > p').text()

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
					$('.edit').show()
					$('.info').html("<p>#{data.user.info}</p>").show()
				else
					$('.alert')
					.addClass('alert-danger')
					.text("Failure: #{data.reason}").show()