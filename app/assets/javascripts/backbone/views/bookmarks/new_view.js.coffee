Myapp.Views.Bookmarks ||= {}

class Myapp.Views.Bookmarks.NewView extends Backbone.View
  template: JST["backbone/templates/bookmarks/new"]

  events:
    "submit #new-bookmark": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @model.bind("change:errors", () =>
      this.render()
    )
        

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.unset("errors")
    @model.set({"details" : $(".tags")[0].value})
    @collection.create(@model.toJSON(),
      success: (bookmark) =>
        @model = bookmark
        window.location.hash = "/#{@model.id}"
      error: (bookmark, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)
    if(@model.has("errors"))
      strHTML=""
      sep=""
      console.log(@model.get("errors"))
      for key, value of @model.get("errors")
        strHTML += sep + value
        sep="<br/>"
        
      this.$("#errorDetail").html(strHTML);
      this.$("#alert").css("display","");
    return this
