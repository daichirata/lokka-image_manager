$(function(){
    $('.tab-post').click(function(){
        $('#thumbnail-post').show();$('#thumbnail-category').hide();$('#thumbnail-noimage').hide()
    });
    $('.tab-category').click(function(){
        $('#thumbnail-post').hide();$('#thumbnail-category').show();$('#thumbnail-noimage').hide()
    });
    $('.tab-noimage').click(function(){
        $('#thumbnail-post').hide();$('#thumbnail-category').hide();$('#thumbnail-noimage').show()
    });

    $('.images').click(function(){
        var image_path = $(this).attr('alt');
        var code = '<img src="' + image_path + '">'
        $('#images_code').val(code);
    });

    $('#images_code').click(function(){
		$(this).select();
	});
});
