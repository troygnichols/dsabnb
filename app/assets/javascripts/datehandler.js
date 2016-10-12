initDatepickerGen = function(startDate, endDate, submitButton, updateText) {
  var dp = $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    minDate: 0,
    // showWeek: true,
    weekHeader: '',
    beforeShowDay: function(dateText) {
      var arrive = moment(startDate.val());
      var date = moment(dateText);

      var highlight = date.isSame(arrive) || (date.isBetween(arrive, moment(endDate.val()).add(1, 'd')));
      return [true, highlight ? 'highlight' : ''];
    },
    onSelect: function(dateText) {
      var startMom = moment(startDate.val());
      var endMom = moment(endDate.val());
      var dateMom = moment(dateText);
      var dateFormat = 'YYYY-MM-DD';

      if(!startMom.isValid() || endMom.isValid()) {
        startDate.val(dateMom.format(dateFormat));
        endDate.val('');
      }
      else if(dateMom.isSame(startMom)) {
        startDate.val('');
        endDate.val('');
      }
      else if(dateMom.isBefore(startMom)) {
        endDate.val(startMom.format(dateFormat));
        startDate.val(dateMom.format(dateFormat));
      }
      else {
        endDate.val(dateMom.format(dateFormat));
      }

      updateText(startDate, endDate);
    }
  });
  updateText(startDate, endDate);
  submitButton.submit(function(event) {
    if(startDate.val() && endDate.val() === '') {
      endDate.val(startDate.val());
    }
  });
};

visitsUpdateDateText = function(startDate, endDate) {
  var arrive = moment(startDate.val());
  var depart = moment(endDate.val());
  var newText = 'Arrival and departure dates';

  if(arrive.isValid()) {
    newText = 'Arriving ' + arrive.format('MMM Do') + ' and leaving ';
    newText += depart.isValid() ? depart.format('MMM Do') : arrive.add(1, 'd').format('MMM Do');
  }

  $('.dateText').html(newText + '.');
};

hostingsUpdateDateText = function(startDate, endDate) {
  var start = moment(startDate.val());
  var end = moment(endDate.val());
  var newText = 'Offering start and end dates';

  if(start.isValid()) {
    newText = 'Offering ' + start.format('MMM Do') + ' through ';
    newText += end.isValid() ? end.format('MMM Do') : start.add(1, 'd').format('MMM Do');
  }

  $('.dateText').html(newText + '.');
};

initDatePicker = function() {
  if($('#visits').length) {
    initDatepickerGen($('#visit_start_date'), $('#visit_end_date'), 
		      $('.new_visit, .edit_visit'), visitsUpdateDateText);
  }
  if($('#hostings').length) {
    initDatepickerGen($('#hosting_start_date'), $('#hosting_end_date'), 
		      $('.new_hosting, .edit_hosting'), hostingsUpdateDateText);
  }
}
