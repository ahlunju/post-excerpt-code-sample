'use strict'

angular.module('pemappApp')
  .directive('slider', ($timeout, SessionsService)->
    templateUrl: 'views/slider.html'
    restrict: 'A'
    scope: {
      excerpts: "="
    }
    link: (scope, element, attrs) ->
      scope.toggleSpotlight = (excerpt) ->
        thisSpotlightStatus = excerpt.spotlight
        thisExcerptId = excerpt.excerptId
        angular.forEach scope.excerpts, ((value, key) ->
            if thisExcerptId is  value.excerptId
              value.spotlight = !value.spotlight
            else
              value.spotlight = false
        )
        SessionsService.updateSession();
      scope.hidePrevArrow = true
      scope.hideNextArrow = false
      scope.$watch 'excerpts', (newval, oldval)->
        if newval
          swiped = element.swiper({
            mode:'horizontal'
            createPagination: false
            loop: false
            keyboardControl: true
            resizeReinit: true
            onSlideChangeStart: ->
              #apply after the current digest cycle has completed
              $timeout ->
                if swiped.activeIndex == 0
                  scope.hidePrevArrow = true
                  scope.hideNextArrow = false
                else if swiped.activeIndex == swiped.slides.length-1
                  scope.hideNextArrow = true
                  scope.hidePrevArrow = false
                else
                  scope.hideNextArrow = false
                  scope.hidePrevArrow = false
          })
          scope.nextSlide = ->
            swiped.swipeNext()
          scope.previousSlide =->
            swiped.swipePrev()
  )
