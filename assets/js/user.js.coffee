$ ->
	$('.edit').click ->
		$('.info').add('.edit').hide()
		$('.info-edit').show()
		$.ajax
			method: "get"
			url: "/user/async/self"
			datatype: "json"
			success: (data) ->
				$('.info-edit').val data.user.info


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
					$('.info').html("#{data.newValue}").show()
				else
					$('.alert')
					.addClass('alert-danger')
					.text("Failure: #{data.reason}").show()