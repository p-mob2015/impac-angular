module = angular.module('impac.components.widgets-settings.width',[])

module.controller('SettingWidthCtrl', ($scope, $element, $timeout, $log, ImpacWidgetsSvc, ImpacDashboardsSvc) ->

  w = $scope.parentWidget

  # What will be passed to parentWidget
  setting = {}
  setting.key = "width"
  setting.isInitialized = false

  # Elements to be hidden during resizing
  for elem in $element.parents()
    if angular.element(elem).hasClass('content')
      $scope.contentElements = angular.element(elem).children()
      break

  # ------------------------------------

  hideOnResize = (elements) ->
    return unless (elements && elements.length > 0)
    # Hides elems in content
    for elem in elements
      angular.element(elem).animate({opacity: 0}, 0)
    # Makes them reappear after resizing
    $timeout ->
      for elem in elements
        angular.element(elem).animate({opacity: 1}, 200)
    , 300

  w.toggleExpanded = (save) ->
    if typeof(save) == 'undefined'
      save = true

    $scope.expanded = !$scope.expanded
    # false because we want to resize the widget without waiting for the response from the dashboarding API
    ImpacWidgetsSvc.updateWidgetSettings(w,false,true) if save

    hideOnResize($scope.contentElements)

    if $scope.expanded
      w.width = parseInt($scope.max)
    else
      w.width = parseInt($scope.min)

  w.isExpanded = ->
    $scope.expanded

  # initialization of time range parameters from widget.content.hist_parameters
  setting.initialize = ->
    if w.width?
      $scope.expanded = (w.width == parseInt($scope.max))
      setting.isInitialized = true

  setting.toMetadata = ->
    if $scope.expanded
      newWidth = $scope.max
    else
      newWidth = $scope.min
    return { width: parseInt(newWidth) }

  $scope.pdfMode = false
  ImpacDashboardsSvc.pdfModeEnabled().then(null, null, ->
    $scope.pdfMode = true
    $scope.initiallyExpanded = $scope.expanded
    # Expand the widget if it's not already the case
    w.toggleExpanded(false) unless $scope.expanded
  )
  ImpacDashboardsSvc.pdfModeCanceled().then(null, null, ->
    $scope.pdfMode = false
    # Reduce the widget if it wasn't expanded initially
    w.toggleExpanded(false) unless $scope.initiallyExpanded
  )

  w.settings.push(setting)

  # Setting is ready: trigger load content
  # ------------------------------------
  $scope.deferred.resolve($scope.parentWidget)
)

module.directive('settingWidth', ($templateCache) ->
  return {
    restrict: 'A',
    scope: {
      parentWidget: '=',
      deferred: '='
      min: '@',
      max: '@',
    },
    template: $templateCache.get('widgets-settings/width.tmpl.html'),
    controller: 'SettingWidthCtrl'
  }
)
