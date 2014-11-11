#= require signup

slimscroll = ->
  userAgent = navigator.userAgent.toLowerCase()
  console.log(userAgent);
  isMac107 = /mac os x 10_7/.test(userAgent)
  isMac108 = /mac os x 10_8/.test(userAgent)
  isMac109 = /mac os x 10_9/.test(userAgent)
  if isMac107 || isMac108 || isMac109
    return
  $('.LandingCardContent').slimScroll({
    color: '#FFFFFF',
    height: 'auto'
  });
slimscroll()

navigate = (card) ->
  sectionID = '#' + $(card).data('id')
  left = parseInt $(sectionID).css('left')
  left -= 200
  left *= -1
  left = 0 if left > 0
  $('#staticNavLinks > li').removeClass('Active')
  $(card).addClass('Active')
  $('.LandingCard').removeClass('Active')
  $(sectionID).addClass('Active')
  $('#landingCardsContainer').css('left', left + 'px')
  if $(card).data('id') != 'start'
    $('#register').addClass('Shadowed')
  else
    $('#register').removeClass('Shadowed')
  window.location.hash = sectionID;
  return

navigate_next = ->
  link_id = '#nav' + ucfirst(window.location.hash.slice(1))
  next_id = $(link_id).data('next-id')
  if next_id.length > 0
    navigate('#nav' + ucfirst(next_id))

navigate_prev = ->
  link_id = '#nav' + ucfirst(window.location.hash.slice(1))
  if link_id == '#navJob'
    link_id = '#navJobs'
  prev_id = $(link_id).data('prev-id')
  if prev_id.length > 0
    navigate('#nav' + ucfirst(prev_id))

$(body).on('click', '#staticNavLinks > li', ->
  navigate(this)
);
$(document).keydown((event) ->
  if event.which == 37
    navigate_prev()
  else if event.which == 39
    navigate_next()
)
$('body').on('keydown', "input", (event) ->
  event.stopPropagation();
)
$('body').on('click', '#cardNavPrev', navigate_prev);
$('body').on('click', '#cardNavNext', navigate_next);
# $('#start').click();

setTimeout((-> $('.LandingCard').each(->
  $(this).addClass('Appeared');
)), 250)
$('#mission').addClass('Active')
setTimeout((-> $('#landingCardsNav').addClass('Active')), 750)

for card, index in $('.LandingCard')
  left = index * 440
  leftpx = left + 'px'
  $(card).css('left', left + 'px')

if window.location.href.indexOf('landing') > -1
  setTimeout((->
    hash = '#start'
    if window.location.hash.length > 1
      hash = window.location.hash
    if hash == '#jobs'
      hash = '#job'
    sel = "[data-id='" + hash.slice(1) + "']"
    navigate($(sel))
  ), 750)

$(body).on('click', '.LandingCard', ->
  navigate($("[data-id='" + $(this).attr('id') + "']"))
)

$(body).on('click', '#startRoleList > li', ->
  $('.StartSteps').slideUp()
  $(this).children('.StartSteps').slideDown()
)

$(body).on('click', '#audience > li', ->
  if $(this).hasClass('Active')
    $(this).removeClass('Active')
    $('.HowItWorksSteps').removeClass('Fade')
    return
  $('#audience > li').removeClass('Active')
  $(this).addClass('Active')
  $('.HowItWorksSteps').addClass('Fade')
  $('#' + $(this).data('id')).removeClass('Fade')
)

$(body).on('click', '#recipientsList > li', ->
  $('#recipientsList > li').removeClass('Active')
  $(this).addClass('Active')
  detailsID = '#help' + $(this).text()
  $('#recipients > p').removeClass('Visible')
  $(detailsID).addClass('Visible')
)

$(body).on('click', '.IconGridItem', (event) ->
  event.stopPropagation()
  navigate($('#navTeam'))
  $('.TeamGridItem.Expand').css('margin-bottom', '9px');
  $('.TeamGridItem.Expand').removeClass('Expand');
  $('.TeamGridItem.Fade').removeClass('Fade');

  currIndex = $(this).index()
  otherIndex1 = 0
  otherIndex2 = 0
  if currIndex % 3 == 0
    otherIndex1 = currIndex + 1
    otherIndex2 = currIndex + 2
  else if currIndex % 3 == 1
    otherIndex1 = currIndex - 1
    otherIndex2 = currIndex + 1
  else
    otherIndex1 = currIndex - 2
    otherIndex2 = currIndex - 1

  gridSelector = '#teamGrid';
  if ($(this).hasClass('Advisor'))
    gridSelector = '#advisorGrid'
  c1 = $(gridSelector).children('.TeamGridItem').eq(otherIndex1)
  c2 = $(gridSelector).children('.TeamGridItem').eq(otherIndex2)
  if !$(c1).hasClass('Expand')
    $(c1).addClass('Expand')
  if !$(c2).hasClass('Expand')
    $(c2).addClass('Expand')
  if !$(this).hasClass('Expand')
    $(this).addClass('Expand')
  $('.TeamGridItem').addClass('Fade')
  $(this).removeClass('Fade')

  if $('.TeamGridItem.Expand').length <= 0  # Nothing expanded
    $('#teamProfile').html('').removeClass('Visible')
    return
  $('#teamProfile').html($(this).data('title'))
  tpheight = $('#teamProfile').height() + 32;
  $('.TeamGridItem.Expand').css('margin-bottom', tpheight + 'px');
  t1 = 116;
  adj = 20;
  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
    t1 = 94;
    adj = 14;
  profileTop = Math.floor(currIndex / 3) * t1 + $(this).height() + adj;
  if ($(this).hasClass('Advisor'))
    profileTop += 410;
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
      profileTop -= 66;

  $('#teamProfile').css('top', profileTop + 'px').removeClass('Visible')
  setTimeout((-> $('#teamProfile').addClass('Visible')), 250);
)
$(body).on('click', '#team', (event) ->
  $('.TeamGridItem.Expand').css('margin-bottom', '9px');
  $('.TeamGridItem.Fade').removeClass('Fade');
  $('#teamProfile').removeClass('Visible');
  $('#teamProfile').html('');
)

$(body).on('click', '#locations > li', ->
  relP = $(this).children('p')
  $('#locations > li > p').not(relP).slideUp();
  if !$(relP).is(':visible')
    $(relP).slideDown();
  else
    $(relP).slideUp();
)

$(window).on('hashchange', (event) ->
  return false;
)

$('#artistSignup').find("input").keyup((event) ->
  if event.keyCode == 13
    $("#signupButton").click();
    setTimeout(->
      event.target.focus();
    , 200)
)

$('#artistLogin').find("input").keyup((event) ->
  if event.keyCode == 13
    $("#loginButton").click();
    setTimeout(->
      event.target.focus();
    , 200)
)


# $(body).on('click', '#getStartedButton', ->
#   $('#homeBox').animate({ scrollTop: $('#tagline').position().top })
# )


$(body).on('click', '#venueButton', ->
  $('#forArtists').slideUp()
  $('#forVenues').slideDown()
  $('#venueButton').addClass('btn-primary')
  $('#artistButton').removeClass('btn-primary')
  $('#artistStart').slideUp()
  $('#venueStart').slideDown()
)

$(body).on('click', '#artistButton', ->
  $('#forArtists').slideDown()
  $('#forVenues').slideUp()
  $('#venueButton').removeClass('btn-primary')
  $('#artistButton').addClass('btn-primary')
  $('#venueStart').slideUp()
  $('#artistStart').slideDown()
)

$(body).on('click', '#artistTour', ->
  alert("We're working on a tour of the site! Get in touch if you have any questions: thetap@tunetap.com")
)
$(body).on('keyDown', '#venueSignup', (event) ->
  event.preventDefault()
  event.stopPropagation()
  $('#venueContactSubmit').click()
)
$(body).on('click', '#venueContactSubmit', ->
  $.post '/venues/start',
    contact: $('#venueSignup').val()
    (resp) => 
      if resp.success == 1
        $('#venueStartResultWarning').slideUp()
        $('#venueStartResultFail').slideUp()
        $('#venueStartResultSuccess').removeClass('Hidden')
        $('#venueStartInput').slideUp()
      else if resp.success == -1
        $('#venueStartResultFail').slideUp()
        $('#venueStartResultSuccess').slideUp()
        $('#venueStartResultWarning').slideDown('Hidden')
        # $('#venueStartResultWarning').removeClass('Hidden')
      else
        $('#venueStartResultWarning').slideUp()
        $('#venueStartResultSuccess').slideUp()
        $('#venueStartResultFail').slideDown('Hidden')
        # $('#venueStartResultFail').removeClass('Hidden')
)