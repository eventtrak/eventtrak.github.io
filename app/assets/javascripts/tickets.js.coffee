# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
displayAndCheckCode = ->
  phrase = ''
  $('.PhraseGeneratorCategory').each(->
    phrase += $(this).children('.btn-primary').first().html()
    phrase += ' '
  )
  phrase = phrase.trim()
  sendAnalytic(5, 'displayAndCheckCode', phrase)
  data = { code: phrase }
  $('#codeText').text(phrase)
  request = $.ajax({
    url: '/code_status',
    type: 'GET',
    data: data,
    datatype: 'JSON',
    success: (resp) ->
      $('#ticketStatus').text(resp.string)
      if resp.status == 1 
        $('#submitCodeButton').removeAttr('disabled')
  })

$('body').on('click', '#phraseGenerator .btn', ->
  if $(this).hasClass('btn-primary')
    $(this).removeClass('btn-primary')
    return
  p = $(this).closest('div')
  $(p).children().removeClass('btn-primary')
  $(this).addClass('btn-primary')
  isCompleteCode = true
  $('.PhraseGeneratorCategory').each(->
    if $(this).children('.btn-primary').length != 1
      isCompleteCode = false
  )
  if isCompleteCode
    # $('#submitCodeButton').removeAttr('disabled')
    displayAndCheckCode()
  else
    $('#submitCodeButton').attr('disabled', 'disabled')
)

$('body').on('click', '#submitCodeButton', ->
  sendAnalytic(1, '#submitCodeButton', $('#codeText').text())
  if $(this).attr('disabled') == 'disabled'
    return
  data = { code: $('#codeText').text() }
  request = $.ajax({
    url: '/redeem',
    type: 'PUT',
    data: data,
    datatype: 'JSON',
    success: (resp) ->
      alert(resp.string)
      if resp.status == 1
        setTimeout((->
          $('#submitCodeButton').attr('disabled', 'disabled')
          $('.btn-primary').removeClass('btn-primary')
          $('#codeText').text('')
          $('#ticketStatus').text('')
        ), 500)
  })
)

$('body').on('click', '#clearDisplay', ->
  sendAnalytic(1, '#clearDisplay', '')
  $('#submitCodeButton').attr('disabled', 'disabled')
  $('.btn-primary').removeClass('btn-primary')
  $('#codeText').text('')
  $('#ticketStatus').text('')
)