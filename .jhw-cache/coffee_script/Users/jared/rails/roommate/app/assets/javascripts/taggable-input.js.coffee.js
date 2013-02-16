(function() {
  var TaggableInput;

  window.TaggableInput = TaggableInput = (function() {
    var BACKSPACE_KEY, ENTER_KEY, MULTI_ELEMS, SINGLE_ELEMS, TAB_KEY;

    ENTER_KEY = 13;

    TAB_KEY = 9;

    BACKSPACE_KEY = 8;

    SINGLE_ELEMS = {
      "me": "Me"
    };

    MULTI_ELEMS = {
      "me": "Me",
      "them": "Them",
      "everyone": "Everyone"
    };

    function TaggableInput(elem) {
      var elems;
      this.element = $(elem);
      elems = this.element.data("tag-type") === "single" ? SINGLE_ELEMS : MULTI_ELEMS;
      this.fullSource = jQuery.extend(this.element.data("full-source"), elems);
      this.tags = [];
      this.placeholderText = this.element.attr("placeholder");
      this.emptySize = this.element.width();
      this._buildSourceFromObject();
      this._createTagContainer();
      this._setBindings();
      this._createHiddenCheckboxes();
    }

    TaggableInput.prototype._emptyInput = function() {
      return this.element.val("");
    };

    TaggableInput.prototype._emptyTags = function() {
      return this.tags.length === 0;
    };

    TaggableInput.prototype._tagContainerSize = function() {
      return this.tagContainer.width();
    };

    TaggableInput.prototype._createTagContainer = function() {
      this.tagContainer = $('<div>').addClass('taggable-input-tag-container');
      return this.tagContainer.insertBefore(this.element);
    };

    TaggableInput.prototype._buildSourceFromObject = function() {
      var key, source, value;
      source = (function() {
        var _ref, _results;
        _ref = this.fullSource;
        _results = [];
        for (key in _ref) {
          value = _ref[key];
          _results.push(value);
        }
        return _results;
      }).call(this);
      return this.element.data("source", source);
    };

    TaggableInput.prototype._createHiddenCheckboxes = function() {
      var checkbox, div, key, value, _ref;
      this.checkboxes = {};
      div = $('<div>').css("display", "none");
      _ref = this.fullSource;
      for (key in _ref) {
        value = _ref[key];
        checkbox = $('<input>').attr({
          "type": "checkbox",
          "name": "" + (this.element.attr("name")) + "[" + key + "]",
          "id": "" + (this.element.attr("id")) + "_" + key
        });
        div.append(checkbox);
        this.checkboxes[value.toLowerCase()] = checkbox;
      }
      div.insertAfter(this.element);
      this.element.attr("name", "" + (this.element.attr("name")) + "[0]");
    };

    TaggableInput.prototype._setBindings = function() {
      var _this = this;
      this.element.keyup(function(event) {
        if (event.which === ENTER_KEY || event.which === TAB_KEY) {
          _this._createTagFromValue();
        }
      });
      this.element.keydown(function(event) {
        if (event.which === BACKSPACE_KEY) _this._deleteLastTag();
      });
      $("form").bind("reset", function(event) {
        _this._resetInput();
        return _this.element.blur();
      });
    };

    TaggableInput.prototype._resetInput = function() {
      var tag, _i, _len, _ref;
      this.element.val("");
      _ref = this.tags;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        this._deleteLastTag();
        true;
      }
    };

    TaggableInput.prototype._deleteLastTag = function() {
      var name, tag,
        _this = this;
      if (this._emptyInput()) {
        tag = this.tags.pop();
        if (tag != null) {
          name = tag.find('span.owner-name').text();
          this.element.data("source").push(name);
          this.checkboxes[name.toLowerCase()].attr("checked", false);
          tag.fadeOut('fast', function() {
            _this._adjustElementSize();
            tag.remove();
            if (_this._emptyTags()) {
              return _this.element.attr("placeholder", _this.placeholderText);
            }
          });
        }
      }
    };

    TaggableInput.prototype._adjustElementSize = function() {
      this.element.css('width', "" + (this.emptySize - this._tagContainerSize()) + "px");
    };

    TaggableInput.prototype._createTagFromValue = function() {
      var _this = this;
      setTimeout(function() {
        var a, span, value;
        value = _this.element.val();
        if (value !== "") {
          _this.element.data("source").splice(_this.element.data("source").indexOf(value), 1);
          a = $('<a>').addClass('taggable-input-tag-close').text("x");
          span = $('<span>').addClass('taggable-input-tag expense-owner').append(a).append($('<span>').addClass('owner-name').append(value));
          _this.tags.push(span);
          _this.tagContainer.append(span);
          _this._adjustElementSize();
          _this.element.val('');
          _this.element.attr("placeholder", "");
          console.log(_this.checkboxes);
          return _this.checkboxes[value.toLowerCase()].attr("checked", "checked");
        }
      }, 1);
    };

    return TaggableInput;

  })();

  $(function() {
    var elem, _i, _len, _ref;
    jQuery.fn.taggable_input = function() {
      return new TaggableInput($(this));
    };
    _ref = $("input[data-provide='typeahead'].taggable");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      elem = _ref[_i];
      $(elem).taggable_input();
    }
  });

}).call(this);
