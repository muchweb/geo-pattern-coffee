SVG = ->
  @width = 100
  @height = 100
  @svg = XMLNode("svg")
  @context = [] # Track nested nodes
  @setAttributes @svg,
    xmlns: "http://www.w3.org/2000/svg"
    width: @width
    height: @height

  this
"use strict"
extend = require("extend")
XMLNode = require("./xml")
module.exports = SVG

# This is a hack so groups work.
SVG::currentContext = ->
  @context[@context.length - 1] or @svg


# This is a hack so groups work.
SVG::end = ->
  @context.pop()
  this

SVG::currentNode = ->
  context = @currentContext()
  context.lastChild or context

SVG::transform = (transformations) ->
  @currentNode().setAttribute "transform", Object.keys(transformations).map((transformation) ->
    transformation + "(" + transformations[transformation].join(",") + ")"
  ).join(" ")
  this

SVG::setAttributes = (el, attrs) ->
  Object.keys(attrs).forEach (attr) ->
    el.setAttribute attr, attrs[attr]
    return

  return

SVG::setWidth = (width) ->
  @svg.setAttribute "width", Math.floor(width)
  return

SVG::setHeight = (height) ->
  @svg.setAttribute "height", Math.floor(height)
  return

SVG::toString = ->
  @svg.toString()

SVG::rect = (x, y, width, height, args) ->
  
  # Accept array first argument
  self = this
  if Array.isArray(x)
    x.forEach (a) ->
      self.rect.apply self, a.concat(args)
      return

    return this
  rect = XMLNode("rect")
  @currentContext().appendChild rect
  @setAttributes rect, extend(
    x: x
    y: y
    width: width
    height: height
  , args)
  this

SVG::circle = (cx, cy, r, args) ->
  circle = XMLNode("circle")
  @currentContext().appendChild circle
  @setAttributes circle, extend(
    cx: cx
    cy: cy
    r: r
  , args)
  this

SVG::path = (str, args) ->
  path = XMLNode("path")
  @currentContext().appendChild path
  @setAttributes path, extend(
    d: str
  , args)
  this

SVG::polyline = (str, args) ->
  
  # Accept array first argument
  self = this
  if Array.isArray(str)
    str.forEach (s) ->
      self.polyline s, args
      return

    return this
  polyline = XMLNode("polyline")
  @currentContext().appendChild polyline
  @setAttributes polyline, extend(
    points: str
  , args)
  this


# group and context are hacks
SVG::group = (args) ->
  group = XMLNode("g")
  @currentContext().appendChild group
  @context.push group
  @setAttributes group, extend({}, args)
  this
