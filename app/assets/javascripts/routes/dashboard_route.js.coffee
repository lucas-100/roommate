Roommate.DashboardRoute = Ember.Route.extend
  model: () ->
    @store.find('house', "current")

  setupController: (controller, model) ->
    $("#dashboard-summary-loading").hide()
    @_super(arguments...)

    return
