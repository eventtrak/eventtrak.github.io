function lcfirst(string) {
  if (!string || string.length <= 0)
    return string;
  return string.charAt(0).toLowerCase() + string.slice(1);
}
function ucfirst(string) {
  if (!string || string.length <= 0)
    return string;
  return string.charAt(0).toUpperCase() + string.slice(1);
}

function getCookie(c_name) {
  var c_value = document.cookie;
  var c_start = c_value.indexOf(" " + c_name + "=");
  if (c_start == -1)
    c_start = c_value.indexOf(c_name + "=");
  
  if (c_start == -1)
    c_value = null;
  else {
    c_start = c_value.indexOf("=", c_start) + 1;
    var c_end = c_value.indexOf(";", c_start);
    if (c_end == -1)
      c_end = c_value.length;
    c_value = unescape(c_value.substring(c_start,c_end));
  }
  return c_value;
}

function setCookie(c_name,value,exdays) {
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + exdays);
  var c_value=escape(value) + ((exdays === null) ? "" : "; expires="+exdate.toUTCString());
  document.cookie=c_name + "=" + c_value;
}

function actionToGAEvent(action) {
  switch(action) {
    case 0: return 'onload';
    case 1: return 'click';
    case 2: return 'unload';
    case 3: return 'mouseover';
    case 4: return 'mouseout';
    default: return 'unknown';
  }
}
function sendAnalytic(action, target, value) {
  $.ajax({
    url: '/user_analytics',
    type: 'POST',
    data: {
      analytic: {
        user_identifier: getCookie('user_analytics_id'),
        is_registered: ((getCookie('current_user') === null) ? false : true),
        url: window.location.href,
        action: action,
        target: target,
        value: value
      }
    }
  });
  ga('send', 'event', target, actionToGAEvent(action), value, { 'page': window.location.href });
}
function sendPageLoadAnalytics() {
  sendAnalytic(0, 'window', null);
}

$(function() {
  if (getCookie('user_analytics_id') !== null) {
    sendPageLoadAnalytics();
    return;
  }
  $.ajax({
    url: '/random_string',
    type: 'GET',
    datatype: 'JSON',
    success: function(resp) {
      var randomString = resp.string;
      setCookie('user_analytics_id', randomString, 7300);
      sendPageLoadAnalytics();
    }
  });
});

$(window).on('unload', function() {
  sendAnalytic(2, 'window', null);
});

Date.prototype.getMonthName = function() {
  var monthNames = [ "January", "February", "March", "April", "May", "June", 
                "July", "August", "September", "October", "November", "December" ];
  return monthNames[this.getMonth()];
}
Date.prototype.getWeekdayName = function() {
  var weekdayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  return weekdayNames[this.getDay()];
}

function numberOfDays(year, month) {
  var d = new Date(year, month, 0);
  return d.getDate();
}
var DatePickerNavBar = React.createClass({
  getInitialState: function() {
    var now = new Date();
    return {
      prevMonth: (now.getMonth() === 0) ? 11 : now.getMonth() - 1,
      prevYear: (now.getMonth() === 0) ? now.getFullYear() - 1 : now.getFullYear(),
      nextMonth: (now.getMonth() + 1) % 12,
      nextYear: (now.getMonth() === 11) ? now.getFullYear() + 1 : now.getFullYear()
    };
  },
  render: function() {
    return React.DOM.div({
      className: 'DatePickerNavBar',
      children: [
        React.DOM.div({
          className: 'Icon',
          id: 'datePickerBack',
          onClick: this.props.backMonth,
          children: ICON_CHEVRON_LEFT_THIN
        }),
        React.DOM.div({
          className: 'DatePickerMonth',
          children: new Date(this.props.year, this.props.month, 1).getMonthName() + ' ' + this.props.year
        }),
        React.DOM.div({
          className: 'Icon',
          id: 'datePickerForward',
          onClick: this.props.forwardMonth,
          children: ICON_CHEVRON_RIGHT_THIN
        })
      ]
    });
  }
});
var DatePickerWeekdayBar = React.createClass({
  render: function() {
    var weekdayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    var weekdays = [];
    for (var i = 0; i < 7; i++)
      weekdays.push(React.DOM.div({ children: weekdayNames[i] }));
    return React.DOM.div({
      className: 'DatePickerWeekdayBar',
      children: weekdays
    });
  }
});
var DatePickerBody = React.createClass({
  selectDate: function(e) {
    $(this.props.target).val($(e.target).data('date'));
    // $('.DatePickerDay').removeClass('Active');
    if (!$(e.target).hasClass('DatePickerDay'))
      target = $(e.target).parent('.DatePickerDay');
    $(target).closest('.DatePicker').find('.Active').removeClass('Active');
    $(target).addClass('Active');
  },
  render: function() {
    var now = new Date();
    var targetMonth = this.props.month;
    var targetYear = this.props.year;
    var firstDayOfWeek = new Date(targetYear, targetMonth, 1).getDay();
    var displayDates = [];
    if (firstDayOfWeek > 0) {
      for (var count = 0; count < firstDayOfWeek; count++) {  // Load days from last month
        var currDate = new Date(targetYear, targetMonth, 1);
        currDate.setDate(currDate.getDate() - (firstDayOfWeek - count));
        displayDates.push(currDate);
      }
    }
    var nextDate = new Date(targetYear, targetMonth, 1);
    displayDates.push(nextDate);
    var lastDayOfWeek = 0;
    for (var i = 1; i <= numberOfDays(targetYear, targetMonth + 1); i++) {   // Load days from this month
      var currDate = new Date(nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate());
      currDate.setDate(currDate.getDate() + 1);
      nextDate = currDate;
      if (currDate.getMonth() != nextDate.getMonth())
        break;
      else {
        displayDates.push(currDate);
        lastDayOfWeek = currDate.getDay();
      }
    }
    if (lastDayOfWeek < 6) {
      for (var i = 0; i < 6 - lastDayOfWeek; i++) {   // Load days from next month
        var currDate = new Date(nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate());
        currDate.setDate(currDate.getDate() + 1);
        nextDate = currDate;
        if (currDate.getDay() <= 6) {
          displayDates.push(currDate);
        }
        else
          break;
      }
    }
    var children = [];
    var rowCount = 0;
    var _t = this;
    for (var i = 0; i < displayDates.length / 7; i++) {
      var dates = [];
      for (var j = 0; j < 7; j++) {
        var date = displayDates[i * 7 + j].getDate();
        var targetDate = displayDates[i * 7 + j];
        var className = 'DatePickerDay';
        className += targetDate.getMonth() !== targetMonth ? ' OtherMonthDate' : '';
        if (targetDate.getFullYear() == targetYear && targetDate.getMonth() == targetMonth && targetDate.getDate() == now.getDate())
          className += ' Today';
        dates.push(React.DOM.div({
          className: className,
          'data-date': targetDate.getFullYear() + '-' + (targetDate.getMonth() + 1) + '-' + targetDate.getDate(),
          onClick: _t.selectDate,
          children: React.DOM.p({
            'data-date': targetDate.getFullYear() + '-' + (targetDate.getMonth() + 1) + '-' + targetDate.getDate(),
            children: date 
          })
        }));
      }
      var tr = React.DOM.div({
        className: 'DatePickerRow',
        children: dates
      });
      children.push(tr);
      rowCount++;
    }
    // if (rowCount > 5)
    //   $('#eventsCalendar').addClass('TallCalendar');
    return React.DOM.div({
      className: 'DatePickerBody',
      children: children
    });
  }
});
var DatePicker = React.createClass({
  getInitialState: function() {
    var now = new Date();
    return { month: now.getMonth(), year: now.getFullYear() };
  },
  updateMonth: function(month, year) {
    node = this.getDOMNode();
    if (node) {
      $(node).find('.Active').removeClass('Active');
      $(this.props.target).val('');
    }
    this.setState({ month: month, year: year });
  },
  forwardMonth: function() {
    var nextMonth = (this.state.month < 11) ? this.state.month + 1 : 0;
    var nextYear = (this.state.month < 11) ? this.state.year : this.state.year + 1;
    this.updateMonth(nextMonth, nextYear);
  },
  backMonth: function() {
    var prevMonth = (this.state.month === 0) ? 11 : this.state.month - 1;
    var prevYear = (this.state.month === 0) ? this.state.year - 1 : this.state.year;
    this.updateMonth(prevMonth, prevYear);
  },
  render: function() {
    var _t = this;
    return React.DOM.div({
      className: 'DatePicker',
      children: [DatePickerNavBar({ month: this.state.month, year: this.state.year, forwardMonth: _t.forwardMonth, backMonth: _t.backMonth }), DatePickerWeekdayBar(), DatePickerBody({ month: this.state.month, year: this.state.year, target: this.props.target })]
    });
  }
});
$('#createEventModal').on('show.bs.modal', function() {
  React.renderComponent(DatePicker({ target: '#eventDate' }), document.getElementById('eventDatePicker'));
  React.renderComponent(DatePicker({ target: '#fundingDate' }), document.getElementById('fundingDatePicker'));
});
$(body).on('click', '#createGenTicket', function() {
  $(this).css('display', 'none');
  $('#createGenTicketGroup').slideDown();
});
$(body).on('click', '#createVIPTicket', function() {
  $(this).css('display', 'none');
  $('#createVIPTicketGroup').slideDown();
});
$(body).on('click', '.CancelCreateTicket', function() {
  $('#' + $(this).data('target') + 'Group').slideUp();
  var _t = this;
  setTimeout(function() { $('#' + $(_t).data('target')).css('display', 'inline-block'); }, 400);
});
$(body).on('change', '.ShouldLimitTicket', function() {
  if ($(this).is(':checked'))
    $('#' + $(this).data('target')).css('display', 'inline-block');
  else
    $('#' + $(this).data('target')).css('display', 'none');
});