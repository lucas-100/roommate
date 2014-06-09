Roommate.DashboardRoute = Ember.Route.extend
  model: () ->
    @store.find('house', "current")


  setupController: (controller, model) ->
    $("#dashboard-summary-loading").hide()

    controller.setProperties
      model: model

    return
