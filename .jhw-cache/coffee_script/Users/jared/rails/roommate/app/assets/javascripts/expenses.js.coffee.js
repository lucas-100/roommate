(function() {

  $(function() {
    $(document).keyup(function(event) {
      if (event.which === 69 && $('#new-expense').is(':hidden')) {
        event.preventDefault();
        $('#add-expense').click();
      } else if (event.which === 27 && $('#new-expense').is(':visible')) {
        event.preventDefault();
        $("#cancel-new-expense").click();
      } else if (event.which === 80) {} else {

      }
    });
    $('#add-expense').click(function(event) {
      event.preventDefault();
      $('#new-expense').slideDown('fast', function() {
        return $('#new-expense-sub-container').fadeIn('fast', function() {
          return $('#new-expense-name').focus();
        });
      });
      $('#add-expense').fadeOut('fast');
    });
    $('#cancel-new-expense').click(function(event) {
      event.preventDefault();
      $('#new-expense-sub-container').fadeOut('fast', function() {
        $('#new-expense').slideUp('fast');
        return $('form.new-expense').each(function() {
          this.reset();
          return this.blur();
        });
      });
      $('#add-expense').fadeIn('fast');
    });
    $('.tag').alert();
  });

}).call(this);
