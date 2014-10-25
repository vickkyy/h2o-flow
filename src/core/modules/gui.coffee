control = (type, opts) ->
  opts = {} unless opts
  guid = "gui_#{uniqueId()}"

  type: type
  id: opts.id or guid
  label: signal opts.label or ' '
  description: signal opts.description or ' '
  visible: signal if opts.visible is no then no else yes
  disable: signal if opts.disable is yes then yes else no
  template: "flow-form-#{type}"
  templateOf: (control) -> control.template

wrapValue = (value, init) ->
  if value is undefined
    signal init
  else
    if isSignal value
      value
    else
      signal value

wrapArray = (elements) ->
  if elements
    if isSignal elements
      element = elements()
      if isArray element then elements else signal [ element ]
    else
      signals if isArray elements then elements else [ elements ]
  else
    signals []

content = (type, opts) ->
  self = control type, opts
  self.value = wrapValue opts.value, ''
  self

text = (opts) -> content 'text', opts
html = (opts) -> content 'html', opts
markdown = (opts) -> content 'markdown', opts

checkbox = (opts) ->
  self = control 'checkbox', opts
  self.value = wrapValue opts.value, if opts.value then yes else no
  self

#TODO KO supports array valued args for 'checked' - can provide a checkboxes function

dropdown = (opts) ->
  self = control 'dropdown', opts
  self.options = opts.options or []
  self.value = wrapValue opts.value
  self.caption = opts.caption or 'Choose...'
  self

listbox = (opts) ->
  self = control 'listbox', opts
  self.options = opts.options or []
  self.values = wrapArray opts.values
  self

textbox = (opts) ->
  self = control 'textbox', opts
  self.value = wrapValue opts.value, ''
  self.event = if isString opts.event then opts.event else null
  self

textarea = (opts) ->
  self = control 'textarea', opts
  self.value = wrapValue opts.value, ''
  self.event = if isString opts.event then opts.event else null
  self.rows = if isNumber opts.rows then opts.rows else 5
  self

button = (opts) ->
  self = control 'button', opts
  self.click = if isFunction opts.click then opts.click else noop
  self

form = (controls, go) ->
  go null, signals controls or []

#XXX keep this module clean - pull gui() out into routines, exposing
# gui.* routines on a separate function
gui = (controls) ->
  Flow.Async.renderable form, controls, (form, go) ->
    go null, Flow.Form form

gui.text = text
gui.html = html
gui.markdown = markdown
gui.checkbox = checkbox
gui.dropdown = dropdown
gui.listbox = listbox
gui.textbox = textbox
gui.textarea = textarea
gui.button = button

Flow.Gui = gui

