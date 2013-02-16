(function() {

  describe("TaggableInput", function() {
    var elem, elemWidth, ti;
    elem = null;
    elemWidth = null;
    ti = null;
    beforeEach(function() {
      elem = $('<input>').attr("type", "text").data("full-source", {
        1: "Jared",
        2: "Bill"
      }).attr("placeholder", "Test Placeholder");
      elemWidth = elem.width();
      return ti = new TaggableInput(elem);
    });
    describe("constructor", function() {
      it("builds off an input", function() {
        return expect(ti).toBeTruthy();
      });
      it("sets @element", function() {
        return expect(ti.element).toEqual(elem);
      });
      it("sets @tags", function() {
        return expect(ti.tags).toEqual([]);
      });
      it("sets @placeholderText", function() {
        return expect(ti.placeholderText).toEqual("Test Placeholder");
      });
      it("sets @emptySize", function() {
        return expect(ti.emptySize).toEqual(elemWidth);
      });
      describe("default case", function() {
        return it("sets @fullSource with 'everyone' and 'them'", function() {
          return expect(ti.fullSource).toEqual({
            1: "Jared",
            2: "Bill",
            "everyone": "Everyone",
            "me": "Me",
            "them": "Them"
          });
        });
      });
      return describe("single case", function() {
        ti = null;
        elem = null;
        beforeEach(function() {
          elem = $('<input>').attr("type", "text").data("full-source", {
            1: "Jared",
            2: "Bill"
          }).data("tag-type", "single");
          return ti = new TaggableInput(elem);
        });
        return it("sets @fullSource without 'everyone' and 'them'", function() {
          return expect(ti.fullSource).toEqual({
            1: "Jared",
            2: "Bill",
            "me": "Me"
          });
        });
      });
    });
    return describe("_emptyInput()", function() {
      return it("should set the elem.val() to ''", function() {
        elem.val("Test");
        ti._emptyInput();
        return expect(elem.val()).toEqual("");
      });
    });
  });

}).call(this);
