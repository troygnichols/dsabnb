App.Hostings = {};

App.Hostings.init = function() {
  this.sDate = $('#hostings_start_date');
  this.eDate = $('#hostings_end_date');

  this.initDatepicker();
  this.updateText();

  $('.new_hosting, .edit_hosting').submit(function(event) {
    if(App.Hostings.sDate.val() && App.Hostings.eDate.val() === '') {
      App.Hostings.eDate.val(App.Hostings.sDate.val());
    }
  });
};

App.Hostings.initDatepicker = function() {
  var start = this.sDate;
  var end = this.eDate;

  var dp = $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    minDate: 0,
    // showWeek: true,
    weekHeader: '',
    beforeShowDay: function(dateText) {
      var arrive = moment(start.val());
      var date = moment(dateText);

      var highlight = date.isSame(arrive) || (date.isBetween(arrive, moment(end.val()).add(1, 'd')));
      return [true, highlight ? 'highlight' : ''];
    },
    onSelect: function(dateText) {
      var startDate = moment(start.val());
      var endDate = moment(end.val());
      var date = moment(dateText);
      var dateFormat = 'YYYY-MM-DD';

      if(!startDate.isValid() || endDate.isValid()) {
        start.val(date.format(dateFormat));
        end.val('');
      }
      else if(date.isSame(startDate)) {
        start.val('');
        end.val('');
      }
      else if(date.isBefore(startDate)) {
        end.val(startDate.format(dateFormat));
        start.val(date.format(dateFormat));
      }
      else {
        end.val(date.format(dateFormat));
      }

      App.Hostings.updateText();
    }
  });
};

App.Hostings.updateText = function() {
  var arrive = moment(this.sDate.val());
  var depart = moment(this.eDate.val());
  var newText = 'Arrival and departure dates';

  if(arrive.isValid()) {
    newText = 'Arriving ' + arrive.format('MMM Do') + ' and leaving ';
    newText += depart.isValid() ? depart.format('MMM Do') : arrive.add(1, 'd').format('MMM Do');
  }

  $('.dateText').html(newText + '.');
};
