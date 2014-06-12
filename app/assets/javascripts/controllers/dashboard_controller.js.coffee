Roommate.DashboardController = Ember.Controller.extend
  searchedForUser:    null
  houseSearchResults: []
  haveSearched:       false

  actions:
    searchForUser: () ->
      unless @get("searchedForUser") == ""
        userSearch = @store.createRecord 'userSearch', {
          email: @get("searchedForUser")
        }

        userSearch.save().then () =>
          @set("haveSearched", true)
          house = userSearch.get("house")
          @set("houseSearchResults", [house])
      return

    createNewHouse: () ->
      console.log "Creating new house!"
      return
