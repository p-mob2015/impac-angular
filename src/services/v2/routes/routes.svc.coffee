# provider for configuring http endpoints.
angular
  .module('impac.services.routes-v2', [])
  .provider('ImpacRoutes', () ->
    provider = @
    #=======================================
    # Private Defaults
    #=======================================
    defaults =
      # base paths
      mnoHub: '/api/v2/impac'
      impacApi: 'http://localhost:4000/api'
      # define specific paths
      dashboards:
        index: null
        show: null
        create: null
        update: null
        del: null
      widgets:
        index: null
        show: null
        create: null
        update: null
        del: null
        # path for widget suggestion feature
        suggestions: null
      kpis:
        index: null
        show: null
        create: null
        update: null
        del: null
        # retrieve local kpis data
        local: null

    #=======================================
    # Public methods available in config
    #=======================================
    provider.configureRoutes = (configOptions) ->
      angular.extend(defaults, configOptions)

    #=======================================
    _$get = () ->
      service = @
      #=======================================
      # Public methods available as service
      #=======================================
      service.dashboards =
        index: -> (defaults.dashboards.index || "#{defaults.mnoHub}/dashboards")
        show: (id) ->
          if defaults.dashboards.show
            defaults.dashboards.show.replace(':id', id)
          else
            "#{defaults.mnoHub}/dashboards/#{id}"

        create: -> (defaults.dashboards.create || "#{defaults.mnoHub}/dashboards")
        update: (id) ->
          if defaults.dashboards.update
            defaults.dashboards.update.replace(':id', id)
          else
            "#{defaults.mnoHub}/dashboards/#{id}"
        delete: (id) ->
          if defaults.dashboards.del
            defaults.dashboards.del.replace(':id', id)
          else
            "#{defaults.mnoHub}/dashboards/#{id}"
      service.widgets =
        index: (dashboard_id) ->
          if defaults.widgets.index
            defaults.widgets.index.replace(':dashboard_id', dashboard_id)
          else
            "#{service.dashboards.show(dashboard_id)}/widgets"
        show: (dashboard_id, id) ->
          if defaults.widgets.show
            defaults.widgets.show.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{defaults.impacApi}/v1/get_widget"
        create: (dashboard_id) ->
          if defaults.widgets.create
            defaults.widgets.create.replace(':dashboard_id', dashboard_id)
          else
            "#{service.dashboards.show(dashboard_id)}/widgets"
        update: (dashboard_id, id) ->
          if defaults.widgets.update
            defaults.widgets.update.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{service.dashboards.show(dashboard_id)}/widgets/#{id}"
        delete: (dashboard_id, id) ->
          if defaults.widgets.del
            defaults.widgets.del.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{service.dashboards.show(dashboard_id)}/widgets/#{id}"
        # TODO: to be added once merged into v1
        # suggestions: -> "#{defaults.widgets.suggestions}"
      service.kpis =
        index: (dashboard_id) ->
          if defaults.kpis.index
            defaults.kpis.index.replace(':dashboard_id', dashboard_id)
          else
            "#{defaults.impacApi}/v2/kpis"
        show: (dashboard_id, id) ->
          if defaults.kpis.show
            defaults.kpis.show.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{defaults.impacApi}/v2/kpis"
        create: (dashboard_id) ->
          if defaults.kpis.create
            defaults.kpis.create.replace(':dashboard_id', dashboard_id)
          else
            "#{service.dashboards.show(dashboard_id)}/kpis"
        update: (dashboard_id, id) ->
          if defaults.kpis.update
            defaults.kpis.update.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{service.dashboards.show(dashboard_id)}/kpis/#{id}"
        delete: (dashboard_id, id) ->
          if defaults.kpis.del
            defaults.kpis.del.replace(':dashboard_id', dashboard_id).replace(':id', id)
          else
            "#{service.dashboards.show(dashboard_id)}/kpis/#{id}"
        local: -> defaults.kpis.local
      service.sendWidgetSuggestion = -> null # TODO: to be removed

      return service
    # inject service dependencies here, and declare in _$get function args.
    _$get.$inject = [];
    # attach provider function onto the provider object
    provider.$get = _$get

    return provider

  )
