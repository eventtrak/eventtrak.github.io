var addData1, addData2, calendar, peventsPage, validate, page;

$("div.pep").hide();

var page = 1;

String.prototype.repeat = function( num )
{
    return new Array( num + 1 ).join( this );
}

$( window ).scroll(function() {
  var pagepixel = (((page-1)*6)+4)*325;
  console.log(pagepixel);
  console.log($(window).scrollTop());
  if ($(window).scrollTop() >= pagepixel) {
    page += 1;
    console.log("works!");
    var url = "/venues/page/" + page;
    $.ajax({
      url: url,
      dataType: "json",
      success: function(morepages) {
        var string = "";
        for (var i=0; i < morepages.length; i++) {
          var v = morepages[i];
          console.log(v);

          string += '<div class = "locations">';
          string += '<div class = "card" style="background-image:'+((v.image_file_name==null) ? "url(http://dogecoin.com/img/dogecoin-300.png)" : ("url("+v.image_file_name+")"))+';background-size:cover;">';
          string += '   <div class ="card_info">';
          string += '     <div class="name">';
          string += '       <p>';
          string += '         <a href="/venues/'+v.id+'"  target="_self">'+((v.name.length > 40) ? v.name.substring(0,40) : v.name)+'</a>';
          string += '       </p>';
          string += '     </div>  ';
          string += '     <div class = "info">';
          string += '       <div class ="size">';
          string += '           <p>';
          string += '           Capacity: '+((v.capacity==null) ? "" : v.capacity)+'';
          string += '         </p>';
          string += '       </div>';
          string += '       <div class="price">';
          string += '         <p>';
          string += '           Price: '+((v.max_price == "") ? ("----") : ("$".repeat(v.max_price)))+'';
          string += '         </p>';
          string += '       </div>  ';
          string += '     </div>';
          string += '   </div>  ';
          string += ' </div>';
          string += '</div>'; 
        }
        $(".whole_page").append(string);
        console.log("should work if this work");
      }
    });
  }
});

addData1 = function() {
  return $('.ConDate').attr("placeholder", "ex: " + moment().format("L"));
};

addData1();

$('body').on('click', '.free', function(t) {
  t.attr('datea-date');
  addData1(t);
  return console.log(t);
});

var CalendarBody = React.createClass({
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
    for (var i = 1; i <= numberOfDays(targetYear, targetMonth + 1); i++) {   // Load days from this month
      var currDate = new Date(nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate());
      currDate.setDate(currDate.getDate() + 1);
      nextDate = currDate;
      if (currDate.getMonth() != nextDate.getMonth())
        break;
      else
        displayDates.push(currDate);
    }
    if (nextDate.getDay() < 6) {
      for (var i = 0; i < 7; i++) {   // Load days from next month
        var currDate = new Date(nextDate.getFullYear(), nextDate.getMonth(), 1);
        currDate.setDate(currDate.getDate() + 1);
        nextDate = currDate;
        if (currDate.getDay() <= 6)
          displayDates.push(currDate);
        else
          break;
      }
    }
    var children = [];
    var rowCount = 0;
    for (var i = 0; i < displayDates.length / 7; i++) {
      var dates = [];
      for (var j = 0; j < 7; j++) {
        var date = displayDates[i * 7 + j].getDate();
        var targetDate = displayDates[i * 7 + j];
        var className = targetDate.getMonth() !== targetMonth ? 'OtherMonthDate' : '';
        if (targetDate.getFullYear() == targetYear && targetDate.getMonth() == targetMonth && targetDate.getDate() == now.getDate())
          className += ' Today';
        dates.push(React.DOM.td({
          className: className,
          'data-date': targetDate.getFullYear() + '-' + (targetDate.getMonth() + 1) + '-' + targetDate.getDate(),
          children: React.DOM.p({ children: date })
        }));
      }
      var tr = React.DOM.tr({
        children: dates
      });
      children.push(tr);
      rowCount++;
    }
    // if (rowCount > 5)
    //   $('#eventsCalendar').addClass('TallCalendar');
    return React.DOM.div({
      children: children
    });
  }
});
var VenueCalendar = React.createClass({
  render: function() {
    var now = new Date();
    var children = [CalendarNavBar(), CalendarWeekdayHeaderBar(), CalendarBody({ month: now.getMonth(), year: now.getFullYear() })];
    return React.DOM.table({
      id: 'venueCalendar',
      children: children
    });
  }
});
var CalendarNavBar = React.createClass({
  render: function() {
    var nextMonthName = '';
    var now = new Date();
    if (now.getMonth() === 11)
      nextMonthName = 'January ' + (now.getFullYear() + 1);
    else
      nextMonthName = new Date(now.getFullYear(), now.getMonth() + 1).getMonthName();

    return React.DOM.tr({
      id: 'calendarNavBar',
      children: [
        React.DOM.th({
          children: 'Past events'
        }),
        React.DOM.th({
          colSpan: 5,
          id: 'calendarNavMonth',
          children: new Date().getMonthName() + ' ' + new Date().getFullYear()
        }),
        React.DOM.th({
          id: 'calendarNavNextMonth',
          children: nextMonthName
        })
      ]
    });
  }
});
var CalendarWeekdayHeaderBar = React.createClass({
  render: function() {
    var weekdayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    var weekdays = [];
    for (var i = 0; i < 7; i++)
      weekdays.push(React.DOM.th({ children: weekdayNames[i] }));
    return React.DOM.tr({
      id: 'calendarWeekdayBar',
      children: weekdays
    });
  }
});
React.renderComponent(VenueCalendar(), document.getElementById('eventsCalendar'));


// peventsPage = function() {
//   var box;
//   box = "<p class = 'hi'>";
//   box += "<p class = 'peventsTitle'>PAST EVENTS</p>";
//   box += "<div class = 'nextIcon'><span id = 'returnCal' class = 'Icon' title='Next Month' alt='Next Month'> <span class ='monx'>January 2014</span></span></div>";
//   box += "<div class = 'eventList'><p class = 'dec'>DECEMBER 2013</p>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 29th: Guitars in the Jar; openers by Gabby & the Thurstones, Adam Clark</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Thursday the 19th: Moon Zombies</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/349997/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Monday the 16th: Gorguts, Origin, and Nero Di Marte</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Friday the 13th: Yeyowulf; openers by The Weight We Cary, Cycles, Burn Everything</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/6873714/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 08th: On the Cinder, Sexy Teenagers, The Results, and Ivy's Panic Room</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 29th: Guitars in the Jar; openers by Gabby & the Thurstones, Adam Clark</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Thursday the 19th: Moon Zombies</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/349997/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Monday the 16th: Gorguts, Origin, and Nero Di Marte</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Friday the 13th: Yeyowulf; openers by The Weight We Cary, Cycles, Burn Everything</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/6873714/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 08th: On the Cinder, Sexy Teenagers, The Results, and Ivy's Panic Room</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 29th: Guitars in the Jar; openers by Gabby & the Thurstones, Adam Clark</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Thursday the 19th: Moon Zombies</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/349997/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Monday the 16th: Gorguts, Origin, and Nero Di Marte</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Friday the 13th: Yeyowulf; openers by The Weight We Cary, Cycles, Burn Everything</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/6873714/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 08th: On the Cinder, Sexy Teenagers, The Results, and Ivy's Panic Room</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 29th: Guitars in the Jar; openers by Gabby & the Thurstones, Adam Clark</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Thursday the 19th: Moon Zombies</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/349997/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Monday the 16th: Gorguts, Origin, and Nero Di Marte</ol>";
//   box += "<ol class = 'list'><img src='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Friday the 13th: Yeyowulf; openers by The Weight We Cary, Cycles, Burn Everything</ol>";
//   box += "<ol class = 'list'><img src='http://www2.sk-static.com/images/media/profile_images/artists/6873714/avatar' alt='http://rlv.zcache.com/anonymous_square_stickers-r398c835dea1f498f922549347093b6bb_v9wf3_8byvr_512.jpg' width='42' height='42'>&nbsp;&nbsp; Sunday the 08th: On the Cinder, Sexy Teenagers, The Results, and Ivy's Panic Room</ol>";
//   box += "</div>";
//   return document.getElementById("peventsPage").innerHTML = box;
// };

// peventsPage();

// $(body).on('click', '#peventsID', function() {
//   $("div.javaCal").hide();
//   return $("div.pep").show();
// });

// $(body).on('click', '#prevMonth', function() {
//   if (mydate.getMonth() === 0) {
//     calendar(mydate.setMonth(11));
//     return calendar(mydate.setFullYear(mydate.getFullYear() - 1));
//   } else {
//     return calendar(mydate.setMonth(mydate.getMonth() - 1));
//   }
// });

// $(body).on('click', '#nextMonth', function() {
//   if (mydate.getMonth() === 11) {
//     calendar(mydate.setMonth(0));
//     return calendar(mydate.setFullYear(mydate.getFullYear() + 1));
//   } else {
//     calendar(mydate.setMonth(mydate.getMonth() + 1));
//     return console.log("New month: " + mydate.getMonth());
//   }
// });

// $(body).on('click', '#returnCal', function() {
//   $("div.pep").hide();
//   $("div.javaCal").show();
//   return calendar(mydate.setMonth(mydate.getMonth()));
// });

// addData2 = function() {
//   if ($('#venue_name').val() === "Bug Jar") {
//     $('#myModal').modal('hide');
//     return console.log("hi");
//   }
// };

$(body).on('keydown', '.cap', function(event) {
  var charCode = (event.which) ? event.which : event.keyCode;
  if (!(charCode == 8 || charCode == 9 || charCode == 13 || (charCode >= 48 && charCode <= 57) || (charCode >= 96 && charCode <= 105)))
    event.preventDefault();
});



$(body).on('click', '#setupOccur', function(event) {
  return addData2();
});

// // validate = function() {
// //   if ($("#venue_name").val().length > 0 && $("#con_date").val().length > 0 && $("#vip").val().length > 0 && $("#target").val().length > 0 && $("#bydate").val().length > 0 && $("#gen_price").val().length > 0) {
// //     return $("#setupOccur").prop("disabled", false);
// //   } else {
// //     return $("#setupOccur").prop("disabled", true);
// //   }
// // };

// // validate();

// $("#venue_name, #con_date, #gen_price", "#vip", "#target", "#bydate").change(validate);
