# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

position_content = ->
  wh = $(window).height()
  # $('.EventContainer').css('margin-top', wh + 'px').css('height', wh + 'px');
  # $('.EventContent').css('height', (wh - 30) + 'px')
  ehh = $('.EventHeroContent').height() + $('.EventContent2').height()
  ehh_mt = (wh - ehh) / 2.0
  # $('.EventHeroContent').css('margin-top', ehh_mt + 'px')
  setTimeout((->
    $('.WelcomeHeader').addClass('Active')
  ), 1500)
position_content()

if getCookie('pps') != null
  $('#' + getCookie('pps')).click()
  setCookie('pps', '', -1)

attendeesResponse = ->
  userAgent = navigator.userAgent.toLowerCase()
  isMac107 = /mac os x 10_7/.test(userAgent)
  isMac108 = /mac os x 10_8/.test(userAgent)
  isMac109 = /mac os x 10_9/.test(userAgent)
  if isMac107 || isMac108 || isMac109
    return
  $('.EventAttendees').addClass('Small')
attendeesResponse()

$('body').on('click', '#whatIsModalTrigger', ->
  sendAnalytic(1, '#whatIsModalTrigger', null)
)
$('body').on('click', '#closeWhatIsTunetapModal', ->
  sendAnalytic(1, '#closeWhatIsTunetapModal', null)
)
$('body').on('click', '.EventDetails', (event) ->
  sendAnalytic(1, '.EventDetails', ($(window).width() + 'x' + $(window).height() + ' (' + event.pageX + ',' + event.pageY + ')'))
)
$('body').on('click', '.EventDetailsContent', (event) ->
  sendAnalytic(1, '.EventDetailsContent', ($(window).width() + 'x' + $(window).height() + ' (' + event.pageX + ',' + event.pageY + ')'))
)
$('body').on('click', '#signupWithFacebookPrompt', ->
  sendAnalytic(1, '#signupWithFacebookPrompt', null)
)
$('body').on('click', '#facebookSignupDismiss', ->
  sendAnalytic(1, '#facebookSignupDismiss', null)
)
$('body').on('click', '#ticket1', ->
  sendAnalytic(1, '#ticket1', null)
)
$('body').on('click', '#ticketVIP', ->
  sendAnalytic(1, '#ticketVIP', null)
)
$('body').on('click', '#dismissRegularTicketDialog', ->
  sendAnalytic(1, '#dismissTicketDialog', null)
)
$('body').on('click', '#cancelFacebookSignup', ->
  sendAnalytic(1, '#cancelFacebookSignup', null)
)
$('body').on('click', '.EventArtistLink', ->
  sendAnalytic(1, '.EventArtistLink', $(this).attr('id'))
)
$('body').on('click', '.MyTicketsCount', ->
  sendAnalytic(1, '.MyTicketsCount', $(this).html())
)
$('body').on('click', '.FacebookProfileCard', ->
  sendAnalytic(1, '.FacebookProfileCard', $(this).data('fb-id'))
)
$('body').on('mouseover', '.EventArtistHeader', ->
  sendAnalytic(3, '.EventArtistHeader', null)
)
$('body').on('mouseout', '.EventArtistHeader', ->
  sendAnalytic(4, '.EventArtistHeader', null)
)
$('body').on('click', '.EventArtistName', ->
  sendAnalytic(1, '.EventArtistName', 'Dylan Owen')
)
$('body').on('click', '.EventArtistLink', ->
  sendAnalytic(1, '.EventArtistLink', $(this).html())
)
$('body').on('click', '.FacebookButton', ->
  sendAnalytic(1, '.FacebookButton', 'Share on Facebook')
)
$('body').on('click', '.TwitterButton', ->
  sendAnalytic(1, '.TwitterButton', 'Tweet on Twitter')
)

# $('.EventContainer').addClass('Active')
# $('.EventContainer').animate({
#   marginTop: $(window).height() - 30
# }, 500)
# $(window).scroll( ->
#   percent_scroll = $(window).scrollTop() / $(window).height()
#   opacity = 1 - percent_scroll
#   scale = 1 - 0.1 * percent_scroll
#   console.log('scale: ' + scale);
#   $('.EventHero').css('opacity', opacity).css('-webkit-transform', ('scale(' + scale + ')')).css('margin-top', (-0.95 * $(window).scrollTop()) + 'px')
# )

slideUpPreorderButton = (button) ->
  console.log('button: ' + button)
  $(button).css('margin-top', '20px')
$('body').on('click', '.PreorderButton', ->
  # x_mt = 0
  # x_times = 1000
  # $('.PreorderPackages .btn').each(->
  #   $(this).css('margin-top', (2000 + x_times * x_mt) + 'px')
  #   x_mt++
  # )
  $('.PreorderButton').addClass('Active')
  $('.WhosGoingButton').removeClass('Active')
  $('.EventAttendees').slideUp()

  $('.PreorderPackages .btn').addClass('Active')

  cnt_height = $('.EventHeroContent').height() + 130  # Ticket buttons height
  wh = $(window).height()
  mt = (wh - cnt_height) / 2.0
  $('.EventHeroContent').css('margin-top', mt + 'px')
)
$('body').on('click', '.WhosGoingButton', ->
  $('.PreorderButton').removeClass('Active')
  $('.WhosGoingButton').addClass('Active')
  $('.EventAttendees').slideDown()
  $('.EventContent2 .btn').removeClass('Active')
)

$('body').on('click', '#signupButton', (event) ->
  $('#signupButton').prop('disabled', true)
  $('#signupModal .alert').slideUp()
  s_data = $('#signupForm').serialize()
  request = $.ajax({
    url: '/users/create_beta',
    type: 'POST',
    data: s_data,
    datatype: 'JSON',
    success: (resp) ->
      if resp.success 
        $('#signupSuccess').slideDown()
        setTimeout((->
          $('#signupModal').modal('hide')
        ), 1500)
        setTimeout((->
          window.top.location = window.top.location
        ), 1750)
      else
        $('#signupFail').slideDown()
  })
  request.always(->
    $('#signupButton').prop('disabled', false)
  )
)

$('body').on('click', '.FacebookButton', (event) ->
  $('.FacebookButton').css('display', 'none')
  $('.FacebookButtonLogo').css('display', 'none')
  $('#facebookLoginSpinner').removeClass('Hidden')
  sendAnalytic(1, '.FacebookButton', null)
  fb_login()
)

$('body').on('click', '#loginButton', (event) ->
  console.log('Login button clicked')
  $('#loginButton').prop('disabled', true)
  $('#loginModal .alert').slideUp()
  l_data = $('#loginForm').serialize()
  request = $.ajax({
    url: '/users/login',
    type: 'POST',
    data: l_data,
    datatype: 'JSON',
    success: (resp) ->
      if resp.success
        $('#loginSuccess').slideDown()
        setTimeout((->
          $('#loginModal').modal('hide')
        ), 1500)
        setTimeout((->
          window.top.location = window.top.location
        ), 1750)
      else
        $('#loginFail').slideDown()
  })
  request.error(->
    $('#loginError').slideDown()
  )
  request.always(->
    $('#loginButton').prop('disabled', false)
  )
)

lastPackage = '';
$('body').on('click', '.PreorderPackage > .btn', (event) ->
  console.log('Is logged in text: ' + $('#isLoggedIn').html())
  if $(this).hasClass('Disabled')
    alert('Disabled button')
    sendAnalytic(1, '.PreorderPackage > .btn', ('Disabled ' + $(this).attr('id')))
    return

  sendAnalytic(1, '.PreorderPackage > .btn', $(this).attr('id'))
  
  if $('#isLoggedIn').html() == '0'
    console.log('Is logged in 0')
    setCookie('pps', $(this).attr('id'), null)
    console.log('Set pps cookie: ' + getCookie('pps'))
    lastPackage = $(this)
    $('#signupModal').modal('show')
    return
  $('#paymentModal .alert').slideUp()
  $('#submitPaymentButton').css('display', 'block')
  $('#ticketPaymentSpinner').css('display', 'none')
  $('#selectedPackageID').val($(this).attr('id'))
  $('#paymentTitle').html($(this).data('title'))
  ppt = 12
  if ($('#selectedPackageID').val() == 'ticketVIP')
    ppt = 30
  if ($('#isLoggedIn').html() == '1')
    ppt = 11
    if ($('#selectedPackageID').val() == 'ticketVIP')
      ppt = 27
  $('#ticketCost').html(1 * ppt + '.00')
  # if $(this).attr('id') == 'ticketVIP'
    # $('#paymentModal #packageDescription').html('A chance to meet-and-greet Dylan before the show and get backstage access during the soundcheck.')
    # $('#ticketQuantity').css('display', 'none')
  # else
  $('#paymentModal #packageDescription').html('')
  $('#paymentModal').modal('show')
)
$('body').on('keyup', '#quantity', ->
  if $(this).val().length == 0 or isNaN($(this).val())
    $('#ticketCost').html('0.00')
    $('#ticketCostLabel').addClass('Hidden')
    return
  $('#ticketCostLabel').removeClass('Hidden')
  q = parseInt($(this).val(), 10)
  ppt = 12
  if ($('#selectedPackageID').val() == 'ticketVIP')
    ppt = 30
  if ($('#isLoggedIn').html() == '1')
    ppt = 11
    if ($('#selectedPackageID').val() == 'ticketVIP')
      ppt = 27
  $('#ticketCost').html(q * ppt + '.00')
)
$('body').on('click', '#skipSignupButton', (event) ->
  sendAnalytic(1, '#skipSignupButton', null)
  $('#signupModal').modal('hide')
  $('#isLoggedIn').html('-1')
  $(lastPackage).click() if lastPackage.length > 0
  lastPackage = ''
  $('#isLoggedIn').html('0')
)
$('body').on('submit', '#paymentForm', (event) ->
  event.preventDefault()
  $('#submitPaymentButton').css('display', 'none')
  $('#ticketPaymentSpinner').css('display', 'block')
  $('#paymentModal .alert').slideUp()
  form = $(this)
  form.find('button').prop('disabled', true)
  Stripe.card.createToken(form, stripeResponseHandler)
  return false
)
errorSentenceHTML = (sentence) ->
  codeString = 'If you contact us, please include this code, which helps us find information in our logs:<br />'
  codeString += ('<strong>' + sentence + '</strong>')
  return codeString

stripeResponseHandler = (status, response) ->
  form = $('#paymentForm')
  if response.error
    form.find('.PaymentErrors').text(response.error.message)
    form.find('button').prop('disabled', false)
  else
    token = response.id
    form.append($('<input type="hidden" name="stripe_token" />').val(token))
    # form.get(0).submit()
    request = $.ajax({
      url: '/transactions'
      type: 'POST',
      data: form.serialize(),
      datatype: 'JSON',
      success: (resp) ->
        console.log('Request success')
        if resp.success && resp.paid
          $('#transactionSuccess').slideDown()
          $('#ticketPaymentSpinner').css('display', 'none')
          $('#paymentForm').slideUp()
        else
          console.log('error_msg: ' + resp.error_msg)
          error_sentence = ''
          if resp.error_code.length > 0
            error_sentence = resp.error_code
            $('#paymentFailSentence').html(errorSentenceHTML(error_sentence))
            $('#transactionFail').slideDown()
          else
            $.ajax({
              url: '/error_code',
              type: 'GET',
              datatype: 'JSON',
              always: (resp) ->
                if resp.code.length > 0
                  $('#paymentFailSentence').html(errorSentenceHTML(resp.code))
                  $('#transactionFail').slideDown()
            })
    })
    request.error((resp) ->
      console.log('Request error')
      if resp.error_code.length > 0
        error_sentence = resp.error_code
        $('#paymentErrorSentence').html(errorSentenceHTML(error_sentence))
        $('#transactionError').slideDown()
      else
        $.ajax({
          url: '/error_code',
          type: 'GET',
          datatype: 'JSON',
          always: (resp) ->
            if resp.code.length > 0
              $('#paymentErrorSentence').html(errorSentenceHTML(resp.code))
              $('#transactionError').slideDown()
        })
    )
    request.always(->
      $('#submitPaymentButton').css('display', 'block')
      $('#ticketPaymentSpinner').css('display', 'none')
      form.find('button').prop('disabled', false)
    )

setCreditCardType = ->
  number = $('#cardNumber').val()
  if number.length < 2
    return
  $('#paymentForm .CardImage').removeClass('Visible')
  found = false
  re = new RegExp("^4");
  if (number.match(re) != null)
    $('#visaCardImage').addClass('Visible')
    found = true

  re = new RegExp("^(34|37)");
  if (number.match(re) != null)
    $('#amexCardImage').addClass('Visible')
    found = true

  re = new RegExp("^5[1-5]");
  if (number.match(re) != null)
    $('#masterCardImage').addClass('Visible')
    found = true

  re = new RegExp("^6011");
  if (number.match(re) != null)
    $('#discoverCardImage').addClass('Visible')
    found = true

  if !found
    $('#genericCardImage').addClass('Visible')

$('body').on('keyup', '#cardNumber', ->
  setCreditCardType()
)

# $('body').on('click', '.AttendeesExpand', ->
#   sendAnalytic(1, '.AttendeesExpand', null)
#   $('.EventAttendees').addClass('Active')
#   $(this).addClass('Hidden')
# )

breakdownCountdown = (seconds) ->
  days = Math.floor(seconds / 86400);
  hours = Math.floor(seconds / 3600) % 24;
  minutes = Math.floor(seconds / 60) % 60;
  s = seconds % 60;
  if s < 10
    s = '0' + s
  timeString = days + ' days, ' + hours + ' hours, ' + minutes + ':' + s
  $('#timeLeft').html(timeString)
  setTimeout((->
    breakdownCountdown(seconds - 1)
  ), 1000)
startCountdown = ->
  endDate = new Date(2013, 10, 25, 23, 59, 59, 0)
  currDate = Date.now()
  timeDif = Math.floor((endDate - currDate) / 1000)
  breakdownCountdown(timeDif)
# startCountdown()