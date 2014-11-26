# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# toggle visibility for css3 animations 

#iphone carousel animation

# Fixed navbar

#animations 

# Parallax Content
parallax = ->
  
  # Turn parallax scrolling off for iOS devices
  iOS = false
  p = navigator.platform
  iOS = true  if p is "iPad" or p is "iPhone" or p is "iPod"
  scaleBg = -$(window).scrollTop() / 3
  if iOS is false
    $(".payoff").css "background-position-y", scaleBg - 150
    $(".social").css "background-position-y", scaleBg + 200
  return
navbar = ->
  if $(window).scrollTop() > 1
    $("#navigation").addClass "show-nav"
  else
    $("#navigation").removeClass "show-nav"
  return
$(document).ready ->
  $("header").addClass "visibility"
  $(".carousel-iphone").addClass "visibility"
  $(".payoff h1").addClass "visibility"
  $(".features .col-md-4").addClass "visibility"
  $(".social .col-md-12").addClass "visibility"
  return

$(window).load ->
  $("header").addClass "animated fadeIn"
  $(".carousel-iphone").addClass "animated fadeInLeft"
  return

$(window).scroll ->
  scrollTop = $(window).scrollTop()
  if scrollTop > 200
    $(".navbar-default").css "display", "block"
    $(".navbar-default").addClass "fixed-to-top"
  else $(".navbar-default").removeClass "fixed-to-top"  if scrollTop is 0
  $(".payoff h1").each ->
    imagePos = $(this).offset().top
    topOfWindow = $(window).scrollTop()
    $(this).addClass "animated fadeInLeft"  if imagePos < topOfWindow + 650
    return

  $(".purchase button.app-store").each ->
    imagePos = $(this).offset().top
    topOfWindow = $(window).scrollTop()
    $(this).addClass "animated pulse"  if imagePos < topOfWindow + 650
    return

  $(".features .col-md-4").each ->
    imagePos = $(this).offset().top
    topOfWindow = $(window).scrollTop()
    $(this).addClass "animated flipInX"  if imagePos < topOfWindow + 650
    return

  $(".social .col-md-12").each ->
    imagePos = $(this).offset().top
    topOfWindow = $(window).scrollTop()
    $(this).addClass "animated fadeInLeft"  if imagePos < topOfWindow + 550
    return

  $(".get-it button.app-store").each ->
    imagePos = $(this).offset().top
    topOfWindow = $(window).scrollTop()
    $(this).addClass "animated pulse"  if imagePos < topOfWindow + 850
    return

  return

$(document).ready ->
  browserWidth = $(window).width()
  if browserWidth > 560
    $(window).scroll ->
      parallax()
      navbar()
      return

  return

$(window).resize ->
  browserWidth = $(window).width()
  if browserWidth > 560
    $(window).scroll ->
      parallax()
      navbar()
      return

  return


# iPhone Header Carousel
$("header .carousel").carousel interval: 3000

# iPhone Features Carousel
$(".detail .carousel").carousel interval: 4000