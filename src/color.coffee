#eslint sort-vars:0, curly:0

###*
Converts a hex CSS color value to RGB.
Adapted from http://stackoverflow.com/a/5624139.

@param	String	hex		The hexadecimal color value
@return	Object			The RGB representation
###
hex2rgb = (hex) ->

  # Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
  shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
  hex = hex.replace(shorthandRegex, (m, r, g, b) ->
    r + r + g + g + b + b
  )
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  if result
    r: parseInt(result[1], 16)
    g: parseInt(result[2], 16)
    b: parseInt(result[3], 16)
   else
     null

###*
Converts an RGB color value to HSL. Conversion formula adapted from
http://en.wikipedia.org/wiki/HSL_color_space. This function adapted
from http://stackoverflow.com/a/9493060.
Assumes r, g, and b are contained in the set [0, 255] and
returns h, s, and l in the set [0, 1].

@param   Object  rgb     RGB as r, g, and b keys
@return  Object          HSL as h, s, and l keys
###
rgb2hsl = (rgb) ->
  r = rgb.r
  g = rgb.g
  b = rgb.b
  r /= 255
  g /= 255
  b /= 255
  max = Math.max(r, g, b)
  min = Math.min(r, g, b)
  h = undefined
  s = undefined
  l = (max + min) / 2
  if max is min
    h = s = 0 # achromatic
  else
    d = max - min
    s = (if l > 0.5 then d / (2 - max - min) else d / (max + min))
    switch max
      when r
        h = (g - b) / d + ((if g < b then 6 else 0))
      when g
        h = (b - r) / d + 2
      when b
        h = (r - g) / d + 4
    h /= 6
  h: h
  s: s
  l: l

###*
Converts an HSL color value to RGB. Conversion formula adapted from
http://en.wikipedia.org/wiki/HSL_color_space. This function adapted
from http://stackoverflow.com/a/9493060.
Assumes h, s, and l are contained in the set [0, 1] and
returns r, g, and b in the set [0, 255].

@param   Object  hsl     HSL as h, s, and l keys
@return  Object          RGB as r, g, and b values
###
hsl2rgb = (hsl) ->
  hue2rgb = (p, q, t) ->
    t += 1  if t < 0
    t -= 1  if t > 1
    return p + (q - p) * 6 * t  if t < 1 / 6
    return q  if t < 1 / 2
    return p + (q - p) * (2 / 3 - t) * 6  if t < 2 / 3
    p
  h = hsl.h
  s = hsl.s
  l = hsl.l
  r = undefined
  g = undefined
  b = undefined
  if s is 0
    r = g = b = l # achromatic
  else
    q = (if l < 0.5 then l * (1 + s) else l + s - l * s)
    p = 2 * l - q
    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  r: Math.round(r * 255)
  g: Math.round(g * 255)
  b: Math.round(b * 255)
"use strict"
module.exports =
  hex2rgb: hex2rgb
  rgb2hsl: rgb2hsl
  hsl2rgb: hsl2rgb
  rgb2rgbString: (rgb) ->
    "rgb(" + [
      rgb.r
      rgb.g
      rgb.b
    ].join(",") + ")"
