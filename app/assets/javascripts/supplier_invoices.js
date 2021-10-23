$(function () {
    $('#add-supplier-invoice-picture').on('click', function () {
        var content = $('.invoice-picture-row:last');
        var content_html = content.wrap('<p/>').parent().html();
        content.unwrap();

        var id = $('.invoice-picture-row:last [id^="suppliers_invoice_attachments_attributes_"][id$="_picture"]').attr('id');
        id = id.replace("customers_invoice_attachments_attributes_", "").replace("_picture", "");
        var new_id = parseInt(id) + 1;

        var regex = new RegExp("_" + id + "_", 'g');
        content_html = content_html.replace(regex, "_" + new_id + "_");

        regex = new RegExp("\\[" + id + "\\]", 'g');
        content_html = content_html.replace(regex, "[" + new_id + "]");

        content.after(content_html);
        content = $('.invoice-picture-row:last');
        content.find('.destroy-invoice-picture').val("0");
        //content.find('input, select').val("");
        content.show();
    });

    $('.invoice.supplier-payment').click(function (e) {
        e.preventDefault();
        $('#supplier-invoice-modal').modal('show').find('#supplier_invoice_base_url').val($(this).attr('href'));
    });

    $('#supplier-invoice-modal').on('shown.bs.modal', function () {
        $('.chosen-select', this).chosen();
    });

});

$(document).on('click', '.delete-invoice-picture', function () {
    var education = $(this).closest('.invoice-picture-row');
    var destroy = education.find('.destroy-invoice-picture');
    destroy.val("1");
    education.hide();
    return false;
});

