# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('Twitter').slideUp()
$('Facebook').slideUp()
$('.Youtube').slideUp()
$('.Instagram').slideUp()

$(document).on('click', '.AboutLink', ->
  # $('.ArtistMusic').removeClass('Visible')
  # $('.ArtistAbout').addClass('Visible')
  # $('.MusicLink').removeClass('Active')
  # $(this).removeClass('Visible')
  sendAnalytic(1, '.AboutLink', null);
  $('.AboutLink').slideUp()
  $('.ArtistAbout').slideDown()
  $('.ArtistMusic').removeClass('Visible').removeClass('ShowSoundcloud')
  $('.PoweredByTunetap').removeClass('ShowSoundcloud')
  $('.ArtistMusicTitleNames').removeClass('Active')
)

#Social Links CoffeeScript

$(document).on('click', '.ArrowDown', ->
  $('.Bar').addClass('None')
  $('.Bar2').addClass('Visible')
  $('.Facebook').slideDown()
  $('.ArrowDown').removeClass('Visible').addClass('None')
  $('.ArrowUp').addClass('Visible')
  $('li.ArtistFacebookLink').addClass('Orange')
)
$(document).on('click', '.ArrowUp', ->
  $('.Bar').removeClass('None')
  $('.Bar2').removeClass('Visible')
  $('.Twitter').slideUp()
  $('.Youtube').slideUp()
  $('.Facebook').slideUp()
  $('.Instagram').slideUp()
  $('.ArrowDown').addClass('Visible')
  $('.ArrowUp').removeClass('Visible')
  $('li.ArtistFacebookLink').removeClass('Orange')
  $('li.ArtistTwitterLink').removeClass('Orange')
  $('li.ArtistYoutubeLink').removeClass('Orange')
  $('li.ArtistInstagramLink').removeClass('Orange')
)
$(document).on('click', '.TwitterLink', ->
  if($('.Facebook').is(":visible")||$('.Youtube').is(":visible")||$('.Instagram').is(":visible"))
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Facebook').slideUp()
    $('.Youtube').slideUp()
    $('.Instagram').slideUp()
    $('.Twitter').slideDown()
    $('li.ArtistFacebookLink').removeClass('Orange')
    $('li.ArtistYoutubeLink').removeClass('Orange')
    $('li.ArtistInstagramLink').removeClass('Orange')
    $('li.ArtistTwitterLink').addClass('Orange')

  else if($('.Twitter').is(":visible"))
    $('.Bar').removeClass('None')
    $('.Bar2').removeClass('Visible')
    $('.Twitter').slideUp()
    $('.ArrowDown').addClass('Visible')
    $('.ArrowUp').removeClass('Visible')
    $('li.ArtistTwitterLink').removeClass('Orange')

  else
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Twitter').slideDown()
    $('.ArrowDown').removeClass('Visible').addClass('None')
    $('.ArrowUp').addClass('Visible')
    $('li.ArtistTwitterLink').addClass('Orange')
)

$(document).on('click', '.FacebookLink', ->
  if($('.Twitter').is(":visible")||$('.Youtube').is(":visible")||$('.Instagram').is(":visible"))
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Facebook').slideDown()
    $('.Instagram').slideUp()
    $('.Youtube').slideUp()
    $('.Twitter').slideUp()
    $('li.ArtistFacebookLink').addClass('Orange')
    $('li.ArtistYoutubeLink').removeClass('Orange')
    $('li.ArtistTwitterLink').removeClass('Orange')
    $('li.ArtistInstagramLink').removeClass('Orange')
   
  else if($('.Facebook').is(":visible"))
    $('.Bar').removeClass('None')
    $('.Bar2').removeClass('Visible')
    $('.Facebook').slideUp()
    $('.ArrowDown').addClass('Visible')
    $('.ArrowUp').removeClass('Visible')
    $('li.ArtistFacebookLink').removeClass('Orange')

  else
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Facebook').slideDown()
    $('.ArrowDown').removeClass('Visible').addClass('None')
    $('.ArrowUp').addClass('Visible')
    $('li.ArtistFacebookLink').addClass('Orange')
)
$(document).on('click', '.YoutubeLink', ->
  if($('.Twitter').is(":visible")||$('.Facebook').is(":visible")||$('.Instagram').is(":visible"))
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Youtube').slideDown()
    $('.Twitter').slideUp()
    $('.Facebook').slideUp()
    $('.Instagram').slideUp()
    $('li.ArtistYoutubeLink').addClass('Orange')
    $('li.ArtistFacebookLink').removeClass('Orange')
    $('li.ArtistInstagramLink').removeClass('Orange')
    $('li.ArtistTwitterLink').removeClass('Orange')
   
  else if($('.Youtube').is(":visible"))
    $('.Bar').removeClass('None')
    $('.Bar2').removeClass('Visible')
    $('.Youtube').slideUp()
    $('.ArrowDown').addClass('Visible')
    $('.ArrowUp').removeClass('Visible')
    $('li.ArtistYoutubeLink').removeClass('Orange')

  else
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Youtube').slideDown()
    $('.ArrowDown').removeClass('Visible').addClass('None')
    $('.ArrowUp').addClass('Visible')
    $('li.ArtistYoutubeLink').addClass('Orange')
)

$(document).on('click', '.InstagramLink', ->
  if($('.Twitter').is(":visible")||$('.Facebook').is(":visible")||$('.Youtube').is(":visible"))
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Instagram').slideDown()
    $('.Twitter').slideUp()
    $('.Facebook').slideUp()
    $('.Youtube').slideUp()
    $('li.ArtistInstagramLink').addClass('Orange')
    $('li.ArtistFacebookLink').removeClass('Orange')
    $('li.ArtistYoutubeLink').removeClass('Orange')
    $('li.ArtistTwitterLink').removeClass('Orange')
   
  else if($('.Instagram').is(":visible"))
    $('.Bar').removeClass('None')
    $('.Bar2').removeClass('Visible')
    $('.Instagram').slideUp()
    $('.ArrowDown').addClass('Visible')
    $('.ArrowUp').removeClass('Visible')
    $('li.ArtistInstagramLink').removeClass('Orange')

  else
    $('.Bar').addClass('None')
    $('.Bar2').addClass('Visible')
    $('.Instagram').slideDown()
    $('.ArrowDown').removeClass('Visible').addClass('None')
    $('.ArrowUp').addClass('Visible')
    $('li.ArtistInstagramLink').addClass('Orange')
)

#keyUp
$(document).on('keyup', '.ArtistName', ->
  textinput = $('.ArtistName').html().replace(/(<([^>]+)>)/ig,"")
  $(".ArtistName2").html(textinput)
)

#AJAX
$(document).on('blur', '#artistdescription', ->
  $.ajax(
    url: "/artists/" + $('#idnumber').html()
    type: "PATCH"
    datatype: "JSON"
    data: {
      description: $('#artistdescription').html().replace(/(<([^>]+)>)/ig,"")
    } 
  )
)

$(document).on('blur', '.ArtistName', ->
  $.ajax(
    url: "/artists/" + $('#idnumber').html()
    type: "PATCH"
    datatype: "JSON"
    data: {
      artist_name: $('.ArtistName').html().replace(/(<([^>]+)>)/ig,"")
    } 
  )
)

$(document).on('click', '.UpdateSocialLinks', ->
  $.ajax(
    url: "/artists/" + $('#idnumber').html()
    type: "PATCH"
    datatype: "JSON"
    data:{
      facebook: $('#facebook_name').val()
      twitter: $('#twitter_name').val()
      instagram: $('#instagram_name').val()
      youtube: $('#youtube_name').val()
    }
  )
  $('#myModal2').modal('hide')

)

$(document).on('click', '#setupOccur', ->
  $.ajax(
    url: "/artists/" + $('#idnumber').html()
    type: "PATCH"
    datatype: "JSON"
    data:{
      facebook: $('#facebook_name').val()
      twitter: $('#twitter_name').val()
      instagram: $('#instagram_name').val()
      youtube: $('#youtube_name').val()
    }
  )
  $('#createEventModal').modal('hide')

)




$(document).on('click', '.MusicLink', ->
 # $('.ArtistAbout').removeClass('Visible')
  $('.ArtistMusic').addClass('Visible')
  # $('.AboutLink').removeClass('Active')
  $(this).addClass('Active')
)
$(document).on('click', '.ArtistMusicTitleNames', ->
  sendAnalytic(1, '.ArtistMusicTitleNames', $(this).data('id'))
  $('.ArtistMusicTitleNames').removeClass('Active')
  $('.ArtistMusicSoundcloudEmbed').css('display', 'none')
  #$('.ArtistAbout').slideUp()
  # $('.AboutLink').addClass('Visible')
  #$('.AboutLink').slideDown()
  $('#' + $(this).data('id')).css('display', 'block')
  $(this).addClass('Active')
  $('.ArtistMusic').addClass('Visible').addClass('ShowSoundcloud')
  # $('.ArtistHero').addClass('ShowSoundcloud')
  $('.PoweredByTunetap').addClass('ShowSoundcloud')
  $('.ArtistMusicTitles').addClass('ShowSoundcloud')
  $("html, body").animate({ scrollTop: $(document).height() }, 1000)
)
$('body').on('click', '.UpcomingEvent', ->
  sendAnalytic(1, '.UpcomingEvent', $(this).attr('id'))
)
$('body').on('click', '.FacebookLink', ->
  sendAnalytic(1, '.FacebookLink', $(this).attr('id'))
)
$('body').on('click', '.TwitterLink', ->
  sendAnalytic(1, '.TwitterLink', $(this).attr('id'))
)


