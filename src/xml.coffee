"use strict"
XMLNode = module.exports = (tagName) ->
  return new XMLNode(tagName)  unless this instanceof XMLNode
  @tagName = tagName
  @attributes = Object.create(null)
  @children = []
  @lastChild = null
  this

XMLNode::appendChild = (child) ->
  @children.push child
  @lastChild = child
  this

XMLNode::setAttribute = (name, value) ->
  @attributes[name] = value
  this

XMLNode::toString = ->
  self = this
  [
    "<"
    self.tagName
    Object.keys(self.attributes).map((attr) ->
      [
        " "
        attr
        "=\""
        self.attributes[attr]
        "\""
      ].join ""
    ).join("")
    ">"
    self.children.map((child) ->
      child.toString()
    ).join("")
    "</"
    self.tagName
    ">"
  ].join ""
